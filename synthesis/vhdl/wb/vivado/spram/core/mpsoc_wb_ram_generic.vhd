-- Converted from mpsoc_wb_ram_generic.v
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
--              Single Port RAM                                               //
--              Wishbone Bus Interface                                        //
--                                                                            //
--//////////////////////////////////////////////////////////////////////////////

-- Copyright (c) 2018-2019 by the author(s)
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
-- *   Olof Kindgren <olof.kindgren@gmail.com>
-- *   Paco Reina Campo <pacoreinacampo@queenfield.tech>
-- */

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

use work.mpsoc_spram_wb_pkg.all;

entity mpsoc_wb_ram_generic is
  generic (
    DEPTH   : integer := 256;
    MEMFILE : string  := "";

    AW : integer := integer(log2(real(DEPTH)));
    DW : integer := 32
    );
  port (
    clk   : in  std_logic;
    we    : in  std_logic_vector(3 downto 0);
    din   : in  std_logic_vector(DW-1 downto 0);
    waddr : in  std_logic_vector(AW-1 downto 0);
    raddr : in  std_logic_vector(AW-1 downto 0);
    dout  : out std_logic_vector(DW-1 downto 0)
    );
end mpsoc_wb_ram_generic;

architecture RTL of mpsoc_wb_ram_generic is
  --////////////////////////////////////////////////////////////////
  --
  -- Variables
  --
  signal mem : std_logic_matrix(DEPTH-1 downto 0)(DW-1 downto 0);

begin
  --////////////////////////////////////////////////////////////////
  --
  -- Module Body
  --
  processing_0 : process (clk)
  begin
    if (rising_edge(clk)) then
      if (we(0) = '1') then
        mem(to_integer(unsigned(raddr)))(7 downto 0) <= din(7 downto 0);
      end if;
      if (we(1) = '1') then
        mem(to_integer(unsigned(raddr)))(15 downto 8) <= din(15 downto 8);
      end if;
      if (we(2) = '1') then
        mem(to_integer(unsigned(raddr)))(23 downto 16) <= din(23 downto 16);
      end if;
      if (we(3) = '1') then
        mem(to_integer(unsigned(raddr)))(31 downto 24) <= din(31 downto 24);
      end if;
      dout <= mem(to_integer(unsigned(raddr)));
    end if;
  end process;

  generating_0 : if (MEMFILE /= "") generate
  end generate;
end RTL;
