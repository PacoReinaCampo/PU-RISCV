-- Converted from riscv_axi2ahb.sv
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
--              AMBA3 AHB-Lite Bus Interface                                  //
--              AMBA4 AXI-Lite Bus Interface                                  //
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

entity riscv_axi2ahb is
  port (


    clk : in std_logic;
    rst_l : in std_logic;

    scan_mode : in std_logic;
    bus_clk_en : in std_logic;
    clk_override : in std_logic;

  --AXI4 instruction
    axi4_aw_id : in std_logic_vector(AXI_ID_WIDTH-1 downto 0);
    axi4_aw_addr : in std_logic_vector(AXI_ADDR_WIDTH-1 downto 0);
    axi4_aw_len : in std_logic_vector(7 downto 0);
    axi4_aw_size : in std_logic_vector(2 downto 0);
    axi4_aw_burst : in std_logic_vector(1 downto 0);
    axi4_aw_lock : in std_logic;
    axi4_aw_cache : in std_logic_vector(3 downto 0);
    axi4_aw_prot : in std_logic_vector(2 downto 0);
    axi4_aw_qos : in std_logic_vector(3 downto 0);
    axi4_aw_region : in std_logic_vector(3 downto 0);
    axi4_aw_user : in std_logic_vector(AXI_USER_WIDTH-1 downto 0);
    axi4_aw_valid : in std_logic;
    axi4_aw_ready : out std_logic;

    axi4_ar_id : in std_logic_vector(AXI_ID_WIDTH-1 downto 0);
    axi4_ar_addr : in std_logic_vector(AXI_ADDR_WIDTH-1 downto 0);
    axi4_ar_len : in std_logic_vector(7 downto 0);
    axi4_ar_size : in std_logic_vector(2 downto 0);
    axi4_ar_burst : in std_logic_vector(1 downto 0);
    axi4_ar_lock : in std_logic;
    axi4_ar_cache : in std_logic_vector(3 downto 0);
    axi4_ar_prot : in std_logic_vector(2 downto 0);
    axi4_ar_qos : in std_logic_vector(3 downto 0);
    axi4_ar_region : in std_logic_vector(3 downto 0);
    axi4_ar_user : in std_logic_vector(AXI_USER_WIDTH-1 downto 0);
    axi4_ar_valid : in std_logic;
    axi4_ar_ready : out std_logic;

    axi4_w_data : in std_logic_vector(AXI_DATA_WIDTH-1 downto 0);
    axi4_w_strb : in std_logic_vector(AXI_STRB_WIDTH-1 downto 0);
    axi4_w_last : in std_logic;
    axi4_w_user : in std_logic_vector(AXI_USER_WIDTH-1 downto 0);
    axi4_w_valid : in std_logic;
    axi4_w_ready : out std_logic;

    axi4_r_id : out std_logic_vector(AXI_ID_WIDTH-1 downto 0);
    axi4_r_data : out std_logic_vector(AXI_DATA_WIDTH-1 downto 0);
    axi4_r_resp : out std_logic_vector(1 downto 0);
    axi4_r_last : out std_logic;
    axi4_r_user : out std_logic_vector(AXI_USER_WIDTH-1 downto 0);
    axi4_r_valid : out std_logic;
    axi4_r_ready : in std_logic;

    axi4_b_id : out std_logic_vector(AXI_ID_WIDTH-1 downto 0);
    axi4_b_resp : out std_logic_vector(1 downto 0);
    axi4_b_user : out std_logic_vector(AXI_USER_WIDTH-1 downto 0);
    axi4_b_valid : out std_logic;
    axi4_b_ready : in std_logic;

  -- AHB3 signals
    ahb3_hsel : out std_logic;
    ahb3_haddr : out std_logic_vector(AHB_ADDR_WIDTH-1 downto 0);
    ahb3_hwdata : out std_logic_vector(AHB_DATA_WIDTH-1 downto 0);
    ahb3_hrdata : in std_logic_vector(AHB_DATA_WIDTH-1 downto 0);
    ahb3_hwrite : out std_logic;
    ahb3_hsize : out std_logic_vector(2 downto 0);
    ahb3_hburst : out std_logic_vector(2 downto 0);
    ahb3_hprot : out std_logic_vector(3 downto 0);
    ahb3_htrans : out std_logic_vector(1 downto 0);
    ahb3_hmastlock : out std_logic;
    ahb3_hreadyin : out std_logic;
    ahb3_hreadyout : in std_logic 
    ahb3_hresp : in std_logic
  );
  constant AXI_ID_WIDTH : integer := 10;
  constant AXI_ADDR_WIDTH : integer := 64;
  constant AXI_DATA_WIDTH : integer := 64;
  constant AXI_STRB_WIDTH : integer := 10;
  constant AXI_USER_WIDTH : integer := 10;
  constant AHB_ADDR_WIDTH : integer := 64;
  constant AHB_DATA_WIDTH : integer := 64;
