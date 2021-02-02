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
//              Single Port RAM                                               //
//              Wishbone Bus Interface                                        //
//                                                                            //
////////////////////////////////////////////////////////////////////////////////

/* Copyright (c) 2018-2019 by the author(s)
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
 *   Olof Kindgren <olof.kindgren@gmail.com>
 *   Paco Reina Campo <pacoreinacampo@queenfield.tech>
 */

module mpsoc_wb_spram #(
  //Memory parameters
  parameter DEPTH   = 256,
  parameter MEMFILE = "",

  //Wishbone parameters
  parameter DW = 32,
  parameter AW = $clog2(DEPTH)
)
  (
    input           wb_clk_i,
    input           wb_rst_i,

    input  [AW-1:0] wb_adr_i,
    input  [DW-1:0] wb_dat_i,
    input  [   3:0] wb_sel_i,
    input           wb_we_i,
    input  [   1:0] wb_bte_i,
    input  [   2:0] wb_cti_i,
    input           wb_cyc_i,
    input           wb_stb_i,

    output reg      wb_ack_o,
    output          wb_err_o,
    output [DW-1:0] wb_dat_o
  );

  //////////////////////////////////////////////////////////////////
  //
  // Constants
  //
  localparam CLASSIC_CYCLE = 1'b0;
  localparam BURST_CYCLE   = 1'b1;

  localparam READ  = 1'b0;
  localparam WRITE = 1'b1;

  localparam [2:0] CTI_CLASSIC      = 3'b000;
  localparam [2:0] CTI_CONST_BURST  = 3'b001;
  localparam [2:0] CTI_INC_BURST    = 3'b010;
  localparam [2:0] CTI_END_OF_BURST = 3'b111;

  localparam [1:0] BTE_LINEAR  = 2'd0;
  localparam [1:0] BTE_WRAP_4  = 2'd1;
  localparam [1:0] BTE_WRAP_8  = 2'd2;
  localparam [1:0] BTE_WRAP_16 = 2'd3;

  //////////////////////////////////////////////////////////////////
  //
  // Functions
  //
  function get_cycle_type;
    input [2:0] cti;
    begin
      get_cycle_type = (cti === CTI_CLASSIC) ? CLASSIC_CYCLE : BURST_CYCLE;
    end
  endfunction

  function wb_is_last;
    input [2:0] cti;
    begin
      case (cti)
        CTI_CLASSIC      : wb_is_last = 1'b1;
        CTI_CONST_BURST  : wb_is_last = 1'b0;
        CTI_INC_BURST    : wb_is_last = 1'b0;
        CTI_END_OF_BURST : wb_is_last = 1'b1;
      endcase
    end
  endfunction

  function [31:0] wb_next_adr;
    input [31:0] adr_i;
    input [2:0]  cti_i;
    input [1:0]  bte_i;

    input integer dw;

    reg [31:0] adr;

    integer shift;
    begin
      if (dw == 64) shift = 3;
      else if (dw == 32) shift = 2;
      else if (dw == 16) shift = 1;
      else shift = 0;
      adr = adr_i >> shift;
      if (cti_i == CTI_INC_BURST)
        case (bte_i)
          BTE_LINEAR   : adr = adr + 1;
          BTE_WRAP_4   : adr = {adr[31:2], adr[1:0]+2'd1};
          BTE_WRAP_8   : adr = {adr[31:3], adr[2:0]+3'd1};
          BTE_WRAP_16  : adr = {adr[31:4], adr[3:0]+4'd1};
        endcase // case (burst_type_i)
      wb_next_adr = adr << shift;
    end
  endfunction

  //////////////////////////////////////////////////////////////////
  //
  // Variables
  //
  reg  [AW-1:0] adr_r;
  wire [AW-1:0] next_adr;
  wire          valid;
  reg           valid_r;
  reg           is_last_r;
  wire          new_cycle;
  wire [AW-1:0] adr;
  wire          ram_we;

  //////////////////////////////////////////////////////////////////
  //
  // Module Body
  //
  assign valid = wb_cyc_i & wb_stb_i;

  always @(posedge wb_clk_i) begin
    is_last_r <= wb_is_last(wb_cti_i);
  end

  assign new_cycle = (valid & !valid_r) | is_last_r;

  assign next_adr = wb_next_adr(adr_r, wb_cti_i, wb_bte_i, DW);

  assign adr = new_cycle ? wb_adr_i : next_adr;

  always@(posedge wb_clk_i) begin
    adr_r   <= adr;
    valid_r <= valid;
    //Ack generation
    wb_ack_o <= valid & (!((wb_cti_i == 3'b000) | (wb_cti_i == 3'b111)) | !wb_ack_o);
    if(wb_rst_i) begin
      adr_r    <= {AW{1'b0}};
      valid_r  <= 1'b0;
      wb_ack_o <= 1'b0;
    end
  end

  assign ram_we = wb_we_i & valid & wb_ack_o;

  //TODO:ck for burst address errors
  assign wb_err_o =  1'b0;

  mpsoc_wb_ram_generic #(
    .DEPTH   (DEPTH/4),
    .MEMFILE (MEMFILE),

    .AW ($clog2(DEPTH/4)),
    .DW (DW)
  )
  ram0 (
    .clk   (wb_clk_i),
    .we    ({4{ram_we}} & wb_sel_i),
    .din   (wb_dat_i),
    .waddr (adr_r[AW-1:2]),
    .raddr (adr[AW-1:2]),
    .dout  (wb_dat_o)
  );
endmodule
