-- Converted from rtl/verilog/core/pu_riscv_wb.sv
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
--              Core - Data Memory Access (Write Back)                        --
--              Wishbone Bus Interface                                        --
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

use work.pu_riscv_vhdl_pkg.all;
use work.peripheral_biu_vhdl_pkg.all;
use work.vhdl_pkg.all;

entity pu_riscv_wb is
  generic (
    XLEN : integer := 64;
    ILEN : integer := 64;

    EXCEPTION_SIZE : integer := 16;

    PC_INIT : std_logic_vector(63 downto 0) := X"0000000080000000"
  );
  port (
    rst_ni : in std_logic;              --Reset
    clk_i  : in std_logic;              --Clock

    wb_stall_o : out std_logic;         --Stall on memory-wait

    mem_pc_i : in  std_logic_vector(XLEN-1 downto 0);
    wb_pc_o  : out std_logic_vector(XLEN-1 downto 0);

    mem_instr_i  : in  std_logic_vector(ILEN-1 downto 0);
    mem_bubble_i : in  std_logic;
    wb_instr_o   : out std_logic_vector(ILEN-1 downto 0);
    wb_bubble_o  : out std_logic;

    mem_exception_i : in  std_logic_vector(EXCEPTION_SIZE-1 downto 0);
    wb_exception_o  : out std_logic_vector(EXCEPTION_SIZE-1 downto 0);
    wb_badaddr_o    : out std_logic_vector(XLEN-1 downto 0);

    mem_r_i      : in std_logic_vector(XLEN-1 downto 0);
    mem_memadr_i : in std_logic_vector(XLEN-1 downto 0);

    --From Memory System
    dmem_ack_i        : in std_logic;
    dmem_err_i        : in std_logic;
    dmem_q_i          : in std_logic_vector(XLEN-1 downto 0);
    dmem_misaligned_i : in std_logic;
    dmem_page_fault_i : in std_logic;

    --To Register File
    wb_dst_o : out std_logic_vector(4 downto 0);
    wb_r_o   : out std_logic_vector(XLEN-1 downto 0);
    wb_we_o  : out std_logic
  );
end pu_riscv_wb;

architecture rtl of pu_riscv_wb is
  ------------------------------------------------------------------------------
  -- Variables
  ------------------------------------------------------------------------------
  signal opcode : std_logic_vector(6 downto 2);
  signal func3  : std_logic_vector(2 downto 0);
  signal func7  : std_logic_vector(6 downto 0);
  signal dst    : std_logic_vector(4 downto 0);

  signal exception : std_logic_vector(EXCEPTION_SIZE-1 downto 0);

  signal m_data : std_logic_vector(XLEN-1 downto 0);
  signal m_qb   : std_logic_vector(7 downto 0);
  signal m_qh   : std_logic_vector(15 downto 0);
  signal m_qw   : std_logic_vector(XLEN-1 downto 0);

  signal m_qd : std_logic_vector(XLEN-1 downto 0);

  signal wb_stall : std_logic;

