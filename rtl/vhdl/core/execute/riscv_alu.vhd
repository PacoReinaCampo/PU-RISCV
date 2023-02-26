-- Converted from rtl/verilog/core/execution/riscv_alu.sv
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
--              Core - Arithmetic & Logical Unit                              --
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

use work.pu_riscv_pkg.all;
use work.vhdl_pkg.all;

entity riscv_alu is
  generic (
    XLEN    : integer := 64;
    ILEN    : integer := 64;
    HAS_RVC : std_logic := '1'
  );
  port (
    rstn : in std_logic;
    clk  : in std_logic;

    ex_stall : in std_logic;

    --Program counter
    id_pc : in std_logic_vector(XLEN-1 downto 0);

    --Instruction
    id_bubble : in std_logic;
    id_instr  : in std_logic_vector(ILEN-1 downto 0);

    --Operands
    opA : in std_logic_vector(XLEN-1 downto 0);
    opB : in std_logic_vector(XLEN-1 downto 0);

    --to WB
    alu_bubble : out std_logic;
    alu_r      : out std_logic_vector(XLEN-1 downto 0);

    --To State
    ex_csr_reg  : out std_logic_vector(11 downto 0);
    ex_csr_wval : out std_logic_vector(XLEN-1 downto 0);
    ex_csr_we   : out std_logic;

    --From State
    st_csr_rval : in std_logic_vector(XLEN-1 downto 0);
    st_xlen     : in std_logic_vector(1 downto 0)
  );
end riscv_alu;

architecture rtl of riscv_alu is
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

  ------------------------------------------------------------------------------
  -- Constants
  ------------------------------------------------------------------------------
  constant SBITS : integer := integer(log2(real(XLEN)));

  ------------------------------------------------------------------------------
  -- Variables
  ------------------------------------------------------------------------------
  signal opcode    : std_logic_vector(6 downto 2);
  signal func3     : std_logic_vector(2 downto 0);
  signal func7     : std_logic_vector(6 downto 0);
  signal rs1       : std_logic_vector(4 downto 0);
  signal xlen32    : std_logic;
  signal has_rvc_s : std_logic;

  --Operand generation
  signal opA32   : std_logic_vector(31 downto 0);
  signal opB32   : std_logic_vector(31 downto 0);
  signal shamt   : std_logic_vector(SBITS-1 downto 0);
  signal shamt32 : std_logic_vector(4 downto 0);
  signal csri    : std_logic_vector(XLEN-1 downto 0);

