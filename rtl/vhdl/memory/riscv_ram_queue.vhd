-- Converted from rtl/verilog/memory/riscv_ram_queue.sv
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
--              Core - Fall-through Queue                                     //
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
use ieee.math_real.all;

use work.riscv_defines.all;

entity riscv_ram_queue is
  generic (
    DEPTH                  : integer := 8;
    DBITS                  : integer := 64;
    ALMOST_FULL_THRESHOLD  : integer := 4;
    ALMOST_EMPTY_THRESHOLD : integer := 0
  );
  port (
    rst_ni : in std_logic;  --asynchronous, active low reset
    clk_i  : in std_logic;  --rising edge triggered clock

    clr_i : in std_logic;  --clear all queue entries (synchronous reset)
    ena_i : in std_logic;  --clock enable

    --Queue Write
    we_i : in std_logic;                           --Queue write enable
    d_i  : in std_logic_vector(DBITS-1 downto 0);  --Queue write data

    --Queue Read
    re_i : in  std_logic;                           --Queue read enable
    q_o  : out std_logic_vector(DBITS-1 downto 0);  --Queue read data

    --Status signals
    empty_o        : out std_logic;  --Queue is empty
    full_o         : out std_logic;  --Queue is full
    almost_empty_o : out std_logic;  --Programmable almost empty
    almost_full_o  : out std_logic   --Programmable almost full
  );
end riscv_ram_queue;

architecture RTL of riscv_ram_queue is
  --////////////////////////////////////////////////////////////////
  --
  -- Constants
  --
  constant EMPTY_THRESHOLD              : integer := 1;
  constant FULL_THRESHOLD               : integer := DEPTH-2;
  constant ALMOST_EMPTY_THRESHOLD_CHECK : integer := EMPTY_THRESHOLD;
  constant ALMOST_FULL_THRESHOLD_CHECK  : integer := FULL_THRESHOLD;

  --////////////////////////////////////////////////////////////////
  --
  -- Variables
  --
  signal queue_data : std_logic_matrix(DEPTH-1 downto 0)(DBITS-1 downto 0);
  signal queue_xadr : std_logic_vector(integer(log2(real(DEPTH)))-1 downto 0);
  signal queue_wadr : std_logic_vector(integer(log2(real(DEPTH)))-1 downto 0);

