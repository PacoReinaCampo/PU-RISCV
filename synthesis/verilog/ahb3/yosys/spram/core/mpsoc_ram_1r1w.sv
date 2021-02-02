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
//              Memory - 1R1W RAM Block                                       //
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

module mpsoc_ram_1r1w #(
  parameter ABITS      = 10,
  parameter DBITS      = 32,
  parameter TECHNOLOGY = "GENERIC"
)
  (
    input                    rst_ni,
    input                    clk_i,

    //Write side
    input  [ ABITS     -1:0] waddr_i,
    input  [ DBITS     -1:0] din_i,
    input                    we_i,
    input  [(DBITS+7)/8-1:0] be_i,

    //Read side
    input  [ ABITS     -1:0] raddr_i,
    input                    re_i,
    output [ DBITS     -1:0] dout_o
  );

  //////////////////////////////////////////////////////////////////
  //
  // Variables
  //
  logic             contention;
  logic             contention_reg;
  logic [DBITS-1:0] mem_dout;
  logic [DBITS-1:0] din_dly;

  //////////////////////////////////////////////////////////////////
  //
  // Module Body
  //
  generate
    if (TECHNOLOGY == "N3XS" || TECHNOLOGY == "n3xs") begin
      //eASIC N3XS
      mpsoc_ram_1r1w_easic_n3xs #(
        .ABITS ( ABITS ),
        .DBITS ( DBITS )
      )
      ram_inst (
        .rst_ni  ( rst_ni     ),
        .clk_i   ( clk_i      ),

        .waddr_i ( waddr_i    ),
        .din_i   ( din_i      ),
        .we_i    ( we_i       ),
        .be_i    ( be_i       ),

        .raddr_i ( raddr_i    ),
        .re_i    (~contention ),
        .dout_o  ( mem_dout   )
      );
    end
    else if (TECHNOLOGY == "N3X" || TECHNOLOGY == "n3x") begin
      //eASIC N3X
      mpsoc_ram_1r1w_easic_n3x #(
        .ABITS ( ABITS ),
        .DBITS ( DBITS )
      )
      ram_inst (
        .rst_ni  ( rst_ni     ),
        .clk_i   ( clk_i      ),

        .waddr_i ( waddr_i    ),
        .din_i   ( din_i      ),
        .we_i    ( we_i       ),
        .be_i    ( be_i       ),

        .raddr_i ( raddr_i    ),
        .re_i    (~contention ),
        .dout_o  ( mem_dout   )
      );
    end
    else begin //(TECHNOLOGY == "GENERIC")
      //GENERIC  -- inferrable memory

      //initial $display ("INFO   : No memory technology specified. Using generic inferred memory (%m)");
      mpsoc_ram_1r1w_generic #(
        .ABITS ( ABITS ),
        .DBITS ( DBITS )
      )
      ram_inst (
        .rst_ni  ( rst_ni   ),
        .clk_i   ( clk_i    ),

        .waddr_i ( waddr_i  ),
        .din_i   ( din_i    ),
        .we_i    ( we_i     ),
        .be_i    ( be_i     ),

        .raddr_i ( raddr_i  ),
        .dout_o  ( mem_dout )
      );
    end
  endgenerate

  //TODO Handle 'be' ... requires partial old, partial new data

  //now ... write-first; we'll still need some bypass logic
  assign contention = we_i && (raddr_i == waddr_i) ? re_i : 1'b0; //prevent 'x' from propagating from eASIC memories

  always @(posedge clk_i) begin
    contention_reg <= contention;
    din_dly        <= din_i;
  end

  assign dout_o = contention_reg ? din_dly : mem_dout;
endmodule
