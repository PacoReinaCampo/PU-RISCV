-- Converted from mpsoc_axi4_spram.sv
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
--              Single Port SRAM                                              //
--              AMBA4 AXI-Lite Bus Interface                                  //
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

entity mpsoc_axi4_spram is
  generic (
    AXI_ID_WIDTH : integer := 10;
    AXI_ADDR_WIDTH : integer := 64;
    AXI_DATA_WIDTH : integer := 64;
    AXI_STRB_WIDTH : integer := 8;
    AXI_USER_WIDTH : integer := 10
  );  
  port (
    clk_i : in std_logic;  -- Clock
    rst_ni : in std_logic;  -- Asynchronous reset active low

    axi_aw_id : in std_logic_vector(AXI_ID_WIDTH-1 downto 0);
    axi_aw_addr : in std_logic_vector(AXI_ADDR_WIDTH-1 downto 0);
    axi_aw_len : in std_logic_vector(7 downto 0);
    axi_aw_size : in std_logic_vector(2 downto 0);
    axi_aw_burst : in std_logic_vector(1 downto 0);
    axi_aw_lock : in std_logic;
    axi_aw_cache : in std_logic_vector(3 downto 0);
    axi_aw_prot : in std_logic_vector(2 downto 0);
    axi_aw_qos : in std_logic_vector(3 downto 0);
    axi_aw_region : in std_logic_vector(3 downto 0);
    axi_aw_user : in std_logic_vector(AXI_USER_WIDTH-1 downto 0);
    axi_aw_valid : in std_logic;
    axi_aw_ready : out std_logic;

    axi_ar_id : in std_logic_vector(AXI_ID_WIDTH-1 downto 0);
    axi_ar_addr : in std_logic_vector(AXI_ADDR_WIDTH-1 downto 0);
    axi_ar_len : in std_logic_vector(7 downto 0);
    axi_ar_size : in std_logic_vector(2 downto 0);
    axi_ar_burst : in std_logic_vector(1 downto 0);
    axi_ar_lock : in std_logic;
    axi_ar_cache : in std_logic_vector(3 downto 0);
    axi_ar_prot : in std_logic_vector(2 downto 0);
    axi_ar_qos : in std_logic_vector(3 downto 0);
    axi_ar_region : in std_logic_vector(3 downto 0);
    axi_ar_user : in std_logic_vector(AXI_USER_WIDTH-1 downto 0);
    axi_ar_valid : in std_logic;
    axi_ar_ready : out std_logic;

    axi_w_data : in std_logic_vector(AXI_DATA_WIDTH-1 downto 0);
    axi_w_strb : in std_logic_vector(AXI_STRB_WIDTH-1 downto 0);
    axi_w_last : in std_logic;
    axi_w_user : in std_logic_vector(AXI_USER_WIDTH-1 downto 0);
    axi_w_valid : in std_logic;
    axi_w_ready : out std_logic;

    axi_r_id : out std_logic_vector(AXI_ID_WIDTH-1 downto 0);
    axi_r_data : out std_logic_vector(AXI_DATA_WIDTH-1 downto 0);
    axi_r_resp : out std_logic_vector(1 downto 0);
    axi_r_last : out std_logic;
    axi_r_user : out std_logic_vector(AXI_USER_WIDTH-1 downto 0);
    axi_r_valid : out std_logic;
    axi_r_ready : in std_logic;

    axi_b_id : out std_logic_vector(AXI_ID_WIDTH-1 downto 0);
    axi_b_resp : out std_logic_vector(1 downto 0);
    axi_b_user : out std_logic_vector(AXI_USER_WIDTH-1 downto 0);
    axi_b_valid : out std_logic;
    axi_b_ready : in std_logic;

    req_o : out std_logic;
    we_o : out std_logic;
    addr_o : out std_logic_vector(AXI_ADDR_WIDTH-1 downto 0);
    be_o : out std_logic_vector(AXI_DATA_WIDTH/8-1 downto 0);
    data_o : out std_logic_vector(AXI_DATA_WIDTH-1 downto 0) 
    data_i : in std_logic_vector(AXI_DATA_WIDTH-1 downto 0)
  );
