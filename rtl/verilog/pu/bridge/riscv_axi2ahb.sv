////////////////////////////////////////////////////////////////////////////////
//                                            __ _      _     _               //
//                                           / _(_)    | |   | |              //
//                __ _ _   _  ___  ___ _ __ | |_ _  ___| | __| |              //
//               / _` | | | |/ _ \/ _ \ '_ \|  _| |/ _ \ |/ _` |              //
//              | (_| | |_| |  __/  __/ | | | | | |  __/ | (_| |              //
//               \__, |\__,_|\___|\___|_| |_|_| |_|\___|_|\__,_|              //
//                  | |                                                       //
//                  |_|                                                       //
//                                                                            //
//                                                                            //
//              MPSoC-RISCV CPU                                               //
//              AMBA3 AHB-Lite Bus Interface                                  //
//              AMBA4 AXI-Lite Bus Interface                                  //
//                                                                            //
////////////////////////////////////////////////////////////////////////////////

/* Copyright (c) 2017-2018 by the author(s)
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 *
 * =============================================================================
 * Author(s):
 *   Francisco Javier Reina Campo <pacoreinacampo@queenfield.tech>
 */

module riscv_axi2ahb #(
  parameter AXI_ID_WIDTH   = 10,
  parameter AXI_ADDR_WIDTH = 64,
  parameter AXI_DATA_WIDTH = 64,
  parameter AXI_STRB_WIDTH = 10,
  parameter AXI_USER_WIDTH = 10,

  parameter AHB_ADDR_WIDTH = 64,
  parameter AHB_DATA_WIDTH = 64
) (
  input clk,
  input rst_l,

  input scan_mode,
  input bus_clk_en,
  input clk_override,

  // AXI4 instruction
  input  wire [AXI_ID_WIDTH  -1:0] axi4_aw_id,
  input  wire [AXI_ADDR_WIDTH-1:0] axi4_aw_addr,
  input  wire [               7:0] axi4_aw_len,
  input  wire [               2:0] axi4_aw_size,
  input  wire [               1:0] axi4_aw_burst,
  input  wire                      axi4_aw_lock,
  input  wire [               3:0] axi4_aw_cache,
  input  wire [               2:0] axi4_aw_prot,
  input  wire [               3:0] axi4_aw_qos,
  input  wire [               3:0] axi4_aw_region,
  input  wire [AXI_USER_WIDTH-1:0] axi4_aw_user,
  input  wire                      axi4_aw_valid,
  output reg                       axi4_aw_ready,

  input  wire [AXI_ID_WIDTH  -1:0] axi4_ar_id,
  input  wire [AXI_ADDR_WIDTH-1:0] axi4_ar_addr,
  input  wire [               7:0] axi4_ar_len,
  input  wire [               2:0] axi4_ar_size,
  input  wire [               1:0] axi4_ar_burst,
  input  wire                      axi4_ar_lock,
  input  wire [               3:0] axi4_ar_cache,
  input  wire [               2:0] axi4_ar_prot,
  input  wire [               3:0] axi4_ar_qos,
  input  wire [               3:0] axi4_ar_region,
  input  wire [AXI_USER_WIDTH-1:0] axi4_ar_user,
  input  wire                      axi4_ar_valid,
  output reg                       axi4_ar_ready,

  input  wire [AXI_DATA_WIDTH-1:0] axi4_w_data,
  input  wire [AXI_STRB_WIDTH-1:0] axi4_w_strb,
  input  wire                      axi4_w_last,
  input  wire [AXI_USER_WIDTH-1:0] axi4_w_user,
  input  wire                      axi4_w_valid,
  output reg                       axi4_w_ready,

  output reg  [AXI_ID_WIDTH  -1:0] axi4_r_id,
  output reg  [AXI_DATA_WIDTH-1:0] axi4_r_data,
  output reg  [               1:0] axi4_r_resp,
  output reg                       axi4_r_last,
  output reg  [AXI_USER_WIDTH-1:0] axi4_r_user,
  output reg                       axi4_r_valid,
  input  wire                      axi4_r_ready,

  output reg  [AXI_ID_WIDTH  -1:0] axi4_b_id,
  output reg  [               1:0] axi4_b_resp,
  output reg  [AXI_USER_WIDTH-1:0] axi4_b_user,
  output reg                       axi4_b_valid,
  input  wire                      axi4_b_ready,

  // AHB3 signals
  output reg                       ahb3_hsel,
  output reg  [AHB_ADDR_WIDTH-1:0] ahb3_haddr,
  output reg  [AHB_DATA_WIDTH-1:0] ahb3_hwdata,
  input  wire [AHB_DATA_WIDTH-1:0] ahb3_hrdata,
  output reg                       ahb3_hwrite,
  output reg  [               2:0] ahb3_hsize,
  output reg  [               2:0] ahb3_hburst,
  output reg  [               3:0] ahb3_hprot,
  output reg  [               1:0] ahb3_htrans,
  output reg                       ahb3_hmastlock,
  output reg                       ahb3_hreadyin,
  input  wire                      ahb3_hreadyout,
  input  wire                      ahb3_hresp
);

  //////////////////////////////////////////////////////////////////////////////
  //
  // Constants
  //

  localparam ID = 1;
  localparam PRTY = 1;

  //////////////////////////////////////////////////////////////////////////////
  //
  // Types
  //

  typedef enum logic [2:0] {
    IDLE          = 3'b000,
    CMD_RD        = 3'b001,
    CMD_WR        = 3'b010,
    DATA_RD       = 3'b011,
    DATA_WR       = 3'b100,
    DONE          = 3'b101,
    STREAM_RD     = 3'b110,
    STREAM_ERR_RD = 3'b111
  } state_t;

  //////////////////////////////////////////////////////////////////////////////
  //
  // Variables
  //

  logic [               2:0] buf_state;
  logic [               2:0] buf_nxtstate;

  logic                      slave_valid;
  logic                      slave_ready;
  logic [AXI_ID_WIDTH  -1:0] slave_tag;
  logic [AXI_DATA_WIDTH-1:0] slave_rdata;
  logic [               3:0] slave_opc;

  logic                      wrbuf_en;
  logic                      wrbuf_data_en;
  logic                      wrbuf_cmd_sent;
  logic                      wrbuf_rst;
  logic                      wrbuf_vld;
  logic                      wrbuf_data_vld;
  logic [AXI_ID_WIDTH  -1:0] wrbuf_tag;
  logic [               2:0] wrbuf_size;
  logic [AXI_ADDR_WIDTH-1:0] wrbuf_addr;
  logic [AXI_DATA_WIDTH-1:0] wrbuf_data;
  logic [               7:0] wrbuf_byteen;

  logic                      bus_write_clk_en;
  logic                      bus_clk;
  logic                      bus_write_clk;

  logic                      master_valid;
  logic                      master_ready;
  logic [AXI_ID_WIDTH  -1:0] master_tag;
  logic [AXI_ADDR_WIDTH-1:0] master_addr;
  logic [AXI_DATA_WIDTH-1:0] master_wdata;
  logic [               2:0] master_size;
  logic [               2:0] master_opc;

  // Buffer signals (one entry buffer)
  logic [AXI_ADDR_WIDTH-1:0] buf_addr;
  logic [               1:0] buf_size;
  logic                      buf_write;
  logic [               7:0] buf_byteen;
  logic                      buf_aligned;
  logic [AXI_DATA_WIDTH-1:0] buf_data;
  logic [AXI_ID_WIDTH  -1:0] buf_tag;

  // Miscellaneous signals
  logic                      buf_rst;
  logic [AXI_ID_WIDTH  -1:0] buf_tag_in;
  logic [AXI_ADDR_WIDTH-1:0] buf_addr_in;
  logic [               7:0] buf_byteen_in;
  logic [AXI_DATA_WIDTH-1:0] buf_data_in;
  logic                      buf_write_in;
  logic                      buf_aligned_in;
  logic [               2:0] buf_size_in;

  logic                      buf_state_en;
  logic                      buf_wr_en;
  logic                      buf_data_wr_en;
  logic                      slvbuf_error_en;
  logic                      wr_cmd_vld;

  logic                      cmd_done_rst;
  logic                      cmd_done;
  logic                      cmd_doneQ;
  logic                      trxn_done;
  logic [               2:0] buf_cmd_byte_ptr;
  logic [               2:0] buf_cmd_byte_ptrQ;
  logic [               2:0] buf_cmd_nxtbyte_ptr;
  logic                      buf_cmd_byte_ptr_en;
  logic                      found;

  logic                      slave_valid_pre;
  logic                      ahb3_hready_q;
  logic                      ahb3_hresp_q;
  logic [               1:0] ahb3_htrans_q;
  logic                      ahb3_hwrite_q;
  logic [AXI_DATA_WIDTH-1:0] ahb3_hrdata_q;


  logic                      slvbuf_write;
  logic                      slvbuf_error;
  logic [AXI_ID_WIDTH  -1:0] slvbuf_tag;

  logic                      slvbuf_error_in;
  logic                      slvbuf_wr_en;
  logic                      bypass_en;
  logic                      rd_bypass_idle;

  logic                      last_addr_en;
  logic [AXI_ADDR_WIDTH-1:0] last_bus_addr;

  // Clocks
  logic                      buf_clken;
  logic                      slvbuf_clken;
  logic                      ahbm_addr_clken;
  logic                      ahbm_data_clken;

  logic                      buf_clk;
  logic                      slvbuf_clk;
  logic                      ahbm_clk;
  logic                      ahbm_addr_clk;
  logic                      ahbm_data_clk;

  //////////////////////////////////////////////////////////////////////////////
  //
  // Functions
  //

  // Function to get the length from byte enable
  function automatic logic [1:0] get_write_size;
    input logic [7:0] byteen;

    logic [1:0] size;

    size[1:0] = (2'b11 & {2{(byteen[7:0] == 8'hff)}}) | (2'b10 & {2{((byteen[7:0] == 8'hf0) | (byteen[7:0] == 8'h0f))}}) | (2'b01 & {2{((byteen[7:0] == 8'hc0) | (byteen[7:0] == 8'h30) | (byteen[7:0] == 8'h0c) | (byteen[7:0] == 8'h03))}});

    return size[1:0];
  endfunction

  // Function to get the length from byte enable
  function automatic logic [2:0] get_write_addr;
    input logic [7:0] byteen;

    logic [2:0] addr;

    addr[2:0] = (3'h0 & {3{((byteen[7:0] == 8'hff) | (byteen[7:0] == 8'h0f) | (byteen[7:0] == 8'h03))}}) | (3'h2 & {3{(byteen[7:0] == 8'h0c)}}) | (3'h4 & {3{((byteen[7:0] == 8'hf0) | (byteen[7:0] == 8'h03))}}) | (3'h6 & {3{(byteen[7:0] == 8'hc0)}});

    return addr;
  endfunction

  // Function to get the next byte pointer
  function automatic logic [2:0] get_nxtbyte_ptr(logic [2:0] current_byte_ptr, logic [7:0] byteen, logic get_next);
    logic [2:0] start_ptr;
    logic       found;
    found          = '0;

    start_ptr[2:0] = get_next ? (current_byte_ptr[2:0] + 3'b1) : current_byte_ptr[2:0];
    for (int j = 0; j < 8; j++) begin
      if (~found) begin
        get_nxtbyte_ptr[2:0] = 3'(j);
        found |= (byteen[j] & (3'(j) >= start_ptr[2:0]));
      end
    end
  endfunction

  //////////////////////////////////////////////////////////////////////////////
  //
  // Module Body
  //

  // Write buffer
  assign wrbuf_en         = axi4_aw_valid & axi4_aw_ready & master_ready;
  assign wrbuf_data_en    = axi4_w_valid & axi4_w_ready & master_ready;
  assign wrbuf_cmd_sent   = master_valid & master_ready & (master_opc[2:1] == 2'b01);
  assign wrbuf_rst        = wrbuf_cmd_sent & ~wrbuf_en;

  assign axi4_aw_ready    = ~(wrbuf_vld & ~wrbuf_cmd_sent) & master_ready;
  assign axi4_w_ready     = ~(wrbuf_data_vld & ~wrbuf_cmd_sent) & master_ready;
  assign axi4_ar_ready    = ~(wrbuf_vld & wrbuf_data_vld) & master_ready;
  assign axi4_r_last      = 1'b1;

  assign wr_cmd_vld       = (wrbuf_vld & wrbuf_data_vld);
  assign master_valid     = wr_cmd_vld | axi4_ar_valid;
  assign master_tag       = wr_cmd_vld ? wrbuf_tag : axi4_ar_id;
  assign master_opc       = wr_cmd_vld ? 3'b011 : 3'b000;
  assign master_addr      = wr_cmd_vld ? wrbuf_addr : axi4_ar_addr;
  assign master_size      = wr_cmd_vld ? wrbuf_size[2:0] : axi4_ar_size;
  assign master_wdata     = wrbuf_data;

  // AXI response channel signals
  assign axi4_b_valid     = slave_valid & slave_ready & slave_opc[3];
  assign axi4_b_resp      = slave_opc[0] ? 2'b10 : (slave_opc[1] ? 2'b11 : 2'b0);
  assign axi4_b_id        = slave_tag;

  assign axi4_r_valid     = slave_valid & slave_ready & (slave_opc[3:2] == 2'b0);
  assign axi4_r_resp      = slave_opc[0] ? 2'b10 : (slave_opc[1] ? 2'b11 : 2'b0);
  assign axi4_r_id        = slave_tag;
  assign axi4_r_data      = slave_rdata;
  assign slave_ready      = axi4_b_ready & axi4_r_ready;

  // Clock header logic
  assign bus_write_clk_en = bus_clk_en & ((axi4_aw_valid & axi4_aw_ready) | (axi4_w_valid & axi4_w_ready));

  always @(negedge clk) begin
    bus_clk       = clk & (bus_clk_en | scan_mode);
    bus_write_clk = clk & (bus_write_clk_en | scan_mode);
  end

  // FIFO state machine
  always_comb begin
    buf_nxtstate        = IDLE;
    buf_state_en        = 1'b0;
    buf_wr_en           = 1'b0;
    buf_data_wr_en      = 1'b0;
    slvbuf_error_in     = 1'b0;
    slvbuf_error_en     = 1'b0;
    buf_write_in        = 1'b0;
    cmd_done            = 1'b0;
    trxn_done           = 1'b0;
    buf_cmd_byte_ptr_en = 1'b0;
    buf_cmd_byte_ptr    = 3'b000;
    slave_valid_pre     = 1'b0;
    master_ready        = 1'b0;
    ahb3_htrans         = 2'b0;
    slvbuf_wr_en        = 1'b0;
    bypass_en           = 1'b0;
    rd_bypass_idle      = 1'b0;

    case (buf_state)
      IDLE: begin
        master_ready        = 1'b1;
        buf_write_in        = (master_opc[2:1] == 2'b01);
        buf_nxtstate        = buf_write_in ? CMD_WR : CMD_RD;
        buf_state_en        = master_valid & master_ready;
        buf_wr_en           = buf_state_en;
        buf_data_wr_en      = buf_state_en & (buf_nxtstate == CMD_WR);
        buf_cmd_byte_ptr_en = buf_state_en;
        buf_cmd_byte_ptr    = buf_write_in ? get_nxtbyte_ptr(3'b0, buf_byteen_in, 1'b0) : master_addr[2:0];
        bypass_en           = buf_state_en;
        rd_bypass_idle      = bypass_en & (buf_nxtstate == CMD_RD);
        ahb3_htrans         = {2{bypass_en}} & 2'b10;
      end
      CMD_RD: begin
        buf_nxtstate     = (master_valid & (master_opc == 3'b000)) ? STREAM_RD : DATA_RD;
        buf_state_en     = ahb3_hready_q & (ahb3_htrans_q[1:0] != 2'b0) & ~ahb3_hwrite_q;
        cmd_done         = buf_state_en & ~master_valid;
        slvbuf_wr_en     = buf_state_en;
        master_ready     = buf_state_en & (buf_nxtstate == STREAM_RD);
        buf_wr_en        = master_ready;
        bypass_en        = master_ready & master_valid;
        buf_cmd_byte_ptr = bypass_en ? master_addr[2:0] : buf_addr[2:0];
        ahb3_htrans      = 2'b10 & {2{~buf_state_en | bypass_en}};
      end
      STREAM_RD: begin
        master_ready     = (ahb3_hready_q & ~ahb3_hresp_q) & ~(master_valid & master_opc[2:1] == 2'b01);

        // update the fifo if we are streaming the read commands
        buf_wr_en        = (master_valid & master_ready & (master_opc == 3'b000));

        // assuming that the master accpets the slave response right away.
        buf_nxtstate     = ahb3_hresp_q ? STREAM_ERR_RD : (buf_wr_en ? STREAM_RD : DATA_RD);
        buf_state_en     = (ahb3_hready_q | ahb3_hresp_q);
        buf_data_wr_en   = buf_state_en;
        slvbuf_error_in  = ahb3_hresp_q;
        slvbuf_error_en  = buf_state_en;
        slave_valid_pre  = buf_state_en & ~ahb3_hresp_q;  // send a response right away if we are not going through an error response.
        cmd_done         = buf_state_en & ~master_valid;  // last one of the stream should not send a htrans
        bypass_en        = master_ready & master_valid & (buf_nxtstate == STREAM_RD) & buf_state_en;
        buf_cmd_byte_ptr = bypass_en ? master_addr[2:0] : buf_addr[2:0];
        ahb3_htrans      = 2'b10 & {2{~((buf_nxtstate != STREAM_RD) & buf_state_en)}};
        slvbuf_wr_en     = buf_wr_en;  // shifting the contents from the buf to slv_buf for streaming cases
      end  // case: STREAM_RD
      STREAM_ERR_RD: begin
        buf_nxtstate     = DATA_RD;
        buf_state_en     = ahb3_hready_q & (ahb3_htrans_q[1:0] != 2'b0) & ~ahb3_hwrite_q;
        slave_valid_pre  = buf_state_en;
        slvbuf_wr_en     = buf_state_en;  // Overwrite slvbuf with buffer
        buf_cmd_byte_ptr = buf_addr[2:0];
        ahb3_htrans      = 2'b10 & {2{~buf_state_en}};
      end
      DATA_RD: begin
        buf_nxtstate    = DONE;
        buf_state_en    = (ahb3_hready_q | ahb3_hresp_q);
        buf_data_wr_en  = buf_state_en;
        slvbuf_error_in = ahb3_hresp_q;
        slvbuf_error_en = buf_state_en;
        slvbuf_wr_en    = buf_state_en;
      end
      CMD_WR: begin
        buf_nxtstate        = DATA_WR;
        trxn_done           = ahb3_hready_q & ahb3_hwrite_q & (ahb3_htrans_q[1:0] != 2'b0);
        buf_state_en        = trxn_done;
        buf_cmd_byte_ptr_en = buf_state_en;
        slvbuf_wr_en        = buf_state_en;
        buf_cmd_byte_ptr    = trxn_done ? get_nxtbyte_ptr(buf_cmd_byte_ptrQ[2:0], buf_byteen[7:0], 1'b1) : buf_cmd_byte_ptrQ;
        cmd_done            = trxn_done & (buf_aligned | (buf_cmd_byte_ptrQ == 3'b111) | (buf_byteen[get_nxtbyte_ptr(buf_cmd_byte_ptrQ[2:0], buf_byteen[7:0], 1'b1)] == 1'b0));
        ahb3_htrans         = {2{~(cmd_done | cmd_doneQ)}} & 2'b10;
      end
      DATA_WR: begin
        buf_state_en        = (cmd_doneQ & ahb3_hready_q) | ahb3_hresp_q;
        master_ready        = buf_state_en & ~ahb3_hresp_q & slave_ready;  // Ready to accept new command if current command done and no error
        buf_nxtstate        = (ahb3_hresp_q | ~slave_ready) ? DONE : ((master_valid & master_ready) ? ((master_opc[2:1] == 2'b01) ? CMD_WR : CMD_RD) : IDLE);
        slvbuf_error_in     = ahb3_hresp_q;
        slvbuf_error_en     = buf_state_en;

        buf_write_in        = (master_opc[2:1] == 2'b01);
        buf_wr_en           = buf_state_en & ((buf_nxtstate == CMD_WR) | (buf_nxtstate == CMD_RD));
        buf_data_wr_en      = buf_wr_en;

        cmd_done            = (ahb3_hresp_q | (ahb3_hready_q & (ahb3_htrans_q[1:0] != 2'b0) & ((buf_cmd_byte_ptrQ == 3'b111) | (buf_byteen[get_nxtbyte_ptr(buf_cmd_byte_ptrQ[2:0], buf_byteen[7:0], 1'b1)] == 1'b0))));
        bypass_en           = buf_state_en & buf_write_in & (buf_nxtstate == CMD_WR);  // Only bypass for writes for the time being
        ahb3_htrans         = {2{(~(cmd_done | cmd_doneQ) | bypass_en)}} & 2'b10;
        slave_valid_pre     = buf_state_en & (buf_nxtstate != DONE);

        trxn_done           = ahb3_hready_q & ahb3_hwrite_q & (ahb3_htrans_q[1:0] != 2'b0);
        buf_cmd_byte_ptr_en = trxn_done | bypass_en;
        buf_cmd_byte_ptr    = bypass_en ? get_nxtbyte_ptr(3'b0, buf_byteen_in, 1'b0) : trxn_done ? get_nxtbyte_ptr(buf_cmd_byte_ptrQ[2:0], buf_byteen[7:0], 1'b1) : buf_cmd_byte_ptrQ;
      end
      DONE: begin
        buf_nxtstate    = IDLE;
        buf_state_en    = slave_ready;
        slvbuf_error_en = 1'b1;
        slave_valid_pre = 1'b1;
      end
    endcase
  end

  assign buf_rst = 1'b0;
  assign cmd_done_rst = slave_valid_pre;
  assign buf_addr_in[2:0] = (buf_aligned_in & (master_opc[2:1] == 2'b01)) ? get_write_addr(wrbuf_byteen[7:0]) : master_addr[2:0];
  assign buf_addr_in[31:3] = master_addr[31:3];
  assign buf_tag_in = master_tag;
  assign buf_byteen_in = wrbuf_byteen[7:0];
  assign buf_data_in = (buf_state == DATA_RD) ? ahb3_hrdata_q : master_wdata;
  assign buf_size_in[1:0] = (buf_aligned_in & (master_size[1:0] == 2'b11) & (master_opc[2:1] == 2'b01)) ? get_write_size(wrbuf_byteen[7:0]) : master_size[1:0];
  assign buf_aligned_in = (master_opc == 3'b000) |  // reads are always aligned since they are either DW or sideeffects
    (master_size[1:0] == 2'b0) | (master_size[1:0] == 2'b01) | (master_size[1:0] == 2'b10) |
    // Always aligned for Byte/HW/Word since they can be only for non-idempotent. IFU/SB are always aligned
    ((master_size[1:0] == 2'b11) & ((wrbuf_byteen[7:0] == 8'h3) | (wrbuf_byteen[7:0] == 8'hc) | (wrbuf_byteen[7:0] == 8'h30) | (wrbuf_byteen[7:0] == 8'hc0) | (wrbuf_byteen[7:0] == 8'hf) | (wrbuf_byteen[7:0] == 8'hf0) | (wrbuf_byteen[7:0] == 8'hff)));

  // Generate the ahb signals
  assign ahb3_haddr = bypass_en ? {master_addr[31:3], buf_cmd_byte_ptr} : {buf_addr[31:3], buf_cmd_byte_ptr};
  assign ahb3_hsize = bypass_en ? {1'b0, ({2{buf_aligned_in}} & buf_size_in[1:0])} : {1'b0, ({2{buf_aligned}} & buf_size[1:0])};  // Send the full size for aligned trxn
  assign ahb3_hburst = 3'b000;
  assign ahb3_hmastlock = 1'b0;
  assign ahb3_hprot = {3'b001, ~axi4_ar_prot[2]};
  assign ahb3_hwrite = bypass_en ? (master_opc[2:1] == 2'b01) : buf_write;
  assign ahb3_hwdata = buf_data;

  assign slave_valid = slave_valid_pre;
  assign slave_opc[3:2] = slvbuf_write ? 2'b11 : 2'b00;
  assign slave_opc[1:0] = {2{slvbuf_error}} & 2'b10;
  assign slave_rdata = slvbuf_error ? {2{last_bus_addr}} : ((buf_state == DONE) ? buf_data : ahb3_hrdata_q);
  assign slave_tag = slvbuf_tag;

  assign last_addr_en = (ahb3_htrans != 2'b0) & ahb3_hreadyout & ahb3_hwrite;

  always_ff @(posedge bus_clk or negedge rst_l) begin
    if (rst_l == 0) begin
      wrbuf_vld <= 0;
    end else begin
      wrbuf_vld <= ~wrbuf_rst & (wrbuf_en ? 1'b1 : wrbuf_vld);
    end
  end

  always_ff @(posedge bus_clk or negedge rst_l) begin
    if (rst_l == 0) begin
      wrbuf_data_vld <= 0;
    end else begin
      wrbuf_data_vld <= ~wrbuf_rst & (wrbuf_data_en ? 1'b1 : wrbuf_data_vld);
    end
  end

  always_ff @(posedge buf_clk or negedge rst_l) begin
    if (rst_l == 0) begin
      slvbuf_write <= 0;
    end else begin
      slvbuf_write <= slvbuf_wr_en ? buf_write : slvbuf_write;
    end
  end

  always_ff @(posedge buf_clk or negedge rst_l) begin
    if (rst_l == 0) begin
      slvbuf_write <= 0;
    end else begin
      slvbuf_write <= slvbuf_wr_en ? buf_write : slvbuf_write;
    end
  end

  always_ff @(posedge bus_clk or negedge rst_l) begin
    if (rst_l == 0) begin
      wrbuf_addr <= 0;
    end else begin
      wrbuf_addr <= wrbuf_en ? axi4_aw_addr : wrbuf_addr;
    end
  end

  always_ff @(posedge buf_clk or negedge bus_clk) begin
    if (rst_l == 0) begin
      wrbuf_data <= 0;
    end else begin
      wrbuf_data <= wrbuf_data_en ? axi4_w_data : wrbuf_data;
    end
  end

  always_ff @(posedge buf_clk or negedge rst_l) begin
    if (rst_l == 0) begin
      slvbuf_write <= 0;
    end else begin
      slvbuf_write <= slvbuf_wr_en ? buf_write : slvbuf_write;
    end
  end

  always_ff @(posedge buf_clk or negedge rst_l) begin
    if (rst_l == 0) begin
      slvbuf_write <= 0;
    end else begin
      slvbuf_write <= slvbuf_wr_en ? buf_write : slvbuf_write;
    end
  end

  always_ff @(posedge ahbm_clk or negedge rst_l) begin
    if (rst_l == 0) begin
      buf_state <= IDLE;
    end else begin
      buf_state <= {3{~buf_rst}} & (buf_state_en ? buf_nxtstate : buf_state);
    end
  end

  always_ff @(posedge buf_clk or negedge rst_l) begin
    if (rst_l == 0) begin
      slvbuf_write <= 0;
    end else begin
      slvbuf_write <= slvbuf_wr_en ? buf_write : slvbuf_write;
    end
  end

  always_ff @(posedge buf_clk or negedge rst_l) begin
    if (rst_l == 0) begin
      slvbuf_write <= 0;
    end else begin
      slvbuf_write <= slvbuf_wr_en ? buf_write : slvbuf_write;
    end
  end

  always_ff @(posedge buf_clk or negedge rst_l) begin
    if (rst_l == 0) begin
      buf_addr <= 0;
    end else begin
      buf_addr <= (buf_wr_en & bus_clk_en) ? buf_addr_in : buf_addr;
    end
  end

  always_ff @(posedge buf_clk or negedge rst_l) begin
    if (rst_l == 0) begin
      slvbuf_write <= 0;
    end else begin
      slvbuf_write <= slvbuf_wr_en ? buf_write : slvbuf_write;
    end
  end

  always_ff @(posedge buf_clk or negedge rst_l) begin
    if (rst_l == 0) begin
      slvbuf_write <= 0;
    end else begin
      slvbuf_write <= slvbuf_wr_en ? buf_write : slvbuf_write;
    end
  end

  always_ff @(posedge buf_clk or negedge rst_l) begin
    if (rst_l == 0) begin
      slvbuf_write <= 0;
    end else begin
      slvbuf_write <= slvbuf_wr_en ? buf_write : slvbuf_write;
    end
  end

  always_ff @(posedge buf_clk or negedge rst_l) begin
    if (rst_l == 0) begin
      buf_data <= 0;
    end else begin
      buf_data <= (buf_data_wr_en & bus_clk_en) ? buf_data_in : buf_data;
    end
  end

  always_ff @(posedge buf_clk or negedge rst_l) begin
    if (rst_l == 0) begin
      slvbuf_write <= 0;
    end else begin
      slvbuf_write <= slvbuf_wr_en ? buf_write : slvbuf_write;
    end
  end

  always_ff @(posedge buf_clk or negedge rst_l) begin
    if (rst_l == 0) begin
      slvbuf_tag <= 0;
    end else begin
      slvbuf_tag <= slvbuf_wr_en ? buf_tag : slvbuf_tag;
    end
  end

  always_ff @(posedge ahbm_clk or negedge rst_l) begin
    if (rst_l == 0) begin
      slvbuf_error <= 0;
    end else begin
      slvbuf_error <= slvbuf_error_en ? slvbuf_error_in : slvbuf_error;
    end
  end

  always_ff @(posedge ahbm_clk or negedge rst_l) begin
    if (rst_l == 0) begin
      cmd_doneQ <= 0;
    end else begin
      cmd_doneQ <= ~cmd_done_rst & (cmd_done ? 1'b1 : cmd_doneQ);
    end
  end

  always_ff @(posedge ahbm_clk or negedge rst_l) begin
    if (rst_l == 0) begin
      ahb3_hready_q <= 0;
    end else begin
      ahb3_hready_q <= ahb3_hreadyout;
    end
  end

  always_ff @(posedge ahbm_clk or negedge rst_l) begin
    if (rst_l == 0) begin
      ahb3_htrans_q <= 0;
    end else begin
      ahb3_htrans_q <= ahb3_htrans;
    end
  end

  always_ff @(posedge ahbm_addr_clk or negedge rst_l) begin
    if (rst_l == 0) begin
      ahb3_hwrite_q <= 0;
    end else begin
      ahb3_hwrite_q <= ahb3_hwrite;
    end
  end

  always_ff @(posedge ahbm_clk or negedge rst_l) begin
    if (rst_l == 0) begin
      ahb3_hresp_q <= 0;
    end else begin
      ahb3_hresp_q <= ahb3_hresp;
    end
  end

  always_ff @(posedge ahbm_data_clk or negedge rst_l) begin
    if (rst_l == 0) begin
      ahb3_hrdata_q <= 0;
    end else begin
      ahb3_hrdata_q <= ahb3_hrdata;
    end
  end

  // Clock headers
  // clock enables for ahbm addr/data
  assign buf_clken       = bus_clk_en & (buf_wr_en | slvbuf_wr_en | clk_override);
  assign ahbm_addr_clken = bus_clk_en & ((ahb3_hreadyout & ahb3_htrans[1]) | clk_override);
  assign ahbm_data_clken = bus_clk_en & ((buf_state != IDLE) | clk_override);

  always @(negedge clk) begin
    bus_clk       = clk & (buf_clken | scan_mode);
    ahbm_clk      = clk & (bus_clk_en | scan_mode);
    ahbm_addr_clk = clk & (ahbm_addr_clken | scan_mode);
    ahbm_data_clk = clk & (ahbm_data_clken | scan_mode);
  end
endmodule
