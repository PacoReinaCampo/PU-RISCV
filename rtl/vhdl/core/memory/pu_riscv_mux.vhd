-- Converted from rtl/verilog/core/memory/pu_riscv_mux.sv
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
--              Core - Bus-Interface-Unit Mux                                 --
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

use work.peripheral_biu_vhdl_pkg.all;
use work.vhdl_pkg.all;

entity pu_riscv_mux is
  generic (
    XLEN  : integer := 64;
    PLEN  : integer := 64;
    PORTS : integer := 2
    );
  port (
    rst_ni : in std_logic;
    clk_i  : in std_logic;

    --Input Ports
    biu_req_i     : in  std_logic_vector(PORTS-1 downto 0);  --access request
    biu_req_ack_o : out std_logic_vector(PORTS-1 downto 0);  --biu access acknowledge
    biu_d_ack_o   : out std_logic_vector(PORTS-1 downto 0);  --biu early data acknowledge
    biu_adri_i    : in  std_logic_matrix(PORTS-1 downto 0)(PLEN-1 downto 0);  --access start address
    biu_adro_o    : out std_logic_matrix(PORTS-1 downto 0)(PLEN-1 downto 0);  --biu response address
    biu_size_i    : in  std_logic_matrix(PORTS-1 downto 0)(2 downto 0);  --access data size
    biu_type_i    : in  std_logic_matrix(PORTS-1 downto 0)(2 downto 0);  --access burst type
    biu_lock_i    : in  std_logic_vector(PORTS-1 downto 0);  --access locked access
    biu_prot_i    : in  std_logic_matrix(PORTS-1 downto 0)(2 downto 0);  --access protection
    biu_we_i      : in  std_logic_vector(PORTS-1 downto 0);  --access write enable
    biu_d_i       : in  std_logic_matrix(PORTS-1 downto 0)(XLEN-1 downto 0);  --access write data
    biu_q_o       : out std_logic_matrix(PORTS-1 downto 0)(XLEN-1 downto 0);  --access read data
    biu_ack_o     : out std_logic_vector(PORTS-1 downto 0);  --access acknowledge
    biu_err_o     : out std_logic_vector(PORTS-1 downto 0);  --access error

    --Output (to BIU)
    biu_req_o     : out std_logic;      --BIU access request
    biu_req_ack_i : in  std_logic;      --BIU ackowledge
    biu_d_ack_i   : in  std_logic;      --BIU early data acknowledge
    biu_adri_o    : out std_logic_vector(PLEN-1 downto 0);  --address into BIU
    biu_adro_i    : in  std_logic_vector(PLEN-1 downto 0);  --address from BIU
    biu_size_o    : out std_logic_vector(2 downto 0);       --transfer size
    biu_type_o    : out std_logic_vector(2 downto 0);       --burst type
    biu_lock_o    : out std_logic;
    biu_prot_o    : out std_logic_vector(2 downto 0);
    biu_we_o      : out std_logic;
    biu_d_o       : out std_logic_vector(XLEN-1 downto 0);  --data into BIU
    biu_q_i       : in  std_logic_vector(XLEN-1 downto 0);  --data from BIU
    biu_ack_i     : in  std_logic;      --data acknowledge, 1 per data
    biu_err_i     : in  std_logic       --data error
    );
end pu_riscv_mux;

architecture rtl of pu_riscv_mux is
  ------------------------------------------------------------------------------
  -- Functions
  ------------------------------------------------------------------------------

  --convert burst type to counter length (actually length -1)
  function biu_type2cnt (
    biu_type : std_logic_vector(2 downto 0)
    ) return std_logic_vector is
    variable biu_type2cnt_return : std_logic_vector(3 downto 0);
  begin
    case (biu_type) is
      when SINGLE =>
        biu_type2cnt_return := std_logic_vector(to_unsigned(0, 4));
      when INCR =>
        biu_type2cnt_return := std_logic_vector(to_unsigned(0, 4));
      when WRAP4 =>
        biu_type2cnt_return := std_logic_vector(to_unsigned(3, 4));
      when INCR4 =>
        biu_type2cnt_return := std_logic_vector(to_unsigned(3, 4));
      when WRAP8 =>
        biu_type2cnt_return := std_logic_vector(to_unsigned(7, 4));
      when INCR8 =>
        biu_type2cnt_return := std_logic_vector(to_unsigned(7, 4));
      when WRAP16 =>
        biu_type2cnt_return := std_logic_vector(to_unsigned(15, 4));
      when INCR16 =>
        biu_type2cnt_return := std_logic_vector(to_unsigned(15, 4));
      when others =>
        null;
    end case;
    return biu_type2cnt_return;
  end biu_type2cnt;

  function busor (
    req : std_logic_vector(PORTS-1 downto 0)
    ) return std_logic is
    variable busor_return : std_logic;
  begin
    --default port
    busor_return := '0';

    --check other ports
    for n in PORTS-1 downto 0 loop
      busor_return := busor_return or req(n);
    end loop;

    return busor_return;
  end busor;

  function port_select (
    req : std_logic_vector(PORTS-1 downto 0)
    ) return std_logic_vector is
    variable port_select_return : std_logic_vector(integer(log2(real(PORTS)))-1 downto 0);
  begin
    --default port
    port_select_return := (others => '0');

    --check other ports
    for n in PORTS-1 downto 0 loop
      if (req(n) = '1') then
        port_select_return := std_logic_vector(to_unsigned(n, integer(log2(real(PORTS)))));
      end if;
    end loop;
    return port_select_return;
  end port_select;

  ------------------------------------------------------------------------------
  -- Constants
  ------------------------------------------------------------------------------
  constant IDLE  : std_logic := '0';
  constant BURST : std_logic := '1';

  ------------------------------------------------------------------------------
  -- Variables
  ------------------------------------------------------------------------------
  signal fsm_state     : std_logic;
  signal pending_req   : std_logic;
  signal pending_port  : std_logic_vector(integer(log2(real(PORTS)))-1 downto 0);
  signal selected_port : std_logic_vector(integer(log2(real(PORTS)))-1 downto 0);
  signal pending_size  : std_logic_vector(2 downto 0);

  signal pending_burst_cnt : std_logic_vector(3 downto 0);
  signal burst_cnt         : std_logic_vector(3 downto 0);