begin
  ------------------------------------------------------------------------------
  -- Module Body
  ------------------------------------------------------------------------------

  --Program Counter
  processing_0 : process (clk_i, rst_ni, mem_pc_i, wb_stall)
  begin
    if (rst_ni = '0') then
      wb_pc_o <= PC_INIT;
    elsif (rising_edge(clk_i) or falling_edge(rst_ni)) then
      if (wb_stall = '0') then
        wb_pc_o <= mem_pc_i;
      end if;
    end if;
  end process;

  --Instruction
  processing_1 : process (clk_i, rst_ni, mem_instr_i, wb_stall)
  begin
    if (rst_ni = '0') then
      wb_instr_o <= INSTR_NOP;
    elsif (rising_edge(clk_i) or falling_edge(rst_ni)) then
      if (wb_stall = '0') then
        wb_instr_o <= mem_instr_i;
      end if;
    end if;
  end process;

  func7  <= mem_instr_i(31 downto 25);
  func3  <= mem_instr_i(14 downto 12);
  opcode <= mem_instr_i(6 downto 2);
  dst    <= mem_instr_i(11 downto 7);

  --Exception
  processing_2 : process (dmem_err_i, dmem_misaligned_i, dmem_page_fault_i, mem_bubble_i, mem_exception_i, opcode)
  begin
    exception <= mem_exception_i;

    if (opcode = OPC_LOAD and mem_bubble_i = '0') then
      exception(CAUSE_MISALIGNED_LOAD) <= dmem_misaligned_i;
    end if;

    if (opcode = OPC_STORE and mem_bubble_i = '0') then
      exception(CAUSE_MISALIGNED_STORE) <= dmem_misaligned_i;
    end if;

    if (opcode = OPC_LOAD and mem_bubble_i = '0') then
      exception(CAUSE_LOAD_ACCESS_FAULT) <= dmem_err_i;
    end if;

    if (opcode = OPC_STORE and mem_bubble_i = '0') then
      exception(CAUSE_STORE_ACCESS_FAULT) <= dmem_err_i;
    end if;

    if (opcode = OPC_LOAD and mem_bubble_i = '0') then
      exception(CAUSE_LOAD_PAGE_FAULT) <= dmem_page_fault_i;
    end if;

    if (opcode = OPC_STORE and mem_bubble_i = '0') then
      exception(CAUSE_STORE_PAGE_FAULT) <= dmem_page_fault_i;
    end if;
  end process;

  processing_3 : process (clk_i, rst_ni, exception, wb_stall)
  begin
    if (rst_ni = '0') then
      wb_exception_o <= (others => '0');
    elsif (rising_edge(clk_i) or falling_edge(rst_ni)) then
      if (wb_stall = '0') then
        wb_exception_o <= exception;
      end if;
    end if;
  end process;

  processing_4 : process (clk_i, rst_ni, exception, mem_memadr_i, mem_pc_i)
  begin
    if (rst_ni = '0') then
      wb_badaddr_o <= (others => '0');
    elsif (rising_edge(clk_i) or falling_edge(rst_ni)) then
      if (exception(CAUSE_MISALIGNED_LOAD) = '1' or
          exception(CAUSE_MISALIGNED_STORE) = '1' or
          exception(CAUSE_LOAD_ACCESS_FAULT) = '1' or
          exception(CAUSE_STORE_ACCESS_FAULT) = '1' or
          exception(CAUSE_LOAD_PAGE_FAULT) = '1' or
          exception(CAUSE_STORE_PAGE_FAULT) = '1') then
        wb_badaddr_o <= mem_memadr_i;
      else
        wb_badaddr_o <= mem_pc_i;
      end if;
    end if;
  end process;

  --From Memory
  processing_5 : process (dmem_ack_i, dmem_err_i, dmem_misaligned_i, dmem_page_fault_i, mem_bubble_i, mem_exception_i, opcode)
    variable from_memory : std_logic_vector(6 downto 0);
  begin
    from_memory := mem_bubble_i & reduce_or(mem_exception_i) & opcode;
    case (from_memory) is
      when (OPC00_LOAD) =>
        wb_stall <= not (dmem_ack_i or dmem_err_i or dmem_misaligned_i or dmem_page_fault_i);
      when (OPC00_STORE) =>
        wb_stall <= not (dmem_ack_i or dmem_err_i or dmem_misaligned_i or dmem_page_fault_i);
      when others =>
        wb_stall <= '0';
    end case;
  end process;

  wb_stall_o <= wb_stall;

  -- data from memory
  generating_0 : if (XLEN = 64) generate
    m_qb <= std_logic_vector(unsigned(dmem_q_i(7 downto 0)) srl (8*to_integer(unsigned(mem_memadr_i(1 downto 0)))));
    m_qh <= std_logic_vector(unsigned(dmem_q_i(15 downto 0)) srl (8*to_integer(unsigned(mem_memadr_i(1 downto 0)))));
    m_qw <= std_logic_vector(unsigned(dmem_q_i) srl (8*to_integer(unsigned(mem_memadr_i(1 downto 0)))));
    m_qd <= dmem_q_i;

    processing_6 : process (func3, func7, m_qb, m_qd, m_qh, m_qw, opcode)
      variable data_from_memory : std_logic_vector(15 downto 0);
    begin
      data_from_memory := 'X' & func7 & func3 & opcode;
      case (data_from_memory) is
        when LB =>
          m_data <= (XLEN-1 downto 8 => m_qb(7)) & m_qb;
        when LH =>
          m_data <= (XLEN-1 downto 16 => m_qh(15)) & m_qh;
        when LW =>
          m_data <= m_qw;
        when LD =>
          m_data <= (m_qd);
        when LBU =>
          m_data <= (XLEN-1 downto 8 => m_qb(7)) & m_qb;
        when LHU =>
          m_data <= (XLEN-1 downto 16 => m_qh(15)) & m_qh;
        when LWU =>
          m_data <= m_qw;
        when others =>
          m_data <= (others => 'X');
      end case;
    end process;
  elsif (XLEN /= 64) generate
    m_qb <= std_logic_vector(unsigned(dmem_q_i) srl (8*to_integer(unsigned(mem_memadr_i(1 downto 0)))));
    m_qh <= std_logic_vector(unsigned(dmem_q_i) srl (8*to_integer(unsigned(mem_memadr_i(1 downto 0)))));
    m_qw <= dmem_q_i;

    processing_7 : process (func3, func7, m_qb, m_qh, m_qw, opcode)
      variable data_from_memory : std_logic_vector(15 downto 0);
    begin
      data_from_memory := 'X' & func7 & func3 & opcode;
      case (data_from_memory) is
        when LB =>
          m_data <= (XLEN-1 downto 8 => m_qb(7)) & m_qb;
        when LH =>
          m_data <= (XLEN-1 downto 16 => m_qh(15)) & m_qh;
        when LW =>
          m_data <= (m_qw);
        when LBU =>
          m_data <= (XLEN-1 downto 8 => '0') & m_qb;
        when LHU =>
          m_data <= (XLEN-1 downto 16 => '0') & m_qh;
        when others =>
          m_data <= (others => 'X');
      end case;
    end process;
  end generate;

  --Register File Write Back

  -- Destination register
  processing_8 : process (clk_i)
  begin
    if (rising_edge(clk_i)) then
      if (wb_stall = '0') then
        wb_dst_o <= dst;
      end if;
    end if;
  end process;

  -- Result
  processing_9 : process (clk_i)
  begin
    if (rising_edge(clk_i)) then
      if (wb_stall = '0') then
        case ((opcode)) is
          when OPC_LOAD =>
            wb_r_o <= m_data;
          when others =>
            wb_r_o <= mem_r_i;
        end case;
      end if;
    end if;
  end process;

  -- Register File Write
  processing_10 : process (clk_i, rst_ni, dst, exception, mem_bubble_i, opcode, wb_stall)
  begin
    if (rst_ni = '0') then
      wb_we_o <= '0';
    elsif (rising_edge(clk_i) or falling_edge(rst_ni)) then
      if (reduce_or(exception) = '1') then
        wb_we_o <= '0';
      else
        case ((opcode)) is
          when OPC_MISC_MEM =>
            wb_we_o <= '0';
          when OPC_LOAD =>
            wb_we_o <= not mem_bubble_i and reduce_or(dst) and not wb_stall;
          when OPC_STORE =>
            wb_we_o <= '0';
          when OPC_STORE_FP =>
            wb_we_o <= '0';
          when OPC_BRANCH =>
            wb_we_o <= '0';
          --OPC_SYSTEM : wb_we_o <= 'b0;
          when others =>
            wb_we_o <= not mem_bubble_i and reduce_or(dst);
        end case;
      end if;
    end if;
  end process;

  -- Write Back Bubble
  processing_11 : process (clk_i, rst_ni, mem_bubble_i, wb_stall)
  begin
    if (rst_ni = '0') then
      wb_bubble_o <= '1';
    elsif (rising_edge(clk_i) or falling_edge(rst_ni)) then
      if (wb_stall = '0') then
        wb_bubble_o <= mem_bubble_i;
      end if;
    end if;
  end process;
end rtl;
