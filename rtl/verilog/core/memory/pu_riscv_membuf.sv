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
//              Core - Memory Access Buffer                                   //
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

module pu_riscv_membuf #(
  parameter DEPTH = 2,
  parameter DBITS = 64
) (
  input wire rst_ni,
  input wire clk_i,

  input wire clr_i,  // clear pending requests
  input wire ena_i,

  // CPU side
  input wire             req_i,
  input wire [DBITS-1:0] d_i,

  // Memory system side
  output reg              req_o,
  input  wire             ack_i,
  output reg  [DBITS-1:0] q_o,

  output reg empty_o,
  output reg full_o
);

  //////////////////////////////////////////////////////////////////////////////
  // Variables
  //////////////////////////////////////////////////////////////////////////////
  logic [DBITS      -1:0] queue_q;
  logic                   queue_we;
  logic                   queue_re;

  logic [$clog2(DEPTH):0] access_pending;

  //////////////////////////////////////////////////////////////////////////////
  // Module Body
  //////////////////////////////////////////////////////////////////////////////

  // Instantiate Queue 
  pu_riscv_ram_queue #(
    .DEPTH(DEPTH),
    .DBITS(DBITS)
  ) ram_queue (
    .rst_ni        (rst_ni),
    .clk_i         (clk_i),
    .clr_i         (clr_i),
    .ena_i         (ena_i),
    .we_i          (queue_we),
    .d_i           (d_i),
    .re_i          (queue_re),
    .q_o           (queue_q),
    .empty_o       (empty_o),
    .full_o        (full_o),
    .almost_empty_o(),
    .almost_full_o ()
  );

  // control signals
  always @(posedge clk_i, negedge rst_ni) begin
    if (!rst_ni) begin
      access_pending <= 'h0;
    end else if (clr_i) begin
      access_pending <= 'h0;
    end else if (ena_i) begin
      case ({
        req_i, ack_i
      })
        2'b01: begin
          access_pending <= access_pending - 1;
        end
        2'b10: begin
          access_pending <= access_pending + 1;
        end
        default: begin
          // do nothing
        end
      endcase
    end
  end

  assign queue_we = |access_pending & (req_i & ~(empty_o & ack_i));
  assign queue_re = ack_i & ~empty_o;

  // queue outputs
  assign req_o    = ~|access_pending ? req_i & ~clr_i : (req_i | ~empty_o) & ack_i & ena_i & ~clr_i;

  assign q_o      = empty_o ? d_i : queue_q;
endmodule
