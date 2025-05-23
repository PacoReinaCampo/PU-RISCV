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

module pu_riscv_pfpu64_i2f (
  input             clk,
  input             rst,
  input             flush_i,  // flush pipe
  input             adv_i,    // advance pipe
  input             start_i,  // start conversion
  input      [63:0] opa_i,
  output reg        i2f_rdy_o,       // i2f is ready
  output reg        i2f_sign_o,      // i2f signum
  output reg [ 3:0] i2f_shr_o,
  output reg [ 7:0] i2f_exp8shr_o,
  output reg [ 4:0] i2f_shl_o,
  output reg [ 7:0] i2f_exp8shl_o,
  output reg [ 7:0] i2f_exp8sh0_o,
  output reg [63:0] i2f_fract64_o
);

  // Any stage's output is registered.
  // Definitions:
  //  s??o_name - "S"tage number "??", "O"utput
  //  s??t_name - "S"tage number "??", "T"emporary (internally)
 
  // signum of input
  wire s1t_signa = opa_i[63];

  // magnitude (tow's complement for negative input)
  wire [63:0] s1t_fract64 = (opa_i ^ {64{s1t_signa}}) + {63'd0,s1t_signa};

  // normalization shifts
  reg [3:0] s1t_shrx;
  reg [4:0] s1t_shlx;

  // shift goal:
  // 23 22                    0
  // |  |                     |
  // h  fffffffffffffffffffffff

  // right shift
  always @(s1t_fract64[63:24]) begin
    casez(s1t_fract64[63:24])  // synopsys full_case parallel_case
      8'b1??????? : s1t_shrx = 4'd8;
      8'b01?????? : s1t_shrx = 4'd7;
      8'b001????? : s1t_shrx = 4'd6;
      8'b0001???? : s1t_shrx = 4'd5;
      8'b00001??? : s1t_shrx = 4'd4;
      8'b000001?? : s1t_shrx = 4'd3;
      8'b0000001? : s1t_shrx = 4'd2;
      8'b00000001 : s1t_shrx = 4'd1;
      8'b00000000 : s1t_shrx = 4'd0;
    endcase
  end

  // left shift
  always @(s1t_fract64[23:0]) begin
    casez(s1t_fract64[23:0])  // synopsys full_case parallel_case
      24'b1??????????????????????? : s1t_shlx = 5'd0; // hidden '1' is in its plase
      24'b01?????????????????????? : s1t_shlx = 5'd1;
      24'b001????????????????????? : s1t_shlx = 5'd2;
      24'b0001???????????????????? : s1t_shlx = 5'd3;
      24'b00001??????????????????? : s1t_shlx = 5'd4;
      24'b000001?????????????????? : s1t_shlx = 5'd5;
      24'b0000001????????????????? : s1t_shlx = 5'd6;
      24'b00000001???????????????? : s1t_shlx = 5'd7;
      24'b000000001??????????????? : s1t_shlx = 5'd8;
      24'b0000000001?????????????? : s1t_shlx = 5'd9;
      24'b00000000001????????????? : s1t_shlx = 5'd10;
      24'b000000000001???????????? : s1t_shlx = 5'd11;
      24'b0000000000001??????????? : s1t_shlx = 5'd12;
      24'b00000000000001?????????? : s1t_shlx = 5'd13;
      24'b000000000000001????????? : s1t_shlx = 5'd14;
      24'b0000000000000001???????? : s1t_shlx = 5'd15;
      24'b00000000000000001??????? : s1t_shlx = 5'd16;
      24'b000000000000000001?????? : s1t_shlx = 5'd17;
      24'b0000000000000000001????? : s1t_shlx = 5'd18;
      24'b00000000000000000001???? : s1t_shlx = 5'd19;
      24'b000000000000000000001??? : s1t_shlx = 5'd20;
      24'b0000000000000000000001?? : s1t_shlx = 5'd21;
      24'b00000000000000000000001? : s1t_shlx = 5'd22;
      24'b000000000000000000000001 : s1t_shlx = 5'd23;
      24'b000000000000000000000000 : s1t_shlx = 5'd0;
    endcase
  end

  // registering output
  always @(posedge clk) begin
    if(adv_i) begin
      // computation related
      i2f_sign_o    <= s1t_signa;
      i2f_shr_o     <= s1t_shrx;
      i2f_exp8shr_o <= 8'd150 + {4'd0,s1t_shrx};      // 150=127+23
      i2f_shl_o     <= s1t_shlx;
      i2f_exp8shl_o <= 8'd150 - {3'd0,s1t_shlx};
      i2f_exp8sh0_o <= {8{s1t_fract64[23]}} & 8'd150; // "1" is in [23] / zero
      i2f_fract64_o <= s1t_fract64;
    end
  end

  // ready is special case
  always @(posedge clk or posedge rst) begin
    if (rst) begin
      i2f_rdy_o <= 1'b0;
    end else if(flush_i) begin
      i2f_rdy_o <= 1'b0;
    end else if(adv_i) begin
      i2f_rdy_o <= start_i;
    end
  end
endmodule
