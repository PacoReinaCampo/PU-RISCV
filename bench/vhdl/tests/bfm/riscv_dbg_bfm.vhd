-- Converted from riscv_dbg_bfm.sv
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
--              Debug Controller Simulation Model                             //
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

architecture rtl of riscv_dbg_bfm is
  ------------------------------------------------------------------------------
  -- Variables
  ------------------------------------------------------------------------------
  signal stall_cpu : std_logic;

begin
  ------------------------------------------------------------------------------
  -- Module body
  ------------------------------------------------------------------------------
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
end rtl;