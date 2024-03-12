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

module peripheral_spram_generic_biu #(
  parameter PLEN = 64,
  parameter XLEN = 64
) (
  input rst,
  input clk,

  input                 req_i,
  input                 we_i,
  input      [     2:0] be_i,
  input      [PLEN-1:0] addr_i,
  input      [XLEN-1:0] data_i,
  output reg [XLEN-1:0] data_o
);

  //////////////////////////////////////////////////////////////////////////////
  // Variables
  //////////////////////////////////////////////////////////////////////////////

  genvar i;

  // Memory Array
  logic [XLEN-1:0] memory_array [2**PLEN-1:0];

  //////////////////////////////////////////////////////////////////////////////
  // Body
  //////////////////////////////////////////////////////////////////////////////

  // write side
  generate
    for (i = 0; i < XLEN/16; i = i+1) begin : write
      if (i*16+16 > XLEN) begin
        always @(posedge clk) begin
          if (req_i && we_i && be_i[i]) begin
            memory_array[addr_i][XLEN-1:i*16] <= data_i[XLEN-1:i*16];
          end
        end
      end else begin
        always @(posedge clk) begin
          if (req_i && we_i && be_i[i]) begin
            memory_array[addr_i][i*16+:16] <= data_i[i*16+:16];
          end
        end
      end
    end
  endgenerate

  // read side

  // per Altera's recommendations. Prevents bypass logic
  always @(posedge clk, negedge rst) begin
    if (~rst) begin
      data_o <= '0;
    end else begin
      data_o <= memory_array[addr_i];
    end
  end
endmodule
