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
//              Core - Multiplier Unit                                        //
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

module riscv_mul #(
  parameter XLEN = 64,
  parameter ILEN = 64
)
  (
    input                 rstn,
    input                 clk,

    input                 ex_stall,
    output reg            mul_stall,

    //Instruction
    input                 id_bubble,
    input      [ILEN-1:0] id_instr,

    //Operands
    input      [XLEN-1:0] opA,
    input      [XLEN-1:0] opB,

    //from State
    input      [     1:0] st_xlen,

    //to WB
    output reg            mul_bubble,
    output reg [XLEN-1:0] mul_r
  );

  ////////////////////////////////////////////////////////////////
  //
  // Constants
  //

  localparam DXLEN       = 2*XLEN;

  localparam MAX_LATENCY = 3;
  localparam LATENCY     = `MULT_LATENCY > MAX_LATENCY ? MAX_LATENCY : `MULT_LATENCY;

  ////////////////////////////////////////////////////////////////
  //
  // functions
  //

  function [XLEN-1:0] sext32;
    input [31:0] operand;
    logic sign;

    sign   = operand[31];
    sext32 = { {XLEN-32{sign}}, operand};
  endfunction

  function [XLEN-1:0] twos;
    input [XLEN-1:0] a;

    twos = ~a +'h1;
  endfunction

  function [DXLEN-1:0] twos_dxlen;
    input [DXLEN-1:0] a;

    twos_dxlen = ~a +'h1;
  endfunction

  function [XLEN-1:0] abs;
    input [XLEN-1:0] a;

    abs = a[XLEN-1] ? twos(a) : a;
  endfunction

  ////////////////////////////////////////////////////////////////
  //
  // Constants
  //

  localparam  ST_IDLE =1'b0;
  localparam  ST_WAIT =1'b1;

  ////////////////////////////////////////////////////////////////
  //
  // Variables
  //

  logic              xlen32;
  logic [ILEN  -1:0] mul_instr;

  logic [       6:2] opcode;
  logic [       6:2] mul_opcode;
  logic [       2:0] func3;
  logic [       2:0] mul_func3;
  logic [       6:0] func7;
  logic [       6:0] mul_func7;

  //Operand generation
  logic [      31:0] opA32;
  logic [      31:0] opB32;

  logic              mult_neg;
  logic              mult_neg_reg;
  logic [XLEN  -1:0] mult_opA;
  logic [XLEN  -1:0] mult_opA_reg;
  logic [XLEN  -1:0] mult_opB;
  logic [XLEN  -1:0] mult_opB_reg;
  logic [DXLEN -1:0] mult_r;
  logic [DXLEN -1:0] mult_r_reg;
  logic [DXLEN -1:0] mult_r_signed;
  logic [DXLEN -1:0] mult_r_signed_reg;

  //FSM (bubble, stall generation)
  logic       is_mul;
  logic [1:0] cnt;
  logic       state;

  ////////////////////////////////////////////////////////////////
  //
  // Module Body
  //

  //Instruction
  assign func7      = id_instr[31:25];
  assign func3      = id_instr[14:12];
  assign opcode     = id_instr[ 6: 2];

  assign mul_func7  = mul_instr[31:25];
  assign mul_func3  = mul_instr[14:12];
  assign mul_opcode = mul_instr[ 6: 2];

  assign xlen32     = st_xlen == `RV32I;

  //32bit operands
  assign opA32   = opA[31:0];
  assign opB32   = opB[31:0];

  /*
   *  Multiply operations
   *
   * Transform all multiplications into 1 unsigned multiplication
   * This avoids building multiple multipliers (signed x signed, signed x unsigned, unsigned x unsigned)
   *   at the expense of potentially making the path slower
   */

  //multiplier operand-A
  always @(*) begin
    casex ( {func7,func3,opcode} )
      `MULW   : mult_opA = abs( sext32(opA32) ); //RV64
      `MULHU  : mult_opA =             opA     ;
      default : mult_opA = abs(        opA    );
    endcase
  end

  //multiplier operand-B
  always @(*) begin
    casex ( {func7,func3,opcode} )
      `MULW   : mult_opB = abs( sext32(opB32) ); //RV64
      `MULHSU : mult_opB =             opB     ;
      `MULHU  : mult_opB =             opB     ;
      default : mult_opB = abs(        opB    );
    endcase
  end

  //negate multiplier output?
  always @(*) begin
    casex ( {func7,func3,opcode} )
      `MUL    : mult_neg = opA[XLEN-1] ^ opB[XLEN-1];
      `MULH   : mult_neg = opA[XLEN-1] ^ opB[XLEN-1];
      `MULHSU : mult_neg = opA[XLEN-1];
      `MULHU  : mult_neg = 1'b0;
      `MULW   : mult_neg = opA32[31] ^ opB32[31];  //RV64
      default : mult_neg = 'hx;
    endcase
  end

  //Actual multiplier
  assign mult_r        = $unsigned(mult_opA_reg) * $unsigned(mult_opB_reg);

  //Correct sign
  assign mult_r_signed = mult_neg_reg ? twos_dxlen(mult_r_reg) : mult_r_reg;

  generate
    if (LATENCY == 0) begin

      /*
       * Single cycle multiplier
       *
       * Registers at: - output
       */

      //Register holding instruction for multiplier-output-selector
      assign mul_instr = id_instr;

      //Registers holding multiplier operands
      assign mult_opA_reg = mult_opA;
      assign mult_opB_reg = mult_opB;
      assign mult_neg_reg = mult_neg;

      //Register holding multiplier output
      assign mult_r_reg = mult_r;

      //Register holding sign correction
      assign mult_r_signed_reg = mult_r_signed;
    end
    else begin

      /*
       * Multi cycle multiplier
       *
       * Registers at: - input
       *               - output
       */

      //Register holding instruction for multiplier-output-selector
      always @(posedge clk) begin
        if (!ex_stall) mul_instr <= id_instr;
      end

      //Registers holding multiplier operands
      always @(posedge clk) begin
        if (!ex_stall) begin
          mult_opA_reg <= mult_opA;
          mult_opB_reg <= mult_opB;
          mult_neg_reg <= mult_neg;
        end
      end

      if (LATENCY == 1) begin
        //Register holding multiplier output
        assign mult_r_reg = mult_r;

        //Register holding sign correction
        assign mult_r_signed_reg = mult_r_signed;
      end
      else if (LATENCY == 2) begin
        //Register holding multiplier output
        always @(posedge clk) begin
          mult_r_reg <= mult_r;
        end

        //Register holding sign correction
        assign mult_r_signed_reg = mult_r_signed;
      end
      else begin
        //Register holding multiplier output
        always @(posedge clk) begin
          mult_r_reg <= mult_r;
        end

        //Register holding sign correction
        always @(posedge clk) begin
          mult_r_signed_reg <= mult_r_signed;
        end
      end
    end
  endgenerate

  //Final output register
  always @(posedge clk) begin
    casex ( {mul_func7,mul_func3,mul_opcode} )
      `MUL    : mul_r <= mult_r_signed_reg[XLEN -1:   0];
      `MULW   : mul_r <= sext32( mult_r_signed_reg[31:0] );  //RV64
      default : mul_r <= mult_r_signed_reg[DXLEN-1:XLEN];
    endcase
  end

  //Stall / Bubble generation
  always @(*) begin
    casex ( {func7,func3,opcode} )
      `MUL    : is_mul = 1'b1;
      `MULH   : is_mul = 1'b1;
      `MULW   : is_mul = ~xlen32;
      `MULHSU : is_mul = 1'b1;
      `MULHU  : is_mul = 1'b1;
      default : is_mul = 1'b0;
    endcase
  end

  always @(posedge clk,negedge rstn) begin
    if (!rstn) begin
      state      <= ST_IDLE;
      cnt        <= LATENCY;

      mul_bubble <= 1'b1;
      mul_stall  <= 1'b0;
    end
    else begin
      mul_bubble <= 1'b1;
      case (state)
        ST_IDLE: if (!ex_stall)
          if (!id_bubble && is_mul) begin
            if (LATENCY == 0) begin
              mul_bubble <= 1'b0;
              mul_stall  <= 1'b0;
            end
            else begin
              state      <= ST_WAIT;
              cnt        <= cnt -1;

              mul_bubble <= 1'b1;
              mul_stall  <= 1'b1;
            end
          end
        ST_WAIT: if (|cnt)
          cnt <= cnt -1;
        else begin
          state <= ST_IDLE;
          cnt   <= LATENCY;

          mul_bubble <= 1'b0;
          mul_stall  <= 1'b0;
        end
      endcase
    end
  end
endmodule
