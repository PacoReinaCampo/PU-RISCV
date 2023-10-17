-- Converted from rtl/verilog/core/execution/pu_riscv_div.sv
-- by verilog2vhdl - QueenField

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
--              Core - Division Unit                                          --
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
--

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

use work.pu_riscv_vhdl_pkg.all;
use work.vhdl_pkg.all;

entity pu_riscv_div is
  generic (
    XLEN : integer := 64;
    ILEN : integer := 64
  );
  port (
    rstn : in std_logic;
    clk  : in std_logic;

    ex_stall  : in  std_logic;
    div_stall : out std_logic;

    --Instruction
    id_bubble : in std_logic;
    id_instr  : in std_logic_vector(ILEN-1 downto 0);

    --Operands
    opA : in std_logic_vector(XLEN-1 downto 0);
    opB : in std_logic_vector(XLEN-1 downto 0);

    --From State
    st_xlen : in std_logic_vector(1 downto 0);

    --To WB
    div_bubble : out std_logic;
    div_r      : out std_logic_vector(XLEN-1 downto 0)
  );
end pu_riscv_div;

architecture rtl of pu_riscv_div is
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
  constant ST_CHK : std_logic_vector(1 downto 0) := "00";
  constant ST_DIV : std_logic_vector(1 downto 0) := "01";
  constant ST_RES : std_logic_vector(1 downto 0) := "10";

  constant CNT_SIZE : integer := integer(log2(real(XLEN)));

  ------------------------------------------------------------------------------
  -- Variables
  ------------------------------------------------------------------------------
  signal xlen32    : std_logic;
  signal div_instr : std_logic_vector(ILEN-1 downto 0);

  signal opcode     : std_logic_vector(6 downto 2);
  signal div_opcode : std_logic_vector(6 downto 2);
  signal func3      : std_logic_vector(2 downto 0);
  signal div_func3  : std_logic_vector(2 downto 0);
  signal func7      : std_logic_vector(6 downto 0);
  signal div_func7  : std_logic_vector(6 downto 0);

  --Operand generation
  signal opA32 : std_logic_vector(31 downto 0);
  signal opB32 : std_logic_vector(31 downto 0);

  signal cnt   : std_logic_vector(CNT_SIZE-1 downto 0);
  signal neg_q : std_logic;             --negate quotient
  signal neg_s : std_logic;             --negate remainder

  --divider internals
  signal pa_p         : std_logic_vector(XLEN-1 downto 0);
  signal pa_a         : std_logic_vector(XLEN-1 downto 0);
  signal pa_shifted_p : std_logic_vector(XLEN-1 downto 0);
  signal pa_shifted_a : std_logic_vector(XLEN-1 downto 0);

  signal p_minus_b : std_logic_vector(XLEN downto 0);
  signal b         : std_logic_vector(XLEN-1 downto 0);

  --FSM
  signal state : std_logic_vector(1 downto 0);

