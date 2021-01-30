-- Converted from memory/mpsoc_ram_1r1w.sv
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
--              Memory - 1R1W RAM Block                                       //
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

entity mpsoc_ram_1r1w is
  generic (
    ABITS      : integer := 10;
    DBITS      : integer := 32;
    TECHNOLOGY : string := "GENERIC"
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
    re_i    : in  std_logic;
    dout_o  : out std_logic_vector(DBITS-1 downto 0)
  );
end mpsoc_ram_1r1w;

architecture RTL of mpsoc_ram_1r1w is
  component mpsoc_ram_1r1w_generic
    generic (
      ABITS : integer := 10;
      DBITS : integer := 32
    );
    port (
      rst_ni : in std_logic;
      clk_i  : in std_logic;

      waddr_i : in std_logic_vector(ABITS-1 downto 0);
      din_i   : in std_logic_vector(DBITS-1 downto 0);
      we_i    : in std_logic;
      be_i    : in std_logic_vector((DBITS+7)/8-1 downto 0);

      raddr_i : in  std_logic_vector(ABITS-1 downto 0);
      dout_o  : out std_logic_vector(DBITS-1 downto 0)
    );
  end component;

  --////////////////////////////////////////////////////////////////
  --
  -- Variables
  --
  signal contention     : std_logic;
  signal contention_reg : std_logic;
  signal mem_dout       : std_logic_vector(DBITS-1 downto 0);
  signal din_dly        : std_logic_vector(DBITS-1 downto 0);

begin
--////////////////////////////////////////////////////////////////
--
-- Module Body
--
  generating_0 : if (TECHNOLOGY = "GENERIC") generate
    --GENERIC  -- inferrable memory

    --initial $display ("INFO   : No memory technology specified. Using generic inferred memory (%m)");
    ram_inst : mpsoc_ram_1r1w_generic
      generic map (
        ABITS => ABITS,
        DBITS => DBITS
      )
      port map (
        rst_ni => rst_ni,
        clk_i  => clk_i,

        waddr_i => waddr_i,
        din_i   => din_i,
        we_i    => we_i,
        be_i    => be_i,

        raddr_i => raddr_i,
        dout_o  => mem_dout
      );
  end generate;

  --TODO Handle 'be' ... requires partial old, partial new data

  --now ... write-first; we'll still need some bypass logic
  contention <= re_i
                when ((we_i = '1') and (raddr_i = waddr_i)) else '0';  --prevent 'x' from propagating from eASIC memories

  processing_0 : process (clk_i)
  begin
    if (rising_edge(clk_i)) then
      contention_reg <= contention;
      din_dly        <= din_i;
    end if;
  end process;

  dout_o <= din_dly
            when (contention_reg = '1') else mem_dout;
end RTL;
