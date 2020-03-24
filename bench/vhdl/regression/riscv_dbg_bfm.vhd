-- Converted from riscv_dbg_bfm.sv
-- by verilog2vhdl - QueenField

--//////////////////////////////////////////////////////////////////////////////
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
--              Debug Controller Simulation Model                             //
--              AMBA3 AHB-Lite Bus Interface                                  //
--                                                                            //
--//////////////////////////////////////////////////////////////////////////////

-- Copyright (c) 2017-2018 by the author(s)
-- *
-- * Permission is hereby granted, free of charge, to any person obtaining a copy
-- * of this software and associated documentation files (the "Software"), to deal
-- * in the Software without restriction, including without limitation the rights
-- * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
-- * copies of the Software, and to permit persons to whom the Software is
-- * furnished to do so, subject to the following conditions:
-- *
-- * The above copyright notice and this permission notice shall be included in
-- * all copies or substantial portions of the Software.
-- *
-- * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
-- * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
-- * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
-- * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
-- * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
-- * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
-- * THE SOFTWARE.
-- *
-- * =============================================================================
-- * Author(s):
-- *   Francisco Javier Reina Campo <frareicam@gmail.com>
-- */


library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.riscv_mpsoc_pkg.all;

entity riscv_dbg_bfm is
  generic (
    XLEN : integer := 64;
    PLEN : integer := 64
    );
  port (
    rstn : in std_logic;
    clk  : in std_logic;

    cpu_bp_i : in std_logic;

    cpu_stall_o : out std_logic;
    cpu_stb_o   : out std_logic;
    cpu_we_o    : out std_logic;
    cpu_adr_o   : out std_logic_vector(PLEN-1 downto 0);
    cpu_dat_o   : out std_logic_vector(XLEN-1 downto 0);
    cpu_dat_i   : in  std_logic_vector(XLEN-1 downto 0);
    cpu_ack_i   : in  std_logic
    );
end riscv_dbg_bfm;

architecture RTL of riscv_dbg_bfm is


  --//////////////////////////////////////////////////////////////
  --
  -- Variables
  --
  signal stall_cpu : std_logic;

  --//////////////////////////////////////////////////////////////
  --
  -- Procedures
  --

  --Stall CPU
  procedure stall (
    signal clk : in std_logic;

    signal stall_cpu : out std_logic
    ) is
  begin
    wait until rising_edge(clk);
    stall_cpu <= '1';
  end stall;

  --Unstall CPU
  procedure unstall (
    signal clk : in std_logic;

    signal stall_cpu : out std_logic
    ) is
  begin
    wait until rising_edge(clk);
      stall_cpu <= '0';
  end unstall;

  --Write to CPU (via DBG interface)
  procedure write (
    signal clk : in std_logic;

    signal cpu_ack_i : in std_logic;

    signal data : in std_logic_vector(XLEN-1 downto 0);
    signal addr : in std_logic_vector(PLEN-1 downto 0);

    signal cpu_stb_o : out std_logic;
    signal cpu_we_o  : out std_logic;
    signal cpu_dat_o : out std_logic_vector(XLEN-1 downto 0);
    signal cpu_adr_o : out std_logic_vector(PLEN-1 downto 0)
    ) is
  begin

    --setup DBG bus
    wait until rising_edge(clk);
    cpu_stb_o <= '1';
    cpu_we_o  <= '1';
    cpu_dat_o <= data;
    cpu_adr_o <= addr;

    --wait for ack
    while (cpu_ack_i = '0') loop
      wait until rising_edge(clk);
    end loop;

    --clear DBG bus
    cpu_stb_o <= '0';
    cpu_we_o  <= '0';
  end write;

  --Read from CPU (via DBG interface)
  procedure read (
    signal clk : in std_logic;

    signal cpu_ack_i : in std_logic;
    signal cpu_dat_i : in std_logic_vector(XLEN-1 downto 0);

    signal data : out std_logic_vector(XLEN-1 downto 0);
    signal addr : in  std_logic_vector(PLEN-1 downto 0);

    signal cpu_stb_o : out std_logic;
    signal cpu_we_o  : out std_logic;
    signal cpu_adr_o : out std_logic_vector(PLEN-1 downto 0)
    ) is
  begin

    --setup DBG bus
    wait until rising_edge(clk);
    cpu_stb_o <= '1';
    cpu_we_o  <= '0';
    cpu_adr_o <= addr;

    --wait for ack
    while (cpu_ack_i = '0') loop
      wait until rising_edge(clk);
    end loop;

    data <= cpu_dat_i;

    --clear DBG bus
    cpu_stb_o <= '0';
    cpu_we_o  <= '0';
  end read;

begin
  --//////////////////////////////////////////////////////////////
  --
  -- Module body
  --
  cpu_stb_o   <= '0';
  cpu_stall_o <= cpu_bp_i or stall_cpu;

  processing_0 : process (clk, rstn)
  begin
    if (rstn = '0') then
      stall_cpu <= '0';
    elsif (rising_edge(clk)) then
      if (cpu_bp_i = '1') then  --gets cleared by task unstall_cpu
        stall_cpu <= '1';
      end if;
    end if;
  end process;
end RTL;