begin
  ------------------------------------------------------------------------------
  -- Module Body
  ------------------------------------------------------------------------------

  --Instruction
  func7  <= id_instr(31 downto 25);
  func3  <= id_instr(14 downto 12);
  opcode <= id_instr(6 downto 2);

  div_func7  <= div_instr(31 downto 25);
  div_func3  <= div_instr(14 downto 12);
  div_opcode <= div_instr(6 downto 2);

  xlen32 <= to_stdlogic(st_xlen = RV32I);

  --retain instruction
  processing_0 : process (clk)
  begin
    if (rising_edge(clk)) then
      if (ex_stall = '0') then
        div_instr <= id_instr;
      end if;
    end if;
  end process;

  --32bit operands
  opA32 <= opA(31 downto 0);
  opB32 <= opB(31 downto 0);

  --Divide operations
  pa_shifted_p <= std_logic_vector(unsigned(pa_p) sll 1);
  pa_shifted_a <= std_logic_vector(unsigned(pa_a) sll 1);
  p_minus_b    <= std_logic_vector(('0' & unsigned(pa_shifted_p))-('0' & unsigned(b)));

  --Division: bit-serial. Max XLEN cycles
  -- q = z/d + s
  -- z: Dividend
  -- d: Divisor
  -- q: Quotient
  -- s: Remainder
  processing_1 : process (clk, rstn)
    variable dividor_register : std_logic_vector(15 downto 0);
    variable result_st        : std_logic_vector(15 downto 0);
  begin
    if (rstn = '0') then
      state      <= ST_CHK;
      div_bubble <= '1';
      div_stall  <= '0';

      div_r <= (others => 'X');

      pa_p  <= (others => 'X');
      pa_a  <= (others => 'X');
      b     <= (others => 'X');
      neg_q <= 'X';
      neg_s <= 'X';
    elsif (rising_edge(clk)) then
      div_bubble <= '1';
      case (state) is
        --  * Check for exceptions (divide by zero, signed overflow)
        --  * Setup dividor registers
        when ST_CHK =>
          if (ex_stall = '0' and id_bubble = '0') then
            dividor_register := xlen32 & func7 & func3 & opcode;
            case (dividor_register) is
              when (DIV) =>
                --signed divide by zero
                if (reduce_nor(opB) = '1') then
                  div_r      <= (others => '1');  --=-1
                  div_bubble <= '0';
                elsif (opA = X"1000000000000000" and reduce_and(opB) = '1') then  -- signed overflow (Dividend=-2^(XLEN-1), Divisor=-1)
                  div_r      <= X"1111111111111110";
                  div_bubble <= '0';
                else
                  cnt       <= (others => '1');
                  state     <= ST_DIV;
                  div_stall <= '1';

                  neg_q <= opA(XLEN-1) xor opB(XLEN-1);
                  neg_s <= opA(XLEN-1);

                  pa_p <= (others => '0');
                  pa_a <= absolute(opA);
                  b    <= absolute(opB);
                end if;
              when (DIVW) =>
                --signed divide by zero
                if (reduce_nor(opB32) = '1') then
                  div_r      <= (others => '1');  --=-1
                  div_bubble <= '0';
                elsif (opA32 = X"10000000" and reduce_and(opB32) = '1') then  -- signed overflow (Dividend=-2^(XLEN-1), Divisor=-1)
                  div_r      <= sext32((31 => '1', 30 downto 0 => '0'));
                  div_bubble <= '0';
                else
                  cnt       <= (others => '1');   --minus 1000...000
                  state     <= ST_DIV;
                  div_stall <= '1';

                  neg_q <= opA32(31) xor opB32(31);
                  neg_s <= opA32(31);

                  pa_p <= (others => '0');
                  pa_a <= absolute(sext32(opA32));
                  b    <= absolute(sext32(opB32));
                end if;
              when (DIVU) =>
                --unsigned divide by zero
                if (reduce_nor(opB) = '1') then
                  div_r      <= (others => '1');  --= 2^XLEN -1
                  div_bubble <= '0';
                else
                  cnt       <= (others => '1');
                  state     <= ST_DIV;
                  div_stall <= '1';

                  neg_q <= '0';
                  neg_s <= '0';

                  pa_p <= (others => '0');
                  pa_a <= opA;
                  b    <= opB;
                end if;
              when (DIVUW) =>
                --unsigned divide by zero
                if (reduce_nor(opB32) = '1') then
                  div_r      <= (others => '1');  --= 2^XLEN -1
                  div_bubble <= '0';
                else
                  cnt       <= (others => '1');   --minus 1000...000
                  state     <= ST_DIV;
                  div_stall <= '1';

                  neg_q <= '0';
                  neg_s <= '0';

                  pa_p <= (others                    => '0');
                  pa_a <= (opA32 & (XLEN-33 downto 0 => '0'));
                  b    <= ((XLEN-1 downto 32         => '0') & opB32);
                end if;
              when (REMX) =>
                --signed divide by zero
                if (reduce_nor(opB) = '1') then
                  div_r      <= opA;
                  div_bubble <= '0';
                elsif (opA = X"1000000000000000" and reduce_and(opB) = '1') then  -- signed overflow (Dividend=-2^(XLEN-1), Divisor=-1)
                  div_r      <= (others => '0');
                  div_bubble <= '0';
                else
                  cnt       <= (others => '1');
                  state     <= ST_DIV;
                  div_stall <= '1';

                  neg_q <= opA(XLEN-1) xor opB(XLEN-1);
                  neg_s <= opA(XLEN-1);

                  pa_p <= (others => '0');
                  pa_a <= absolute(opA);
                  b    <= absolute(opB);
                end if;
              when (REMW) =>
                --signed divide by zero
                if (reduce_nor(opB32) = '1') then
                  div_r      <= sext32(opA32);
                  div_bubble <= '0';
                elsif (opA32 = X"10000000" and reduce_and(opB32) = '1') then  -- signed overflow (Dividend=-2^(XLEN-1), Divisor=-1)
                  div_r      <= (others => '0');
                  div_bubble <= '0';
                else
                  cnt       <= (others => '1');  --minus 1000...000
                  state     <= ST_DIV;
                  div_stall <= '1';

                  neg_q <= opA32(31) xor opB32(31);
                  neg_s <= opA32(31);

                  pa_p <= (others => '0');
                  pa_a <= absolute(sext32(opA32));
                  b    <= absolute(sext32(opB32));
                end if;
              when (REMU) =>
                --unsigned divide by zero
                if (reduce_nor(opB) = '1') then
                  div_r      <= opA;
                  div_bubble <= '0';
                else
                  cnt       <= (others => '1');
                  state     <= ST_DIV;
                  div_stall <= '1';

                  neg_q <= '0';
                  neg_s <= '0';

                  pa_p <= (others => '0');
                  pa_a <= opA;
                  b    <= opB;
                end if;
              when (REMUW) =>
                if (reduce_nor(opB32) = '1') then
                  div_r      <= sext32(opA32);
                  div_bubble <= '0';
                else
                  cnt       <= (others => '1');  --minus 1000...000
                  state     <= ST_DIV;
                  div_stall <= '1';

                  neg_q <= '0';
                  neg_s <= '0';

                  pa_p <= (others                      => '0');
                  pa_a <= (opA32 & (XLEN-32-1 downto 0 => '0'));
                  b    <= ((XLEN-1 downto 32           => '0') & opB32);
                end if;
              when others =>
                null;
            end case;
          end if;
        --actual division loop
        when ST_DIV =>
          cnt <= std_logic_vector(unsigned(cnt) - "01");
          if (reduce_nor(cnt) = '1') then
            state <= ST_RES;
          end if;
          --restoring divider section
          if (p_minus_b(XLEN) = '1') then  --sub gave negative result
            pa_p <= pa_shifted_p;       --restore
            pa_a <= (pa_shifted_a(XLEN-1 downto 1) & '0');  --shift in '0' for Q
          else                          --sub gave positive result
            --store sub result
            pa_p <= p_minus_b(XLEN-1 downto 0);
            pa_a <= (pa_shifted_a(XLEN-1 downto 1) & '1');  --shift in '1' for Q
          end if;
        --Result
        when ST_RES =>
          state      <= ST_CHK;
          div_bubble <= '0';
          div_stall  <= '0';
          result_st  := 'X' & div_func7 & div_func3 & div_opcode;
          case (result_st) is
            when DIV =>
              if (neg_q = '1') then
                div_r <= twos(pa_a);
              else
                div_r <= pa_a;
              end if;
            when DIVW =>
              if (neg_q = '1') then
              --div_r <= sext32(twos(pa_a));
              else
                div_r <= pa_a;
          end if;
        when DIVU =>
          div_r <= pa_a;
        when DIVUW =>
          div_r <= pa_a;
        when REMX =>
          if (neg_s = '1') then
            div_r <= pa_p;
          else
            div_r <= pa_p;
          end if;
        when REMW =>
          if (neg_s = '1') then
          --div_r <= sext32(twos(pa_p));
          else
            div_r <= pa_p;
      end if;
    when REMU =>
    div_r <= pa_p;
    when REMUW =>
    div_r <= pa_p;
    when others =>
    div_r <= (others => 'X');
  end case;
  when others =>
  null;
end case;
end if;
end process;
end rtl;
