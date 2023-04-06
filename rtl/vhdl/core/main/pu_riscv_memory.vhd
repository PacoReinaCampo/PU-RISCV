-- Converted from rtl/verilog/core/pu_riscv_memory.sv
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
--              Core - Memory Unit                                            --
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

use work.vhdl_pkg.all;

entity pu_riscv_memory is
  generic (
    XLEN : integer := 64;
    ILEN : integer := 64;

    EXCEPTION_SIZE : integer := 16;

    PC_INIT : std_logic_vector(63 downto 0) := X"0000000080000000"
  );
  port (
    rstn : in std_logic;
    clk  : in std_logic;

    wb_stall : in std_logic;

    --Program counter
    ex_pc  : in  std_logic_vector(XLEN-1 downto 0);
    mem_pc : out std_logic_vector(XLEN-1 downto 0);

    --Instruction
    ex_bubble  : in  std_logic;
    ex_instr   : in  std_logic_vector(ILEN-1 downto 0);
    mem_bubble : out std_logic;
    mem_instr  : out std_logic_vector(ILEN-1 downto 0);

    ex_exception  : in  std_logic_vector(EXCEPTION_SIZE-1 downto 0);
    wb_exception  : in  std_logic_vector(EXCEPTION_SIZE-1 downto 0);
    mem_exception : out std_logic_vector(EXCEPTION_SIZE-1 downto 0);

    --From EX
    ex_r     : in std_logic_vector(XLEN-1 downto 0);
    dmem_adr : in std_logic_vector(XLEN-1 downto 0);

    --To WB
    mem_r      : out std_logic_vector(XLEN-1 downto 0);
    mem_memadr : out std_logic_vector(XLEN-1 downto 0)
  );
end pu_riscv_memory;

architecture rtl of pu_riscv_memory is

  ------------------------------------------------------------------------------
  -- Variables
  ------------------------------------------------------------------------------
  signal mem_exception_signal : std_logic_vector(EXCEPTION_SIZE-1 downto 0);

begin
  ------------------------------------------------------------------------------
  -- Module Body
  ------------------------------------------------------------------------------

  --Program Counter
  processing_0 : process (clk, rstn)
  begin
    if (rstn = '0') then
      mem_pc <= PC_INIT;
    elsif (rising_edge(clk) or falling_edge(rstn)) then
      if (wb_stall = '0') then
        mem_pc <= ex_pc;
      end if;
    end if;
  end process;

  --Instruction
  processing_1 : process (clk)
  begin
    if (rising_edge(clk) or falling_edge(rstn)) then
      if (wb_stall = '0') then
        mem_instr <= ex_instr;
      end if;
    end if;
  end process;

  processing_2 : process (clk, rstn)
  begin
    if (rstn = '0') then
      mem_bubble <= '1';
    elsif (rising_edge(clk)) then
      if (wb_stall = '0') then
        mem_bubble <= ex_bubble;
      end if;
    end if;
  end process;

  --Data
  processing_3 : process (clk)
  begin
    if (rising_edge(clk)) then
      if (wb_stall = '0') then
        mem_r <= ex_r;
      end if;
    end if;
  end process;

  processing_4 : process (clk)
  begin
    if (rising_edge(clk)) then
      if (wb_stall = '0') then
        mem_memadr <= dmem_adr;
      end if;
    end if;
  end process;

  --Exception
  processing_5 : process (clk, rstn)
  begin
    if (rstn = '0') then
      mem_exception_signal <= (others => '0');
    elsif (rising_edge(clk) or falling_edge(rstn)) then
      if (reduce_or(mem_exception_signal) = '1' or reduce_or(wb_exception) = '1') then
        mem_exception_signal <= (others => '0');
      elsif (wb_stall = '0') then
        mem_exception_signal <= ex_exception;
      end if;
    end if;
  end process;

  mem_exception <= mem_exception_signal;
end rtl;
