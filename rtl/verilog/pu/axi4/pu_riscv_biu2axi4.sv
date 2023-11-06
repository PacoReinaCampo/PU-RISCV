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
//              Bus Interface Unit                                            //
//              AMBA3 AHB-Lite Bus Interface                                  //
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

import peripheral_axi4_verilog_pkg::*;
import peripheral_biu_verilog_pkg::*;

module pu_riscv_biu2axi4 #(
  parameter XLEN = 64,
  parameter PLEN = 64,

  parameter AXI_ID_WIDTH   = 10,
  parameter AXI_ADDR_WIDTH = 64,
  parameter AXI_DATA_WIDTH = 64,
  parameter AXI_STRB_WIDTH = 10,
  parameter AXI_USER_WIDTH = 10,

  parameter AHB_ADDR_WIDTH = 64,
  parameter AHB_DATA_WIDTH = 64
) (
  input wire HRESETn,
  input wire HCLK,

  // AXI4 instruction
  output reg  [AXI_ID_WIDTH    -1:0] axi4_aw_id,
  output reg  [AXI_ADDR_WIDTH  -1:0] axi4_aw_addr,
  output reg  [                 7:0] axi4_aw_len,
  output reg  [                 2:0] axi4_aw_size,
  output reg  [                 1:0] axi4_aw_burst,
  output reg                         axi4_aw_lock,
  output reg  [                 3:0] axi4_aw_cache,
  output reg  [                 2:0] axi4_aw_prot,
  output reg  [                 3:0] axi4_aw_qos,
  output reg  [                 3:0] axi4_aw_region,
  output reg  [AXI_USER_WIDTH  -1:0] axi4_aw_user,
  output reg                         axi4_aw_valid,
  input  wire                        axi4_aw_ready,

  output reg  [AXI_ID_WIDTH    -1:0] axi4_ar_id,
  output reg  [AXI_ADDR_WIDTH  -1:0] axi4_ar_addr,
  output reg  [                 7:0] axi4_ar_len,
  output reg  [                 2:0] axi4_ar_size,
  output reg  [                 1:0] axi4_ar_burst,
  output reg                         axi4_ar_lock,
  output reg  [                 3:0] axi4_ar_cache,
  output reg  [                 2:0] axi4_ar_prot,
  output reg  [                 3:0] axi4_ar_qos,
  output reg  [                 3:0] axi4_ar_region,
  output reg  [AXI_USER_WIDTH  -1:0] axi4_ar_user,
  output reg                         axi4_ar_valid,
  input  wire                        axi4_ar_ready,

  output reg  [AXI_DATA_WIDTH  -1:0] axi4_w_data,
  output reg  [AXI_STRB_WIDTH  -1:0] axi4_w_strb,
  output reg                         axi4_w_last,
  output reg  [AXI_USER_WIDTH  -1:0] axi4_w_user,
  output reg                         axi4_w_valid,
  input  wire                        axi4_w_ready,

  input  wire [AXI_ID_WIDTH    -1:0] axi4_r_id,
  input  wire [AXI_DATA_WIDTH  -1:0] axi4_r_data,
  input  wire [                 1:0] axi4_r_resp,
  input  wire                        axi4_r_last,
  input  wire [AXI_USER_WIDTH  -1:0] axi4_r_user,
  input  wire                        axi4_r_valid,
  output reg                         axi4_r_ready,

  input  wire [AXI_ID_WIDTH    -1:0] axi4_b_id,
  input  wire [                 1:0] axi4_b_resp,
  input  wire [AXI_USER_WIDTH  -1:0] axi4_b_user,
  input  wire                        axi4_b_valid,
  output reg                         axi4_b_ready,

  // BIU Bus (Core ports)
  input  wire             biu_stb_i,      // strobe
  output reg              biu_stb_ack_o,  // strobe acknowledge; can send new strobe
  output reg              biu_d_ack_o,    // data acknowledge (send new biu_d_i); for pipelined buses
  input  wire [PLEN -1:0] biu_adri_i,
  output reg  [PLEN -1:0] biu_adro_o,
  input  wire [      2:0] biu_size_i,     // transfer size
  input  wire [      2:0] biu_type_i,     // burst type
  input  wire [      2:0] biu_prot_i,     // protection
  input  wire             biu_lock_i,
  input  wire             biu_we_i,
  input  wire [XLEN -1:0] biu_d_i,
  output reg  [XLEN -1:0] biu_q_o,
  output reg              biu_ack_o,      // transfer acknowledge
  output reg              biu_err_o       // transfer error
);

  //////////////////////////////////////////////////////////////////////////////
  //
  // Functions
  //

  function automatic [2:0] biu_size2hsize;
    input [2:0] size;

    case (size)
      3'b000:  biu_size2hsize = `HSIZE_BYTE;
      3'b001:  biu_size2hsize = `HSIZE_HWORD;
      3'b010:  biu_size2hsize = `HSIZE_WORD;
      3'b011:  biu_size2hsize = `HSIZE_DWORD;
      default: biu_size2hsize = 3'hx;  // OOPSS
    endcase
  endfunction

  // convert burst type to counter length (actually length -1)
  function automatic [3:0] biu_type2cnt;
    input [2:0] biu_type;

    case (biu_type)
      `SINGLE: biu_type2cnt = 0;
      `INCR:   biu_type2cnt = 0;
      `WRAP4:  biu_type2cnt = 3;
      `INCR4:  biu_type2cnt = 3;
      `WRAP8:  biu_type2cnt = 7;
      `INCR8:  biu_type2cnt = 7;
      `WRAP16: biu_type2cnt = 15;
      `INCR16: biu_type2cnt = 15;
      default: biu_type2cnt = 4'hx;  // OOPS
    endcase
  endfunction

  // convert burst type to counter length (actually length -1)
  function automatic [2:0] biu_type2hburst;
    input [2:0] biu_type;

    case (biu_type)
      `SINGLE: biu_type2hburst = `HBURST_SINGLE;
      `INCR:   biu_type2hburst = `HBURST_INCR;
      `WRAP4:  biu_type2hburst = `HBURST_WRAP4;
      `INCR4:  biu_type2hburst = `HBURST_INCR4;
      `WRAP8:  biu_type2hburst = `HBURST_WRAP8;
      `INCR8:  biu_type2hburst = `HBURST_INCR8;
      `WRAP16: biu_type2hburst = `HBURST_WRAP16;
      `INCR16: biu_type2hburst = `HBURST_INCR16;
      default: biu_type2hburst = 3'hx;  // OOPS
    endcase
  endfunction

  // convert burst type to counter length (actually length -1)
  function automatic [3:0] biu_prot2hprot;
    input [2:0] biu_prot;

    biu_prot2hprot = biu_prot & `PROT_DATA ? `HPROT_DATA : `HPROT_OPCODE;
    biu_prot2hprot = biu_prot2hprot | (biu_prot & `PROT_PRIVILEGED ? `HPROT_PRIVILEGED : `HPROT_USER);
    biu_prot2hprot = biu_prot2hprot | (biu_prot & `PROT_CACHEABLE ? `HPROT_CACHEABLE : `HPROT_NON_CACHEABLE);
  endfunction

  // convert burst type to counter length (actually length -1)
  function automatic [PLEN-1:0] nxt_addr;
    input [PLEN -1:0] addr;  // current address
    input [2:0] hburst;  // AHB hburst

    // next linear address
    if (XLEN == 32) begin
      nxt_addr = (addr + 'h4) & ~'h3;
    end else begin
      nxt_addr = (addr + 'h8) & ~'h7;
    end

    // wrap?
    case (hburst)
      `HBURST_WRAP4:  nxt_addr = (XLEN == 32) ? {addr[PLEN-1:4], nxt_addr[3:0]} : {addr[PLEN-1:5], nxt_addr[4:0]};
      `HBURST_WRAP8:  nxt_addr = (XLEN == 32) ? {addr[PLEN-1:5], nxt_addr[4:0]} : {addr[PLEN-1:6], nxt_addr[5:0]};
      `HBURST_WRAP16: nxt_addr = (XLEN == 32) ? {addr[PLEN-1:6], nxt_addr[5:0]} : {addr[PLEN-1:7], nxt_addr[6:0]};
      default:        ;
    endcase
  endfunction

  //////////////////////////////////////////////////////////////////////////////
  // Variables
  //////////////////////////////////////////////////////////////////////////////

  logic [3:0] burst_cnt;
  logic data_ena, data_ena_d;
  logic [XLEN -1:0] biu_di_dly;

  logic             hsel;
  logic [PLEN -1:0] haddr;
  logic [XLEN -1:0] hrdata;
  logic [XLEN -1:0] hwdata;
  logic             hwrite;
  logic [      2:0] hsize;
  logic [      2:0] hburst;
  logic [      3:0] hprot;
  logic [      1:0] htrans;
  logic             hmastlock;
  logic             hready;
  logic             hresp;

  //////////////////////////////////////////////////////////////////////////////
  // Module Body
  //////////////////////////////////////////////////////////////////////////////

  // State Machine
  always @(posedge HCLK, negedge HRESETn)
    if (!HRESETn) begin
      data_ena  <= 1'b0;
      biu_err_o <= 1'b0;
      burst_cnt <= 'h0;

      hsel      <= 1'b0;
      haddr     <= 'h0;
      hwrite    <= 1'b0;
      hsize     <= 'h0;  // dont care
      hburst    <= 'h0;  // dont care
      hprot     <= `HPROT_DATA | `HPROT_PRIVILEGED | `HPROT_NON_BUFFERABLE | `HPROT_NON_CACHEABLE;
      htrans    <= `HTRANS_IDLE;
      hmastlock <= 1'b0;
    end else begin
      // strobe/ack signals
      biu_err_o <= 1'b0;

      if (hready) begin
        if (~|burst_cnt) begin  // burst complete
          if (biu_stb_i && !biu_err_o) begin
            data_ena  <= 1'b1;
            burst_cnt <= biu_type2cnt(biu_type_i);

            hsel      <= 1'b1;
            htrans    <= `HTRANS_NONSEQ;  // start of burst
            haddr     <= biu_adri_i;
            hwrite    <= biu_we_i;
            hsize     <= biu_size2hsize(biu_size_i);
            hburst    <= biu_type2hburst(biu_type_i);
            hprot     <= biu_prot2hprot(biu_prot_i);
            hmastlock <= biu_lock_i;
          end else begin
            data_ena  <= 1'b0;

            hsel      <= 1'b0;
            htrans    <= `HTRANS_IDLE;  // no new transfer
            hmastlock <= biu_lock_i;
          end
        end else begin  // continue burst
          data_ena  <= 1'b1;
          burst_cnt <= burst_cnt - 1;

          htrans    <= `HTRANS_SEQ;  // continue burst
          haddr     <= nxt_addr(haddr, hburst);  // next address
        end
      end else begin
        // error response
        if (hresp == `HRESP_ERROR) begin
          burst_cnt <= 'h0;  // burst done (interrupted)

          hsel      <= 1'b0;
          htrans    <= `HTRANS_IDLE;

          data_ena  <= 1'b0;
          biu_err_o <= 1'b1;
        end
      end
    end

  // Data section
  always @(posedge HCLK) begin
    if (hready) begin
      biu_di_dly <= biu_d_i;
    end
  end

  always @(posedge HCLK) begin
    if (hready) begin
      hwdata     <= biu_di_dly;
      biu_adro_o <= haddr;
    end
  end

  always @(posedge HCLK, negedge HRESETn) begin
    if (!HRESETn) begin
      data_ena_d <= 1'b0;
    end else if (hready) begin
      data_ena_d <= data_ena;
    end
  end

  assign biu_q_o       = hrdata;
  assign biu_ack_o     = hready & data_ena_d;
  assign biu_d_ack_o   = hready & data_ena;
  assign biu_stb_ack_o = hready & ~|burst_cnt & biu_stb_i & ~biu_err_o;

  riscv_ahb2axi #(
    .AXI_ID_WIDTH  (AXI_ID_WIDTH),
    .AXI_ADDR_WIDTH(AXI_ADDR_WIDTH),
    .AXI_DATA_WIDTH(AXI_DATA_WIDTH),
    .AXI_STRB_WIDTH(AXI_STRB_WIDTH),

    .AHB_ADDR_WIDTH(AHB_ADDR_WIDTH),
    .AHB_DATA_WIDTH(AHB_DATA_WIDTH)
  ) ahb2axi (
    .clk  (HCLK),
    .rst_l(HRESETn),

    .scan_mode (1'b1),
    .bus_clk_en(1'b1),

    // AXI4 signals
    .axi4_aw_id    (axi4_aw_id),
    .axi4_aw_addr  (axi4_aw_addr),
    .axi4_aw_len   (axi4_aw_len),
    .axi4_aw_size  (axi4_aw_size),
    .axi4_aw_burst (axi4_aw_burst),
    .axi4_aw_lock  (axi4_aw_lock),
    .axi4_aw_cache (axi4_aw_cache),
    .axi4_aw_prot  (axi4_aw_prot),
    .axi4_aw_qos   (axi4_aw_qos),
    .axi4_aw_region(axi4_aw_region),
    .axi4_aw_user  (axi4_aw_user),
    .axi4_aw_valid (axi4_aw_valid),
    .axi4_aw_ready (axi4_aw_ready),

    .axi4_ar_id    (axi4_ar_id),
    .axi4_ar_addr  (axi4_ar_addr),
    .axi4_ar_len   (axi4_ar_len),
    .axi4_ar_size  (axi4_ar_size),
    .axi4_ar_burst (axi4_ar_burst),
    .axi4_ar_lock  (axi4_ar_lock),
    .axi4_ar_cache (axi4_ar_cache),
    .axi4_ar_prot  (axi4_ar_prot),
    .axi4_ar_qos   (axi4_ar_qos),
    .axi4_ar_region(axi4_ar_region),
    .axi4_ar_user  (axi4_ar_user),
    .axi4_ar_valid (axi4_ar_valid),
    .axi4_ar_ready (axi4_ar_ready),

    .axi4_w_data (axi4_w_data),
    .axi4_w_strb (axi4_w_strb),
    .axi4_w_last (axi4_w_last),
    .axi4_w_user (axi4_w_user),
    .axi4_w_valid(axi4_w_valid),
    .axi4_w_ready(axi4_w_ready),

    .axi4_r_id   (axi4_r_id),
    .axi4_r_data (axi4_r_data),
    .axi4_r_resp (axi4_r_resp),
    .axi4_r_last (axi4_r_last),
    .axi4_r_user (axi4_r_user),
    .axi4_r_valid(axi4_r_valid),
    .axi4_r_ready(axi4_r_ready),

    .axi4_b_id   (axi4_b_id),
    .axi4_b_resp (axi4_b_resp),
    .axi4_b_user (axi4_b_user),
    .axi4_b_valid(axi4_b_valid),
    .axi4_b_ready(axi4_b_ready),

    // AHB3 signals
    .ahb3_hsel     (hsel),
    .ahb3_haddr    (haddr),
    .ahb3_hwdata   (hwdata),
    .ahb3_hrdata   (hrdata),
    .ahb3_hwrite   (hwrite),
    .ahb3_hsize    (hsize),
    .ahb3_hburst   (hburst),
    .ahb3_hprot    (hprot),
    .ahb3_htrans   (htrans),
    .ahb3_hmastlock(hmastlock),
    .ahb3_hreadyin (hreadyin),
    .ahb3_hreadyout(hreadyout),
    .ahb3_hresp    (hresp)
  );
endmodule
