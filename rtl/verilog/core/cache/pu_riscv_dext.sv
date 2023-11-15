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
//              Core - Data External Access Logic                             //
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

module pu_riscv_dext #(
  parameter XLEN  = 64,
  parameter PLEN  = 64,  // Physical address bus size
  parameter DEPTH = 2    // number of instructions in flight
) (
  input wire rst_ni,
  input wire clk_i,
  input wire clr_i,

  // CPU side
  input  wire             mem_req_i,
  input  wire [XLEN -1:0] mem_adr_i,
  input  wire [      2:0] mem_size_i,
  input  wire [      2:0] mem_type_i,
  input  wire             mem_lock_i,
  input  wire [      2:0] mem_prot_i,
  input  wire             mem_we_i,
  input  wire [XLEN -1:0] mem_d_i,
  output reg              mem_adr_ack_o,  // acknowledge address phase
  output reg  [PLEN -1:0] mem_adr_o,
  output reg  [XLEN -1:0] mem_q_o,
  output reg              mem_ack_o,      // acknowledge data transfer
  output reg              mem_err_o,      // data transfer error

  // To BIU
  output reg              biu_stb_o,
  input  wire             biu_stb_ack_i,
  output reg  [PLEN -1:0] biu_adri_o,
  input  wire [PLEN -1:0] biu_adro_i,
  output reg  [      2:0] biu_size_o,     // transfer size
  output reg  [      2:0] biu_type_o,     // burst type
  output reg              biu_lock_o,
  output reg  [      2:0] biu_prot_o,
  output reg              biu_we_o,
  output reg  [XLEN -1:0] biu_d_o,
  input  wire [XLEN -1:0] biu_q_i,
  input  wire             biu_ack_i,      // data acknowledge, 1 per data
  input  wire             biu_err_i       // data error
);

  //////////////////////////////////////////////////////////////////////////////
  // Variables
  //////////////////////////////////////////////////////////////////////////////
  logic                   hold_mem_req;
  logic [XLEN       -1:0] hold_mem_adr;
  logic [XLEN       -1:0] hold_mem_d;
  logic [            2:0] hold_mem_size;
  logic [            2:0] hold_mem_type;
  logic [            2:0] hold_mem_prot;
  logic                   hold_mem_lock;
  logic                   hold_mem_we;

  logic [$clog2(DEPTH):0] inflight;
  logic [$clog2(DEPTH):0] discard;

  //////////////////////////////////////////////////////////////////////////////
  // Module Body
  //////////////////////////////////////////////////////////////////////////////

  // State Machine
  always @(posedge clk_i) begin
    if (mem_req_i) begin
      hold_mem_adr  <= mem_adr_i;
      hold_mem_size <= mem_size_i;
      hold_mem_type <= mem_type_i;
      hold_mem_lock <= mem_lock_i;
      hold_mem_we   <= mem_we_i;
      hold_mem_d    <= mem_d_i;
    end
  end

  always @(posedge clk_i) begin
    if (!rst_ni) begin
      hold_mem_req <= 1'b0;
    end else if (clr_i) begin
      hold_mem_req <= 1'b0;
    end else begin
      hold_mem_req <= (mem_req_i | hold_mem_req) & ~biu_stb_ack_i;
    end
  end

  always @(posedge clk_i, negedge rst_ni) begin
    if (!rst_ni) begin
      inflight <= 'h0;
    end else begin
      case ({
        biu_stb_ack_i, biu_ack_i | biu_err_i
      })
        2'b01: begin
          inflight <= inflight - 1;
        end
        2'b10: begin
          inflight <= inflight + 1;
        end
        default: begin
          // do nothing
        end
      endcase
    end
  end

  always @(posedge clk_i, negedge rst_ni) begin
    if (!rst_ni) begin
      discard <= 'h0;
    end else if (clr_i) begin
      if (|inflight && (biu_ack_i | biu_err_i)) begin
        discard <= inflight - 1;
      end else begin
        discard <= inflight;
      end
    end else if (|discard && (biu_ack_i | biu_err_i)) begin
      discard <= discard - 1;
    end
  end

  // External Interface
  assign biu_stb_o     = (mem_req_i | hold_mem_req) & ~clr_i;
  assign biu_adri_o    = hold_mem_req ? hold_mem_adr : mem_adr_i;
  assign biu_size_o    = hold_mem_req ? hold_mem_size : mem_size_i;
  assign biu_lock_o    = hold_mem_req ? hold_mem_lock : mem_lock_i;
  assign biu_prot_o    = hold_mem_req ? hold_mem_prot : mem_prot_i;
  assign biu_we_o      = hold_mem_req ? hold_mem_we : mem_we_i;
  assign biu_d_o       = hold_mem_req ? hold_mem_d : mem_d_i;
  assign biu_type_o    = hold_mem_req ? hold_mem_type : mem_type_i;

  assign mem_adr_ack_o = biu_stb_ack_i;
  assign mem_adr_o     = biu_adro_i;
  assign mem_q_o       = biu_q_i;
  assign mem_ack_o     = |discard ? 1'b0 : |inflight ? biu_ack_i & ~clr_i : biu_ack_i & biu_stb_o;
  assign mem_err_o     = |discard ? 1'b0 : |inflight ? biu_err_i & ~clr_i : biu_err_i & biu_stb_o;
endmodule
