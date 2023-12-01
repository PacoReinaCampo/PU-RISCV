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
//              Core - Division Unit                                          //
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

import pu_riscv_verilog_pkg::*;

module pu_riscv_divider #(
  parameter XLEN = 64,
  parameter ILEN = 64
) (
  input rstn,
  input clk,

  input      ex_stall,
  output reg div_stall,

  // Instruction
  input            id_bubble,
  input [ILEN-1:0] id_instr,

  // Operands
  input [XLEN-1:0] opA,
  input [XLEN-1:0] opB,

  // From State
  input [1:0] st_xlen,

  // To WB
  output reg            div_bubble,
  output reg [XLEN-1:0] div_r
);

  //////////////////////////////////////////////////////////////////////////////
  // Functions
  //////////////////////////////////////////////////////////////////////////////

  function [XLEN-1:0] sext32;
    input [31:0] operand;
    logic sign;

    sign   = operand[31];
    sext32 = {{XLEN - 32{sign}}, operand};
  endfunction

  function [XLEN-1:0] twos;
    input [XLEN-1:0] a;

    twos = ~a + 'h1;
  endfunction

  function [XLEN-1:0] abs;
    input [XLEN-1:0] a;

    abs = a[XLEN-1] ? twos(a) : a;
  endfunction

  //////////////////////////////////////////////////////////////////////////////
  // Constants
  //////////////////////////////////////////////////////////////////////////////

  localparam ST_CHK = 2'b00;
  localparam ST_DIV = 2'b01;
  localparam ST_RES = 2'b10;

  //////////////////////////////////////////////////////////////////////////////
  // Variables
  //////////////////////////////////////////////////////////////////////////////

  logic                    xlen32;
  logic [ILEN        -1:0] div_instr;

  logic [             6:2] opcode;
  logic [             6:2] div_opcode;
  logic [             2:0] func3;
  logic [             2:0] div_func3;
  logic [             6:0] func7;
  logic [             6:0] div_func7;

  // Operand generation
  logic [            31:0] opA32;
  logic [            31:0] opB32;

  logic [$clog2(XLEN)-1:0] cnt;
  logic                    neg_q;  // negate quotient
  logic                    neg_s;  // negate remainder

  // divider internals
  logic [XLEN        -1:0] pa_p;
  logic [XLEN        -1:0] pa_a;
  logic [XLEN        -1:0] pa_shifted_p;
  logic [XLEN        -1:0] pa_shifted_a;

  logic [        XLEN : 0] p_minus_b;
  logic [XLEN        -1:0] b;

  // FSM
  logic [             1:0] state;

  //////////////////////////////////////////////////////////////////////////////
  // Body
  //////////////////////////////////////////////////////////////////////////////

  // Instruction
  assign func7      = id_instr[31:25];
  assign func3      = id_instr[14:12];
  assign opcode     = id_instr[6:2];

  assign div_func7  = div_instr[31:25];
  assign div_func3  = div_instr[14:12];
  assign div_opcode = div_instr[6:2];

  assign xlen32     = st_xlen == RV32I;

  // retain instruction
  always @(posedge clk) begin
    if (!ex_stall) begin
      div_instr <= id_instr;
    end
  end

  // 32bit operands
  assign opA32                        = opA[31:0];
  assign opB32                        = opB[31:0];

  // Divide operations
  assign {pa_shifted_p, pa_shifted_a} = {pa_p, pa_a} << 1;
  assign p_minus_b                    = pa_shifted_p - b;

  // Division: bit-serial. Max XLEN cycles
  // q = z/d + s
  // z: Dividend
  // d: Divisor
  // q: Quotient
  // s: Remainder
  always @(posedge clk, negedge rstn) begin
    if (!rstn) begin
      state      <= ST_CHK;
      div_bubble <= 1'b1;
      div_stall  <= 1'b0;

      div_r      <= 'hx;

      pa_p       <= 'hx;
      pa_a       <= 'hx;
      b          <= 'hx;
      neg_q      <= 1'bx;
      neg_s      <= 1'bx;
    end else begin
      div_bubble <= 1'b1;

      case (state)
        // Check for exceptions (divide by zero, signed overflow)
        // Setup dividor registers
        ST_CHK: begin
          if (!ex_stall && !id_bubble) begin
            casex ({
              xlen32, func7, func3, opcode
            })
              {
                1'b?, DIV
              } : begin
                if (~|opB) begin
                  // signed divide by zero
                  div_r      <= {XLEN{1'b1}};  // =-1
                  div_bubble <= 1'b0;
                end else if (opA == {1'b1, {XLEN - 1{1'b0}}} && &opB) begin
                  // signed overflow (Dividend=-2^(XLEN-1), Divisor=-1)
                  div_r      <= {1'b1, {XLEN - 1{1'b0}}};
                  div_bubble <= 1'b0;
                end else begin
                  cnt       <= {$bits(cnt) {1'b1}};
                  state     <= ST_DIV;
                  div_stall <= 1'b1;

                  neg_q     <= opA[XLEN-1] ^ opB[XLEN-1];
                  neg_s     <= opA[XLEN-1];

                  pa_p      <= 'h0;
                  pa_a      <= abs(opA);
                  b         <= abs(opB);
                end
              end
              {
                1'b0, DIVW
              } : begin
                if (~|opB32) begin
                  // signed divide by zero
                  div_r      <= {XLEN{1'b1}};  // =-1
                  div_bubble <= 1'b0;
                end else if (opA32 == {1'b1, {31{1'b0}}} && &opB32) begin
                  // signed overflow (Dividend=-2^(XLEN-1), Divisor=-1)
                  div_r      <= sext32({1'b1, {31{1'b0}}});
                  div_bubble <= 1'b0;
                end else begin
                  cnt       <= {1'b0, {$bits(cnt) - 1{1'b1}}};
                  state     <= ST_DIV;
                  div_stall <= 1'b1;

                  neg_q     <= opA32[31] ^ opB32[31];
                  neg_s     <= opA32[31];

                  pa_p      <= 'h0;
                  pa_a      <= {abs(sext32(opA32)), {XLEN - 32{1'b0}}};
                  b         <= abs(sext32(opB32));
                end
              end
              {
                1'b?, DIVU
              } : begin
                if (~|opB) begin
                  // unsigned divide by zero
                  div_r      <= {XLEN{1'b1}};  // = 2^XLEN -1
                  div_bubble <= 1'b0;
                end else begin
                  cnt       <= {$bits(cnt) {1'b1}};
                  state     <= ST_DIV;
                  div_stall <= 1'b1;

                  neg_q     <= 1'b0;
                  neg_s     <= 1'b0;

                  pa_p      <= 'h0;
                  pa_a      <= opA;
                  b         <= opB;
                end
              end
              {
                1'b0, DIVUW
              } : begin
                if (~|opB32) begin
                  // unsigned divide by zero
                  div_r      <= {XLEN{1'b1}};  // = 2^XLEN -1
                  div_bubble <= 1'b0;
                end else begin
                  cnt       <= {1'b0, {$bits(cnt) - 1{1'b1}}};
                  state     <= ST_DIV;
                  div_stall <= 1'b1;

                  neg_q     <= 1'b0;
                  neg_s     <= 1'b0;

                  pa_p      <= 'h0;
                  pa_a      <= {opA32, {XLEN - 32{1'b0}}};
                  b         <= {{XLEN - 32{1'b0}}, opB32};
                end
              end
              {
                1'b?, REM
              } : begin
                if (~|opB) begin
                  // signed divide by zero
                  div_r      <= opA;
                  div_bubble <= 1'b0;
                end else if (opA == {1'b1, {XLEN - 1{1'b0}}} && &opB) begin
                  // signed overflow (Dividend=-2^(XLEN-1), Divisor=-1)
                  div_r      <= 'h0;
                  div_bubble <= 1'b0;
                end else begin
                  cnt       <= {$bits(cnt) {1'b1}};
                  state     <= ST_DIV;
                  div_stall <= 1'b1;

                  neg_q     <= opA[XLEN-1] ^ opB[XLEN-1];
                  neg_s     <= opA[XLEN-1];

                  pa_p      <= 'h0;
                  pa_a      <= abs(opA);
                  b         <= abs(opB);
                end
              end
              {
                1'b0, REMW
              } : begin
                if (~|opB32) begin
                  // signed divide by zero
                  div_r      <= sext32(opA32);
                  div_bubble <= 1'b0;
                end else if (opA32 == {1'b1, {31{1'b0}}} && &opB32) begin
                  // signed overflow (Dividend=-2^(XLEN-1), Divisor=-1)
                  div_r      <= 'h0;
                  div_bubble <= 1'b0;
                end else begin
                  cnt       <= {1'b0, {$bits(cnt) - 1{1'b1}}};
                  state     <= ST_DIV;
                  div_stall <= 1'b1;

                  neg_q     <= opA32[31] ^ opB32[31];
                  neg_s     <= opA32[31];

                  pa_p      <= 'h0;
                  pa_a      <= {abs(sext32(opA32)), {XLEN - 32{1'b0}}};
                  b         <= abs(sext32(opB32));
                end
              end
              {
                1'b?, REMU
              } : begin
                if (~|opB) begin
                  // unsigned divide by zero
                  div_r      <= opA;
                  div_bubble <= 1'b0;
                end else begin
                  cnt       <= {$bits(cnt) {1'b1}};
                  state     <= ST_DIV;
                  div_stall <= 1'b1;

                  neg_q     <= 1'b0;
                  neg_s     <= 1'b0;

                  pa_p      <= 'h0;
                  pa_a      <= opA;
                  b         <= opB;
                end
              end
              {
                1'b0, REMUW
              } : begin
                if (~|opB32) begin
                  div_r      <= sext32(opA32);
                  div_bubble <= 1'b0;
                end else begin
                  cnt       <= {1'b0, {$bits(cnt) - 1{1'b1}}};
                  state     <= ST_DIV;
                  div_stall <= 1'b1;

                  neg_q     <= 1'b0;
                  neg_s     <= 1'b0;

                  pa_p      <= 'h0;
                  pa_a      <= {opA32, {XLEN - 32{1'b0}}};
                  b         <= {{XLEN - 32{1'b0}}, opB32};
                end
              end
              default: begin
              end
            endcase
          end
        end
        // actual division loop
        ST_DIV: begin
          cnt <= cnt - 1;
          if (~|cnt) begin
            state <= ST_RES;
          end
          // restoring divider section
          if (p_minus_b[XLEN]) begin
            // sub gave negative result
            pa_p <= pa_shifted_p;  // restore
            pa_a <= {pa_shifted_a[XLEN-1:1], 1'b0};  // shift in '0' for Q
          end else begin
            // sub gave positive result
            pa_p <= p_minus_b[XLEN-1:0];  // store sub result
            pa_a <= {pa_shifted_a[XLEN-1:1], 1'b1};  // shift in '1' for Q
          end
        end
        // Result
        ST_RES: begin
          state      <= ST_CHK;
          div_bubble <= 1'b0;
          div_stall  <= 1'b0;
          casex ({
            div_func7, div_func3, div_opcode
          })
            DIV:     div_r <= neg_q ? twos(pa_a) : pa_a;
            DIVW:    div_r <= sext32(neg_q ? twos(pa_a) : pa_a);
            DIVU:    div_r <= pa_a;
            DIVUW:   div_r <= sext32(pa_a);
            REM:     div_r <= neg_s ? twos(pa_p) : pa_p;
            REMW:    div_r <= sext32(neg_s ? twos(pa_p) : pa_p);
            REMU:    div_r <= pa_p;
            REMUW:   div_r <= sext32(pa_p);
            default: div_r <= 'hx;
          endcase
        end
      endcase
    end
  end
endmodule