begin
  --////////////////////////////////////////////////////////////////
  --
  -- Module Body
  --

  --Write Address
  processing_0 : process (clk_i, rst_ni)
    variable were : std_logic_vector(1 downto 0);
  begin
    if (rst_ni = '0') then
      queue_wadr <= X"0";
    elsif (rising_edge(clk_i) or falling_edge(rst_ni)) then
      if (clr_i = '1') then
        queue_wadr <= X"0";
      elsif (ena_i = '1') then
        were := we_i & re_i;
        case (were) is
          when "01" =>
            queue_wadr <= std_logic_vector(unsigned(queue_wadr)-(queue_wadr'range => '1'));
          when "10" =>
            queue_wadr <= std_logic_vector(unsigned(queue_wadr)+(queue_wadr'range => '1'));
          when others =>
            null;
        end case;
      end if;
    end if;
  end process;

  queue_xadr <= std_logic_vector(to_unsigned(DEPTH-1, integer(log2(real(DEPTH)))))
                when (queue_wadr = (queue_wadr'range => '0')) else std_logic_vector(unsigned(queue_wadr)-(queue_wadr'range => '1'));

  --Queue Data
  processing_1 : process (clk_i, rst_ni)
    variable were : std_logic_vector(1 downto 0);
  begin
    if (rising_edge(clk_i) or falling_edge(rst_ni)) then
      if (rst_ni = '0' or clr_i = '1') then
        for n in 0 to DEPTH - 2 loop
          queue_data(n) <= (others => '0');
        end loop;
      elsif (ena_i = '1') then
        were := we_i & re_i;
        case (were) is
          when "01" =>
            for n in 0 to DEPTH - 2 loop
              queue_data(n) <= queue_data(n+1);
            end loop;
            queue_data(DEPTH-1) <= (others => '0');
          when "10" =>
            queue_data(to_integer(unsigned(queue_wadr))) <= d_i;
          when "11" =>
            for n in 0 to DEPTH - 2 loop
              queue_data(n) <= queue_data(n+1);
            end loop;
            queue_data(to_integer(unsigned(queue_xadr))) <= d_i;
          when others =>
            null;
        end case;
      end if;
    end if;
  end process;

  --Queue Almost Empty
  processing_2 : process (clk_i, rst_ni)
    variable were : std_logic_vector(1 downto 0);
  begin
    if (rst_ni = '0') then
      almost_empty_o <= '1';
    elsif (rising_edge(clk_i) or falling_edge(rst_ni)) then
      if (clr_i = '1') then
        almost_empty_o <= '1';
      elsif (ena_i = '1') then
        were := we_i & re_i;
        case (were) is
          when "01" =>
            almost_empty_o <= to_stdlogic(queue_wadr <= std_logic_vector(to_unsigned(ALMOST_EMPTY_THRESHOLD_CHECK, integer(log2(real(DEPTH))))));
          when "10" =>
            almost_empty_o <= not to_stdlogic(queue_wadr > std_logic_vector(to_unsigned(ALMOST_EMPTY_THRESHOLD_CHECK, integer(log2(real(DEPTH))))));
          when others =>
            null;
        end case;
      end if;
    end if;
  end process;

  --Queue Empty
  processing_3 : process (clk_i, rst_ni)
    variable were : std_logic_vector(1 downto 0);
  begin
    if (rst_ni = '0') then
      empty_o <= '1';
    elsif (rising_edge(clk_i) or falling_edge(rst_ni)) then
      if (clr_i = '1') then
        empty_o <= '1';
      elsif (ena_i = '1') then
        were := we_i & re_i;
        case (were) is
          when "01" =>
            empty_o <= to_stdlogic(queue_wadr = std_logic_vector(to_unsigned(EMPTY_THRESHOLD, integer(log2(real(DEPTH))))));
          when "10" =>
            empty_o <= '0';
          when others =>
            null;
        end case;
      end if;
    end if;
  end process;

  --Queue Almost Full
  processing_4 : process (clk_i, rst_ni)
    variable were : std_logic_vector(1 downto 0);
  begin
    if (rst_ni = '0') then
      almost_full_o <= '0';
    elsif (rising_edge(clk_i) or falling_edge(rst_ni)) then
      if (clr_i = '1') then
        almost_full_o <= '0';
      elsif (ena_i = '1') then
        were := we_i & re_i;
        case (were) is
          when "01" =>
            almost_full_o <= not to_stdlogic(queue_wadr < std_logic_vector(to_unsigned(ALMOST_FULL_THRESHOLD_CHECK, integer(log2(real(DEPTH))))));
          when "10" =>
            almost_full_o <= to_stdlogic(queue_wadr >= std_logic_vector(to_unsigned(ALMOST_FULL_THRESHOLD_CHECK, integer(log2(real(DEPTH))))));
          when others =>
            null;
        end case;
      end if;
    end if;
  end process;

  --Queue Full
  processing_5 : process (clk_i, rst_ni)
    variable were : std_logic_vector(1 downto 0);
  begin
    if (rst_ni = '0') then
      full_o <= '0';
    elsif (rising_edge(clk_i) or falling_edge(rst_ni)) then
      if (clr_i = '1') then
        full_o <= '0';
      elsif (ena_i = '1') then
        were := we_i & re_i;
        case (were) is
          when "01" =>
            full_o <= '0';
          when "10" =>
            full_o <= to_stdlogic(queue_wadr = std_logic_vector(to_unsigned(FULL_THRESHOLD, integer(log2(real(DEPTH))))));
          when others =>
            null;
        end case;
      end if;
    end if;
  end process;

  --Queue output data
  q_o <= queue_data(0);
end RTL;
