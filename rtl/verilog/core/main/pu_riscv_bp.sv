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
//              Core - Correlating Branch Prediction Unit                     //
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

module pu_riscv_bp #(
  parameter XLEN = 64,

  parameter HAS_BPU = 1,

  parameter BP_GLOBAL_BITS    = 2,
  parameter BP_LOCAL_BITS     = 10,
  parameter BP_LOCAL_BITS_LSB = 2,

  parameter TECHNOLOGY = "GENERIC",

  parameter AVOID_X = 0,

  parameter [XLEN-1:0] PC_INIT = 'h8000_0000
) (
  input rst_ni,
  input clk_i,

  // Read side
  input             id_stall_i,
  input  [XLEN-1:0] if_parcel_pc_i,
  output [     1:0] bp_bp_predict_o,

  // Write side
  input [XLEN          -1:0] ex_pc_i,
  input [BP_GLOBAL_BITS-1:0] bu_bp_history_i,  // branch history
  input [               1:0] bu_bp_predict_i,  // prediction bits for branch
  input                      bu_bp_btaken_i,
  input                      bu_bp_update_i
);

  //////////////////////////////////////////////////////////////////////////////
  // Constants
  //////////////////////////////////////////////////////////////////////////////
  localparam ADR_BITS = BP_GLOBAL_BITS + BP_LOCAL_BITS;
  localparam MEMORY_DEPTH = 1 << ADR_BITS;

  //////////////////////////////////////////////////////////////////////////////
  // Variables
  //////////////////////////////////////////////////////////////////////////////
  logic [ADR_BITS-1:0] radr;
  logic [ADR_BITS-1:0] wadr;

  logic [XLEN    -1:0] if_parcel_pc_dly;

  logic [         1:0] new_prediction;
  bit   [         1:0] old_prediction;

  //////////////////////////////////////////////////////////////////////////////
  // Module Body
  //////////////////////////////////////////////////////////////////////////////
  always @(posedge clk_i, negedge rst_ni) begin
    if (!rst_ni) begin
      if_parcel_pc_dly <= PC_INIT;
    end else if (!id_stall_i) begin
      if_parcel_pc_dly <= if_parcel_pc_i;
    end
  end

  assign radr              = id_stall_i ? {bu_bp_history_i, if_parcel_pc_dly[BP_LOCAL_BITS_LSB +: BP_LOCAL_BITS]} : {bu_bp_history_i, if_parcel_pc_i[BP_LOCAL_BITS_LSB +: BP_LOCAL_BITS]};
  assign wadr              = {bu_bp_history_i, ex_pc_i[BP_LOCAL_BITS_LSB +: BP_LOCAL_BITS]};

  /*
   *  Calculate new prediction bits
   *
   *  00<-->01<-->11<-->10
   */

  assign new_prediction[0] = bu_bp_predict_i[1] ^ bu_bp_btaken_i;
  assign new_prediction[1] = (bu_bp_predict_i[1] & ~bu_bp_predict_i[0]) | (bu_bp_btaken_i & bu_bp_predict_i[0]);

  // Hookup 1R1W memory
  pu_riscv_ram_1r1w #(
    .ABITS     (ADR_BITS),
    .DBITS     (2),
    .TECHNOLOGY(TECHNOLOGY)
  ) ram_1r1w (
    .rst_ni(rst_ni),
    .clk_i (clk_i),

    // Write side
    .waddr_i(wadr),
    .din_i  (new_prediction),
    .we_i   (bu_bp_update_i),
    .be_i   (1'b1),

    // Read side
    .raddr_i(radr),
    .re_i   (1'b1),
    .dout_o (old_prediction)
  );

  generate
    if (AVOID_X) begin
      assign bp_bp_predict_o = (old_prediction == 2'bxx) ? $random : old_prediction;
    end else begin
      assign bp_bp_predict_o = old_prediction;
    end
  endgenerate
endmodule
