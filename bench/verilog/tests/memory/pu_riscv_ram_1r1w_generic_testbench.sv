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
//   Paco Reina Campo <pacoreinacampo@queenfield.tech>

module pu_riscv_ram_1r1w_generic_testbench;

  //////////////////////////////////////////////////////////////////////////////
  // Constants
  //////////////////////////////////////////////////////////////////////////////

  parameter ABITS = 16;
  parameter DBITS = 32;

  //////////////////////////////////////////////////////////////////////////////
  // Variables
  //////////////////////////////////////////////////////////////////////////////

  // Global
  reg                   rst_ni;
  reg                   clk_i;

  // Write side
  reg [ ABITS     -1:0] waddr_i;
  reg [ DBITS     -1:0] din_i;
  reg                   we_i;
  reg [(DBITS+7)/8-1:0] be_i;

  // Read side
  reg [ ABITS     -1:0] raddr_i;
  reg                   re_i;
  reg [ DBITS     -1:0] dout_o;

  //////////////////////////////////////////////////////////////////////////////
  // Module Body
  //////////////////////////////////////////////////////////////////////////////

  // DUT
  pu_riscv_ram_1r1w_generic #(
    .ABITS(ABITS),
    .DBITS(DBITS)
  ) ram_1r1w_generic (
    .rst_ni(rst_ni),
    .clk_i (clk_i),

    .waddr_i(waddr_i),
    .din_i  (din_i),
    .we_i   (we_i),
    .be_i   (be_i),

    .raddr_i(raddr_i),
    .dout_o (mem_dout)
  );

  // STIMULUS

  always #1 clk_i = ~clk_i;

  initial begin
    // Dump waves
    $dumpfile("system.vcd");
    $dumpvars(0, pu_riscv_ram_1r1w_generic_testbench);

    clk_i  = 0;
    rst_ni = 0;

    rst_ni = 1;
    #2;

    $display("End");
    $finish();
  end
endmodule
