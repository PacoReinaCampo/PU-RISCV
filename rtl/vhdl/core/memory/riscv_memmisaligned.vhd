-- Converted from rtl/verilog/core/memory/riscv_memmisaligned.sv
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
--              Core - Misalignment Check                                     //
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
-- *   Paco Reina Campo <pacoreinacampo@queenfield.tech>
-- */


library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.peripheral_biu_pkg.all;
use work.vhdl_pkg.all;

entity riscv_memmisaligned is
  generic (
    XLEN    : integer := 64;
    HAS_RVC : std_logic := '1'
  );
  port (
    clk_i : in std_logic;

    --CPU side
    instruction_i : in std_logic;
    req_i         : in std_logic;
    adr_i         : in std_logic_vector(XLEN-1 downto 0);
    size_i        : in std_logic_vector(2 downto 0);

    --To memory subsystem
    misaligned_o : out std_logic
    );
end riscv_memmisaligned;

architecture RTL of riscv_memmisaligned is
  --////////////////////////////////////////////////////////////////
  --
  -- Variables
  --
  signal misaligned : std_logic;

begin
  --////////////////////////////////////////////////////////////////
  --
  -- Module Body
  --
  processing_0 : process (adr_i, instruction_i, size_i)
  begin
    if (instruction_i = '1') then
      if (HAS_RVC /= '0') then
        misaligned <= adr_i(0);
      else
        misaligned <= reduce_or(adr_i(1 downto 0));
      end if;
    else
      case (size_i) is
        when BYTE =>
          misaligned <= '0';
        when HWORD =>
          misaligned <= adr_i(0);
        when WORD =>
          misaligned <= reduce_or(adr_i(1 downto 0));
        when DWORD =>
          misaligned <= reduce_or(adr_i(2 downto 0));
        when others =>
          misaligned <= '1';
      end case;
    end if;
  end process;

  processing_1 : process (clk_i)
  begin
    if (rising_edge(clk_i)) then
      misaligned_o <= req_i and misaligned;
    end if;
  end process;
end RTL;
