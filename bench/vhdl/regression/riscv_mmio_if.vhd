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

entity riscv_mmio_if is
  generic (
    XLEN : integer := 32;
    PLEN : integer := 32;

    TOHOST  : std_logic_vector(63 downto 0) := X"0000000080001000";
    UART_TX : std_logic_vector(63 downto 0) := X"0000000080001080"
    );
  port (
    HRESETn : in std_logic;
    HCLK    : in std_logic;

    HTRANS : in  std_logic_vector(1 downto 0);
    HADDR  : in  std_logic_vector(PLEN-1 downto 0);
    HWRITE : in  std_logic;
    HSIZE  : in  std_logic_vector(2 downto 0);
    HBURST : in  std_logic_vector(2 downto 0);
    HWDATA : in  std_logic_vector(XLEN-1 downto 0);
    HRDATA : out std_logic_vector(XLEN-1 downto 0);

    HREADYOUT : out std_logic;
    HRESP     : out std_logic
    );
end riscv_mmio_if;

architecture RTL of riscv_mmio_if is
  --////////////////////////////////////////////////////////////////
  --
  -- Variables
  --
  signal data_reg      : std_logic_vector(XLEN-1 downto 0);
  signal catch_test    : std_logic;
  signal catch_uart_tx : std_logic;

  signal dHTRANS : std_logic_vector(1 downto 0);
  signal dHADDR  : std_logic_vector(PLEN-1 downto 0);
  signal dHWRITE : std_logic;

  signal watchdog_cnt : integer;

  --////////////////////////////////////////////////////////////////
  --
  -- Functions
  --
  function reduce_nor (
    reduce_nor_in : std_logic_vector
    ) return std_logic is
    variable reduce_nor_out : std_logic := '0';
  begin
    for i in reduce_nor_in'range loop
      reduce_nor_out := reduce_nor_out nor reduce_nor_in(i);
    end loop;
    return reduce_nor_out;
  end reduce_nor;

  function to_stdlogic (
    input : boolean
    ) return std_logic is
  begin
    if input then
      return('1');
    else
      return('0');
    end if;
  end function to_stdlogic;

begin
  --//////////////////////////////////////////////////////////////
  --
  -- Module Body
  --

  --Generate watchdog counter
  processing_2 : process (HCLK, HRESETn)
  begin
    if (HRESETn = '0') then
      watchdog_cnt <= 0;
    elsif (rising_edge(HCLK)) then
      watchdog_cnt <= watchdog_cnt+1;
    end if;
  end process;

  --Catch write to host address
  HRESP <= HRESP_OKAY;

  processing_3 : process (HCLK)
  begin
    if (rising_edge(HCLK)) then
      dHTRANS <= HTRANS;
      dHADDR  <= HADDR;
      dHWRITE <= HWRITE;
    end if;
  end process;

  processing_4 : process (HCLK, HRESETn)
  begin
    if (HRESETn = '0') then
      HREADYOUT <= '1';
    elsif (rising_edge(HCLK)) then
      if (HTRANS = HTRANS_IDLE) then
        null;
      end if;
    end if;
  end process;

  processing_5 : process (HCLK, HRESETn)
  begin
    if (HRESETn = '0') then
      catch_test    <= '0';
      catch_uart_tx <= '0';
    elsif (rising_edge(HCLK)) then
      catch_test    <= to_stdlogic(dHTRANS = HTRANS_NONSEQ) and dHWRITE and to_stdlogic(dHADDR = TOHOST);
      catch_uart_tx <= to_stdlogic(dHTRANS = HTRANS_NONSEQ) and dHWRITE and to_stdlogic(dHADDR = UART_TX);
      data_reg      <= HWDATA;
    end if;
  end process;
  --Generate output

  --Simulated UART Tx (prints characters on screen)
  processing_6 : process (HCLK)
  begin
    if (rising_edge(HCLK)) then
      if (catch_uart_tx = '1') then
        --write(data_reg);
      end if;
    end if;
  end process;

  --Tests ...
  processing_7 : process (HCLK)
  begin
    if (rising_edge(HCLK)) then
      if (watchdog_cnt > 1000000 or catch_test = '1') then
        report "\n";
        report "-------------------------------------------------------------";
        report "* RISC-V test bench finished";
        if (data_reg(0) = '1') then
          if (reduce_nor(data_reg(XLEN-1 downto 1)) = '1') then
            report "* PASSED " & to_string(data_reg);
          else
            report "* FAILED: code: " & integer'image(to_integer(unsigned(data_reg) srl 1))
                                      & integer'image(to_integer(unsigned(data_reg) srl 1));
          end if;
        else
          report "* FAILED: watchdog count reached " & integer'image(watchdog_cnt);
        end if;
        report "-------------------------------------------------------------";
        report "\n";
      end if;
    end if;
  end process;
end RTL;
