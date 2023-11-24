--------------------------------------------------------------------------------
--                                            __ _      _     _               --
--                                           / _(_)    | |   | |              --
--                __ _ _   _  ___  ___ _ __ | |_ _  ___| | __| |              --
--               / _` | | | |/ _ \/ _ \ '_ \|  _| |/ _ \ |/ _` |              --
--              | (_| | |_| |  __/  __/ | | | | | |  __/ | (_| |              --
--               \__, |\__,_|\___|\___|_| |_|_| |_|\___|_|\__,_|              --
--                  | |                                                       --
--                  |_|                                                       --
--                                                                            --
--                                                                            --
--              MPSoC-RISCV CPU                                               --
--              Core - Multiplier Unit                                        --
--              AMBA3 AHB-Lite Bus Interface                                  --
--                                                                            --
--------------------------------------------------------------------------------

-- Copyright (c) 2017-2018 by the author(s)
--
-- Permission is hereby granted, free of charge, to any person obtaining a copy
-- of this software and associated documentation files (the "Software"), to deal
-- in the Software without restriction, including without limitation the rights
-- to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
-- copies of the Software, and to permit persons to whom the Software is
-- furnished to do so, subject to the following conditions:
--
-- The above copyright notice and this permission notice shall be included in
-- all copies or substantial portions of the Software.
--
-- THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
-- IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
-- FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
-- AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
-- LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
-- OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
-- THE SOFTWARE.
--
--------------------------------------------------------------------------------
-- Author(s):
--   Paco Reina Campo <pacoreinacampo@queenfield.tech>

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.pu_riscv_vhdl_pkg.all;
use work.vhdl_pkg.all;

entity pu_riscv_multiplier is
  generic (
    XLEN : integer := 64;
    ILEN : integer := 64
    );
  port (
    rstn : in std_logic;
    clk  : in std_logic;

    ex_stall  : in  std_logic;
    mul_stall : out std_logic;

    -- Instruction
    id_bubble : in std_logic;
    id_instr  : in std_logic_vector(ILEN-1 downto 0);

    -- Operands
    opA : in std_logic_vector(XLEN-1 downto 0);
    opB : in std_logic_vector(XLEN-1 downto 0);

    -- from State
    st_xlen : in std_logic_vector(1 downto 0);

    -- to WB
    mul_bubble : out std_logic;
    mul_r      : out std_logic_vector(XLEN-1 downto 0)
    );
end pu_riscv_multiplier;

architecture rtl of pu_riscv_multiplier is
  ------------------------------------------------------------------------------
  -- Constants
  ------------------------------------------------------------------------------
  constant DXLEN : integer := 2*XLEN;

  constant MAX_LATENCY : integer := 3;
  constant LATENCY     : integer := MAX_LATENCY;

  ------------------------------------------------------------------------------
  -- functions
  ------------------------------------------------------------------------------
  function sext32 (
    operand : std_logic_vector(31 downto 0)

    ) return std_logic_vector is
    variable sign          : std_logic;
    variable sext32_return : std_logic_vector (XLEN-1 downto 0);
  begin
    sign          := operand(31);
    sext32_return := ((XLEN-1 downto 31 => sign) & operand(30 downto 0));
    return sext32_return;
  end sext32;

  function twos (
    a : std_logic_vector(XLEN-1 downto 0)
    ) return std_logic_vector is
    variable twos_return : std_logic_vector (XLEN-1 downto 0);
  begin
    twos_return := std_logic_vector(unsigned(not a)+X"0000000000000001");
    return twos_return;
  end twos;

  function twos_dxlen (
    a : std_logic_vector(DXLEN-1 downto 0)
    ) return std_logic_vector is
    variable twos_dxlen_return : std_logic_vector (DXLEN-1 downto 0);
  begin
    twos_dxlen_return := std_logic_vector(unsigned(not a)+X"00000000000000000000000000000001");
    return twos_dxlen_return;
  end twos_dxlen;

  function absolute (
    a : std_logic_vector(XLEN-1 downto 0)
    ) return std_logic_vector is
    variable abs_return : std_logic_vector (XLEN-1 downto 0);
  begin
    if (a(XLEN-1) = '1') then
      abs_return := twos(a);
    else
      abs_return := a;
    end if;

    return abs_return;
  end absolute;

  ------------------------------------------------------------------------------
  -- Constants
  ------------------------------------------------------------------------------
  constant ST_IDLE : std_logic := '0';
  constant ST_WAIT : std_logic := '1';

  ------------------------------------------------------------------------------
  -- Variables
  ------------------------------------------------------------------------------
  signal xlen32    : std_logic;
  signal mul_instr : std_logic_vector(ILEN-1 downto 0);

  signal opcode     : std_logic_vector(6 downto 2);
  signal mul_opcode : std_logic_vector(6 downto 2);
  signal func3      : std_logic_vector(2 downto 0);
  signal mul_func3  : std_logic_vector(2 downto 0);
  signal func7      : std_logic_vector(6 downto 0);
  signal mul_func7  : std_logic_vector(6 downto 0);

  -- Operand generation
  signal opA32 : std_logic_vector(31 downto 0);
  signal opB32 : std_logic_vector(31 downto 0);

  signal mult_neg          : std_logic;
  signal mult_neg_reg      : std_logic;
  signal mult_opA          : std_logic_vector(XLEN-1 downto 0);
  signal mult_opA_reg      : std_logic_vector(XLEN-1 downto 0);
  signal mult_opB          : std_logic_vector(XLEN-1 downto 0);
  signal mult_opB_reg      : std_logic_vector(XLEN-1 downto 0);
  signal mult_r            : std_logic_vector(DXLEN-1 downto 0);
  signal mult_r_reg        : std_logic_vector(DXLEN-1 downto 0);
  signal mult_r_signed     : std_logic_vector(DXLEN-1 downto 0);
  signal mult_r_signed_reg : std_logic_vector(DXLEN-1 downto 0);

  -- FSM (bubble, stall generation)
  signal is_mul : std_logic;
  signal cnt    : std_logic_vector(1 downto 0);
  signal state  : std_logic;

begin
  ------------------------------------------------------------------------------
  -- Module Body
  ------------------------------------------------------------------------------

  -- Instruction
  func7  <= id_instr(31 downto 25);
  func3  <= id_instr(14 downto 12);
  opcode <= id_instr(6 downto 2);

  mul_func7  <= mul_instr(31 downto 25);
  mul_func3  <= mul_instr(14 downto 12);
  mul_opcode <= mul_instr(6 downto 2);

  xlen32 <= to_stdlogic(st_xlen = RV32I);

  -- 32bit operands
  opA32 <= opA(31 downto 0);
  opB32 <= opB(31 downto 0);

  --   *  Multiply operations
  --   *
  --   * Transform all multiplications into 1 unsigned multiplication
  --   * This avoids building multiple multipliers (signed x signed, signed x unsigned, unsigned x unsigned)
  --   *   at the expense of potentially making the path slower
  -- multiplier operand-A
  processing_0 : process (func3, func7, opA, opA32, opcode)
    variable multiplier_a : std_logic_vector(15 downto 0);
  begin
    multiplier_a := 'X' & func7 & func3 & opcode;
    case (multiplier_a) is
      when MULW =>
        -- RV64
        mult_opA <= absolute(sext32(opA32));
      when MULHU =>
        mult_opA <= opA;
      when others =>
        mult_opA <= absolute(opA);
    end case;
  end process;

  -- multiplier operand-B
  processing_1 : process (func3, func7, opB, opB32, opcode)
    variable multiplier_b : std_logic_vector(15 downto 0);
  begin
    multiplier_b := 'X' & func7 & func3 & opcode;
    case (multiplier_b) is
      when MULW =>
        -- RV64
        mult_opB <= absolute(sext32(opB32));
      when MULHSU =>
        mult_opB <= opB;
      when MULHU =>
        mult_opB <= opB;
      when others =>
        mult_opB <= absolute(opB);
    end case;
  end process;

  -- negate multiplier output?
  processing_2 : process (func3, func7, opA, opA32, opB, opB32, opcode)
    variable multiplier_negate : std_logic_vector(15 downto 0);
  begin
    multiplier_negate := 'X' & func7 & func3 & opcode;
    case (multiplier_negate) is
      when MUL =>
        mult_neg <= opA(XLEN-1) xor opB(XLEN-1);
      when MULH =>
        mult_neg <= opA(XLEN-1) xor opB(XLEN-1);
      when MULHSU =>
        mult_neg <= opA(XLEN-1);
      when MULHU =>
        mult_neg <= '0';
      when MULW =>
        -- RV64
        mult_neg <= opA32(31) xor opB32(31);
      when others =>
        mult_neg <= 'X';
    end case;
  end process;

  -- Actual multiplier
  mult_r <= std_logic_vector(unsigned(mult_opA_reg)*unsigned(mult_opB_reg));

  -- Correct sign
  mult_r_signed <= twos_dxlen(mult_r_reg)
                   when (mult_neg_reg = '0') else mult_r_reg;

  generating_0 : if (LATENCY = 0) generate
    --  * Single cycle multiplier
    --  *
    --  * Registers at: - output

    -- Register holding instruction for multiplier-output-selector
    mul_instr <= id_instr;

    -- Registers holding multiplier operands
    mult_opA_reg <= mult_opA;
    mult_opB_reg <= mult_opB;
    mult_neg_reg <= mult_neg;

    -- Register holding multiplier output
    mult_r_reg <= mult_r;

    -- Register holding sign correction
    mult_r_signed_reg <= mult_r_signed;
  end generate;
  generating_1 : if (LATENCY /= 0) generate

    --  * Multi cycle multiplier
    --  *
    --  * Registers at: - input
    --  *               - output

    -- Register holding instruction for multiplier-output-selector
    processing_3 : process (clk)
    begin
      if (rising_edge(clk)) then
        if (ex_stall = '0') then
          mul_instr <= id_instr;
        end if;
      end if;
    end process;

    -- Registers holding multiplier operands
    processing_4 : process (clk)
    begin
      if (rising_edge(clk)) then
        if (ex_stall = '0') then
          mult_opA_reg <= mult_opA;
          mult_opB_reg <= mult_opB;
          mult_neg_reg <= mult_neg;
        end if;
      end if;
    end process;

    generating_2 : if (LATENCY = 1) generate
      -- Register holding multiplier output
      mult_r_reg <= mult_r;

      -- Register holding sign correction
      mult_r_signed_reg <= mult_r_signed;
    end generate;
    generating_3 : if (LATENCY = 2) generate
      -- Register holding multiplier output
      processing_5 : process (clk)
      begin
        if (rising_edge(clk)) then
          mult_r_reg <= mult_r;
        end if;
      end process;

      -- Register holding sign correction
      mult_r_signed_reg <= mult_r_signed;
    end generate;
    generating_4 : if (LATENCY /= 1 and LATENCY /= 2) generate  -- Register holding multiplier output
      processing_6 : process (clk)
      begin
        if (rising_edge(clk)) then
          mult_r_reg <= mult_r;
        end if;
      end process;

      -- Register holding sign correction
      processing_7 : process (clk)
      begin
        if (rising_edge(clk)) then
          mult_r_signed_reg <= mult_r_signed;
        end if;
      end process;
    end generate;
  end generate;

  -- Final output register
  processing_8 : process (clk)
    variable output_register : std_logic_vector(15 downto 0);
  begin
    if (rising_edge(clk)) then
      output_register := 'X' & mul_func7 & mul_func3 & mul_opcode;
      case (output_register) is
        when MUL =>
          mul_r <= mult_r_signed_reg(XLEN-1 downto 0);
        when MULW =>
          -- RV64
          mul_r <= sext32(mult_r_signed_reg(31 downto 0));
        when others =>
          mul_r <= mult_r_signed_reg(DXLEN-1 downto XLEN);
      end case;
    end if;
  end process;

  -- Stall / Bubble generation
  processing_9 : process (mul_func3, mul_func7, mul_opcode, xlen32)
    variable generation : std_logic_vector(15 downto 0);
  begin
    generation := 'X' & mul_func7 & mul_func3 & mul_opcode;
    case (generation) is
      when MUL =>
        is_mul <= '1';
      when MULH =>
        is_mul <= '1';
      when MULW =>
        is_mul <= not xlen32;
      when MULHSU =>
        is_mul <= '1';
      when MULHU =>
        is_mul <= '1';
      when others =>
        is_mul <= '0';
    end case;
  end process;

  processing_10 : process (clk, rstn)
  begin
    if (rstn = '0') then
      state      <= ST_IDLE;
      cnt        <= "11";               -- LATENCY
      mul_bubble <= '1';
      mul_stall  <= '0';
    elsif (rising_edge(clk)) then
      mul_bubble <= '1';
      case (state) is
        when ST_IDLE =>
          if (ex_stall = '0') then
            if (id_bubble = '0' and is_mul = '1') then
              if (LATENCY = 0) then
                mul_bubble <= '0';
                mul_stall  <= '0';
              else
                state      <= ST_WAIT;
                cnt        <= std_logic_vector(unsigned(cnt)-"01");
                mul_bubble <= '1';
                mul_stall  <= '1';
              end if;
            end if;
          end if;
        when ST_WAIT =>
          if (reduce_or(cnt) = '1') then
            cnt <= std_logic_vector(unsigned(cnt)-"01");
          else
            state      <= ST_IDLE;
            cnt        <= "11";         -- LATENCY
            mul_bubble <= '0';
            mul_stall  <= '0';
          end if;
        when others =>
          null;
      end case;
    end if;
  end process;
end rtl;