end mpsoc_axi4_spram;

architecture RTL of mpsoc_axi4_spram is


  -- AXI has the following rules governing the use of bursts:
  -- - for wrapping bursts, the burst length must be 2, 4, 8, or 16
  -- - a burst must not cross a 4KB address boundary
  -- - early termination of bursts is not supported.
  --typedef enum logic [1:0] { FIXED = 2'b00, INCR = 2'b01, WRAP = 2'b10} axi_burst_t;

  constant LOG_NR_BYTES : integer := (null)(AXI_DATA_WIDTH/8);

  --  typedef struct packed {
  --    logic [AXI_ID_WIDTH  -1:0] id;
  --    logic [AXI_ADDR_WIDTH-1:0] addr;
  --    logic [               7:0] len;
  --    logic [               2:0] size;
  --    axi_burst_t                burst;
  --  } ax_req_t;

  -- Registers
  --  enum logic [2:0] { IDLE, READ, WRITE, SEND_B, WAIT_WVALID }  state_d, state_q;
  --  ax_req_t                   ax_req_d, ax_req_q;
  signal req_addr_d, req_addr_q : std_logic_vector(AXI_ADDR_WIDTH-1 downto 0);
  signal cnt_d, cnt_q : std_logic_vector(7 downto 0);



  signal aligned_address : std_logic_vector(AXI_ADDR_WIDTH-1 downto 0);
  signal wrap_boundary : std_logic_vector(AXI_ADDR_WIDTH-1 downto 0);
  signal upper_wrap_boundary : std_logic_vector(AXI_ADDR_WIDTH-1 downto 0);
  signal cons_addr : std_logic_vector(AXI_ADDR_WIDTH-1 downto 0);

begin
  processing_0 : process
  begin
    -- address generation
    aligned_address <= (ax_req_q.addr(AXI_ADDR_WIDTH-1 downto LOG_NR_BYTES) & concatenate((LOG_NR_BYTES), '0'));
    wrap_boundary <= (null)(ax_req_q.addr, ax_req_q.len);
    -- this will overflow
    upper_wrap_boundary <= wrap_boundary+((ax_req_q.len+1) sll LOG_NR_BYTES);
    -- calculate consecutive address
    cons_addr <= aligned_address+(cnt_q sll LOG_NR_BYTES);

    -- Transaction attributes
    -- default assignments
    state_d <= state_q;
    ax_req_d <= ax_req_q;
    req_addr_d <= req_addr_q;
    cnt_d <= cnt_q;
    -- Memory default assignments
    data_o <= axi_w_data;
    be_o <= axi_w_strb;
    we_o <= '0';
    req_o <= '0';
    addr_o <= 0;
    -- AXI assignments
    -- request
    axi_aw_ready <= '0';
    axi_ar_ready <= '0';
    -- read response channel
    axi_r_valid <= '0';
    axi_r_data <= data_i;
    axi_r_resp <= 0;
    axi_r_last <= 0;
    axi_r_id <= ax_req_q.id;
    axi_r_user <= 0;
    -- slave write data channel
    axi_w_ready <= '0';
    -- write response channel
    axi_b_valid <= '0';
    axi_b_resp <= '0';
    axi_b_id <= '0';
    axi_b_user <= '0';

    case ((state_q)) is

    when IDLE =>
    -- Wait for a read or write
    -- Read
      if (axi_ar_valid) then
        axi_ar_ready <= '1';
        -- sample ax
        ax_req_d <= (axi_ar_id & axi_ar_addr & axi_ar_len & axi_ar_size & axi_ar_burst);
        state_d <= READ;
        --  we can request the first address, this saves us time
        req_o <= '1';
        addr_o <= axi_ar_addr;
        -- save the address
        req_addr_d <= axi_ar_addr;
        -- save the ar_len
        cnt_d <= 1;
      -- Write
      elsif (axi_aw_valid) then
        axi_aw_ready <= '1';
        axi_w_ready <= '1';
        addr_o <= axi_aw_addr;
        -- sample ax
        ax_req_d <= (axi_aw_id & axi_aw_addr & axi_aw_len & axi_aw_size & axi_aw_burst);
        -- we've got our first w_valid so start the write process
        if (axi_w_valid) then
          req_o <= '1';
          we_o <= '1';
          state_d <= SEND_B
          when (axi_w_last) else WRITE;
          cnt_d <= 1;
        else        -- we still have to wait for the first w_valid to arrive
          state_d <= WAIT_WVALID;
        end if;
      end if;


    -- ~> we are still missing a w_valid
    when WAIT_WVALID =>
      axi_w_ready <= '1';
      addr_o <= ax_req_q.addr;
      -- we can now make our first request
      if (axi_w_valid) then
        req_o <= '1';
        we_o <= '1';
        state_d <= SEND_B
        when (axi_w_last) else WRITE;
        cnt_d <= 1;
      end if;


    when READ =>
    -- keep request to memory high
      req_o <= '1';
      addr_o <= req_addr_q;
      -- send the response
      axi_r_valid <= '1';
      axi_r_data <= data_i;
      axi_r_id <= ax_req_q.id;
      axi_r_last <= (cnt_q = ax_req_q.len+1);

      -- check that the master is ready, the slave must not wait on this
      if (axi_r_ready) then
        -- Next address generation
        -- handle the correct burst type
        case ((ax_req_q.burst)) is
        when FIXED, INCR =>
          addr_o <= cons_addr;
        when WRAP =>
        -- check if the address reached warp boundary
          if (cons_addr = upper_wrap_boundary) then
            addr_o <= wrap_boundary;
          -- address warped beyond boundary
          elsif (cons_addr > upper_wrap_boundary) then
            addr_o <= ax_req_q.addr+((cnt_q-ax_req_q.len) sll LOG_NR_BYTES);
          else          -- we are still in the incremental regime
            addr_o <= cons_addr;
          end if;
        end case;
        -- we need to change the address here for the upcoming request
        -- we sent the last byte -> go back to idle
        if (axi_r_last) then
          state_d <= IDLE;
          -- we already got everything
          req_o <= '0';
        end if;
        -- save the request address for the next cycle
        req_addr_d <= addr_o;
        -- we can decrease the counter as the master has consumed the read data
        cnt_d <= cnt_q+1;
      end if;
    -- TODO: configure correct byte-lane
    -- ~> we already wrote the first word here
    when WRITE =>




      axi_w_ready <= '1';
      -- consume a word here
      if (axi_w_valid) then
        req_o <= '1';
        we_o <= '1';
        -- Next address generation
        -- handle the correct burst type
        case ((ax_req_q.burst)) is

        when FIXED, INCR =>
          addr_o <= cons_addr;
        when WRAP =>
        -- check if the address reached warp boundary
          if (cons_addr = upper_wrap_boundary) then
            addr_o <= wrap_boundary;
          -- address warped beyond boundary
          elsif (cons_addr > upper_wrap_boundary) then
            addr_o <= ax_req_q.addr+((cnt_q-ax_req_q.len) sll LOG_NR_BYTES);
          else          -- we are still in the incremental regime
            addr_o <= cons_addr;
          end if;
        end case;
        -- save the request address for the next cycle
        req_addr_d <= addr_o;
        -- we can decrease the counter as the master has consumed the read data
        cnt_d <= cnt_q+1;

        if (axi_w_last) then
          state_d <= SEND_B;
        end if;
      end if;
    -- ~> send a write acknowledge back
    when SEND_B =>
      axi_b_valid <= '1';
      axi_b_id <= ax_req_q.id;
      if (axi_b_ready) then
        state_d <= IDLE;
      end if;
    end case;
  end process;


  -- Registers
  processing_1 : process (clk_i, rst_ni)
  begin
    if (not rst_ni) then
      state_q <= IDLE;
      ax_req_q <= 0;
      req_addr_q <= 0;
      cnt_q <= 0;
    elsif (rising_edge(clk_i)) then
      state_q <= state_d;
      ax_req_q <= ax_req_d;
      req_addr_q <= req_addr_d;
      cnt_q <= cnt_d;
    end if;
  end process;
end RTL;
