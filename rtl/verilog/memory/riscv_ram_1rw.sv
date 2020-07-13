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
//              Memory - 1RW (SP) Memory Block                                //
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

module riscv_ram_1rw #(
  parameter ABITS      = 10,
  parameter DBITS      = 32,
  parameter TECHNOLOGY = "GENERIC"
)
  (
    input                    rst_ni,
    input                    clk_i,

    input  [ ABITS     -1:0] addr_i,
    input                    we_i,
    input  [(DBITS+7)/8-1:0] be_i,
    input  [ DBITS     -1:0] din_i,
    output [ DBITS     -1:0] dout_o
  );

  //////////////////////////////////////////////////////////////////
  //
  // Module Body
  //
  generate
    if (TECHNOLOGY == "N3X" || TECHNOLOGY == "n3x" ) begin
      //eASIC N3X
      riscv_ram_1rw_easic_n3x #(
        .ABITS ( ABITS ),
        .DBITS ( DBITS )
      )
      ram_inst (
        .rst_ni ( rst_ni ),
        .clk_i  ( clk_i  ),

        .addr_i ( addr_i ),
        .we_i   ( we_i   ),
        .be_i   ( be_i   ),
        .din_i  ( din_i  ),
        .dout_o ( dout_o )
      );
    end
    else begin // (TECHNOLOGY == "GENERIC")

      //GENERIC -- inferrable memory

      //initial $display ("INFO   : No memory technology specified. Using generic inferred memory (%m)");

      riscv_ram_1rw_generic #(
        .ABITS ( ABITS ),
        .DBITS ( DBITS )
      )
      ram_inst (
        .rst_ni ( rst_ni ),
        .clk_i  ( clk_i  ),

        .addr_i ( addr_i ),
        .we_i   ( we_i   ),
        .be_i   ( be_i   ),
        .din_i  ( din_i  ),
        .dout_o ( dout_o )
      );
    end
  endgenerate
endmodule
