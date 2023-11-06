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
//              Core - Fall-through Queue                                     //
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

module pu_riscv_ram_queue #(
  parameter DEPTH                  = 8,
  parameter DBITS                  = 64,
  parameter ALMOST_FULL_THRESHOLD  = 4,
  parameter ALMOST_EMPTY_THRESHOLD = 0
) (
  input wire rst_ni,  // asynchronous, active low reset
  input wire clk_i,   // rising edge triggered clock

  input wire clr_i,  // clear all queue entries (synchronous reset)
  input wire ena_i,  // clock enable

  // Queue Write
  input wire             we_i,  // Queue write enable
  input wire [DBITS-1:0] d_i,   // Queue write data

  // Queue Read
  input  wire             re_i,  // Queue read enable
  output reg  [DBITS-1:0] q_o,   // Queue read data

  // Status signals
  output reg empty_o,         // Queue is empty
  output reg full_o,          // Queue is full
  output reg almost_empty_o,  // Programmable almost empty
  output reg almost_full_o    // Programmable almost full
);

  //////////////////////////////////////////////////////////////////////////////
  // Constants
  //////////////////////////////////////////////////////////////////////////////
  localparam EMPTY_THRESHOLD = 1;
  localparam FULL_THRESHOLD = DEPTH - 2;
  localparam ALMOST_EMPTY_THRESHOLD_CHECK = ALMOST_EMPTY_THRESHOLD <= 0 ? EMPTY_THRESHOLD : ALMOST_EMPTY_THRESHOLD + 1;
  localparam ALMOST_FULL_THRESHOLD_CHECK = ALMOST_FULL_THRESHOLD >= DEPTH ? FULL_THRESHOLD : ALMOST_FULL_THRESHOLD - 2;

  //////////////////////////////////////////////////////////////////////////////
  // Variables
  //////////////////////////////////////////////////////////////////////////////
  logic [DBITS        -1:0] queue_data [DEPTH];
  logic [$clog2(DEPTH)-1:0] queue_xadr;
  logic [$clog2(DEPTH)-1:0] queue_wadr;

  genvar n;

  //////////////////////////////////////////////////////////////////////////////
  // Module Body
  //////////////////////////////////////////////////////////////////////////////

  // Write Address
  always @(posedge clk_i, negedge rst_ni) begin
    if (!rst_ni) begin
      queue_wadr <= 'h0;
    end else if (clr_i) begin
      queue_wadr <= 'h0;
    end else if (ena_i) begin
      case ({
        we_i, re_i
      })
        2'b01:   queue_wadr <= queue_wadr - 1;
        2'b10:   queue_wadr <= queue_wadr + 1;
        default: ;
      endcase
    end
  end

  assign queue_xadr = ~|queue_wadr ? DEPTH - 1 : queue_wadr - 1;

  // Queue Data
  generate
    for (n = 0; n < DEPTH - 1; n = n + 1) begin
      always @(posedge clk_i, negedge rst_ni) begin
        if (!rst_ni) begin
          queue_data[n]       <= 'h0;
          queue_data[DEPTH-1] <= 'h0;
        end else if (clr_i) begin
          queue_data[n]       <= 'h0;
          queue_data[DEPTH-1] <= 'h0;
        end else if (ena_i) begin
          case ({
            we_i, re_i
          })
            2'b01: begin
              queue_data[n]       <= queue_data[n+1];
              queue_data[DEPTH-1] <= 'h0;
            end
            2'b10: begin
              queue_data[queue_wadr] <= d_i;
            end
            2'b11: begin
              queue_data[n]          <= queue_data[n+1];
              queue_data[DEPTH-1]    <= 'h0;
              queue_data[queue_xadr] <= d_i;
            end
            default: ;
          endcase
        end
      end
    end
  endgenerate

  // Queue Almost Empty
  always @(posedge clk_i, negedge rst_ni) begin
    if (!rst_ni) begin
      almost_empty_o <= 1'b1;
    end else if (clr_i) begin
      almost_empty_o <= 1'b1;
    end else if (ena_i) begin
      case ({
        we_i, re_i
      })
        2'b01:   almost_empty_o <= (queue_wadr <= ALMOST_EMPTY_THRESHOLD_CHECK);
        2'b10:   almost_empty_o <= ~(queue_wadr > ALMOST_EMPTY_THRESHOLD_CHECK);
        default: ;
      endcase
    end
  end

  // Queue Empty
  always @(posedge clk_i, negedge rst_ni) begin
    if (!rst_ni) begin
      empty_o <= 1'b1;
    end else if (clr_i) begin
      empty_o <= 1'b1;
    end else if (ena_i) begin
      case ({
        we_i, re_i
      })
        2'b01:   empty_o <= (queue_wadr == EMPTY_THRESHOLD);
        2'b10:   empty_o <= 1'b0;
        default: ;
      endcase
    end
  end

  // Queue Almost Full
  always @(posedge clk_i, negedge rst_ni) begin
    if (!rst_ni) begin
      almost_full_o <= 1'b0;
    end else if (clr_i) begin
      almost_full_o <= 1'b0;
    end else if (ena_i) begin
      case ({
        we_i, re_i
      })
        2'b01:   almost_full_o <= ~(queue_wadr < ALMOST_FULL_THRESHOLD_CHECK);
        2'b10:   almost_full_o <= (queue_wadr >= ALMOST_FULL_THRESHOLD_CHECK);
        default: ;
      endcase
    end
  end

  // Queue Full
  always @(posedge clk_i, negedge rst_ni) begin
    if (!rst_ni) begin
      full_o <= 1'b0;
    end else if (clr_i) begin
      full_o <= 1'b0;
    end else if (ena_i) begin
      case ({
        we_i, re_i
      })
        2'b01:   full_o <= 1'b0;
        2'b10:   full_o <= (queue_wadr == FULL_THRESHOLD);
        default: ;
      endcase
    end
  end

  // Queue output data
  assign q_o = queue_data[0];

`ifdef rl_ram_queue_WARNINGS
  always @(posedge clk_i) begin
    if (empty_o && !we_i && re_i) begin
      $display("rl_ram_queue (%m): underflow @%0t", $time);
    end
    if (full_o && we_i && !re_i) begin
      $display("rl_ram_queue (%m): overflow @%0t", $time);
    end
  end
`endif
endmodule