end riscv_axi2ahb;

architecture RTL of riscv_axi2ahb is


  --////////////////////////////////////////////////////////////////
  --
  -- Constants
  --

  constant ID : integer := 1;
  constant PRTY : integer := 1;

  --////////////////////////////////////////////////////////////////
  --
  -- Variables
  --

  signal buf_state, buf_nxtstate : std_logic_vector(2 downto 0);

  signal slave_valid : std_logic;
  signal slave_ready : std_logic;
  signal slave_tag : std_logic_vector(AXI_ID_WIDTH-1 downto 0);
  signal slave_rdata : std_logic_vector(AXI_DATA_WIDTH-1 downto 0);
  signal slave_opc : std_logic_vector(3 downto 0);

  signal wrbuf_en, wrbuf_data_en : std_logic;
  signal wrbuf_cmd_sent, wrbuf_rst : std_logic;
  signal wrbuf_vld : std_logic;
  signal wrbuf_data_vld : std_logic;
  signal wrbuf_tag : std_logic_vector(AXI_ID_WIDTH-1 downto 0);
  signal wrbuf_size : std_logic_vector(2 downto 0);
  signal wrbuf_addr : std_logic_vector(AXI_ADDR_WIDTH-1 downto 0);
  signal wrbuf_data : std_logic_vector(AXI_DATA_WIDTH-1 downto 0);
  signal wrbuf_byteen : std_logic_vector(7 downto 0);

  signal bus_write_clk_en : std_logic;
  signal bus_clk, bus_write_clk : std_logic;

  signal master_valid : std_logic;
  signal master_ready : std_logic;
  signal master_tag : std_logic_vector(AXI_ID_WIDTH-1 downto 0);
  signal master_addr : std_logic_vector(AXI_ADDR_WIDTH-1 downto 0);
  signal master_wdata : std_logic_vector(AXI_DATA_WIDTH-1 downto 0);
  signal master_size : std_logic_vector(2 downto 0);
  signal master_opc : std_logic_vector(2 downto 0);

  -- Buffer signals (one entry buffer)
  signal buf_addr : std_logic_vector(AXI_ADDR_WIDTH-1 downto 0);
  signal buf_size : std_logic_vector(1 downto 0);
  signal buf_write : std_logic;
  signal buf_byteen : std_logic_vector(7 downto 0);
  signal buf_aligned : std_logic;
  signal buf_data : std_logic_vector(AXI_DATA_WIDTH-1 downto 0);
  signal buf_tag : std_logic_vector(AXI_ID_WIDTH-1 downto 0);

  --Miscellaneous signals
  signal buf_rst : std_logic;
  signal buf_tag_in : std_logic_vector(AXI_ID_WIDTH-1 downto 0);
  signal buf_addr_in : std_logic_vector(AXI_ADDR_WIDTH-1 downto 0);
  signal buf_byteen_in : std_logic_vector(7 downto 0);
  signal buf_data_in : std_logic_vector(AXI_DATA_WIDTH-1 downto 0);
  signal buf_write_in : std_logic;
  signal buf_aligned_in : std_logic;
  signal buf_size_in : std_logic_vector(2 downto 0);

  signal buf_state_en : std_logic;
  signal buf_wr_en : std_logic;
  signal buf_data_wr_en : std_logic;
  signal slvbuf_error_en : std_logic;
  signal wr_cmd_vld : std_logic;

  signal cmd_done_rst, cmd_done, cmd_doneQ : std_logic;
  signal trxn_done : std_logic;
  signal buf_cmd_byte_ptr, buf_cmd_byte_ptrQ, buf_cmd_nxtbyte_ptr : std_logic_vector(2 downto 0);
  signal buf_cmd_byte_ptr_en : std_logic;
  signal found : std_logic;

  signal slave_valid_pre : std_logic;
  signal ahb3_hready_q : std_logic;
  signal ahb3_hresp_q : std_logic;
  signal ahb3_htrans_q : std_logic_vector(1 downto 0);
  signal ahb3_hwrite_q : std_logic;
  signal ahb3_hrdata_q : std_logic_vector(AXI_DATA_WIDTH-1 downto 0);


  signal slvbuf_write : std_logic;
  signal slvbuf_error : std_logic;
  signal slvbuf_tag : std_logic_vector(AXI_ID_WIDTH-1 downto 0);

  signal slvbuf_error_in : std_logic;
  signal slvbuf_wr_en : std_logic;
  signal bypass_en : std_logic;
  signal rd_bypass_idle : std_logic;

  signal last_addr_en : std_logic;
  signal last_bus_addr : std_logic_vector(AXI_ADDR_WIDTH-1 downto 0);

  -- Clocks
  signal buf_clken, slvbuf_clken : std_logic;
  signal ahbm_addr_clken : std_logic;
  signal ahbm_data_clken : std_logic;

  signal buf_clk, slvbuf_clk : std_logic;
  signal ahbm_clk : std_logic;
  signal ahbm_addr_clk : std_logic;
  signal ahbm_data_clk : std_logic;

  --////////////////////////////////////////////////////////////////
  --
  -- Functions
  --

  -- Function to get the length from byte enable
  function get_write_size (
    byteen : std_logic_vector(7 downto 0);

    signal size : std_logic_vector(1 downto 0);

  ) return std_logic
    variable get_write_size_return : std_logic;
  begin
    size(1 downto 0) <= ("11" and ((byteen(7 downto 0) = X"ff") & (byteen(7 downto 0) = X"ff"))) or ("10" and (((byteen(7 downto 0) = X"f0") or (byteen(7 downto 0) = X"0f")) & ((byteen(7 downto 0) = X"f0") or (byteen(7 downto 0) = X"0f")))) or ("01" and (((byteen(7 downto 0) = X"c0") or (byteen(7 downto 0) = X"30") or (byteen(7 downto 0) = X"0c") or (byteen(7 downto 0) = X"03")) & ((byteen(7 downto 0) = X"c0") or (byteen(7 downto 0) = X"30") or (byteen(7 downto 0) = X"0c") or (byteen(7 downto 0) = X"03"))));

    return get_write_size_return;
  end get_write_size;



  -- Function to get the length from byte enable
  function get_write_addr (
    byteen : std_logic_vector(7 downto 0);

    signal addr : std_logic_vector(2 downto 0);

  ) return std_logic
    variable get_write_addr_return : std_logic;
  begin
    addr(2 downto 0) <= (X"0" and (((byteen(7 downto 0) = X"ff") or (byteen(7 downto 0) = X"0f") or (byteen(7 downto 0) = X"03")) & ((byteen(7 downto 0) = X"ff") or (byteen(7 downto 0) = X"0f") or (byteen(7 downto 0) = X"03")) & ((byteen(7 downto 0) = X"ff") or (byteen(7 downto 0) = X"0f") or (byteen(7 downto 0) = X"03")))) or (X"2" and ((byteen(7 downto 0) = X"0c") & (byteen(7 downto 0) = X"0c") & (byteen(7 downto 0) = X"0c"))) or (X"4" and (((byteen(7 downto 0) = X"f0") or (byteen(7 downto 0) = X"03")) & ((byteen(7 downto 0) = X"f0") or (byteen(7 downto 0) = X"03")) & ((byteen(7 downto 0) = X"f0") or (byteen(7 downto 0) = X"03")))) or (X"6" and ((byteen(7 downto 0) = X"c0") & (byteen(7 downto 0) = X"c0") & (byteen(7 downto 0) = X"c0")));

    return get_write_addr_return;
  end get_write_addr;

