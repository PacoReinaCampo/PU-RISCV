-- Converted from rtl/verilog/core/riscv_if.sv
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
--              Core - Instruction Fetch                                      //
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

use work.pu_riscv_pkg.all;
use work.vhdl_pkg.all;

entity riscv_if is
  generic (
    XLEN           : integer := 64;
    ILEN           : integer := 64;
    PARCEL_SIZE    : integer := 64;
    EXCEPTION_SIZE : integer := 16;

    PC_INIT : std_logic_vector(63 downto 0) := X"0000000080000000"
  );
  port (
    rstn     : in std_logic;  --Reset
    clk      : in std_logic;  --Clock
    id_stall : in std_logic;

    if_stall_nxt_pc      : in std_logic;
    if_parcel            : in std_logic_vector(PARCEL_SIZE-1 downto 0);
    if_parcel_pc         : in std_logic_vector(XLEN-1 downto 0);
    if_parcel_valid      : in std_logic_vector(PARCEL_SIZE/16-1 downto 0);
    if_parcel_misaligned : in std_logic;
    if_parcel_page_fault : in std_logic;

    if_instr     : out std_logic_vector(ILEN-1 downto 0);  --Instruction out
    if_bubble    : out std_logic;  --Insert bubble in the pipe (NOP instruction)
    if_exception : out std_logic_vector(EXCEPTION_SIZE-1 downto 0);  --Exceptions


    bp_bp_predict : in  std_logic_vector(1 downto 0);  --Branch Prediction bits
    if_bp_predict : out std_logic_vector(1 downto 0);  --push down the pipe

    bu_flush : in std_logic;  --flush pipe & load new program counter
    st_flush : in std_logic;
    du_flush : in std_logic;  --flush pipe after debug exit

    bu_nxt_pc : in std_logic_vector(XLEN-1 downto 0);  --Branch Unit Next Program Counter
    st_nxt_pc : in std_logic_vector(XLEN-1 downto 0);  --State Next Program Counter

    if_nxt_pc : out std_logic_vector(XLEN-1 downto 0);  --next Program Counter
    if_stall  : out std_logic;  --stall instruction fetch BIU (cache/bus-interface)
    if_flush  : out std_logic;  --flush instruction fetch BIU (cache/bus-interface)
    if_pc     : out std_logic_vector(XLEN-1 downto 0)   --Program Counter
    );
end riscv_if;

architecture rtl of riscv_if is

  ------------------------------------------------------------------------------
  -- Variables
  ------------------------------------------------------------------------------

  --Instruction size
  signal is_16bit_instruction : std_logic;
  signal is_32bit_instruction : std_logic;
  --logic is_48bit_instruction;
  --logic is_64bit_instruction;

  signal flushes : std_logic;  --OR all flush signals

  signal parcel_shift_register : std_logic_vector(2*ILEN-1 downto 0);
  signal new_parcel            : std_logic_vector(ILEN-1 downto 0);
  signal active_parcel         : std_logic_vector(63 downto 0);
  signal converted_instruction : std_logic_vector(ILEN-1 downto 0);
  signal pd_instr              : std_logic_vector(ILEN-1 downto 0);
  signal pd_bubble             : std_logic;

  signal pd_pc            : std_logic_vector(XLEN-1 downto 0);
  signal parcel_valid     : std_logic_vector(PARCEL_SIZE/16-1 downto 0);
  signal parcel_sr_valid  : std_logic_vector(2 downto 0);
  signal parcel_sr_bubble : std_logic_vector(2 downto 0);

  signal opcode : std_logic_vector(6 downto 2);

  signal parcel_exception : std_logic_vector(EXCEPTION_SIZE-1 downto 0);
  signal pd_exception     : std_logic_vector(EXCEPTION_SIZE-1 downto 0);

  signal branch_pc    : std_logic_vector(XLEN-1 downto 0);
  signal branch_taken : std_logic;

  signal immB : std_logic_vector(XLEN-1 downto 0);
  signal immJ : std_logic_vector(XLEN-1 downto 0);

  signal if_nxt_pc_o : std_logic_vector(XLEN-1 downto 0);

