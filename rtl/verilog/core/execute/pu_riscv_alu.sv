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
//              Core - Arithmetic & Logical Unit                              //
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

import pu_riscv_pkg::*;

module pu_riscv_alu #(
  parameter XLEN    = 64,
  parameter ILEN    = 64,
  parameter HAS_RVC = 1
)
  (
    input                  rstn,
    input                  clk,

    input                  ex_stall,

    //Program counter
    input      [XLEN-1:0] id_pc,

    //Instruction
    input                 id_bubble,
    input      [ILEN-1:0] id_instr,

    //Operands
    input      [XLEN-1:0] opA,
    input      [XLEN-1:0] opB,

    //to WB
    output reg            alu_bubble,
    output reg [XLEN-1:0] alu_r,

    //To State
    output     [    11:0] ex_csr_reg,
    output reg [XLEN-1:0] ex_csr_wval,
    output reg            ex_csr_we,

    //From State
    input      [XLEN-1:0] st_csr_rval,
    input      [     1:0] st_xlen
  );

  ////////////////////////////////////////////////////////////////
  //
  // functions
  //

  function [XLEN-1:0] sext32;
    input [31:0] operand;
    logic sign;

    sign   = operand[31];
    sext32 = { {XLEN-31{sign}}, operand[30:0]};
  endfunction

  ////////////////////////////////////////////////////////////////
  //
  // Constants
  //
  localparam SBITS=$clog2(XLEN);

  ////////////////////////////////////////////////////////////////
  //
  // Variables
  //
  logic [             6:2] opcode;
  logic [             2:0] func3;
  logic [             6:0] func7;
  logic [             4:0] rs1;
  logic                    xlen32;
  logic                    has_rvc;

  //Operand generation
  logic [            31:0] opA32;
  logic [            31:0] opB32;
  logic [SBITS       -1:0] shamt;
  logic [             4:0] shamt32;
  logic [XLEN        -1:0] csri;

  ////////////////////////////////////////////////////////////////
  //
  // Module Body
  //

  //Instruction
  assign func7  = id_instr[31:25];
  assign func3  = id_instr[14:12];
  assign opcode = id_instr[ 6: 2];

  assign xlen32  = (st_xlen == RV32I);
  assign has_rvc = (HAS_RVC !=     0);

  assign opA32   = opA[     31:0];
  assign opB32   = opB[     31:0];
  assign shamt   = opB[SBITS-1:0];
  assign shamt32 = opB[      4:0];

  //ALU operations
  always @(posedge clk, negedge rstn) begin
    if      (!rstn    )
      alu_r <= 'h0;
    else if (!ex_stall) begin
      casex ( {xlen32,func7,func3,opcode} )
        {1'b?,LUI   }: alu_r <= opA + opB; //actually just opB, but simplify encoding
        {1'b?,AUIPC }: alu_r <= opA + opB;
        {1'b?,JAL   }: alu_r <= id_pc + 'h4;
        {1'b?,JALR  }: alu_r <= id_pc + 'h4;
        //logical operators
        {1'b?,ADDI  }: alu_r <= opA + opB;
        {1'b?,ADD   }: alu_r <= opA + opB;
        {1'b0,ADDIW }: alu_r <= sext32(opA32 + opB32);    //RV64
        {1'b0,ADDW  }: alu_r <= sext32(opA32 + opB32);    //RV64
        {1'b?,SUB   }: alu_r <= opA - opB;
        {1'b0,SUBW  }: alu_r <= sext32(opA32 - opB32);    //RV64
        {1'b?,XORI  }: alu_r <= opA ^ opB;
        {1'b?,XORX  }: alu_r <= opA ^ opB;
        {1'b?,ORI   }: alu_r <= opA | opB;
        {1'b?,ORX   }: alu_r <= opA | opB;
        {1'b?,ANDI  }: alu_r <= opA & opB;
        {1'b?,ANDX  }: alu_r <= opA & opB;
        {1'b?,SLLI  }: alu_r <= opA << shamt;
        {1'b?,SLLX  }: alu_r <= opA << shamt;
        {1'b0,SLLIW }: alu_r <= sext32(opA32 << shamt32); //RV64
        {1'b0,SLLW  }: alu_r <= sext32(opA32 << shamt32); //RV64
        {1'b?,SLTI  }: alu_r <= {~opA[XLEN-1],opA[XLEN-2:0]} < {~opB[XLEN-1],opB[XLEN-2:0]} ? 'h1 : 'h0;
        {1'b?,SLT   }: alu_r <= {~opA[XLEN-1],opA[XLEN-2:0]} < {~opB[XLEN-1],opB[XLEN-2:0]} ? 'h1 : 'h0;
        {1'b?,SLTIU }: alu_r <= opA < opB ? 'h1 : 'h0;
        {1'b?,SLTU  }: alu_r <= opA < opB ? 'h1 : 'h0;
        {1'b?,SRLI  }: alu_r <= opA >> shamt;
        {1'b?,SRLX  }: alu_r <= opA >> shamt;
        {1'b0,SRLIW }: alu_r <= sext32(opA32 >> shamt32); //RV64
        {1'b0,SRLW  }: alu_r <= sext32(opA32 >> shamt32); //RV64
        {1'b?,SRAI  }: alu_r <= $signed(opA) >>> shamt;
        {1'b?,SRAX  }: alu_r <= $signed(opA) >>> shamt;
        {1'b0,SRAIW }: alu_r <= sext32($signed(opA32) >>> shamt32);
        {1'b?,SRAW  }: alu_r <= sext32($signed(opA32) >>> shamt32);
        //CSR access
        {1'b?,CSRRW }: alu_r <= {XLEN{1'b0}} | st_csr_rval;
        {1'b?,CSRRWI}: alu_r <= {XLEN{1'b0}} | st_csr_rval;
        {1'b?,CSRRS }: alu_r <= {XLEN{1'b0}} | st_csr_rval;
        {1'b?,CSRRSI}: alu_r <= {XLEN{1'b0}} | st_csr_rval;
        {1'b?,CSRRC }: alu_r <= {XLEN{1'b0}} | st_csr_rval;
        {1'b?,CSRRCI}: alu_r <= {XLEN{1'b0}} | st_csr_rval;
        default      : alu_r <= 'hx;
      endcase
    end
  end

  always @(posedge clk, negedge rstn) begin
    if (!rstn) alu_bubble <= 1'b1;
    else if (!ex_stall) begin
      casex ( {xlen32,func7,func3,opcode} )
        {1'b?,LUI   }: alu_bubble <= id_bubble;
        {1'b?,AUIPC }: alu_bubble <= id_bubble;
        {1'b?,JAL   }: alu_bubble <= id_bubble;
        {1'b?,JALR  }: alu_bubble <= id_bubble;
        //logical operators
        {1'b?,ADDI  }: alu_bubble <= id_bubble;
        {1'b?,ADD   }: alu_bubble <= id_bubble;
        {1'b0,ADDIW }: alu_bubble <= id_bubble;
        {1'b0,ADDW  }: alu_bubble <= id_bubble;
        {1'b?,SUB   }: alu_bubble <= id_bubble;
        {1'b0,SUBW  }: alu_bubble <= id_bubble;
        {1'b?,XORI  }: alu_bubble <= id_bubble;
        {1'b?,XORX  }: alu_bubble <= id_bubble;
        {1'b?,ORI   }: alu_bubble <= id_bubble;
        {1'b?,ORX   }: alu_bubble <= id_bubble;
        {1'b?,ANDI  }: alu_bubble <= id_bubble;
        {1'b?,ANDX  }: alu_bubble <= id_bubble;
        {1'b?,SLLI  }: alu_bubble <= id_bubble;
        {1'b?,SLLX  }: alu_bubble <= id_bubble;
        {1'b0,SLLIW }: alu_bubble <= id_bubble;
        {1'b0,SLLW  }: alu_bubble <= id_bubble;
        {1'b?,SLTI  }: alu_bubble <= id_bubble;
        {1'b?,SLT   }: alu_bubble <= id_bubble;
        {1'b?,SLTIU }: alu_bubble <= id_bubble;
        {1'b?,SLTU  }: alu_bubble <= id_bubble;
        {1'b?,SRLI  }: alu_bubble <= id_bubble;
        {1'b?,SRLX  }: alu_bubble <= id_bubble;
        {1'b0,SRLIW }: alu_bubble <= id_bubble;
        {1'b0,SRLW  }: alu_bubble <= id_bubble;
        {1'b?,SRAI  }: alu_bubble <= id_bubble;
        {1'b?,SRAX  }: alu_bubble <= id_bubble;
        {1'b0,SRAIW }: alu_bubble <= id_bubble;
        {1'b?,SRAW  }: alu_bubble <= id_bubble;
        //CSR access
        {1'b?,CSRRW }: alu_bubble <= id_bubble;
        {1'b?,CSRRWI}: alu_bubble <= id_bubble;
        {1'b?,CSRRS }: alu_bubble <= id_bubble;
        {1'b?,CSRRSI}: alu_bubble <= id_bubble;
        {1'b?,CSRRC }: alu_bubble <= id_bubble;
        {1'b?,CSRRCI}: alu_bubble <= id_bubble;
        default      : alu_bubble <= 1'b1;
      endcase
    end
  end

  //CSR
  assign ex_csr_reg = id_instr[31:20];
  assign csri = {{XLEN-5{1'b0}},opB[4:0]};

  always @(*) begin
    casex ( {id_bubble,func7,func3,opcode} )
      {1'b0,CSRRW } : begin
        ex_csr_we   = 'b1;
        ex_csr_wval = opA;
      end
      {1'b0,CSRRWI} : begin
        ex_csr_we   = |csri;
        ex_csr_wval = csri;
      end
      {1'b0,CSRRS } : begin
        ex_csr_we   = |opA;
        ex_csr_wval = st_csr_rval | opA;
      end
      {1'b0,CSRRSI} : begin
        ex_csr_we   = |csri;
        ex_csr_wval = st_csr_rval | csri;
      end
      {1'b0,CSRRC } : begin
        ex_csr_we   = |opA;
        ex_csr_wval = st_csr_rval & ~opA;
      end
      {1'b0,CSRRCI} : begin
        ex_csr_we   = |csri;
        ex_csr_wval = st_csr_rval & ~csri;
      end
      default       : begin
        ex_csr_we   = 'b0;
        ex_csr_wval = 'hx;
      end
    endcase
  end
endmodule 