begin


  -- Function to get the next byte pointer

  --////////////////////////////////////////////////////////////////
  --
  -- Module Body
  --

  -- Write buffer
  wrbuf_en <= axi4_aw_valid and axi4_aw_ready and master_ready;
  wrbuf_data_en <= axi4_w_valid and axi4_w_ready and master_ready;
  wrbuf_cmd_sent <= master_valid and master_ready and (master_opc(2 downto 1) = "01");
  wrbuf_rst <= wrbuf_cmd_sent and not wrbuf_en;

  axi4_aw_ready <= not (wrbuf_vld and not wrbuf_cmd_sent) and master_ready;
  axi4_w_ready <= not (wrbuf_data_vld and not wrbuf_cmd_sent) and master_ready;
  axi4_ar_ready <= not (wrbuf_vld and wrbuf_data_vld) and master_ready;
  axi4_r_last <= '1';

  wr_cmd_vld <= (wrbuf_vld and wrbuf_data_vld);
  master_valid <= wr_cmd_vld or axi4_ar_valid;
  master_tag <= wrbuf_tag
  when wr_cmd_vld else axi4_ar_id;
  master_opc <= "011"
  when wr_cmd_vld else "000";
  master_addr <= wrbuf_addr
  when wr_cmd_vld else axi4_ar_addr;
  master_size <= wrbuf_size(2 downto 0)
  when wr_cmd_vld else axi4_ar_size;
  master_wdata <= wrbuf_data;

  -- AXI response channel signals
  axi4_b_valid <= slave_valid and slave_ready and slave_opc(3);
  axi4_b_resp <= "10"
  when slave_opc(0) else "11"
  when slave_opc(1) else '0';
  axi4_b_id <= slave_tag;

  axi4_r_valid <= slave_valid and slave_ready and (slave_opc(3 downto 2) = '0');
  axi4_r_resp <= "10"
  when slave_opc(0) else "11"
  when slave_opc(1) else '0';
  axi4_r_id <= slave_tag;
  axi4_r_data <= slave_rdata;
  slave_ready <= axi4_b_ready and axi4_r_ready;

  -- Clock header logic
  bus_write_clk_en <= bus_clk_en and ((axi4_aw_valid and axi4_aw_ready) or (axi4_w_valid and axi4_w_ready));

  processing_0 : process (clk)
  begin
    if (falling_edge(clk)) then
      bus_clk <= clk and (bus_clk_en or scan_mode);
      bus_write_clk <= clk and (bus_write_clk_en or scan_mode);
    end if;
  end process;


  -- FIFO state machine
  processing_1 : process
  begin
    buf_nxtstate <= IDLE;
    buf_state_en <= '0';
    buf_wr_en <= '0';
    buf_data_wr_en <= '0';
    slvbuf_error_in <= '0';
    slvbuf_error_en <= '0';
    buf_write_in <= '0';
    cmd_done <= '0';
    trxn_done <= '0';
    buf_cmd_byte_ptr_en <= '0';
    buf_cmd_byte_ptr <= "000";
    slave_valid_pre <= '0';
    master_ready <= '0';
    ahb3_htrans <= '0';
    slvbuf_wr_en <= '0';
    bypass_en <= '0';
    rd_bypass_idle <= '0';

    case ((buf_state)) is
    when IDLE =>
      master_ready <= '1';
      buf_write_in <= (master_opc(2 downto 1) = "01");
      buf_nxtstate <= CMD_WR
      when buf_write_in else CMD_RD;
      buf_state_en <= master_valid and master_ready;
      buf_wr_en <= buf_state_en;
      buf_data_wr_en <= buf_state_en and (buf_nxtstate = CMD_WR);
      buf_cmd_byte_ptr_en <= buf_state_en;
      buf_cmd_byte_ptr <= (null)('0', buf_byteen_in, '0')
      when buf_write_in else master_addr(2 downto 0);
      bypass_en <= buf_state_en;
      rd_bypass_idle <= bypass_en and (buf_nxtstate = CMD_RD);
      ahb3_htrans <= (bypass_en & bypass_en) and "10";
    when CMD_RD =>
      buf_nxtstate <= STREAM_RD
      when (master_valid and (master_opc = "000")) else DATA_RD;
      buf_state_en <= ahb3_hready_q and (ahb3_htrans_q(1 downto 0) /= '0') and not ahb3_hwrite_q;
      cmd_done <= buf_state_en and not master_valid;
      slvbuf_wr_en <= buf_state_en;
      master_ready <= buf_state_en and (buf_nxtstate = STREAM_RD);
      buf_wr_en <= master_ready;
      bypass_en <= master_ready and master_valid;
      buf_cmd_byte_ptr <= master_addr(2 downto 0)
      when bypass_en else buf_addr(2 downto 0);
      ahb3_htrans <= "10" and (not buf_state_en or bypass_en & not buf_state_en or bypass_en);
    when STREAM_RD =>
      master_ready <= (ahb3_hready_q and not ahb3_hresp_q) and not (master_valid and master_opc(2 downto 1) = "01");
      -- update the fifo if we are streaming the read commands
      buf_wr_en <= (master_valid and master_ready and (master_opc = "000"));
      -- assuming that the master accpets the slave response right away.
      buf_nxtstate <= STREAM_ERR_RD
      when ahb3_hresp_q else STREAM_RD
      when buf_wr_en else DATA_RD;
      buf_state_en <= (ahb3_hready_q or ahb3_hresp_q);
      buf_data_wr_en <= buf_state_en;
      slvbuf_error_in <= ahb3_hresp_q;
      slvbuf_error_en <= buf_state_en;
      slave_valid_pre <= buf_state_en and not ahb3_hresp_q;      -- send a response right away if we are not going through an error response.
      cmd_done <= buf_state_en and not master_valid;      -- last one of the stream should not send a htrans
      bypass_en <= master_ready and master_valid and (buf_nxtstate = STREAM_RD) and buf_state_en;
      buf_cmd_byte_ptr <= master_addr(2 downto 0)
      when bypass_en else buf_addr(2 downto 0);
      ahb3_htrans <= "10" and (not ((buf_nxtstate /= STREAM_RD) and buf_state_en) & not ((buf_nxtstate /= STREAM_RD) and buf_state_en));
      slvbuf_wr_en <= buf_wr_en;      -- shifting the contents from the buf to slv_buf for streaming cases
    -- case: STREAM_RD
    when STREAM_ERR_RD =>
      buf_nxtstate <= DATA_RD;
      buf_state_en <= ahb3_hready_q and (ahb3_htrans_q(1 downto 0) /= '0') and not ahb3_hwrite_q;
      slave_valid_pre <= buf_state_en;
      slvbuf_wr_en <= buf_state_en;      -- Overwrite slvbuf with buffer
      buf_cmd_byte_ptr <= buf_addr(2 downto 0);
      ahb3_htrans <= "10" and (not buf_state_en & not buf_state_en);
    when DATA_RD =>
      buf_nxtstate <= DONE;
      buf_state_en <= (ahb3_hready_q or ahb3_hresp_q);
      buf_data_wr_en <= buf_state_en;
      slvbuf_error_in <= ahb3_hresp_q;
      slvbuf_error_en <= buf_state_en;
      slvbuf_wr_en <= buf_state_en;
    when CMD_WR =>
      buf_nxtstate <= DATA_WR;
      trxn_done <= ahb3_hready_q and ahb3_hwrite_q and (ahb3_htrans_q(1 downto 0) /= '0');
      buf_state_en <= trxn_done;
      buf_cmd_byte_ptr_en <= buf_state_en;
      slvbuf_wr_en <= buf_state_en;
      buf_cmd_byte_ptr <= (null)(buf_cmd_byte_ptrQ(2 downto 0), buf_byteen(7 downto 0), '1')
      when trxn_done else buf_cmd_byte_ptrQ;
      cmd_done <= trxn_done and (buf_aligned or (buf_cmd_byte_ptrQ = "111") or (buf_byteen((null)(buf_cmd_byte_ptrQ(2 downto 0), buf_byteen(7 downto 0), '1')) = '0'));
      ahb3_htrans <= (not (cmd_done or cmd_doneQ) & not (cmd_done or cmd_doneQ)) and "10";
    when DATA_WR =>
      buf_state_en <= (cmd_doneQ and ahb3_hready_q) or ahb3_hresp_q;
      master_ready <= buf_state_en and not ahb3_hresp_q and slave_ready;      -- Ready to accept new command if current command done and no error
      buf_nxtstate <= DONE
      when (ahb3_hresp_q or not slave_ready) else CMD_WR
      when (master_opc(2 downto 1) = "01") else CMD_RD
      when (master_valid and master_ready) else IDLE;
      slvbuf_error_in <= ahb3_hresp_q;
      slvbuf_error_en <= buf_state_en;

      buf_write_in <= (master_opc(2 downto 1) = "01");
      buf_wr_en <= buf_state_en and ((buf_nxtstate = CMD_WR) or (buf_nxtstate = CMD_RD));
      buf_data_wr_en <= buf_wr_en;

      cmd_done <= (ahb3_hresp_q or (ahb3_hready_q and (ahb3_htrans_q(1 downto 0) /= '0') and ((buf_cmd_byte_ptrQ = "111") or (buf_byteen((null)(buf_cmd_byte_ptrQ(2 downto 0), buf_byteen(7 downto 0), '1')) = '0'))));
      bypass_en <= buf_state_en and buf_write_in and (buf_nxtstate = CMD_WR);      -- Only bypass for writes for the time being
      ahb3_htrans <= ((not (cmd_done or cmd_doneQ) or bypass_en) & (not (cmd_done or cmd_doneQ) or bypass_en)) and "10";
      slave_valid_pre <= buf_state_en and (buf_nxtstate /= DONE);

      trxn_done <= ahb3_hready_q and ahb3_hwrite_q and (ahb3_htrans_q(1 downto 0) /= '0');
      buf_cmd_byte_ptr_en <= trxn_done or bypass_en;
      buf_cmd_byte_ptr <= (null)('0', buf_byteen_in, '0')
      when bypass_en else (null)(buf_cmd_byte_ptrQ(2 downto 0), buf_byteen(7 downto 0), '1')
      when trxn_done else buf_cmd_byte_ptrQ;
    when DONE =>
      buf_nxtstate <= IDLE;
      buf_state_en <= slave_ready;
      slvbuf_error_en <= '1';
      slave_valid_pre <= '1';
    end case;
  end process;


  buf_rst <= '0';
  cmd_done_rst <= slave_valid_pre;
  buf_addr_in(2 downto 0) <= (null)(wrbuf_byteen(7 downto 0))
  when (buf_aligned_in and (master_opc(2 downto 1) = "01")) else master_addr(2 downto 0);
  buf_addr_in(31 downto 3) <= master_addr(31 downto 3);
  buf_tag_in <= master_tag;
  buf_byteen_in <= wrbuf_byteen(7 downto 0);
  buf_data_in <= ahb3_hrdata_q
  when (buf_state = DATA_RD) else master_wdata;
  buf_size_in(1 downto 0) <= (null)(wrbuf_byteen(7 downto 0))
  when (buf_aligned_in and (master_size(1 downto 0) = "11") and (master_opc(2 downto 1) = "01")) else master_size(1 downto 0);
  -- reads are always aligned since they are either DW or sideeffects
  -- Always aligned for Byte/HW/Word since they can be only for non-idempotent. IFU/SB are always aligned
  buf_aligned_in <= (master_opc = "000") or (master_size(1 downto 0) = '0') or (master_size(1 downto 0) = "01") or (master_size(1 downto 0) = "10") or ((master_size(1 downto 0) = "11") and ((wrbuf_byteen(7 downto 0) = X"3") or (wrbuf_byteen(7 downto 0) = X"c") or (wrbuf_byteen(7 downto 0) = X"30") or (wrbuf_byteen(7 downto 0) = X"c0") or (wrbuf_byteen(7 downto 0) = X"f") or (wrbuf_byteen(7 downto 0) = X"f0") or (wrbuf_byteen(7 downto 0) = X"ff")));

  -- Generate the ahb signals
  ahb3_haddr <= (master_addr(31 downto 3) & buf_cmd_byte_ptr)
  when bypass_en else (buf_addr(31 downto 3) & buf_cmd_byte_ptr);
  ahb3_hsize <= ('0' & ((buf_aligned_in & buf_aligned_in) and buf_size_in(1 downto 0)))
  when bypass_en else ('0' & ((buf_aligned & buf_aligned) and buf_size(1 downto 0)));  -- Send the full size for aligned trxn
  ahb3_hburst <= "000";
  ahb3_hmastlock <= '0';
  ahb3_hprot <= ("001" & not axi4_ar_prot(2));
  ahb3_hwrite <= (master_opc(2 downto 1) = "01")
  when bypass_en else buf_write;
  ahb3_hwdata <= buf_data;

  slave_valid <= slave_valid_pre;
  slave_opc(3 downto 2) <= "11"
  when slvbuf_write else "00";
  slave_opc(1 downto 0) <= (slvbuf_error & slvbuf_error) and "10";
  slave_rdata <= (last_bus_addr & last_bus_addr)
  when slvbuf_error else buf_data
  when (buf_state = DONE) else ahb3_hrdata_q;
  slave_tag <= slvbuf_tag;

  last_addr_en <= (ahb3_htrans /= '0') and ahb3_hreadyout and ahb3_hwrite;

  processing_2 : process (bus_clk, rst_l)
  begin
    if (rst_l = 0) then
      wrbuf_vld <= 0;
    elsif (rising_edge(bus_clk)) then
      wrbuf_vld <= not wrbuf_rst and ('1'
      when wrbuf_en else wrbuf_vld);
    end if;
  end process;


  processing_3 : process (bus_clk, rst_l)
  begin
    if (rst_l = 0) then
      wrbuf_data_vld <= 0;
    elsif (rising_edge(bus_clk)) then
      wrbuf_data_vld <= not wrbuf_rst and ('1'
      when wrbuf_data_en else wrbuf_data_vld);
    end if;
  end process;


  processing_4 : process (buf_clk, rst_l)
  begin
    if (rst_l = 0) then
      slvbuf_write <= 0;
    elsif (rising_edge(buf_clk)) then
      slvbuf_write <= buf_write
      when slvbuf_wr_en else slvbuf_write;
    end if;
  end process;


  processing_5 : process (buf_clk, rst_l)
  begin
    if (rst_l = 0) then
      slvbuf_write <= 0;
    elsif (rising_edge(buf_clk)) then
      slvbuf_write <= buf_write
      when slvbuf_wr_en else slvbuf_write;
    end if;
  end process;


  processing_6 : process (bus_clk, rst_l)
  begin
    if (rst_l = 0) then
      wrbuf_addr <= 0;
    elsif (rising_edge(bus_clk)) then
      wrbuf_addr <= axi4_aw_addr
      when wrbuf_en else wrbuf_addr;
    end if;
  end process;


  processing_7 : process (buf_clk, bus_clk)
  begin
    if (rst_l = 0) then
      wrbuf_data <= 0;
    elsif (rising_edge(buf_clk)) then
      wrbuf_data <= axi4_w_data
      when wrbuf_data_en else wrbuf_data;
    end if;
  end process;


  processing_8 : process (buf_clk, rst_l)
  begin
    if (rst_l = 0) then
      slvbuf_write <= 0;
    elsif (rising_edge(buf_clk)) then
      slvbuf_write <= buf_write
      when slvbuf_wr_en else slvbuf_write;
    end if;
  end process;


  processing_9 : process (buf_clk, rst_l)
  begin
    if (rst_l = 0) then
      slvbuf_write <= 0;
    elsif (rising_edge(buf_clk)) then
      slvbuf_write <= buf_write
      when slvbuf_wr_en else slvbuf_write;
    end if;
  end process;


  processing_10 : process (ahbm_clk, rst_l)
  begin
    if (rst_l = 0) then
      buf_state <= IDLE;
    elsif (rising_edge(ahbm_clk)) then
      buf_state <= (not buf_rst & not buf_rst & not buf_rst) and (buf_nxtstate
      when buf_state_en else buf_state);
    end if;
  end process;


  processing_11 : process (buf_clk, rst_l)
  begin
    if (rst_l = 0) then
      slvbuf_write <= 0;
    elsif (rising_edge(buf_clk)) then
      slvbuf_write <= buf_write
      when slvbuf_wr_en else slvbuf_write;
    end if;
  end process;


  processing_12 : process (buf_clk, rst_l)
  begin
    if (rst_l = 0) then
      slvbuf_write <= 0;
    elsif (rising_edge(buf_clk)) then
      slvbuf_write <= buf_write
      when slvbuf_wr_en else slvbuf_write;
    end if;
  end process;


  processing_13 : process (buf_clk, rst_l)
  begin
    if (rst_l = 0) then
      buf_addr <= 0;
    elsif (rising_edge(buf_clk)) then
      buf_addr <= buf_addr_in
      when (buf_wr_en and bus_clk_en) else buf_addr;
    end if;
  end process;


  processing_14 : process (buf_clk, rst_l)
  begin
    if (rst_l = 0) then
      slvbuf_write <= 0;
    elsif (rising_edge(buf_clk)) then
      slvbuf_write <= buf_write
      when slvbuf_wr_en else slvbuf_write;
    end if;
  end process;


  processing_15 : process (buf_clk, rst_l)
  begin
    if (rst_l = 0) then
      slvbuf_write <= 0;
    elsif (rising_edge(buf_clk)) then
      slvbuf_write <= buf_write
      when slvbuf_wr_en else slvbuf_write;
    end if;
  end process;


  processing_16 : process (buf_clk, rst_l)
  begin
    if (rst_l = 0) then
      slvbuf_write <= 0;
    elsif (rising_edge(buf_clk)) then
      slvbuf_write <= buf_write
      when slvbuf_wr_en else slvbuf_write;
    end if;
  end process;


  processing_17 : process (buf_clk, rst_l)
  begin
    if (rst_l = 0) then
      buf_data <= 0;
    elsif (rising_edge(buf_clk)) then
      buf_data <= buf_data_in
      when (buf_data_wr_en and bus_clk_en) else buf_data;
    end if;
  end process;


  processing_18 : process (buf_clk, rst_l)
  begin
    if (rst_l = 0) then
      slvbuf_write <= 0;
    elsif (rising_edge(buf_clk)) then
      slvbuf_write <= buf_write
      when slvbuf_wr_en else slvbuf_write;
    end if;
  end process;


  processing_19 : process (buf_clk, rst_l)
  begin
    if (rst_l = 0) then
      slvbuf_tag <= 0;
    elsif (rising_edge(buf_clk)) then
      slvbuf_tag <= buf_tag
      when slvbuf_wr_en else slvbuf_tag;
    end if;
  end process;


  processing_20 : process (ahbm_clk, rst_l)
  begin
    if (rst_l = 0) then
      slvbuf_error <= 0;
    elsif (rising_edge(ahbm_clk)) then
      slvbuf_error <= slvbuf_error_in
      when slvbuf_error_en else slvbuf_error;
    end if;
  end process;


  processing_21 : process (ahbm_clk, rst_l)
  begin
    if (rst_l = 0) then
      cmd_doneQ <= 0;
    elsif (rising_edge(ahbm_clk)) then
      cmd_doneQ <= not cmd_done_rst and ('1'
      when cmd_done else cmd_doneQ);
    end if;
  end process;


  processing_22 : process (ahbm_clk, rst_l)
  begin
    if (rst_l = 0) then
      ahb3_hready_q <= 0;
    elsif (rising_edge(ahbm_clk)) then
      ahb3_hready_q <= ahb3_hreadyout;
    end if;
  end process;


  processing_23 : process (ahbm_clk, rst_l)
  begin
    if (rst_l = 0) then
      ahb3_htrans_q <= 0;
    elsif (rising_edge(ahbm_clk)) then
      ahb3_htrans_q <= ahb3_htrans;
    end if;
  end process;


  processing_24 : process (ahbm_addr_clk, rst_l)
  begin
    if (rst_l = 0) then
      ahb3_hwrite_q <= 0;
    elsif (rising_edge(ahbm_addr_clk)) then
      ahb3_hwrite_q <= ahb3_hwrite;
    end if;
  end process;


  processing_25 : process (ahbm_clk, rst_l)
  begin
    if (rst_l = 0) then
      ahb3_hresp_q <= 0;
    elsif (rising_edge(ahbm_clk)) then
      ahb3_hresp_q <= ahb3_hresp;
    end if;
  end process;


  processing_26 : process (ahbm_data_clk, rst_l)
  begin
    if (rst_l = 0) then
      ahb3_hrdata_q <= 0;
    elsif (rising_edge(ahbm_data_clk)) then
      ahb3_hrdata_q <= ahb3_hrdata;
    end if;
  end process;


  -- Clock headers
  -- clock enables for ahbm addr/data
  buf_clken <= bus_clk_en and (buf_wr_en or slvbuf_wr_en or clk_override);
  ahbm_addr_clken <= bus_clk_en and ((ahb3_hreadyout and ahb3_htrans(1)) or clk_override);
  ahbm_data_clken <= bus_clk_en and ((buf_state /= IDLE) or clk_override);

  processing_27 : process (clk)
  begin
    if (falling_edge(clk)) then
      bus_clk <= clk and (buf_clken or scan_mode);
      ahbm_clk <= clk and (bus_clk_en or scan_mode);
      ahbm_addr_clk <= clk and (ahbm_addr_clken or scan_mode);
      ahbm_data_clk <= clk and (ahbm_data_clken or scan_mode);
    end if;
  end process;
end RTL;
