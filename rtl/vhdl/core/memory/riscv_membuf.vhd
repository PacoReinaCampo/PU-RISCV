-- Converted from rtl/verilog/core/memory/riscv_membuf.sv
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
--              Core - Memory Access Buffer                                   //
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
use ieee.math_real.all;

entity riscv_membuf is
  generic (
    DEPTH : integer := 2;
    DBITS : integer := 64
  );
  port (
    rst_ni : in std_logic;
    clk_i  : in std_logic;

    clr_i : in std_logic;  --clear pending requests
    ena_i : in std_logic;

    --CPU side
    req_i : in std_logic;
    d_i   : in std_logic_vector(DBITS-1 downto 0);

    --Memory system side
    req_o : out std_logic;
    ack_i : in  std_logic;
    q_o   : out std_logic_vector(DBITS-1 downto 0);

    empty_o : out std_logic;
    full_o  : out std_logic
  );
end riscv_membuf;

architecture RTL of riscv_membuf is
  component riscv_ram_queue
    generic (
      DEPTH                  : integer := 2;
      DBITS                  : integer := 32;
      ALMOST_EMPTY_THRESHOLD : integer := 0;
      ALMOST_FULL_THRESHOLD  : integer := 2
    );
    port (
      rst_ni : in std_logic;  --asynchronous, active low reset
      clk_i  : in std_logic;  --rising edge triggered clock

      clr_i : in std_logic;  --clear all queue entries (synchronous reset)
      ena_i : in std_logic;  --clock enable

      we_i : in std_logic;                           --Queue write enable
      d_i  : in std_logic_vector(DBITS-1 downto 0);  --Queue write data

      re_i : in  std_logic;                           --Queue read enable
      q_o  : out std_logic_vector(DBITS-1 downto 0);  --Queue read data

      empty_o        : out std_logic;   --Queue is empty
      full_o         : out std_logic;   --Queue is full
      almost_empty_o : out std_logic;   --Programmable almost empty
      almost_full_o  : out std_logic    --Programmable almost full
    );
  end component;

  --////////////////////////////////////////////////////////////////
  --
  -- Functions
  --
  function reduce_or (
    reduce_or_in : std_logic_vector
  ) return std_logic is
    variable reduce_or_out : std_logic := '0';
  begin
    for i in reduce_or_in'range loop
      reduce_or_out := reduce_or_out or reduce_or_in(i);
    end loop;
    return reduce_or_out;
  end reduce_or;

  function reduce_nor (
    reduce_or_in : std_logic_vector
  ) return std_logic is
    variable reduce_or_out : std_logic := '0';
  begin
    for i in reduce_or_in'range loop
      reduce_or_out := reduce_or_out or reduce_or_in(i);
    end loop;
    return reduce_or_out;
  end reduce_nor;

  --////////////////////////////////////////////////////////////////
  --
  -- Variables
  --
  signal queue_q  : std_logic_vector(DBITS-1 downto 0);
  signal queue_we : std_logic;
  signal queue_re : std_logic;

  signal access_pending : std_logic_vector(integer(log2(real(DEPTH))) downto 0);

  signal empty : std_logic;

begin
  --////////////////////////////////////////////////////////////////
  --
  -- Module Body
  --

  -- Instantiate Queue 
  ram_queue : riscv_ram_queue
    generic map (
      DEPTH => DEPTH,
      DBITS => DBITS,
      ALMOST_EMPTY_THRESHOLD => 0,
      ALMOST_FULL_THRESHOLD => DEPTH
    )
    port map (
      rst_ni         => rst_ni,
      clk_i          => clk_i,
      clr_i          => clr_i,
      ena_i          => ena_i,
      we_i           => queue_we,
      d_i            => d_i,
      re_i           => queue_re,
      q_o            => queue_q,
      empty_o        => empty,
      full_o         => full_o,
      almost_empty_o => open,
      almost_full_o  => open
      );

  --control signals
  processing_0 : process (clk_i, rst_ni)
    variable req_ack : std_logic_vector(1 downto 0);
  begin
    if (rst_ni = '0') then
      access_pending <= (others => '0');
    elsif (rising_edge(clk_i) or falling_edge(rst_ni)) then
      if (clr_i = '1') then
        access_pending <= (others => '0');
      elsif (ena_i = '1') then
        req_ack := req_i & ack_i;
        case (req_ack) is
          when "01" =>
            access_pending <= std_logic_vector(unsigned(access_pending)-(access_pending'range => '1'));
          when "10" =>
            access_pending <= std_logic_vector(unsigned(access_pending)+(access_pending'range => '1'));
          when others =>
            --do nothing
            null;
        end case;
      end if;
    end if;
  end process;

  queue_we <= reduce_or(access_pending) and (req_i and not (empty and ack_i));
  queue_re <= ack_i and not empty;

  --queue outputs
  req_o <= req_i and not clr_i
           when (reduce_nor(access_pending) = '1') else (req_i or not empty) and ack_i and ena_i and not clr_i;

  q_o <= d_i
         when (empty = '1') else queue_q;

  empty_o <= empty;
end RTL;
