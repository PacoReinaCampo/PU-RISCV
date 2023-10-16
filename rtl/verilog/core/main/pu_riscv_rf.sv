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
//              Core - Register File                                          //
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
 *   Paco Reina Campo <pacoreinacampo@queenfield.tech>
 */

module pu_riscv_rf #(
  parameter XLEN    = 64,
  parameter AR_BITS = 5,
  parameter RDPORTS = 2,
  parameter WRPORTS = 1
) (
  input rstn,
  input clk,

  //Register File read
  input  [RDPORTS-1:0][AR_BITS-1:0] rf_src1,
  input  [RDPORTS-1:0][AR_BITS-1:0] rf_src2,
  output [RDPORTS-1:0][XLEN   -1:0] rf_srcv1,
  output [RDPORTS-1:0][XLEN   -1:0] rf_srcv2,

  //Register File write
  input [WRPORTS-1:0][AR_BITS-1:0] rf_dst,
  input [WRPORTS-1:0][XLEN   -1:0] rf_dstv,
  input [WRPORTS-1:0]              rf_we,

  //Debug Interface
  input                du_stall,
  input                du_we_rf,
  input  [XLEN   -1:0] du_dato,     //output from debug unit
  output [XLEN   -1:0] du_dati_rf,
  input  [       11:0] du_addr
);

  ///////////////////////////////////////////////////////////////////////////////
  //
  // Variables
  //

  //Actual register file
  logic              [XLEN-1:0] rf         [32];

  //read data from register file
  logic [RDPORTS-1:0]           src1_is_x0;
  logic [RDPORTS-1:0]           src2_is_x0;
  logic [RDPORTS-1:0][XLEN-1:0] dout1;
  logic [RDPORTS-1:0][XLEN-1:0] dout2;

  //variable for generates
  genvar i;

  ///////////////////////////////////////////////////////////////////////////////
  //
  // Module Body
  //

  //Reads are asynchronous
  generate
    for (i = 0; i < RDPORTS; i = i + 1) begin : xreg_rd
      //per Altera's recommendations. Prevents bypass logic
      always @(posedge clk) begin
        dout1[i] <= rf[rf_src1[i]];
      end

      always @(posedge clk) begin
        dout2[i] <= rf[rf_src2[i]];
      end

      //got data from RAM, now handle X0
      always @(posedge clk) begin
        src1_is_x0[i] <= ~|rf_src1[i];
      end

      always @(posedge clk) begin
        src2_is_x0[i] <= ~|rf_src2[i];
      end

      assign rf_srcv1[i] = src1_is_x0[i] ? {XLEN{1'b0}} : dout1[i];
      assign rf_srcv2[i] = src2_is_x0[i] ? {XLEN{1'b0}} : dout2[i];
    end
  endgenerate

  //TODO: For the Debug Unit ... mux with port0
  assign du_dati_rf = |du_addr[AR_BITS-1:0] ? rf[du_addr[AR_BITS-1:0]] : {XLEN{1'b0}};

  //Writes are synchronous
  generate
    for (i = 0; i < WRPORTS; i = i + 1) begin : xreg_wr
      always @(posedge clk) begin
        if (du_we_rf) begin
          rf[du_addr[AR_BITS-1:0]] <= du_dato;
        end else if (rf_we[i]) begin
          rf[rf_dst[i]] <= rf_dstv[i];
        end
      end
    end
  endgenerate
endmodule