begin
  ------------------------------------------------------------------------------
  -- Module Body
  ------------------------------------------------------------------------------

  --All flush signals
  flushes <= bu_flush or st_flush or du_flush;

  --Flush upper layer (memory BIU) 
  if_flush <= bu_flush or st_flush or du_flush or branch_taken;

  --stall program counter on ID-stall and when instruction-hold register is full
  if_stall <= id_stall or (reduce_and(parcel_sr_valid) and not flushes);

  --parcel is valid when bus-interface says so AND when received PC is requested PC
  processing_0 : process (clk, rstn)
  begin
    if (rstn = '0') then
      parcel_valid <= (others => '0');
    elsif (rising_edge(clk)) then
      parcel_valid <= if_parcel_valid;
    end if;
  end process;

  --Next Program Counter
  processing_1 : process (clk, rstn)
  begin
    if (rstn = '0') then
      if_nxt_pc_o <= PC_INIT;
    elsif (rising_edge(clk)) then
      if (st_flush = '1') then
        if_nxt_pc_o <= st_nxt_pc;
      elsif (bu_flush = '1' or du_flush = '1') then  --flush takes priority
        if_nxt_pc_o <= bu_nxt_pc;
      --else if (!id_stall)
      elsif (branch_taken = '1') then
        if_nxt_pc_o <= branch_pc;
      elsif (if_stall_nxt_pc = '0') then   --if_stall_nxt_pc
        if_nxt_pc_o <= std_logic_vector(unsigned(if_nxt_pc_o)+X"0000000000000004");
      end if;
    end if;
  end process;

  if_nxt_pc <= if_nxt_pc_o;

  --      else if (!if_stall_nxt_pc && !id_stall) if_nxt_pc_o <= if_nxt_pc_o + 'h4;
  --TODO: handle if_stall and 16bit instructions

  processing_2 : process (clk, rstn)
  begin
    if (rstn = '0') then
      pd_pc <= PC_INIT;
    elsif (rising_edge(clk)) then
      if (st_flush = '1') then
        pd_pc <= st_nxt_pc;
      elsif (bu_flush = '1' or du_flush = '1') then
        pd_pc <= bu_nxt_pc;
      elsif (branch_taken = '1' and id_stall = '0') then
        pd_pc <= branch_pc;
      elsif (if_parcel_valid = "1111" and id_stall = '0') then
        pd_pc <= if_parcel_pc;
      end if;
    end if;
  end process;

  processing_3 : process (clk, rstn)
  begin
    if (rstn = '0') then
      if_pc <= PC_INIT;
    elsif (rising_edge(clk)) then
      if (st_flush = '1') then
        if_pc <= st_nxt_pc;
      elsif (bu_flush = '1' or du_flush = '1') then
        if_pc <= bu_nxt_pc;
      elsif (id_stall = '0') then
        if_pc <= pd_pc;
      end if;
    end if;
  end process;

  --Instruction

  --instruction shift register, for 16bit instruction support
  new_parcel <= if_parcel(ILEN-1 downto 0);

  processing_4 : process (clk, rstn)
  begin
    if (rstn = '0') then
      parcel_shift_register <= (INSTR_NOP & INSTR_NOP);
    elsif (rising_edge(clk)) then
      if (flushes = '1') then
        parcel_shift_register <= (INSTR_NOP & INSTR_NOP);
      elsif (id_stall = '0') then
        if (branch_taken = '1') then
          parcel_shift_register <= (INSTR_NOP & INSTR_NOP);
        else
          case (parcel_sr_valid) is
            when "000" =>
              parcel_shift_register <= (INSTR_NOP & new_parcel);
            when "001" =>
              if (is_16bit_instruction = '1') then
                parcel_shift_register <= (INSTR_NOP & new_parcel);
              else
                parcel_shift_register <= (new_parcel & parcel_shift_register(XLEN-1 downto 0));
              end if;
            when "011" =>
              if (is_16bit_instruction = '1') then
                parcel_shift_register <= (new_parcel & parcel_shift_register(ILEN+XLEN-1 downto ILEN));
              else
                parcel_shift_register <= (INSTR_NOP & new_parcel);
              end if;
            when "111" =>
              if (is_16bit_instruction = '1') then
                parcel_shift_register <= (INSTR_NOP & parcel_shift_register(ILEN+XLEN-1 downto ILEN));
              else
                parcel_shift_register <= (new_parcel & parcel_shift_register(ILEN+XLEN-1 downto ILEN));
              end if;
            when others =>
              null;
          end case;
        end if;
      end if;
    end if;
  end process;

  processing_5 : process (clk, rstn)
  begin
    if (rstn = '0') then
      parcel_sr_valid <= (others => '0');
    elsif (rising_edge(clk)) then
      if (flushes = '1') then
        parcel_sr_valid <= (others => '0');
      elsif (id_stall = '0') then
        if (branch_taken = '1') then
          parcel_sr_valid <= (others => '0');
        else
          case (parcel_sr_valid) is
            --branch to 16bit address would yield 3'b010
            when "000" =>
              --3'b011;
              parcel_sr_valid <= if_parcel_valid(2 downto 0);
            when "001" =>
              --3'b011;
              if (is_16bit_instruction = '1') then
                parcel_sr_valid <= if_parcel_valid(2 downto 0);
              else                      --3'b111;
                parcel_sr_valid <= if_parcel_valid(2 downto 0);
              end if;
            when "011" =>
              --3'b111;
              if (is_16bit_instruction = '1') then
                parcel_sr_valid <= if_parcel_valid(2 downto 0);
              else                      --3'b011;
                parcel_sr_valid <= if_parcel_valid(2 downto 0);
              end if;
            when "111" =>
              --3'b011;
              if (is_16bit_instruction = '1') then
                parcel_sr_valid <= ('0' & '1' & '1');
              else                      --3'b111;
                parcel_sr_valid <= if_parcel_valid(2 downto 0);
              end if;
            when others =>
              null;
          end case;
        end if;
      end if;
    end if;
  end process;

  active_parcel <= parcel_shift_register(ILEN-1 downto 0);
  pd_bubble     <= not parcel_sr_valid(0)
               when (is_16bit_instruction = '1') else reduce_nand(parcel_sr_valid(1 downto 0));

  is_16bit_instruction <= reduce_nand(active_parcel(1 downto 0));
  is_32bit_instruction <= reduce_and(active_parcel(1 downto 0));
  --assign is_48bit_instruction = active_parcel[5:0] == 6'b011111;
  --assign is_64bit_instruction = active_parcel[6:0] == 7'b0111111;

  --Convert 16bit instructions to 32bit instructions here.
  processing_6 : process (active_parcel, is_32bit_instruction)
  begin
    case (active_parcel) is
      when WFI =>
        --Implement WFI as a nop 
        pd_instr <= INSTR_NOP;
      when others =>
        if (is_32bit_instruction = '1') then
          pd_instr <= active_parcel;
        else  --Illegal
          pd_instr <= std_logic_vector(to_signed(-1, ILEN));
        end if;
    end case;
  end process;

  processing_7 : process (clk, rstn)
  begin
    if (rstn = '0') then
      if_instr <= INSTR_NOP;
    elsif (rising_edge(clk)) then
      if (flushes = '1') then
        if_instr <= INSTR_NOP;
      elsif (id_stall = '0') then
        if_instr <= pd_instr;
      end if;
    end if;
  end process;

  processing_8 : process (clk, rstn)
  begin
    if (rstn = '0') then
      if_bubble <= '1';
    elsif (rising_edge(clk)) then
      if (flushes = '1') then
        if_bubble <= '1';
      elsif (id_stall = '0') then
        if_bubble <= pd_bubble;
      end if;
    end if;
  end process;

  --Branches & Jump
  immB <= ((XLEN-1 downto 12 => pd_instr(31)) & pd_instr(7) & pd_instr(30 downto 25) & pd_instr(11 downto 8) & '0');
  immJ <= ((XLEN-1 downto 20 => pd_instr(31)) & pd_instr(19 downto 12) & pd_instr(20) & pd_instr(30 downto 25) & pd_instr(24 downto 21) & '0');

  opcode <= pd_instr(6 downto 2);

  -- Branch and Jump prediction
  processing_9 : process (bp_bp_predict(1), immB, immJ, opcode, pd_bubble, pd_pc)
    variable prediction : std_logic_vector(5 downto 0);
  begin
    prediction := pd_bubble & opcode;
    case (prediction) is
      when (OPC0_JAL) =>
        branch_taken <= '1';
        branch_pc    <= std_logic_vector(unsigned(pd_pc)+unsigned(immJ));
      when (OPC0_BRANCH) =>
        --if this CPU has a Branch Predict Unit, then use it's prediction
        --otherwise assume backwards jumps taken, forward jumps not taken
        if (HAS_BPU = '1') then
          branch_taken <= bp_bp_predict(1);
        else
          branch_taken <= immB(31);
        end if;
        branch_pc <= std_logic_vector(unsigned(pd_pc)+unsigned(immB));
      when others =>
        branch_taken <= '0';
        branch_pc    <= (others => 'X');
    end case;
  end process;

  processing_10 : process (clk, rstn)
  begin
    if (rstn = '0') then
      if_bp_predict <= "00";
    elsif (rising_edge(clk)) then
      if (id_stall = '0') then
        if (HAS_BPU = '1') then
          if_bp_predict <= bp_bp_predict;
        else
          if_bp_predict <= (branch_taken & '0');
        end if;
      end if;
    end if;
  end process;

  --Exceptions

  --parcel-fetch
  processing_11 : process (clk, rstn)
  begin
    if (rstn = '0') then
      parcel_exception <= (others => '0');
    elsif (rising_edge(clk)) then
      if (flushes = '1') then
        parcel_exception <= (others => '0');
      elsif (parcel_valid = "1111" and id_stall = '0') then
        parcel_exception                                 <= (others => '0');
        parcel_exception(CAUSE_MISALIGNED_INSTRUCTION)   <= if_parcel_misaligned;
        parcel_exception(CAUSE_INSTRUCTION_ACCESS_FAULT) <= if_parcel_page_fault;
      end if;
    end if;
  end process;

  --pre-decode
  processing_12 : process (clk, rstn)
  begin
    if (rstn = '0') then
      pd_exception <= (others => '0');
    elsif (rising_edge(clk)) then
      if (flushes = '1') then
        pd_exception <= (others => '0');
      elsif (parcel_valid = "1111" and id_stall = '0') then
        pd_exception <= parcel_exception;
      end if;
    end if;
  end process;

  --instruction-fetch
  processing_13 : process (clk, rstn)
  begin
    if (rstn = '0') then
      if_exception <= (others => '0');
    elsif (rising_edge(clk)) then
      if (flushes = '1') then
        if_exception <= (others => '0');
      elsif (parcel_valid = "1111" and id_stall = '0') then
        if_exception <= pd_exception;
      end if;
    end if;
  end process;
end rtl;