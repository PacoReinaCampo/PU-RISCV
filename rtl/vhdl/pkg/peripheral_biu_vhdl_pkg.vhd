-- Converted from pkg/peripheral_biu_vhdl_pkg.sv
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
--              RISC-V Package                                                --
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
use ieee.math_real.all;

package peripheral_biu_vhdl_pkg is

  --BIU Constants Package
  constant BYTE       : std_logic_vector(2 downto 0) := "000";
  constant HWORD      : std_logic_vector(2 downto 0) := "001";
  constant WORD       : std_logic_vector(2 downto 0) := "010";
  constant DWORD      : std_logic_vector(2 downto 0) := "011";
  constant QWORD      : std_logic_vector(2 downto 0) := "100";
  constant UNDEF_SIZE : std_logic_vector(2 downto 0) := "XXX";

  constant SINGLE      : std_logic_vector(2 downto 0) := "000";
  constant INCR        : std_logic_vector(2 downto 0) := "001";
  constant WRAP4       : std_logic_vector(2 downto 0) := "010";
  constant INCR4       : std_logic_vector(2 downto 0) := "011";
  constant WRAP8       : std_logic_vector(2 downto 0) := "100";
  constant INCR8       : std_logic_vector(2 downto 0) := "101";
  constant WRAP16      : std_logic_vector(2 downto 0) := "110";
  constant INCR16      : std_logic_vector(2 downto 0) := "111";
  constant UNDEF_BURST : std_logic_vector(2 downto 0) := "XXX";

  --Enumeration Codes
  constant PROT_INSTRUCTION  : std_logic_vector(2 downto 0) := "000";
  constant PROT_DATA         : std_logic_vector(2 downto 0) := "001";
  constant PROT_USER         : std_logic_vector(2 downto 0) := "000";
  constant PROT_PRIVILEGED   : std_logic_vector(2 downto 0) := "010";
  constant PROT_NONCACHEABLE : std_logic_vector(2 downto 0) := "000";
  constant PROT_CACHEABLE    : std_logic_vector(2 downto 0) := "100";

  --Complex Enumerations
  constant NONCACHEABLE_USER_INSTRUCTION       : std_logic_vector(2 downto 0) := "000";
  constant NONCACHEABLE_USER_DATA              : std_logic_vector(2 downto 0) := "001";
  constant NONCACHEABLE_PRIVILEGED_INSTRUCTION : std_logic_vector(2 downto 0) := "010";
  constant NONCACHEABLE_PRIVILEGED_DATA        : std_logic_vector(2 downto 0) := "011";
  constant CACHEABLE_USER_INSTRUCTION          : std_logic_vector(2 downto 0) := "100";
  constant CACHEABLE_USER_DATA                 : std_logic_vector(2 downto 0) := "101";
  constant CACHEABLE_PRIVILEGED_INSTRUCTION    : std_logic_vector(2 downto 0) := "110";
  constant CACHEABLE_PRIVILEGED_DATA           : std_logic_vector(2 downto 0) := "111";

end peripheral_biu_vhdl_pkg;
