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
    rstn : in std_ulogic;
    clk  : in std_ulogic;

    --Register File read
    rf_src1  : in  M_RDPORTS_AR_BITS;
    rf_src2  : in  M_RDPORTS_AR_BITS;
    rf_srcv1 : out M_RDPORTS_XLEN;
    rf_srcv2 : out M_RDPORTS_XLEN;

    --Register File write
    rf_dst  : in M_WRPORTS_AR_BITS;
    rf_dstv : in M_WRPORTS_XLEN;
    rf_we   : in std_ulogic_vector(WRPORTS-1 downto 0);

    --Debug Interface
    du_stall   : in  std_ulogic;
    du_we_rf   : in  std_ulogic;
    du_dato    : in  std_ulogic_vector(XLEN-1 downto 0);  --output from debug unit
    du_dati_rf : out std_ulogic_vector(XLEN-1 downto 0);
    du_addr    : in  std_ulogic_vector(11 downto 0)
  );
end riscv_rf;

architecture RTL of riscv_rf is
  --////////////////////////////////////////////////////////////////
  --
  -- Functions
  --
  function reduce_or (
    reduce_or_in : std_ulogic_vector
  ) return std_ulogic is
    variable reduce_or_out : std_ulogic := '0';
  begin
    for i in reduce_or_in'range loop
      reduce_or_out := reduce_or_out or reduce_or_in(i);
    end loop;
    return reduce_or_out;
  end reduce_or;

  function reduce_nor (
    reduce_nor_in : std_ulogic_vector
  ) return std_ulogic is
    variable reduce_nor_out : std_ulogic := '0';
  begin
    for i in reduce_nor_in'range loop
      reduce_nor_out := reduce_nor_out nor reduce_nor_in(i);
    end loop;
    return reduce_nor_out;
  end reduce_nor;

  --///////////////////////////////////////////////////////////////
  --
  -- Types
  --
  type M_XLEN_XLEN is array (XLEN-1 downto 0) of std_ulogic_vector (XLEN-1 downto 0);

  --///////////////////////////////////////////////////////////////
  --
  -- Variables
  --

  --Actual register file
  signal rf : M_XLEN_XLEN;

  --read data from register file
  signal src1_is_x0 : std_ulogic_vector(RDPORTS-1 downto 0);
  signal src2_is_x0 : std_ulogic_vector(RDPORTS-1 downto 0);
  signal dout1      : M_RDPORTS_XLEN;
  signal dout2      : M_RDPORTS_XLEN;

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
