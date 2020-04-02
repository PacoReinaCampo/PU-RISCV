-- Converted from riscv_testbench.sv
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
--              TestBench                                                     //
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

entity riscv_htif is
  generic (
    XLEN : integer := 32
    );
  port (
    rstn : in std_logic;
    clk  : in std_logic;

    host_csr_req      : out std_logic;
    host_csr_ack      : in  std_logic;
    host_csr_we       : out std_logic;
    host_csr_tohost   : in  std_logic_vector(XLEN-1 downto 0);
    host_csr_fromhost : out std_logic_vector(XLEN-1 downto 0)
    );
end riscv_htif;

architecture RTL of riscv_htif is
  --////////////////////////////////////////////////////////////////
  --
  -- Variables
  --
  signal watchdog_cnt : integer;

begin
  --//////////////////////////////////////////////////////////////
  --
  -- Module Body
  --

  --Generate watchdog counter
  processing_0 : process (clk, rstn)
  begin
    if (rstn = '0') then
      watchdog_cnt <= 0;
    elsif (rising_edge(clk)) then
      watchdog_cnt <= watchdog_cnt+1;
    end if;
  end process;

  processing_1 : process (clk)
  begin
    if (rising_edge(clk)) then
      if (watchdog_cnt > 200000 or host_csr_tohost(0) = '1') then
        report "\n";
        report "*****************************************************";
        report "* RISC-V test bench finished";
        if (host_csr_tohost(0) = '1') then
          if (reduce_nor(host_csr_tohost(XLEN-1 downto 1)) = '1') then
            report "* PASSED " & to_string(host_csr_tohost);
          else
            report "* FAILED: code: " & integer'image(to_integer(unsigned(host_csr_tohost) srl 1))
                                      & integer'image(to_integer(unsigned(host_csr_tohost) srl 1));
          end if;
        else
          report "* FAILED: watchdog count reached " & integer'image(watchdog_cnt);
        end if;
        report "*****************************************************";
        report "\n";
      end if;
    end if;
  end process;
end RTL;
