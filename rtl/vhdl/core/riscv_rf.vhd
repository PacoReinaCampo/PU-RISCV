-- Converted from rtl/verilog/core/riscv_rf.sv
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
--              Core - Register File                                          //
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

entity riscv_rf is
  generic (
    XLEN    : integer := 64;
    AR_BITS : integer := 5;
    RDPORTS : integer := 2;
    WRPORTS : integer := 1
  );
  port (
    rstn : in std_logic;
    clk  : in std_logic;

    --Register File read
    rf_src1  : in  std_logic_matrix(RDPORTS-1 downto 0)(AR_BITS-1 downto 0);
    rf_src2  : in  std_logic_matrix(RDPORTS-1 downto 0)(AR_BITS-1 downto 0);
    rf_srcv1 : out std_logic_matrix(RDPORTS-1 downto 0)(XLEN-1 downto 0);
    rf_srcv2 : out std_logic_matrix(RDPORTS-1 downto 0)(XLEN-1 downto 0);

    --Register File write
    rf_dst  : in std_logic_matrix(WRPORTS-1 downto 0)(AR_BITS-1 downto 0);
    rf_dstv : in std_logic_matrix(WRPORTS-1 downto 0)(XLEN-1 downto 0);
    rf_we   : in std_logic_vector(WRPORTS-1 downto 0);

    --Debug Interface
    du_stall   : in  std_logic;
    du_we_rf   : in  std_logic;
    du_dato    : in  std_logic_vector(XLEN-1 downto 0);  --output from debug unit
    du_dati_rf : out std_logic_vector(XLEN-1 downto 0);
    du_addr    : in  std_logic_vector(11 downto 0)
  );
end riscv_rf;

architecture RTL of riscv_rf is
  --///////////////////////////////////////////////////////////////
  --
  -- Variables
  --

  --Actual register file
  signal rf : std_logic_matrix(XLEN-1 downto 0)(XLEN-1 downto 0);

  --read data from register file
  signal src1_is_x0 : std_logic_vector(RDPORTS-1 downto 0);
  signal src2_is_x0 : std_logic_vector(RDPORTS-1 downto 0);
  signal dout1      : std_logic_matrix(RDPORTS-1 downto 0)(XLEN-1 downto 0);
  signal dout2      : std_logic_matrix(RDPORTS-1 downto 0)(XLEN-1 downto 0);

begin
  --///////////////////////////////////////////////////////////////
  --
  -- Module Body
  --

  --Reads are asynchronous
  generating_0 : for i in 0 to RDPORTS - 1 generate
    --per Altera's recommendations. Prevents bypass logic
    processing_0 : process (clk)
    begin
      if (rising_edge(clk)) then
        dout1(i) <= rf(to_integer(unsigned(rf_src1(i))));
      end if;
    end process;

    processing_1 : process (clk)
    begin
      if (rising_edge(clk)) then
        dout2(i) <= rf(to_integer(unsigned(rf_src2(i))));
      end if;
    end process;

    --got data from RAM, now handle X0
    processing_2 : process (clk)
    begin
      if (rising_edge(clk)) then
        src1_is_x0(i) <= reduce_nor(rf_src1(i));
      end if;
    end process;

    processing_3 : process (clk)
    begin
      if (rising_edge(clk)) then
        src2_is_x0(i) <= reduce_nor(rf_src2(i));
      end if;
    end process;
  end generate;

  rf_srcv1 <= (others => (others => '0'));
  rf_srcv2 <= (others => (others => '0'));

  --TODO: For the Debug Unit ... mux with port0
  du_dati_rf <= rf(to_integer(unsigned(du_addr(AR_BITS-1 downto 0))))
                when (reduce_or(du_addr(AR_BITS-1 downto 0)) = '1') else (others => '0');

  --Writes are synchronous
  processing_4 : process (clk)
  begin
    for i in 0 to WRPORTS - 1 loop
      if (rising_edge(clk)) then
        if (du_we_rf = '1') then
          rf(to_integer(unsigned(du_addr(AR_BITS-1 downto 0)))) <= du_dato;
        elsif (rf_we(i) = '1') then
          rf(to_integer(unsigned(rf_dst(i)))) <= rf_dstv(i);
        end if;
      end if;
    end loop;
  end process;
end RTL;
