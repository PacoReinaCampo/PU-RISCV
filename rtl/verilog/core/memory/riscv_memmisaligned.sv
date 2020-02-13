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
//              Core - Misalignment Check                                     //
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
 *   Francisco Javier Reina Campo <frareicam@gmail.com>
 */

`include "riscv_mpsoc_pkg.sv"

module riscv_memmisaligned #(
  parameter XLEN    = 64,
  parameter HAS_RVC = 1
)
  (
    input  logic              clk_i,

    //CPU side
    input  logic              instruction_i,
    input  logic              req_i,
    input  logic [XLEN  -1:0] adr_i,
    input  logic [       2:0] size_i,

    //To memory subsystem
    output logic              misaligned_o
  );

  //////////////////////////////////////////////////////////////////
  //
  // Variables
  //
  logic misaligned;

  //////////////////////////////////////////////////////////////////
  //
  // Module Body
  //
  always @(*) begin
    if (instruction_i)
      misaligned = (HAS_RVC != 0) ? adr_i[0] : |adr_i[1:0];
    else begin
      case (size_i)
        `BYTE   : misaligned = 1'b0;
        `HWORD  : misaligned =  adr_i[  0];
        `WORD   : misaligned = |adr_i[1:0];
        `DWORD  : misaligned = |adr_i[2:0];
        default : misaligned = 1'b1;
      endcase
    end
  end

  always @(posedge clk_i) begin
    misaligned_o <= req_i & misaligned;
  end
endmodule
