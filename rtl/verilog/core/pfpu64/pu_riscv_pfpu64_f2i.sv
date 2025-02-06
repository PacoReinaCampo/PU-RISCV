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
//              MPSoC-OR1K CPU                                                //
//              Processing Unit                                               //
//              Wishbone Bus Interface                                        //
//                                                                            //
////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2015-2016 by the author(s)
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
//   Paco Reina Campo <pacoreinacampo@queenfield.tech>

`include "pu_riscv_defines.sv"

module pu_riscv_pfpu64_f2i (
  input             clk,
  input             rst,
  input             flush_i,  // flush pipe
  input             adv_i,    // advance pipe
  input             start_i,  // start conversion
  input             signa_i,  // input 'a' related values
  input      [ 9:0] exp10a_i,
  input      [23:0] fract24a_i,
  input             snan_i,   // 'a'/'b' related
  input             qnan_i,
  output reg        f2i_rdy_o,       // f2i is ready
  output reg        f2i_sign_o,      // f2i signum
  output reg [23:0] f2i_int24_o,     // f2i fractional
  output reg [ 4:0] f2i_shr_o,       // f2i required shift right value
  output reg [ 3:0] f2i_shl_o,       // f2i required shift left value   
  output reg        f2i_ovf_o,       // f2i overflow flag
  output reg        f2i_snan_o       // f2i signaling NaN output reg
);

  // Any stage's output is registered.
  // Definitions:
  //  s??o_name - "S"tage number "??", "O"utput
  //  s??t_name - "S"tage number "??", "T"emporary (internally)
 
  // exponent after moving binary point at the end of mantissa
  // bias is also removed
  wire [9:0] s1t_exp10m = exp10a_i - 10'd150; // (- 127 - 23)

  // detect if now shift right is required
  wire [9:0] s1t_shr_t = {10{s1t_exp10m[9]}} & (10'd150 - exp10a_i);

  // limit right shift by 31
  wire [4:0] s1t_shr = s1t_shr_t[4:0] | {5{|s1t_shr_t[9:5]}};

  // detect if left shift required for mantissa
  // (limited by 15)
  wire [3:0] s1t_shl = {4{~s1t_exp10m[9]}} & (s1t_exp10m[3:0] | {4{|s1t_exp10m[9:4]}});

  // check overflow
  wire s1t_is_shl_gt8 = s1t_shl[3] & (|s1t_shl[2:0]);
  wire s1t_is_shl_eq8 = s1t_shl[3] & (~(|s1t_shl[2:0]));
  wire s1t_is_shl_ovf = s1t_is_shl_gt8 | (s1t_is_shl_eq8 & (~signa_i)) | (s1t_is_shl_eq8 & signa_i & (|fract24a_i[22:0]));

  // registering output
  always @(posedge clk) begin
    if(adv_i) begin
      // input related
      f2i_snan_o  <= snan_i;

      // computation related
      f2i_sign_o  <= signa_i & (!(qnan_i | snan_i)); // if 'a' is a NaN than ouput is max. positive
      f2i_int24_o <= fract24a_i;
      f2i_shr_o   <= s1t_shr;
      f2i_shl_o   <= s1t_shl;
      f2i_ovf_o   <= s1t_is_shl_ovf;
    end
  end

  // ready is special case
  always @(posedge clk or posedge rst) begin
    if (rst) begin
      f2i_rdy_o <= 1'b0;
    end else if(flush_i) begin
      f2i_rdy_o <= 1'b0;
    end else if(adv_i) begin
      f2i_rdy_o <= start_i;
    end
  end
endmodule