begin
  ------------------------------------------------------------------------------
  -- Module Body
  ------------------------------------------------------------------------------

  pending_req       <= busor(biu_req_i);
  pending_port      <= port_select(biu_req_i);
  pending_size      <= biu_size_i(to_integer(unsigned(pending_port)));
  pending_burst_cnt <= biu_type2cnt(biu_type_i(to_integer(unsigned(pending_port))));

  --Access Statemachine
  processing_0 : process (clk_i, rst_ni)
  begin
    if (rst_ni = '0') then
      fsm_state <= IDLE;
      burst_cnt <= (others => '0');
    elsif (rising_edge(clk_i)) then
      case (fsm_state) is
        when IDLE =>
          if (pending_req = '1' and reduce_or(pending_burst_cnt) = '1') then
            fsm_state     <= BURST;
            burst_cnt     <= pending_burst_cnt;
            selected_port <= pending_port;
          else
            selected_port <= pending_port;
          end if;
        when BURST =>
          if (biu_ack_i = '1') then
            burst_cnt <= std_logic_vector(unsigned(burst_cnt)-"0001");
            if (reduce_nor(burst_cnt) = '1') then  --Burst done
              if (pending_req = '1' and reduce_or(pending_burst_cnt) = '1') then
                burst_cnt     <= pending_burst_cnt;
                selected_port <= pending_port;
              else
                fsm_state     <= IDLE;
                selected_port <= pending_port;
              end if;
            end if;
          end if;
        when others =>
          null;
      end case;
    end if;
  end process;

  --Mux BIU ports
  processing_1 : process (biu_ack_i, biu_adri_i, biu_d_i, biu_lock_i, biu_size_i, biu_type_i, biu_we_i, burst_cnt, fsm_state, pending_port, pending_req, selected_port)
  begin
    case (fsm_state) is
      when IDLE =>
        biu_req_o  <= pending_req;
        biu_adri_o <= biu_adri_i (to_integer(unsigned(pending_port)));
        biu_size_o <= biu_size_i (to_integer(unsigned(pending_port)));
        biu_type_o <= biu_type_i (to_integer(unsigned(pending_port)));
        biu_lock_o <= biu_lock_i (to_integer(unsigned(pending_port)));
        biu_we_o   <= biu_we_i (to_integer(unsigned(pending_port)));
        biu_d_o    <= biu_d_i (to_integer(unsigned(pending_port)));
      when BURST =>
        biu_req_o  <= biu_ack_i and reduce_nor(burst_cnt) and pending_req;
        biu_adri_o <= biu_adri_i (to_integer(unsigned(pending_port)));
        biu_size_o <= biu_size_i (to_integer(unsigned(pending_port)));
        biu_type_o <= biu_type_i (to_integer(unsigned(pending_port)));
        biu_lock_o <= biu_lock_i (to_integer(unsigned(pending_port)));
        biu_we_o   <= biu_we_i (to_integer(unsigned(pending_port)));
        if (biu_ack_i = '1' and reduce_nor(burst_cnt) = '1') then
          biu_d_o <= biu_d_i(to_integer(unsigned(pending_port)));
        else
          biu_d_o <= biu_d_i(to_integer(unsigned(selected_port)));
        end if;
--      WAIT4BIU: begin
--        biu_req_o  = 1'b1;
--        biu_adri_o = biu_adri   [ selected_port ];
--        biu_size_o = biu_size_i [ selected_port ];
--        biu_type_o = biu_type_i [ selected_port ];
--        biu_lock_o = biu_lock_i [ selected_port ];
--        biu_we_o   = biu_we_i   [ selected_port ];
--        biu_d_o    = biu_d      [ selected_port ];
--      end
      when others =>
        biu_req_o  <= 'X';
        biu_adri_o <= (others => 'X');
        biu_size_o <= (others => 'X');
        biu_type_o <= (others => 'X');
        biu_lock_o <= 'X';
        biu_we_o   <= 'X';
        biu_d_o    <= (others => 'X');
    end case;
  end process;

  --Decode MEM ports
  generating_0 : for p in 0 to PORTS - 1 generate
    biu_req_ack_o(p) <= biu_req_ack_i
                        when (to_unsigned(p, integer(log2(real(PORTS)))) = unsigned(pending_port)) else '0';
    biu_d_ack_o(p) <= biu_d_ack_i
                      when (to_unsigned(p, integer(log2(real(PORTS)))) = unsigned(pending_port)) else '0';
    biu_adro_o(p) <= biu_adro_i;
    biu_q_o(p)    <= biu_q_i;
    biu_ack_o(p)  <= biu_ack_i
                    when (to_unsigned(p, integer(log2(real(PORTS)))) = unsigned(pending_port)) else '0';
    biu_err_o(p) <= biu_err_i
                    when (to_unsigned(p, integer(log2(real(PORTS)))) = unsigned(pending_port)) else '0';
  end generate;

  biu_prot_o <= (others => '0');
end rtl;
