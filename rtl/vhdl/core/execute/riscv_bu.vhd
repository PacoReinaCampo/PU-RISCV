-- Converted from rtl/verilog/core/execution/riscv_bu.sv
-- by verilog2vhdl - QueenField

--------------------------------------------------------------------------------
--                                            __ _      _     _               //
--                                           / _(_)    | |   | |              //
--                __ _ _   _  ___  ___ _ __ | |_ _  ___| | __| |              //
--               / _` | | | |/ _ \/ _ \ '_ \|  _| |/ _ \ |/ _` |              //
--              | (_| | |_| |  __/  __/ | | | | | |  __/ | (_| |              //
--               \__, |\__,_|\___|\___|_| |_|_| |_|\___|_|\__,_|              //
--                  | |                                                       //
--                  |_|                                                       //
--                                                                            //
--                                                                            //
--              MPSoC-RISCV CPU                                               //
--              Core - Branch Unit                                            //
--              AMBA3 AHB-Lite Bus Interface                                  //
--                                                                            //
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

entity riscv_bu is
  generic (
    XLEN           : integer := 64;
    ILEN           : integer := 64;
    EXCEPTION_SIZE : integer := 16;
    BP_GLOBAL_BITS : integer := 2;

    HAS_RVC : std_logic := '1';
    PC_INIT : std_logic_vector(63 downto 0) := X"0000000080000000"
  );
  port (
    rstn : in std_logic;
    clk  : in std_logic;

    ex_stall : in std_logic;
    st_flush : in std_logic;

    --Program counter
    id_pc         : in  std_logic_vector(XLEN-1 downto 0);
    bu_nxt_pc     : out std_logic_vector(XLEN-1 downto 0);
    bu_flush      : out std_logic;
    bu_cacheflush : out std_logic;
    id_bp_predict : in  std_logic_vector(1 downto 0);
    bu_bp_predict : out std_logic_vector(1 downto 0);
    bu_bp_history : out std_logic_vector(BP_GLOBAL_BITS-1 downto 0);
    bu_bp_btaken  : out std_logic;
    bu_bp_update  : out std_logic;

    --Instruction
    id_bubble : in std_logic;
    id_instr  : in std_logic_vector(63 downto 0);

    id_exception  : in  std_logic_vector(EXCEPTION_SIZE-1 downto 0);
    ex_exception  : in  std_logic_vector(EXCEPTION_SIZE-1 downto 0);
    mem_exception : in  std_logic_vector(EXCEPTION_SIZE-1 downto 0);
    wb_exception  : in  std_logic_vector(EXCEPTION_SIZE-1 downto 0);
    bu_exception  : out std_logic_vector(EXCEPTION_SIZE-1 downto 0);

    --from ID
    opA : in std_logic_vector(XLEN-1 downto 0);
    opB : in std_logic_vector(XLEN-1 downto 0);

    --Debug Unit
    du_stall : in std_logic;
    du_flush : in std_logic;
    du_we_pc : in std_logic;
    du_dato  : in std_logic_vector(XLEN-1 downto 0);
    du_ie    : in std_logic_vector(31 downto 0)
    );
end riscv_bu;

architecture rtl of riscv_bu is

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
  signal has_rvc_s : std_logic;

  --Operand generation
  signal immJ : std_logic_vector(XLEN-1 downto 0);
  signal immB : std_logic_vector(XLEN-1 downto 0);

  --Branch controls
  signal pipeflush    : std_logic;
  signal cacheflush   : std_logic;
  signal btaken       : std_logic;
  signal bp_update    : std_logic;
  signal bp_history   : std_logic_vector(BP_GLOBAL_BITS downto 0);
  signal nxt_pc       : std_logic_vector(XLEN-1 downto 0);
  signal du_nxt_pc    : std_logic_vector(XLEN-1 downto 0);
  signal du_we_pc_dly : std_logic;
  signal du_wrote_pc  : std_logic;

  signal bu_flush_o : std_logic;

begin
  ------------------------------------------------------------------------------
  -- Module Body
  ------------------------------------------------------------------------------

  --Instruction
  func7  <= id_instr(31 downto 25);
  func3  <= id_instr(14 downto 12);
  opcode <= id_instr(6 downto 2);

  has_rvc_s <= to_stdlogic(HAS_RVC /= '0');

  --Exceptions
  processing_0 : process (clk, rstn)
    variable exceptions : std_logic_vector(5 downto 0);
  begin
    if (rstn = '0') then
      bu_exception <= (others => '0');
    elsif (rising_edge(clk)) then
      if (ex_stall = '0') then
        if (bu_flush_o               = '1' or
            st_flush                 = '1' or
            reduce_or(ex_exception)  = '1' or
            reduce_or(mem_exception) = '1' or
            reduce_or(wb_exception)  = '1') then
          bu_exception <= (others => '0');
        elsif (du_stall = '0') then
          bu_exception <= id_exception;
          exceptions := id_bubble & opcode;
          case (exceptions) is
            when (OPC0_JALR) =>
              if (id_exception(CAUSE_MISALIGNED_INSTRUCTION) = '1' or has_rvc_s = '1') then
                bu_exception(CAUSE_MISALIGNED_INSTRUCTION) <= nxt_pc(0);
              else
                bu_exception(CAUSE_MISALIGNED_INSTRUCTION) <= reduce_or(nxt_pc(1 downto 0));
              end if;
            when (OPC0_BRANCH) =>
              if (id_exception(CAUSE_MISALIGNED_INSTRUCTION) = '1' or has_rvc_s = '1') then
                bu_exception(CAUSE_MISALIGNED_INSTRUCTION) <= nxt_pc(0);
              else
                bu_exception(CAUSE_MISALIGNED_INSTRUCTION) <= reduce_or(nxt_pc(1 downto 0));
              end if;
            when others =>
              bu_exception(CAUSE_MISALIGNED_INSTRUCTION) <= id_exception(CAUSE_MISALIGNED_INSTRUCTION);
          end case;
        end if;
      end if;
    end if;
  end process;

  --Decode Immediates
  immJ <= ((XLEN-1 downto 20 => id_instr(31)) & id_instr(19 downto 12) & id_instr(20) & id_instr(30 downto 25) & id_instr(24 downto 21) & '0');
  immB <= ((XLEN-1 downto 12 => id_instr(31)) & id_instr(7) & id_instr(30 downto 25) & id_instr(11 downto 8) & '0');

  --  * Program Counter modifications
  --  * - Branches/JALR (JAL/JALR results handled by ALU)
  --  * - Exceptions
  --  * - Debug Unit NPC access

  processing_1 : process (clk)
  begin
    if (rising_edge(clk)) then
      du_we_pc_dly <= du_we_pc;
    end if;
  end process;

  processing_2 : process (clk, rstn)
  begin
    if (rstn = '0') then
      du_wrote_pc <= '0';
    elsif (rising_edge(clk)) then
      du_wrote_pc <= du_we_pc or (du_wrote_pc and du_stall);
    end if;
  end process;

  processing_3 : process (clk)
  begin
    if (rising_edge(clk)) then
      if (du_we_pc = '1') then
        du_nxt_pc <= du_dato;
      end if;
    end if;
  end process;

  processing_4 : process (btaken, func3, func7, id_bp_predict, id_bubble, id_instr, id_pc, immB, immJ, opA, opB, opcode)
    variable debug : std_logic_vector(15 downto 0);
  begin
    debug := id_bubble & func7 & func3 & opcode;
    case (debug) is
      when (JAL) =>
        --This is really only for the debug unit, such that NPC points to the correct address
        btaken     <= '1';
        bp_update  <= '0';
        pipeflush  <= '0';  --Handled in IF, do NOT flush here!!
        cacheflush <= '0';
        nxt_pc     <= std_logic_vector(unsigned(id_pc)+unsigned(immJ));
      when (JALR) =>
        btaken     <= '1';
        bp_update  <= '0';
        pipeflush  <= '1';
        cacheflush <= '0';
        nxt_pc     <= std_logic_vector(unsigned(opA)+unsigned(opB)) and X"1111111111111110";
      when (BEQ) =>
        btaken     <= to_stdlogic(opA = opB);
        bp_update  <= '1';
        pipeflush  <= btaken xor id_bp_predict(1);
        cacheflush <= '0';
        if (btaken = '1') then
          nxt_pc <= std_logic_vector(unsigned(id_pc)+unsigned(immB));
        else
          nxt_pc <= std_logic_vector(unsigned(id_pc)+X"0000000000000004");
        end if;
      when (BNE) =>
        btaken     <= to_stdlogic(opA /= opB);
        bp_update  <= '1';
        pipeflush  <= btaken xor id_bp_predict(1);
        cacheflush <= '0';
        if (btaken = '1') then
          nxt_pc <= std_logic_vector(unsigned(id_pc)+unsigned(immB));
        else
          nxt_pc <= std_logic_vector(unsigned(id_pc)+X"0000000000000004");
        end if;
      when (BLTU) =>
        btaken     <= to_stdlogic(opA < opB);
        bp_update  <= '1';
        pipeflush  <= btaken xor id_bp_predict(1);
        cacheflush <= '0';
        if (btaken = '1') then
          nxt_pc <= std_logic_vector(unsigned(id_pc)+unsigned(immB));
        else
          nxt_pc <= std_logic_vector(unsigned(id_pc)+X"0000000000000004");
        end if;
      when (BGEU) =>
        btaken     <= to_stdlogic(opA >= opB);
        bp_update  <= '1';
        pipeflush  <= btaken xor id_bp_predict(1);
        cacheflush <= '0';
        if (btaken = '1') then
          nxt_pc <= std_logic_vector(unsigned(id_pc)+unsigned(immB));
        else
          nxt_pc <= std_logic_vector(unsigned(id_pc)+X"0000000000000004");
        end if;
      when (BLT) =>
        btaken     <= to_stdlogic(signed(opA) < signed(opB));
        bp_update  <= '1';
        pipeflush  <= btaken xor id_bp_predict(1);
        cacheflush <= '0';
        if (btaken = '1') then
          nxt_pc <= std_logic_vector(unsigned(id_pc)+unsigned(immB));
        else
          nxt_pc <= std_logic_vector(unsigned(id_pc)+X"0000000000000004");
        end if;
      when (BGE) =>
        btaken     <= to_stdlogic(signed(opA) >= signed(opB));
        bp_update  <= '1';
        pipeflush  <= btaken xor id_bp_predict(1);
        cacheflush <= '0';
        if (btaken = '1') then
          nxt_pc <= std_logic_vector(unsigned(id_pc)+unsigned(immB));
        else
          nxt_pc <= std_logic_vector(unsigned(id_pc)+X"0000000000000004");
        end if;
      when (MISCMEM) =>
        case (id_instr) is
          when FENCE_I =>
            btaken     <= '0';
            bp_update  <= '0';
            pipeflush  <= '1';
            cacheflush <= '1';
            nxt_pc     <= std_logic_vector(unsigned(id_pc)+X"0000000000000004");
          when others =>
            btaken     <= '0';
            bp_update  <= '0';
            pipeflush  <= '0';
            cacheflush <= '0';
            nxt_pc     <= std_logic_vector(unsigned(id_pc)+X"0000000000000004");
        end case;
      when others =>
        btaken     <= '0';
        bp_update  <= '0';
        pipeflush  <= '0';
        cacheflush <= '0';
        nxt_pc     <= std_logic_vector(unsigned(id_pc)+X"0000000000000004");  --TODO: handle 16bit instructions
    end case;
  end process;

  --Program Counter modifications (Branches/JALR)
  processing_5 : process (clk, rstn)
  begin
    if (rstn = '0') then
      bu_flush_o    <= '1';
      bu_cacheflush <= '0';
      bu_nxt_pc     <= PC_INIT;

      bu_bp_predict <= "00";
      bu_bp_btaken  <= '0';
      bu_bp_update  <= '0';
      bp_history    <= (others => '0');
    elsif (rising_edge(clk)) then
      if (du_wrote_pc = '1') then
        bu_flush_o    <= du_we_pc_dly;
        bu_cacheflush <= '0';
        bu_nxt_pc     <= du_nxt_pc;
        bu_bp_predict <= "00";
        bu_bp_btaken  <= '0';
        bu_bp_update  <= '0';
      else
        bu_flush_o    <= (pipeflush and not du_stall and not du_flush);
        bu_cacheflush <= cacheflush;
        bu_nxt_pc     <= nxt_pc;
        bu_bp_predict <= id_bp_predict;
        bu_bp_btaken  <= btaken;
        bu_bp_update  <= bp_update;
        if (bp_update = '1') then
          bp_history <= (bp_history(BP_GLOBAL_BITS-1 downto 0) & btaken);
        end if;
      end if;
    end if;
  end process;

  bu_flush <= bu_flush_o;

  --don't take myself (current branch) into account when updating branch history
  bu_bp_history <= bp_history(BP_GLOBAL_BITS downto 1);
end rtl;