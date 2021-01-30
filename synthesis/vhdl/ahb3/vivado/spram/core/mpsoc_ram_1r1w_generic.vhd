-- Converted from rtl/verilog/memory/mpsoc_ram_1r1w_generic.sv
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
--              Memory - Technology Independent (Inferrable) Memory Wrapper   //
--              AMBA3 AHB-Lite Bus Interface                                  //
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
-- *   Paco Reina Campo <pacoreinacampo@queenfield.tech>
-- */

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity mpsoc_ram_1r1w_generic is
  generic (
    ABITS : integer := 10;
    DBITS : integer := 32
  );
  port (
    rst_ni : in std_logic;
    clk_i  : in std_logic;

    --Write side
    waddr_i : in std_logic_vector(ABITS-1 downto 0);
    din_i   : in std_logic_vector(DBITS-1 downto 0);
    we_i    : in std_logic;
    be_i    : in std_logic_vector((DBITS+7)/8-1 downto 0);

    --Read side
    raddr_i : in  std_logic_vector(ABITS-1 downto 0);
    dout_o  : out std_logic_vector(DBITS-1 downto 0)
  );
end mpsoc_ram_1r1w_generic;

architecture RTL of mpsoc_ram_1r1w_generic is
  --////////////////////////////////////////////////////////////////
  --
  -- Types
  --
  type type_mem_array is array (2**ABITS-1 downto 0) of std_logic_vector(DBITS-1 downto 0);  --memory array

  --////////////////////////////////////////////////////////////////
  --
  -- Variables
  --
  signal mem_array : type_mem_array;  --memory array

begin
  --////////////////////////////////////////////////////////////////
  --
  -- Module Body
  --

  --write side
  generating_0 : for i in 0 to (DBITS+7)/8 - 1 generate
    generating_1 : if (i*8+8 > DBITS) generate
      processing_0 : process (clk_i)
      begin
        if (rising_edge(clk_i)) then
          if (we_i = '1' and be_i(i) = '1' and to_unsigned(i, ABITS) = unsigned(waddr_i)) then
            mem_array(i)(DBITS-1 downto i*8) <= din_i(DBITS-1 downto i*8);
          end if;
        end if;
      end process;
    end generate;
    generating_2 : if (i*8+8 <= DBITS) generate
      processing_1 : process (clk_i)
      begin
        if (rising_edge(clk_i)) then
          if (we_i = '1' and be_i(i) = '1' and to_unsigned(i, ABITS) = unsigned(waddr_i)) then
            mem_array(i)(i*8 downto i) <= din_i(i*8 downto i);
          end if;
        end if;
      end process;
    end generate;
  end generate;

  --read side

  --per Altera's recommendations. Prevents bypass logic
  processing_2 : process (clk_i)
  begin
    if (rising_edge(clk_i)) then
      dout_o <= mem_array(to_integer(unsigned(raddr_i)));
    end if;
  end process;
end RTL;
