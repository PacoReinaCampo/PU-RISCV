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

module mpsoc_wb_ram_generic #(
  parameter DEPTH   = 256,
  parameter MEMFILE = "",

  parameter AW = $clog2(DEPTH),
  parameter DW = 32
)
  (
    input               clk,
    input      [   3:0] we,
    input      [DW-1:0] din,
    input      [AW-1:0] waddr,
    input      [AW-1:0] raddr,
    output reg [DW-1:0] dout
  );

  //////////////////////////////////////////////////////////////////
  //
  // Variables
  //
  reg [DW-1:0] mem [0:DEPTH-1] /* verilator public */;

  //////////////////////////////////////////////////////////////////
  //
  // Module Body
  //
  always @(posedge clk) begin
    if (we[0]) mem[waddr][7:0]   <= din[7:0];
    if (we[1]) mem[waddr][15:8]  <= din[15:8];
    if (we[2]) mem[waddr][23:16] <= din[23:16];
    if (we[3]) mem[waddr][31:24] <= din[31:24];
    dout <= mem[raddr];
  end

  generate
    initial
      if(MEMFILE != "") begin
        $display("Preloading %m from %s", MEMFILE);
        $readmemh(MEMFILE, mem);
      end
  endgenerate
endmodule
