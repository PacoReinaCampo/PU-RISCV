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
//              BIU Bus Interface                                             //
//                                                                            //
////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2017-2018 by the author(s)
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.
//
////////////////////////////////////////////////////////////////////////////////
// Author(s):
//   Francisco Javier Reina Campo <pacoreinacampo@queenfield.tech>

import peripheral_biu_pkg::*;

module peripheral_spram_biu #(
  parameter XLEN = 64,
  parameter PLEN = 64
) (
  input wire rst,
  input wire clk,

  // BIU Bus (Core ports)
  input  wire            biu_stb_i,      // strobe
  output reg             biu_stb_ack_o,  // strobe acknowledge; can send new strobe
  output reg             biu_d_ack_o,    // data acknowledge (send new biu_d_i); for pipelined buses
  input  wire [PLEN-1:0] biu_adri_i,
  output reg  [PLEN-1:0] biu_adro_o,
  input  wire [     2:0] biu_size_i,     // transfer size
  input  wire [     2:0] biu_type_i,     // burst type
  input  wire [     2:0] biu_prot_i,     // protection
  input  wire            biu_lock_i,
  input  wire            biu_we_i,
  input  wire [XLEN-1:0] biu_d_i,
  output reg  [XLEN-1:0] biu_q_o,
  output reg             biu_ack_o,      // transfer acknowledge
  output reg             biu_err_o       // transfer error
);

  //////////////////////////////////////////////////////////////////////////////
  // Body
  //////////////////////////////////////////////////////////////////////////////

  logic            req_int;
  logic            we_int;
  logic [     2:0] be_int;
  logic [PLEN-1:0] addr_int;
  logic [XLEN-1:0] data_i_int;
  logic [XLEN-1:0] data_o_int;

  peripheral_spram_bridge_biu #(
    .XLEN(XLEN),
    .PLEN(PLEN)
  ) spram_bridge_biu (
    .clk(clk),
    .rst(rst),

    .req_i (req_int),
    .we_i  (we_int),
    .be_i  (be_int),
    .addr_i(addr_int),
    .data_i(data_o_int),
    .data_o(data_i_int),

    // BIU Bus (Core ports)
    .biu_stb_i    (biu_stb_i),      // strobe
    .biu_stb_ack_o(biu_stb_ack_o),  // strobe acknowledge; can send new strobe
    .biu_d_ack_o  (biu_d_ack_o),    // data acknowledge (send new biu_d_i); for pipelined buses
    .biu_adri_i   (biu_adri_i),
    .biu_adro_o   (biu_adro_o),
    .biu_size_i   (biu_size_i),     // transfer size
    .biu_type_i   (biu_type_i),     // burst type
    .biu_prot_i   (biu_prot_i),     // protection
    .biu_lock_i   (biu_lock_i),
    .biu_we_i     (biu_we_i),
    .biu_d_i      (biu_d_i),
    .biu_q_o      (biu_q_o),
    .biu_ack_o    (biu_ack_o),      // transfer acknowledge
    .biu_err_o    (biu_err_o)       // transfer error
  );

  peripheral_spram_generic_biu #(
    .PLEN(PLEN),
    .XLEN(XLEN)
  ) spram_generic_biu (
    .rst(rst),
    .clk(clk),

    .req_i (req_int),
    .we_i  (we_int),
    .be_i  (be_int),
    .addr_i(addr_int),
    .data_i(data_o_int),
    .data_o(data_i_int)
  );

endmodule
