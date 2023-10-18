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

module riscv_ahb2axi #(
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

  // AXI4 instruction
  output reg  [AXI_ID_WIDTH  -1:0] axi4_aw_id,
  output reg  [AXI_ADDR_WIDTH-1:0] axi4_aw_addr,
  output reg  [               7:0] axi4_aw_len,
  output reg  [               2:0] axi4_aw_size,
  output reg  [               1:0] axi4_aw_burst,
  output reg                       axi4_aw_lock,
  output reg  [               3:0] axi4_aw_cache,
  output reg  [               2:0] axi4_aw_prot,
  output reg  [               3:0] axi4_aw_qos,
  output reg  [               3:0] axi4_aw_region,
  output reg  [AXI_USER_WIDTH-1:0] axi4_aw_user,
  output reg                       axi4_aw_valid,
  input  wire                      axi4_aw_ready,

  output reg  [AXI_ID_WIDTH  -1:0] axi4_ar_id,
  output reg  [AXI_ADDR_WIDTH-1:0] axi4_ar_addr,
  output reg  [               7:0] axi4_ar_len,
  output reg  [               2:0] axi4_ar_size,
  output reg  [               1:0] axi4_ar_burst,
  output reg                       axi4_ar_lock,
  output reg  [               3:0] axi4_ar_cache,
  output reg  [               2:0] axi4_ar_prot,
  output reg  [               3:0] axi4_ar_qos,
  output reg  [               3:0] axi4_ar_region,
  output reg  [AXI_USER_WIDTH-1:0] axi4_ar_user,
  output reg                       axi4_ar_valid,
  input  wire                      axi4_ar_ready,

  output reg  [AXI_DATA_WIDTH-1:0] axi4_w_data,
  output reg  [AXI_STRB_WIDTH-1:0] axi4_w_strb,
  output reg                       axi4_w_last,
  output reg  [AXI_USER_WIDTH-1:0] axi4_w_user,
  output reg                       axi4_w_valid,
  input  wire                      axi4_w_ready,

  input  wire [AXI_ID_WIDTH  -1:0] axi4_r_id,
  input  wire [AXI_DATA_WIDTH-1:0] axi4_r_data,
  input  wire [               1:0] axi4_r_resp,
  input  wire                      axi4_r_last,
  input  wire [AXI_USER_WIDTH-1:0] axi4_r_user,
  input  wire                      axi4_r_valid,
  output reg                       axi4_r_ready,

  input  wire [AXI_ID_WIDTH  -1:0] axi4_b_id,
  input  wire [               1:0] axi4_b_resp,
  input  wire [AXI_USER_WIDTH-1:0] axi4_b_user,
  input  wire                      axi4_b_valid,
  output reg                       axi4_b_ready,

  // AHB3 signals
  input  wire                      ahb3_hsel,
  input  wire [AHB_ADDR_WIDTH-1:0] ahb3_haddr,
  input  wire [AHB_DATA_WIDTH-1:0] ahb3_hwdata,
  output reg  [AHB_DATA_WIDTH-1:0] ahb3_hrdata,
  input  wire                      ahb3_hwrite,
  input  wire [               2:0] ahb3_hsize,
  input  wire [               2:0] ahb3_hburst,
  input  wire [               3:0] ahb3_hprot,
  input  wire [               1:0] ahb3_htrans,
  input  wire                      ahb3_hmastlock,
  input  wire                      ahb3_hreadyin,
  output reg                       ahb3_hreadyout,
  output reg                       ahb3_hresp
);

  //////////////////////////////////////////////////////////////////////////////
  //
  // Constants
  //

  localparam [AHB_ADDR_WIDTH-1:0] RV_PIC_BASE_ADDR = 64'h00000000f00c0000;
  localparam [AHB_ADDR_WIDTH-1:0] RV_ICCM_SADR = 64'h00000000ee000000;
  localparam [AHB_ADDR_WIDTH-1:0] RV_DCCM_SADR = 64'h00000000f0040000;

  localparam RV_ICCM_SIZE = 1024;
  localparam RV_DCCM_SIZE = 64;

  localparam RV_PIC_SIZE = 64;

  localparam RV_ICCM_ENABLE = 1'b1;

  localparam REGION_BITS = 4;
  localparam MASK_BITS = 10 + $clog2(RV_PIC_SIZE);

  //////////////////////////////////////////////////////////////////////////////
  //
  // Types
  //

  typedef enum logic [1:0] {
    IDLE = 2'b00,  // Nothing in the buffer. No commands yet recieved
    WR   = 2'b01,  // Write Command recieved
    RD   = 2'b10,  // Read Command recieved
    PEND = 2'b11   // Waiting on Read Data from core
  } state_t;

  //////////////////////////////////////////////////////////////////////////////
  //
  // Variables
  //

  logic   [               7:0] master_wstrb;

  state_t                      buf_state;
  state_t                      buf_nxtstate;
  logic                        buf_state_en;

  // Buffer signals (one entry buffer)
  logic                        buf_read_error_in;
  logic                        buf_read_error;
  logic   [AHB_DATA_WIDTH-1:0] buf_rdata;

  logic                        ahb3_hready;
  logic                        ahb3_hready_q;
  logic   [               1:0] ahb3_htrans_in;
  logic   [               1:0] ahb3_htrans_q;
  logic   [               2:0] ahb3_hsize_q;
  logic                        ahb3_hwrite_q;
  logic   [AHB_ADDR_WIDTH-1:0] ahb3_haddr_q;
  logic   [AHB_DATA_WIDTH-1:0] ahb3_hwdata_q;
  logic                        ahb3_hresp_q;

  // Miscellaneous signals
  logic                        ahb3_addr_in_dccm;
  logic                        ahb3_addr_in_iccm;
  logic                        ahb3_addr_in_pic;
  logic                        ahb3_addr_in_dccm_region_nc;
  logic                        ahb3_addr_in_iccm_region_nc;
  logic                        ahb3_addr_in_pic_region_nc;

  // signals needed for the read data coming back from the core and to block any further commands as AHB is a blocking bus
  logic                        buf_rdata_en;

  logic                        ahb3_bus_addr_clk_en;
  logic                        buf_rdata_clk_en;
  logic                        ahb3_clk;
  logic                        ahb3_addr_clk;
  logic                        buf_rdata_clk;

  // Command buffer is the holding station where we convert to AXI and send to core
  logic                        cmdbuf_wr_en;
  logic                        cmdbuf_rst;
  logic                        cmdbuf_full;
  logic                        cmdbuf_vld;
  logic                        cmdbuf_write;
  logic   [               1:0] cmdbuf_size;
  logic   [AXI_STRB_WIDTH-1:0] cmdbuf_wstrb;
  logic   [AXI_ADDR_WIDTH-1:0] cmdbuf_addr;
  logic   [AXI_DATA_WIDTH-1:0] cmdbuf_wdata;

  logic                        bus_clk;

  //////////////////////////////////////////////////////////////////////////////
  //
  // Module Body
  //

  // FSM to control the bus states and when to block the hready and load the command buffer
  always_comb begin
    buf_nxtstate      = IDLE;
    buf_state_en      = 1'b0;
    buf_rdata_en      = 1'b0;  // signal to load the buffer when the core sends read data back
    buf_read_error_in = 1'b0;  // signal indicating that an error came back with the read from the core
    cmdbuf_wr_en      = 1'b0;  // all clear from the gasket to load the buffer with the command for reads, command/dat for writes
    case (buf_state)
      IDLE: begin  // No commands recieved
        buf_nxtstate = ahb3_hwrite ? WR : RD;
        buf_state_en = ahb3_hready & ahb3_htrans[1] & ahb3_hsel;  // only transition on a valid hrtans
      end
      WR: begin  // Write command recieved last cycle
        buf_nxtstate = (ahb3_hresp | (ahb3_htrans[1:0] == 2'b0) | ~ahb3_hsel) ? IDLE : (ahb3_hwrite ? WR : RD);
        buf_state_en = (~cmdbuf_full | ahb3_hresp);
        cmdbuf_wr_en = ~cmdbuf_full & ~(ahb3_hresp | ((ahb3_htrans[1:0] == 2'b01) & ahb3_hsel));
        // Dont send command to the buffer in case of an error or when the master is not ready with the data now.
      end
      RD: begin  // Read command recieved last cycle.
        buf_nxtstate = ahb3_hresp ? IDLE : PEND;  // If error go to idle, else wait for read data
        buf_state_en = (~cmdbuf_full | ahb3_hresp);  // only when command can go, or if its an error
        cmdbuf_wr_en = ~ahb3_hresp & ~cmdbuf_full;  // send command only when no error
      end
      PEND: begin  // Read Command has been sent. Waiting on Data.
        buf_nxtstate      = IDLE;  // go back for next command and present data next cycle
        buf_state_en      = axi4_r_valid & ~cmdbuf_write;  // read data is back
        buf_rdata_en      = buf_state_en;  // buffer the read data coming back from core
        buf_read_error_in = buf_state_en & |axi4_r_resp[1:0];  // buffer error flag if return has Error ( ECC )
      end
    endcase
  end

  always_ff @(posedge ahb3_clk or negedge rst_l) begin
    if (rst_l == 0) begin
      buf_state <= IDLE;
    end else begin
      buf_state <= buf_state_en ? buf_nxtstate : buf_state;
    end
  end

  assign master_wstrb[7:0]   = ({8{ahb3_hsize_q == 3'b000}} & (8'b0000_0001 << ahb3_haddr_q[2:0])) |
                               ({8{ahb3_hsize_q == 3'b001}} & (8'b0000_0011 << ahb3_haddr_q[2:0])) |
                               ({8{ahb3_hsize_q == 3'b010}} & (8'b0000_1111 << ahb3_haddr_q[2:0])) |
                               ({8{ahb3_hsize_q == 3'b011}} & (8'b1111_1111));

  // AHB signals
  assign ahb3_hreadyout = ahb3_hresp ? (ahb3_hresp_q & ~ahb3_hready_q) : ((~cmdbuf_full | (buf_state == IDLE)) & ~(buf_state == RD | buf_state == PEND) & ~buf_read_error);

  assign ahb3_hready = ahb3_hreadyout & ahb3_hreadyin;
  assign ahb3_htrans_in = {2{ahb3_hsel}} & ahb3_htrans[1:0];
  assign ahb3_hrdata = buf_rdata[63:0];
  assign ahb3_hresp = ((ahb3_htrans_q[1:0] != 2'b0) & (buf_state != IDLE) &
    // request not for ICCM or DCCM
    ((~(ahb3_addr_in_dccm | ahb3_addr_in_iccm)) |
    // ICCM Rd/Wr OR DCCM Wr not the right size
    ((ahb3_addr_in_iccm | (ahb3_addr_in_dccm & ahb3_hwrite_q)) & ~((ahb3_hsize_q[1:0] == 2'b10) | (ahb3_hsize_q[1:0] == 2'b11))) |
    // HW size but unaligned
    ((ahb3_hsize_q == 3'h1) & ahb3_haddr_q[0]) |
    // W size but unaligned
    ((ahb3_hsize_q == 3'h2) & (|ahb3_haddr_q[1:0])) |
    // DW size but unaligned
    ((ahb3_hsize_q == 3'h3) & (|ahb3_haddr_q[2:0])))) |
    // Read ECC error
    buf_read_error |
    // This is for second cycle of hresp protocol
    (ahb3_hresp_q & ~ahb3_hready_q);

  // Buffer signals - needed for the read data and ECC error response
  always_ff @(posedge buf_rdata_clk or negedge rst_l) begin
    if (rst_l == 0) begin
      buf_rdata <= 0;
    end else begin
      buf_rdata <= axi4_r_data;
    end
  end

  // buf_read_error will be high only one cycle
  always_ff @(posedge ahb3_clk or negedge rst_l) begin
    if (rst_l == 0) begin
      buf_read_error <= 0;
    end else begin
      buf_read_error <= buf_read_error_in;
    end
  end

  // All the Master signals are captured before presenting it to the command buffer.
  // We check for Hresp before sending it to the cmd buffer.
  always_ff @(posedge ahb3_clk or negedge rst_l) begin
    if (rst_l == 0) begin
      ahb3_hresp_q <= 0;
    end else begin
      ahb3_hresp_q <= ahb3_hresp;
    end
  end

  always_ff @(posedge ahb3_clk or negedge rst_l) begin
    if (rst_l == 0) begin
      ahb3_hready_q <= 0;
    end else begin
      ahb3_hready_q <= ahb3_hready;
    end
  end

  always_ff @(posedge ahb3_clk or negedge rst_l) begin
    if (rst_l == 0) begin
      ahb3_htrans_q <= 0;
    end else begin
      ahb3_htrans_q <= ahb3_htrans_in;
    end
  end

  always_ff @(posedge ahb3_addr_clk or negedge rst_l) begin
    if (rst_l == 0) begin
      ahb3_hsize_q <= 0;
    end else begin
      ahb3_hsize_q <= ahb3_hsize;
    end
  end

  always_ff @(posedge ahb3_addr_clk or negedge rst_l) begin
    if (rst_l == 0) begin
      ahb3_hwrite_q <= 0;
    end else begin
      ahb3_hwrite_q <= ahb3_hwrite;
    end
  end

  always_ff @(posedge ahb3_addr_clk or negedge rst_l) begin
    if (rst_l == 0) begin
      ahb3_haddr_q <= 0;
    end else begin
      ahb3_haddr_q <= ahb3_haddr;
    end
  end

  // Clock header logic
  assign ahb3_bus_addr_clk_en = bus_clk_en & (ahb3_hready & ahb3_htrans[1]);
  assign buf_rdata_clk_en     = bus_clk_en & buf_rdata_en;

  always @(negedge clk) begin
    ahb3_clk      = (bus_clk_en | scan_mode);  // clk &
    ahb3_addr_clk = (ahb3_bus_addr_clk_en | scan_mode);  // clk &
    buf_rdata_clk = (buf_rdata_clk_en | scan_mode);  // clk &
  end

  // Address check  dccm
  assign ahb3_addr_in_dccm_region_nc = (ahb3_haddr_q[AHB_ADDR_WIDTH-1:(AHB_ADDR_WIDTH-REGION_BITS)] == RV_DCCM_SADR[AHB_ADDR_WIDTH-1:(AHB_ADDR_WIDTH-REGION_BITS)]);

  if (RV_DCCM_SIZE == 48) begin
    assign ahb3_addr_in_dccm = (ahb3_haddr_q[AHB_ADDR_WIDTH-1:MASK_BITS] == RV_DCCM_SADR[AHB_ADDR_WIDTH-1:MASK_BITS]) & ~(&ahb3_haddr_q[MASK_BITS-1 : MASK_BITS-2]);
  end else begin
    assign ahb3_addr_in_dccm = (ahb3_haddr_q[AHB_ADDR_WIDTH-1:MASK_BITS] == RV_DCCM_SADR[AHB_ADDR_WIDTH-1:MASK_BITS]);
  end

  // Address check  iccm
`ifdef RV_ICCM_ENABLE
  assign ahb3_addr_in_iccm_region_nc = (ahb3_haddr_q[AHB_ADDR_WIDTH-1:(AHB_ADDR_WIDTH-REGION_BITS)] == RV_ICCM_SADR[AHB_ADDR_WIDTH-1:(AHB_ADDR_WIDTH-REGION_BITS)]);

  if (RV_ICCM_SIZE == 48) begin
    assign ahb3_addr_in_iccm = (ahb3_haddr_q[AHB_ADDR_WIDTH-1:MASK_BITS] == RV_ICCM_SADR[AHB_ADDR_WIDTH-1:MASK_BITS]) & ~(&ahb3_haddr_q[MASK_BITS-1 : MASK_BITS-2]);
  end else begin
    assign ahb3_addr_in_iccm = (ahb3_haddr_q[AHB_ADDR_WIDTH-1:MASK_BITS] == RV_ICCM_SADR[AHB_ADDR_WIDTH-1:MASK_BITS]);
  end
`else
  assign ahb3_addr_in_iccm           = '0;
  assign ahb3_addr_in_iccm_region_nc = '0;
`endif

  // PIC memory address check
  assign ahb3_addr_in_pic_region_nc = (ahb3_haddr_q[AHB_ADDR_WIDTH-1:(AHB_ADDR_WIDTH-REGION_BITS)] == RV_PIC_BASE_ADDR[AHB_ADDR_WIDTH-1:(AHB_ADDR_WIDTH-REGION_BITS)]);

  if (RV_PIC_SIZE == 48) begin
    assign ahb3_addr_in_pic = (ahb3_haddr_q[AHB_ADDR_WIDTH-1:MASK_BITS] == RV_PIC_BASE_ADDR[AHB_ADDR_WIDTH-1:MASK_BITS]) & ~(&ahb3_haddr_q[MASK_BITS-1 : MASK_BITS-2]);
  end else begin
    assign ahb3_addr_in_pic = (ahb3_haddr_q[AHB_ADDR_WIDTH-1:MASK_BITS] == RV_PIC_BASE_ADDR[AHB_ADDR_WIDTH-1:MASK_BITS]);
  end

  // Command Buffer
  // Holding for the commands to be sent for the AXI. It will be converted to the AXI signals.
  assign cmdbuf_rst  = (((axi4_aw_valid & axi4_aw_ready) | (axi4_ar_valid & axi4_ar_ready)) & ~cmdbuf_wr_en) | (ahb3_hresp & ~cmdbuf_write);
  assign cmdbuf_full = (cmdbuf_vld & ~((axi4_aw_valid & axi4_aw_ready) | (axi4_ar_valid & axi4_ar_ready)));

  always_ff @(posedge bus_clk or negedge rst_l) begin
    if (rst_l == 0) begin
      cmdbuf_vld <= 0;
    end else begin
      cmdbuf_vld <= ~cmdbuf_rst & (cmdbuf_wr_en ? 1'b1 : cmdbuf_vld);
    end
  end

  always_ff @(posedge bus_clk or negedge rst_l) begin
    if (rst_l == 0) begin
      cmdbuf_write <= 0;
    end else begin
      cmdbuf_write <= cmdbuf_wr_en ? ahb3_hwrite_q : cmdbuf_write;
    end
  end

  always_ff @(posedge bus_clk or negedge rst_l) begin
    if (rst_l == 0) begin
      cmdbuf_size <= 0;
    end else begin
      cmdbuf_size <= cmdbuf_wr_en ? ahb3_hsize_q[1:0] : cmdbuf_size;
    end
  end

  always_ff @(posedge bus_clk or negedge rst_l) begin
    if (rst_l == 0) begin
      cmdbuf_wstrb <= 0;
    end else begin
      cmdbuf_wstrb <= cmdbuf_wr_en ? master_wstrb : cmdbuf_wstrb;
    end
  end

  always_ff @(posedge bus_clk or negedge rst_l) begin
    if (rst_l == 0) begin
      cmdbuf_addr <= 0;
    end else begin
      cmdbuf_addr <= cmdbuf_wr_en ? ahb3_haddr_q : cmdbuf_addr;
    end
  end

  always_ff @(posedge bus_clk or negedge rst_l) begin
    if (rst_l == 0) begin
      cmdbuf_wdata <= 0;
    end else begin
      cmdbuf_wdata <= cmdbuf_wr_en ? ahb3_hwdata : cmdbuf_wdata;
    end
  end

  // AXI Write Command Channel
  assign axi4_aw_id     = '0;
  assign axi4_aw_addr   = cmdbuf_addr;
  assign axi4_aw_len    = 8'b0000_0000;
  assign axi4_aw_size   = {1'b0, cmdbuf_size[1:0]};
  assign axi4_aw_burst  = 2'b01;
  assign axi4_aw_lock   = 1'b0;
  assign axi4_aw_cache  = 4'b0000;
  assign axi4_aw_prot   = 3'b000;
  assign axi4_aw_qos    = 4'b0000;
  assign axi4_aw_region = 4'b0000;
  assign axi4_aw_user   = '0;
  assign axi4_aw_valid  = cmdbuf_vld & cmdbuf_write;

  // AXI Write Data Channel
  // This is tied to the command channel as we only write the command buffer once we have the data.
  assign axi4_w_data    = cmdbuf_wdata;
  assign axi4_w_strb    = cmdbuf_wstrb;
  assign axi4_w_last    = 1'b1;
  assign axi4_w_user    = 1'b0;
  assign axi4_w_valid   = cmdbuf_vld & cmdbuf_write;

  // AXI Write Response
  // Always ready. AHB does not require a write response.
  assign axi4_b_ready   = 1'b1;

  // AXI Read Channels
  assign axi4_ar_id     = '0;
  assign axi4_ar_addr   = cmdbuf_addr;
  assign axi4_ar_len    = 8'b0000_0000;
  assign axi4_ar_size   = {1'b0, cmdbuf_size};
  assign axi4_ar_burst  = 2'b01;
  assign axi4_ar_lock   = 1'b0;
  assign axi4_ar_cache  = 4'b0000;
  assign axi4_ar_prot   = 3'b000;
  assign axi4_ar_qos    = 4'b0000;
  assign axi4_ar_region = 4'b0000;
  assign axi4_ar_user   = '0;
  assign axi4_ar_valid  = cmdbuf_vld & ~cmdbuf_write;

  // AXI Read Response Channel
  // Always ready as AHB reads are blocking and the the buffer is available for the read coming back always.
  assign axi4_r_ready   = 1'b1;

  // Clock header logic
  always @(negedge clk) begin
    bus_clk = (bus_clk_en | scan_mode);  // clk &
  end
endmodule
