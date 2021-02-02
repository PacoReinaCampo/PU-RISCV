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
//              Memory - Technology Independent (Inferrable) Memory Wrapper   //
//              AMBA3 AHB-Lite Bus Interface                                  //
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
 *   Paco Reina Campo <pacoreinacampo@queenfield.tech>
 */

module mpsoc_ram_1r1w_generic #(
  parameter ABITS = 10,
  parameter DBITS = 32
)
  (
    input                        rst_ni,
    input                        clk_i,

    //Write side
    input      [ ABITS     -1:0] waddr_i,
    input      [ DBITS     -1:0] din_i,
    input                        we_i,
    input      [(DBITS+7)/8-1:0] be_i,

    //Read side
    input      [ ABITS     -1:0] raddr_i,
    output reg [ DBITS     -1:0] dout_o
  );

  //////////////////////////////////////////////////////////////////
  //
  // Variables
  //
  genvar i;

  logic [DBITS-1:0] mem_array [2**ABITS -1:0];  //memory array

  //////////////////////////////////////////////////////////////////
  //
  // Module Body
  //

  //write side
  generate
    for (i=0; i<(DBITS+7)/8; i=i+1) begin: write
      if (i*8 +8 > DBITS) begin
        always @(posedge clk_i) begin
          if (we_i && be_i[i])
            mem_array[ waddr_i ] [DBITS-1:i*8] <= din_i[DBITS-1:i*8];
        end
      end
      else begin
        always @(posedge clk_i) begin
          if (we_i && be_i[i])
            mem_array[ waddr_i ][i*8+:8] <= din_i[i*8+:8];
        end
      end
    end
  endgenerate

  //read side

  //per Altera's recommendations. Prevents bypass logic
  always @(posedge clk_i) begin
    dout_o <= mem_array[ raddr_i ];
  end
endmodule