begin
  ------------------------------------------------------------------------------
  -- Module Body
  ------------------------------------------------------------------------------

  --Instruction
  func7  <= id_instr(31 downto 25);
  func3  <= id_instr(14 downto 12);
  opcode <= id_instr(6 downto 2);

  xlen32    <= to_stdlogic(st_xlen = RV32I);
  has_rvc_s <= to_stdlogic(HAS_RVC /= '0');

  opA32   <= opA(31 downto 0);
  opB32   <= opB(31 downto 0);
  shamt   <= opB(SBITS-1 downto 0);
  shamt32 <= opB(4 downto 0);

  --ALU operations
  processing_0 : process (clk, rstn)
    variable operations : std_logic_vector(15 downto 0);
  begin
    if (rstn = '0') then
      alu_r <= (others => '0');
    elsif (rising_edge(clk)) then
      if (ex_stall = '0') then
        operations := xlen32 & func7 & func3 & opcode;
        case (operations) is
          when (LUI) =>
            --actually just opB, but simplify encoding
            alu_r <= std_logic_vector(unsigned(opA)+unsigned(opB));
          when (AUIPC) =>
            alu_r <= std_logic_vector(unsigned(opA)+unsigned(opB));
          when (JAL) =>
            alu_r <= std_logic_vector(unsigned(id_pc)+X"0000000000000004");
          when (JALR) =>
            alu_r <= std_logic_vector(unsigned(id_pc)+X"0000000000000004");
          --logical operators
          when (ADDI) =>
            alu_r <= std_logic_vector(unsigned(opA)+unsigned(opB));
          when (ADDX) =>
            alu_r <= std_logic_vector(unsigned(opA)+unsigned(opB));
          when (ADDIW) =>
            --RV64
            alu_r <= sext32(std_logic_vector(unsigned(opA32)+unsigned(opB32)));
          when (ADDW) =>
            --RV64
            alu_r <= sext32(std_logic_vector(unsigned(opA32)+unsigned(opB32)));
          when (SUBX) =>
            alu_r <= std_logic_vector(unsigned(opA)+unsigned(opB));
          when (SUBW) =>
            --RV64
            alu_r <= sext32(std_logic_vector(unsigned(opA32)-unsigned(opB32)));
          when (XORI) =>
            alu_r <= opA xor opB;
          when (XORX) =>
            alu_r <= opA xor opB;
          when (ORI) =>
            alu_r <= opA or opB;
          when (ORX) =>
            alu_r <= opA or opB;
          when (ANDI) =>
            alu_r <= opA and opB;
          when (ANDX) =>
            alu_r <= opA and opB;
          when (SLLI) =>
            alu_r <= std_logic_vector(unsigned(opA) sll to_integer(unsigned(shamt)));
          when (SLLX) =>
            alu_r <= std_logic_vector(unsigned(opA) sll to_integer(unsigned(shamt)));
          when (SLLIW) =>
            --RV64
            alu_r <= sext32(std_logic_vector(unsigned(opA32) sll to_integer(unsigned(shamt32))));
          when (SLLW) =>
            --RV64
            alu_r <= sext32(std_logic_vector(unsigned(opA32) sll to_integer(unsigned(shamt32))));
          when (SLTI) =>
            if (not opA(XLEN-1) & opA(XLEN-2 downto 0)) < (not opB(XLEN-1) & opB(XLEN-2 downto 0)) then
              alu_r <= (others => '1');
            else
              alu_r <= (others => '0');
            end if;
          when (SLT) =>
            if (not opA(XLEN-1) & opA(XLEN-2 downto 0)) < (not opB(XLEN-1) & opB(XLEN-2 downto 0)) then
              alu_r <= (others => '1');
            else
              alu_r <= (others => '0');
            end if;
          when (SLTIU) =>
            if (opA < opB) then
              alu_r <= (others => '1');
            else
              alu_r <= (others => '0');
            end if;
          when (SLTU) =>
            if (opA < opB) then
              alu_r <= (others => '1');
            else
              alu_r <= (others => '0');
            end if;
          when (SRLI) =>
            alu_r <= std_logic_vector(unsigned(opA) srl to_integer(unsigned(shamt)));
          when (SRLX) =>
            alu_r <= std_logic_vector(unsigned(opA) srl to_integer(unsigned(shamt)));
          when (SRLIW) =>
            --RV64
            alu_r <= sext32(std_logic_vector(unsigned(opA32) srl to_integer(unsigned(shamt32))));
          when (SRLW) =>
            --RV64
            alu_r <= sext32(std_logic_vector(unsigned(opA32) srl to_integer(unsigned(shamt32))));
          when (SRAI) =>
            alu_r <= std_logic_vector(signed(opA) srl to_integer(unsigned(shamt)));
          when (SRAX) =>
            alu_r <= std_logic_vector(signed(opA) srl to_integer(unsigned(shamt)));
          when (SRAIW) =>
            alu_r <= std_logic_vector(signed(sext32(opA32)) srl to_integer(unsigned(shamt32)));
          when (SRAW) =>
            alu_r <= std_logic_vector(signed(sext32(opA32)) srl to_integer(unsigned(shamt32)));
          --CSR access
          when (CSRRW) =>
            alu_r <= (alu_r'range => '0') or st_csr_rval;
          when (CSRRWI) =>
            alu_r <= (alu_r'range => '0') or st_csr_rval;
          when (CSRRS) =>
            alu_r <= (alu_r'range => '0') or st_csr_rval;
          when (CSRRSI) =>
            alu_r <= (alu_r'range => '0') or st_csr_rval;
          when (CSRRC) =>
            alu_r <= (alu_r'range => '0') or st_csr_rval;
          when (CSRRCI) =>
            alu_r <= (alu_r'range => '0') or st_csr_rval;
          when others =>
            alu_r <= (others => 'X');
        end case;
      end if;
    end if;
  end process;

  processing_1 : process (clk, rstn)
    variable bubble : std_logic_vector(15 downto 0);
  begin
    if (rstn = '0') then
      alu_bubble <= '1';
    elsif (rising_edge(clk)) then
      if (ex_stall = '0') then
        bubble := xlen32 & func7 & func3 & opcode;
        case (bubble) is
          when (LUI) =>
            alu_bubble <= id_bubble;
          when (AUIPC) =>
            alu_bubble <= id_bubble;
          when (JAL) =>
            alu_bubble <= id_bubble;
          when (JALR) =>
            alu_bubble <= id_bubble;
          --logical operators
          when (ADDI) =>
            alu_bubble <= id_bubble;
          when (ADDX) =>
            alu_bubble <= id_bubble;
          when (ADDIW) =>
            alu_bubble <= id_bubble;
          when (ADDW) =>
            alu_bubble <= id_bubble;
          when (SUBX) =>
            alu_bubble <= id_bubble;
          when (SUBW) =>
            alu_bubble <= id_bubble;
          when (XORI) =>
            alu_bubble <= id_bubble;
          when (XORX) =>
            alu_bubble <= id_bubble;
          when (ORI) =>
            alu_bubble <= id_bubble;
          when (ORX) =>
            alu_bubble <= id_bubble;
          when (ANDI) =>
            alu_bubble <= id_bubble;
          when (ANDX) =>
            alu_bubble <= id_bubble;
          when (SLLI) =>
            alu_bubble <= id_bubble;
          when (SLLX) =>
            alu_bubble <= id_bubble;
          when (SLLIW) =>
            alu_bubble <= id_bubble;
          when (SLLW) =>
            alu_bubble <= id_bubble;
          when (SLTI) =>
            alu_bubble <= id_bubble;
          when (SLT) =>
            alu_bubble <= id_bubble;
          when (SLTIU) =>
            alu_bubble <= id_bubble;
          when (SLTU) =>
            alu_bubble <= id_bubble;
          when (SRLI) =>
            alu_bubble <= id_bubble;
          when (SRLX) =>
            alu_bubble <= id_bubble;
          when (SRLIW) =>
            alu_bubble <= id_bubble;
          when (SRLW) =>
            alu_bubble <= id_bubble;
          when (SRAI) =>
            alu_bubble <= id_bubble;
          when (SRAX) =>
            alu_bubble <= id_bubble;
          when (SRAIW) =>
            alu_bubble <= id_bubble;
          when (SRAW) =>
            alu_bubble <= id_bubble;
          --CSR access
          when (CSRRW) =>
            alu_bubble <= id_bubble;
          when (CSRRWI) =>
            alu_bubble <= id_bubble;
          when (CSRRS) =>
            alu_bubble <= id_bubble;
          when (CSRRSI) =>
            alu_bubble <= id_bubble;
          when (CSRRC) =>
            alu_bubble <= id_bubble;
          when (CSRRCI) =>
            alu_bubble <= id_bubble;
          when others =>
            alu_bubble <= '1';
        end case;
      end if;
    end if;
  end process;

  --CSR
  ex_csr_reg <= id_instr(31 downto 20);
  csri       <= ((XLEN-1 downto 5 => '0') & opB(4 downto 0));

  processing_2 : process (opA, csri, func3, func7, id_bubble, opcode, st_csr_rval)
    variable csr : std_logic_vector(15 downto 0);
  begin
    csr := id_bubble & func7 & func3 & opcode;
    case (csr) is
      when (CSRRW) =>
        ex_csr_we   <= '1';
        ex_csr_wval <= opA;
      when (CSRRWI) =>
        ex_csr_we   <= reduce_or(csri);
        ex_csr_wval <= csri;
      when (CSRRS) =>
        ex_csr_we   <= reduce_or(opA);
        ex_csr_wval <= st_csr_rval or opA;
      when (CSRRSI) =>
        ex_csr_we   <= reduce_or(csri);
        ex_csr_wval <= st_csr_rval or csri;
      when (CSRRC) =>
        ex_csr_we   <= reduce_or(opA);
        ex_csr_wval <= st_csr_rval and not opA;
      when (CSRRCI) =>
        ex_csr_we   <= reduce_or(csri);
        ex_csr_wval <= st_csr_rval and not csri;
      when others =>
        ex_csr_we   <= '0';
        ex_csr_wval <= (others => 'X');
    end case;
  end process;
end rtl;