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
--              Core - Data External Access Logic                             --
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

use work.vhdl_pkg.all;

entity pu_riscv_dext is
  generic (
    XLEN  : integer := 64;
    PLEN  : integer := 64;              -- Physical address bus size
    DEPTH : integer := 2                -- number of instructions in flight
    );
  port (
    rst_ni : in std_logic;
    clk_i  : in std_logic;
    clr_i  : in std_logic;

    -- CPU side
    mem_req_i     : in  std_logic;
    mem_adr_i     : in  std_logic_vector(XLEN-1 downto 0);
    mem_size_i    : in  std_logic_vector(2 downto 0);
    mem_type_i    : in  std_logic_vector(2 downto 0);
    mem_lock_i    : in  std_logic;
    mem_prot_i    : in  std_logic_vector(2 downto 0);
    mem_we_i      : in  std_logic;
    mem_d_i       : in  std_logic_vector(XLEN-1 downto 0);
    mem_adr_ack_o : out std_logic;      -- acknowledge address phase
    mem_adr_o     : out std_logic_vector(PLEN-1 downto 0);
    mem_q_o       : out std_logic_vector(XLEN-1 downto 0);
    mem_ack_o     : out std_logic;      -- acknowledge data transfer
    mem_err_o     : out std_logic;      -- data transfer error

    -- To BIU
    biu_stb_o     : out std_logic;
    biu_stb_ack_i : in  std_logic;
    biu_adri_o    : out std_logic_vector(PLEN-1 downto 0);
    biu_adro_i    : in  std_logic_vector(PLEN-1 downto 0);
    biu_size_o    : out std_logic_vector(2 downto 0);  -- transfer size
    biu_type_o    : out std_logic_vector(2 downto 0);  -- burst type
    biu_lock_o    : out std_logic;
    biu_prot_o    : out std_logic_vector(2 downto 0);
    biu_we_o      : out std_logic;
    biu_d_o       : out std_logic_vector(XLEN-1 downto 0);
    biu_q_i       : in  std_logic_vector(XLEN-1 downto 0);
    biu_ack_i     : in  std_logic;      -- data acknowledge, 1 per data
    biu_err_i     : in  std_logic       -- data error
    );
end pu_riscv_dext;

architecture rtl of pu_riscv_dext is

  ------------------------------------------------------------------------------
  -- Variables
  ------------------------------------------------------------------------------
  signal hold_mem_req  : std_logic;
  signal hold_mem_adr  : std_logic_vector(XLEN-1 downto 0);
  signal hold_mem_d    : std_logic_vector(XLEN-1 downto 0);
  signal hold_mem_size : std_logic_vector(2 downto 0);
  signal hold_mem_type : std_logic_vector(2 downto 0);
  signal hold_mem_prot : std_logic_vector(2 downto 0);
  signal hold_mem_lock : std_logic;
  signal hold_mem_we   : std_logic;

  signal inflight : std_logic_vector(integer(log2(real(DEPTH))) downto 0);
  signal discard  : std_logic_vector(integer(log2(real(DEPTH))) downto 0);

  signal biu_stb : std_logic;

begin
  ------------------------------------------------------------------------------
  -- Module Body
  ------------------------------------------------------------------------------

  -- State Machine
  processing_0 : process (clk_i)
  begin
    if (rising_edge(clk_i)) then
      if (mem_req_i = '1') then
        hold_mem_adr  <= mem_adr_i;
        hold_mem_size <= mem_size_i;
        hold_mem_type <= mem_type_i;
        hold_mem_lock <= mem_lock_i;
        hold_mem_we   <= mem_we_i;
        hold_mem_d    <= mem_d_i;
      end if;
    end if;
  end process;

  processing_1 : process (clk_i)
  begin
    if (rising_edge(clk_i)) then
      if (rst_ni = '0') then
        hold_mem_req <= '0';
      elsif (clr_i = '1') then
        hold_mem_req <= '0';
      else
        hold_mem_req <= (mem_req_i or hold_mem_req) and not biu_stb_ack_i;
      end if;
    end if;
  end process;

  processing_2 : process (clk_i, rst_ni)
    variable biu : std_logic_vector(1 downto 0);
  begin
    if (rst_ni = '0') then
      inflight <= (others => '0');
    elsif (rising_edge(clk_i) or falling_edge(rst_ni)) then
      biu := biu_stb_ack_i & (biu_ack_i or biu_err_i);
      case (biu) is
        when "01" =>
          inflight <= std_logic_vector(unsigned(inflight)-(inflight'range => '1'));
        when "10" =>
          inflight <= std_logic_vector(unsigned(inflight)+(inflight'range => '1'));
        when others =>
          -- do nothing
          null;
      end case;
    end if;
  end process;

  processing_3 : process (clk_i, rst_ni)
  begin
    if (rst_ni = '0') then
      discard <= (others => '0');
    elsif (rising_edge(clk_i) or falling_edge(rst_ni)) then
      if (clr_i = '1') then
        if (reduce_or(inflight) = '1' and (biu_ack_i or biu_err_i) = '1') then
          discard <= std_logic_vector(unsigned(inflight)-(inflight'range => '1'));
        else
          discard <= inflight;
        end if;
      elsif (reduce_or(discard) = '1' and (biu_ack_i or biu_err_i) = '1') then
        discard <= std_logic_vector(unsigned(discard)-(discard'range => '1'));
      end if;
    end if;
  end process;

  -- External Interface
  biu_stb    <= (mem_req_i or hold_mem_req) and not clr_i;
  biu_adri_o <= hold_mem_adr
                when (hold_mem_req = '1') else mem_adr_i;
  biu_size_o <= hold_mem_size
                when (hold_mem_req = '1') else mem_size_i;
  biu_lock_o <= hold_mem_lock
                when (hold_mem_req = '1') else mem_lock_i;
  biu_prot_o <= hold_mem_prot
                when (hold_mem_req = '1') else mem_prot_i;
  biu_we_o <= hold_mem_we
              when (hold_mem_req = '1') else mem_we_i;
  biu_d_o <= hold_mem_d
             when (hold_mem_req = '1') else mem_d_i;
  biu_type_o <= hold_mem_type
                when (hold_mem_req = '1') else mem_type_i;

  mem_adr_ack_o <= biu_stb_ack_i;
  mem_adr_o     <= biu_adro_i;
  mem_q_o       <= biu_q_i;
  mem_ack_o     <= '0'
               when (reduce_or(discard) = '1')  else biu_ack_i and not clr_i
               when (reduce_or(inflight) = '1') else biu_ack_i and biu_stb;
  mem_err_o <= '0'
               when (reduce_or(discard) = '1')  else biu_err_i and not clr_i
               when (reduce_or(inflight) = '1') else biu_err_i and biu_stb;

  biu_stb_o <= biu_stb;
end rtl;
