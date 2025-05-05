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
//              Core - Instruction Decoder                                    //
//              AMBA4 AHB-Lite Bus Interface                                  //
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

module pu_riscv_id #(
  parameter XLEN           = 64,
  parameter ILEN           = 64,
  parameter EXCEPTION_SIZE = 16
) (
  input rstn,
  input clk,

  output reg id_stall,
  input      ex_stall,
  input      du_stall,

  input bu_flush,
  input st_flush,
  input du_flush,

  input [XLEN-1:0] bu_nxt_pc,
  input [XLEN-1:0] st_nxt_pc,

  // Program Counter
  input      [XLEN-1:0] if_pc,
  output reg [XLEN-1:0] id_pc,
  input      [     1:0] if_bp_predict,
  output reg [     1:0] id_bp_predict,

  // Instruction
  input      [ILEN-1:0] if_instr,
  input                 if_bubble,
  output reg [ILEN-1:0] id_instr,
  output reg            id_bubble,
  input      [ILEN-1:0] ex_instr,
  input                 ex_bubble,
  input      [ILEN-1:0] mem_instr,
  input                 mem_bubble,
  input      [ILEN-1:0] wb_instr,
  input                 wb_bubble,

  // Exceptions
  input      [EXCEPTION_SIZE-1:0] if_exception,
  input      [EXCEPTION_SIZE-1:0] ex_exception,
  input      [EXCEPTION_SIZE-1:0] mem_exception,
  input      [EXCEPTION_SIZE-1:0] wb_exception,
  output reg [EXCEPTION_SIZE-1:0] id_exception,

  // From State
  input [     1:0] st_prv,
  input [     1:0] st_xlen,
  input            st_tvm,
  input            st_tw,
  input            st_tsr,
  input [XLEN-1:0] st_mcounteren,
  input [XLEN-1:0] st_scounteren,

  // To RF
  output [4:0] id_src1,
  output [4:0] id_src2,

  // To execution units
  output reg [XLEN-1:0] id_opA,
  output reg [XLEN-1:0] id_opB,

  output reg id_userf_opA,
  output reg id_userf_opB,
  output reg id_bypex_opA,
  output reg id_bypex_opB,
  output reg id_bypmem_opA,
  output reg id_bypmem_opB,
  output reg id_bypwb_opA,
  output reg id_bypwb_opB,

  // from MEM/WB
  input [XLEN-1:0] mem_r,
  input [XLEN-1:0] wb_r
);

  //////////////////////////////////////////////////////////////////////////////
  // Variables
  //////////////////////////////////////////////////////////////////////////////

  logic            id_bubble_r;
  logic            multi_cycle_instruction;
  logic            stall;

  // Immediates
  logic [XLEN-1:0] immI;
  logic [XLEN-1:0] immU;

  // Opcodes
  logic [     6:2] if_opcode;
  logic [     6:2] id_opcode;
  logic [     6:2] ex_opcode;
  logic [     6:2] mem_opcode;
  logic [     6:2] wb_opcode;

  logic [     2:0] if_func3;
  logic [     6:0] if_func7;

  logic            xlen;  // Current CPU state XLEN
  logic            xlen64;  // Is the CPU state set to RV64?
  logic            xlen32;  // Is the CPU state set to RV32?
  logic            has_fpu;
  logic            has_muldiv;
  logic            has_amo;
  logic            has_u;
  logic            has_s;
  logic            has_h;

  logic [     4:0] if_src1;
  logic [     4:0] if_src2;
  logic [     4:0] id_dst;
  logic [     4:0] ex_dst;
  logic [     4:0] mem_dst;
  logic [     4:0] wb_dst;

  logic            can_bypex;
  logic            can_bypmem;
  logic            can_bypwb;
  logic            can_ldwb;

  logic            illegal_instr;
  logic            illegal_alu_instr;
  logic            illegal_lsu_instr;
  logic            illegal_muldiv_instr;
  logic            illegal_csr_rd;
  logic            illegal_csr_wr;

  //////////////////////////////////////////////////////////////////////////////
  // Body
  //////////////////////////////////////////////////////////////////////////////

  // Program Counter
  always @(posedge clk, negedge rstn) begin
    if (!rstn) begin
      id_pc <= PC_INIT;
    end else if (st_flush) begin
      id_pc <= st_nxt_pc;
    end else if (bu_flush || du_flush) begin
      id_pc <= bu_nxt_pc;  // Is this required?! 
    end else if (!stall && !id_stall) begin
      id_pc <= if_pc;
    end
  end

  // Instruction
  //
  // TO-DO: push if-instr upon illegal-instruction

  always @(posedge clk) begin
    if (!stall) begin
      id_instr <= if_instr;
    end
  end

  always @(posedge clk, negedge rstn) begin
    if (!rstn) begin
      id_bubble_r <= 1'b1;
    end else if (bu_flush || st_flush || du_flush) begin
      id_bubble_r <= 1'b1;
    end else if (!stall) begin
      if (id_stall) begin
        id_bubble_r <= 1'b1;
      end else begin
        id_bubble_r <= if_bubble;
      end
    end
  end

  // local stall
  assign stall      = ex_stall | (du_stall & ~|wb_exception);
  assign id_bubble  = stall | bu_flush | st_flush | |ex_exception | |mem_exception | |wb_exception | id_bubble_r;

  assign if_opcode  = if_instr[6:2];
  assign if_func7   = if_instr[31:25];
  assign if_func3   = if_instr[14:12];

  assign id_opcode  = id_instr[6:2];
  assign ex_opcode  = ex_instr[6:2];
  assign mem_opcode = mem_instr[6:2];
  assign wb_opcode  = wb_instr[6:2];
  assign id_dst     = id_instr[11:7];
  assign ex_dst     = ex_instr[11:7];
  assign mem_dst    = mem_instr[11:7];
  assign wb_dst     = wb_instr[11:7];

  assign has_fpu    = (HAS_FPU != 0);
  assign has_muldiv = (HAS_RVM != 0);
  assign has_amo    = (HAS_RVA != 0);
  assign has_u      = (HAS_USER != 0);
  assign has_s      = (HAS_SUPER != 0);
  assign has_h      = (HAS_HYPER != 0);

  assign xlen64     = st_xlen == RV64I;
  assign xlen32     = st_xlen == RV32I;

  always @(posedge clk) begin
    if (!stall && !id_stall) begin
      id_bp_predict <= if_bp_predict;
    end
  end

  // Exceptions
  always @(posedge clk, negedge rstn) begin
    if (!rstn) begin
      id_exception <= 'h0;
    end else if (bu_flush || st_flush) begin
      id_exception <= 'h0;
    end else if (!stall) begin
      if (id_stall) begin
        id_exception <= 'h0;
      end else begin
        id_exception                            <= if_exception;
        id_exception[CAUSE_ILLEGAL_INSTRUCTION] <= ~if_bubble & illegal_instr;
        id_exception[CAUSE_BREAKPOINT]          <= ~if_bubble & (if_instr == EBREAK);
        id_exception[CAUSE_UMODE_ECALL]         <= ~if_bubble & (if_instr == ECALL) & (st_prv == PRV_U) & has_u;
        id_exception[CAUSE_SMODE_ECALL]         <= ~if_bubble & (if_instr == ECALL) & (st_prv == PRV_S) & has_s;
        id_exception[CAUSE_HMODE_ECALL]         <= ~if_bubble & (if_instr == ECALL) & (st_prv == PRV_H) & has_h;
        id_exception[CAUSE_MMODE_ECALL]         <= ~if_bubble & (if_instr == ECALL) & (st_prv == PRV_M);
      end
    end
  end

  // To Register File

  // address into register file. Gets registered in memory
  // Should the hold be handled by the memory?!
  assign id_src1 = ~(du_stall || ex_stall) ? if_instr[19:15] : id_instr[19:15];
  assign id_src2 = ~(du_stall || ex_stall) ? if_instr[24:20] : id_instr[24:20];

  assign if_src1 = if_instr[19:15];
  assign if_src2 = if_instr[24:20];

  // Decode Immediates
  //
  // 31    30          12           11  10           5  4            1            0

  assign immI    = {{XLEN - 11{if_instr[31]}}, if_instr[30:25], if_instr[24:21], if_instr[20]};
  assign immU    = {{XLEN - 31{if_instr[31]}}, if_instr[30:12], 12'b0};

  // Create ALU operands

  // generate Load-WB-result
  // result might fall inbetween wb_r and data available in Register File
  always @(*) begin
    casex (wb_opcode)
      OPC_LOAD:     can_ldwb = ~wb_bubble;
      OPC_OP_IMM:   can_ldwb = ~wb_bubble;
      OPC_AUIPC:    can_ldwb = ~wb_bubble;
      OPC_OP_IMM32: can_ldwb = ~wb_bubble;
      OPC_AMO:      can_ldwb = ~wb_bubble;
      OPC_OP:       can_ldwb = ~wb_bubble;
      OPC_LUI:      can_ldwb = ~wb_bubble;
      OPC_OP32:     can_ldwb = ~wb_bubble;
      OPC_JALR:     can_ldwb = ~wb_bubble;
      OPC_JAL:      can_ldwb = ~wb_bubble;
      OPC_SYSTEM:   can_ldwb = ~wb_bubble;  // TO-DO: not ALL SYSTEM
      default:      can_ldwb = 'b0;
    endcase
  end

  always @(posedge clk) begin
    if (!stall) begin
      casex (if_opcode)
        OPC_OP_IMM: begin
          id_userf_opA <= ~((if_src1 == wb_dst) & |wb_dst & can_ldwb);
          id_userf_opB <= 'b0;
        end
        OPC_AUIPC: begin
          id_userf_opA <= 'b0;
          id_userf_opB <= 'b0;
        end
        OPC_OP_IMM32: begin
          id_userf_opA <= ~((if_src1 == wb_dst) & |wb_dst & can_ldwb);
          id_userf_opB <= 'b0;
        end
        OPC_OP: begin
          id_userf_opA <= ~((if_src1 == wb_dst) & |wb_dst & can_ldwb);
          id_userf_opB <= ~((if_src2 == wb_dst) & |wb_dst & can_ldwb);
        end
        OPC_LUI: begin
          id_userf_opA <= 'b0;
          id_userf_opB <= 'b0;
        end
        OPC_OP32: begin
          id_userf_opA <= ~((if_src1 == wb_dst) & |wb_dst & can_ldwb);
          id_userf_opB <= ~((if_src2 == wb_dst) & |wb_dst & can_ldwb);
        end
        OPC_BRANCH: begin
          id_userf_opA <= ~((if_src1 == wb_dst) & |wb_dst & can_ldwb);
          id_userf_opB <= ~((if_src2 == wb_dst) & |wb_dst & can_ldwb);
        end
        OPC_JALR: begin
          id_userf_opA <= ~((if_src1 == wb_dst) & |wb_dst & can_ldwb);
          id_userf_opB <= 'b0;
        end
        OPC_LOAD: begin
          id_userf_opA <= ~((if_src1 == wb_dst) & |wb_dst & can_ldwb);
          id_userf_opB <= 'b0;
        end
        OPC_STORE: begin
          id_userf_opA <= ~((if_src1 == wb_dst) & |wb_dst & can_ldwb);
          id_userf_opB <= ~((if_src2 == wb_dst) & |wb_dst & can_ldwb);
        end
        OPC_SYSTEM: begin
          id_userf_opA <= ~((if_src1 == wb_dst) & |wb_dst & can_ldwb);
          id_userf_opB <= 'b0;
        end
        default: begin
          id_userf_opA <= 'b1;
          id_userf_opB <= 'b1;
        end
      endcase
    end
  end

  always @(posedge clk) begin
    if (!stall) begin
      casex (if_opcode)
        OPC_LOAD_FP: begin
        end
        OPC_MISC_MEM: begin
        end
        OPC_OP_IMM: begin
          id_opA <= wb_r;
          id_opB <= immI;
        end
        OPC_AUIPC: begin
          id_opA <= if_pc;
          id_opB <= immU;
        end
        OPC_OP_IMM32: begin
          id_opA <= wb_r;
          id_opB <= immI;
        end
        OPC_LOAD: begin
          id_opA <= wb_r;
          id_opB <= immI;
        end
        OPC_STORE: begin
          id_opA <= wb_r;
          id_opB <= wb_r;
        end
        OPC_STORE_FP: begin
        end
        OPC_AMO: begin
        end
        OPC_OP: begin
          id_opA <= wb_r;
          id_opB <= wb_r;
        end
        OPC_LUI: begin
          id_opA <= 0;
          id_opB <= immU;
        end
        OPC_OP32: begin
          id_opA <= wb_r;
          id_opB <= wb_r;
        end
        OPC_MADD: begin
        end
        OPC_MSUB: begin
        end
        OPC_NMSUB: begin
        end
        OPC_NMADD: begin
        end
        OPC_OP_FP: begin
        end
        OPC_BRANCH: begin
          id_opA <= wb_r;
          id_opB <= wb_r;
        end
        OPC_JALR: begin
          id_opA <= wb_r;
          id_opB <= immI;
        end
        OPC_SYSTEM: begin
          id_opA <= wb_r;  // for CSRxx
          id_opB <= {{XLEN - 5{1'b0}}, if_src1};  // for CSRxxI
        end
        default: begin
          id_opA <= 'hx;
          id_opB <= 'hx;
        end
      endcase
    end
  end

  // Bypasses
  always @(posedge clk, negedge rstn) begin
    if (!rstn) begin
      multi_cycle_instruction <= 1'b0;
    end else if (!stall) begin
      casex ({ xlen32, if_func7, if_func3, if_opcode })
        {1'b?, MUL} :    multi_cycle_instruction <= MULT_LATENCY > 0 ? has_muldiv : 1'b0;
        {1'b?, MULH} :   multi_cycle_instruction <= MULT_LATENCY > 0 ? has_muldiv : 1'b0;
        {1'b0, MULW} :   multi_cycle_instruction <= MULT_LATENCY > 0 ? has_muldiv : 1'b0;
        {1'b?, MULHSU} : multi_cycle_instruction <= MULT_LATENCY > 0 ? has_muldiv : 1'b0;
        {1'b?, MULHU} :  multi_cycle_instruction <= MULT_LATENCY > 0 ? has_muldiv : 1'b0;
        {1'b?, DIV} :    multi_cycle_instruction <= has_muldiv;
        {1'b0, DIVW} :   multi_cycle_instruction <= has_muldiv;
        {1'b?, DIVU} :   multi_cycle_instruction <= has_muldiv;
        {1'b0, DIVUW} :  multi_cycle_instruction <= has_muldiv;
        {1'b?, REM} :    multi_cycle_instruction <= has_muldiv;
        {1'b0, REMW} :   multi_cycle_instruction <= has_muldiv;
        {1'b?, REMU} :   multi_cycle_instruction <= has_muldiv;
        {1'b0, REMUW} :  multi_cycle_instruction <= has_muldiv;
        default:         multi_cycle_instruction <= 1'b0;
      endcase
    end
  end

  // Check for each stage if the result should be used
  always @(*) begin
    casex (id_opcode)
      OPC_LOAD:     can_bypex = ~id_bubble;
      OPC_OP_IMM:   can_bypex = ~id_bubble;
      OPC_AUIPC:    can_bypex = ~id_bubble;
      OPC_OP_IMM32: can_bypex = ~id_bubble;
      OPC_AMO:      can_bypex = ~id_bubble;
      OPC_OP:       can_bypex = ~id_bubble;
      OPC_LUI:      can_bypex = ~id_bubble;
      OPC_OP32:     can_bypex = ~id_bubble;
      OPC_JALR:     can_bypex = ~id_bubble;
      OPC_JAL:      can_bypex = ~id_bubble;
      OPC_SYSTEM:   can_bypex = ~id_bubble;  // TO-DO: not ALL SYSTEM
      default:      can_bypex = 1'b0;
    endcase
  end

  always @(*) begin
    casex (ex_opcode)
      OPC_LOAD:     can_bypmem = ~ex_bubble & ~multi_cycle_instruction;
      OPC_OP_IMM:   can_bypmem = ~ex_bubble & ~multi_cycle_instruction;
      OPC_AUIPC:    can_bypmem = ~ex_bubble & ~multi_cycle_instruction;
      OPC_OP_IMM32: can_bypmem = ~ex_bubble & ~multi_cycle_instruction;
      OPC_AMO:      can_bypmem = ~ex_bubble & ~multi_cycle_instruction;
      OPC_OP:       can_bypmem = ~ex_bubble & ~multi_cycle_instruction;
      OPC_LUI:      can_bypmem = ~ex_bubble & ~multi_cycle_instruction;
      OPC_OP32:     can_bypmem = ~ex_bubble & ~multi_cycle_instruction;
      OPC_JALR:     can_bypmem = ~ex_bubble & ~multi_cycle_instruction;
      OPC_JAL:      can_bypmem = ~ex_bubble & ~multi_cycle_instruction;
      OPC_SYSTEM:   can_bypmem = ~ex_bubble & ~multi_cycle_instruction;  // TO-DO: not ALL SYSTEM
      default:      can_bypmem = 1'b0;
    endcase
  end

  always @(*) begin
    casex (mem_opcode)
      OPC_LOAD:     can_bypwb = ~mem_bubble & ~multi_cycle_instruction;
      OPC_OP_IMM:   can_bypwb = ~mem_bubble & ~multi_cycle_instruction;
      OPC_AUIPC:    can_bypwb = ~mem_bubble & ~multi_cycle_instruction;
      OPC_OP_IMM32: can_bypwb = ~mem_bubble & ~multi_cycle_instruction;
      OPC_AMO:      can_bypwb = ~mem_bubble & ~multi_cycle_instruction;
      OPC_OP:       can_bypwb = ~mem_bubble & ~multi_cycle_instruction;
      OPC_LUI:      can_bypwb = ~mem_bubble & ~multi_cycle_instruction;
      OPC_OP32:     can_bypwb = ~mem_bubble & ~multi_cycle_instruction;
      OPC_JALR:     can_bypwb = ~mem_bubble & ~multi_cycle_instruction;
      OPC_JAL:      can_bypwb = ~mem_bubble & ~multi_cycle_instruction;
      OPC_SYSTEM:   can_bypwb = ~mem_bubble & ~multi_cycle_instruction;  // TO-DO: not ALL SYSTEM
      default:      can_bypwb = 1'b0;
    endcase
  end

  // set bypass switches.
  // 'x0' is used as a black hole. It should always be zero, but may contain other values in the pipeline
  // therefore we check if dst is non-zero

  always @(posedge clk) begin
    if (!stall) begin
      casex (if_opcode)
        OPC_OP_IMM: begin
          id_bypex_opA  <= (if_src1 == id_dst) & |id_dst & can_bypex;
          id_bypex_opB  <= 1'b0;

          id_bypmem_opA <= (if_src1 == ex_dst) & |ex_dst & can_bypmem;
          id_bypmem_opB <= 1'b0;

          id_bypwb_opA  <= (if_src1 == mem_dst) & |mem_dst & can_bypwb;
          id_bypwb_opB  <= 1'b0;
        end
        OPC_OP_IMM32: begin
          id_bypex_opA  <= (if_src1 == id_dst) & |id_dst & can_bypex;
          id_bypex_opB  <= 1'b0;

          id_bypmem_opA <= (if_src1 == ex_dst) & |ex_dst & can_bypmem;
          id_bypmem_opB <= 1'b0;

          id_bypwb_opA  <= (if_src1 == mem_dst) & |mem_dst & can_bypwb;
          id_bypwb_opB  <= 1'b0;
        end
        OPC_OP: begin
          id_bypex_opA  <= (if_src1 == id_dst) & |id_dst & can_bypex;
          id_bypex_opB  <= (if_src2 == id_dst) & |id_dst & can_bypex;

          id_bypmem_opA <= (if_src1 == ex_dst) & |ex_dst & can_bypmem;
          id_bypmem_opB <= (if_src2 == ex_dst) & |ex_dst & can_bypmem;

          id_bypwb_opA  <= (if_src1 == mem_dst) & |mem_dst & can_bypwb;
          id_bypwb_opB  <= (if_src2 == mem_dst) & |mem_dst & can_bypwb;
        end
        OPC_OP32: begin
          id_bypex_opA  <= (if_src1 == id_dst) & |id_dst & can_bypex;
          id_bypex_opB  <= (if_src2 == id_dst) & |id_dst & can_bypex;

          id_bypmem_opA <= (if_src1 == ex_dst) & |ex_dst & can_bypmem;
          id_bypmem_opB <= (if_src2 == ex_dst) & |ex_dst & can_bypmem;

          id_bypwb_opA  <= (if_src1 == mem_dst) & |mem_dst & can_bypwb;
          id_bypwb_opB  <= (if_src2 == mem_dst) & |mem_dst & can_bypwb;
        end
        OPC_BRANCH: begin
          id_bypex_opA  <= (if_src1 == id_dst) & |id_dst & can_bypex;
          id_bypex_opB  <= (if_src2 == id_dst) & |id_dst & can_bypex;

          id_bypmem_opA <= (if_src1 == ex_dst) & |ex_dst & can_bypmem;
          id_bypmem_opB <= (if_src2 == ex_dst) & |ex_dst & can_bypmem;

          id_bypwb_opA  <= (if_src1 == mem_dst) & |mem_dst & can_bypwb;
          id_bypwb_opB  <= (if_src2 == mem_dst) & |mem_dst & can_bypwb;
        end
        OPC_JALR: begin
          id_bypex_opA  <= (if_src1 == id_dst) & |id_dst & can_bypex;
          id_bypex_opB  <= 1'b0;

          id_bypmem_opA <= (if_src1 == ex_dst) & |ex_dst & can_bypmem;
          id_bypmem_opB <= 1'b0;

          id_bypwb_opA  <= (if_src1 == mem_dst) & |mem_dst & can_bypwb;
          id_bypwb_opB  <= 1'b0;
        end
        OPC_LOAD: begin
          id_bypex_opA  <= (if_src1 == id_dst) & |id_dst & can_bypex;
          id_bypex_opB  <= 1'b0;

          id_bypmem_opA <= (if_src1 == ex_dst) & |ex_dst & can_bypmem;
          id_bypmem_opB <= 1'b0;

          id_bypwb_opA  <= (if_src1 == mem_dst) & |mem_dst & can_bypwb;
          id_bypwb_opB  <= 1'b0;
        end
        OPC_STORE: begin
          id_bypex_opA  <= (if_src1 == id_dst) & |id_dst & can_bypex;
          id_bypex_opB  <= (if_src2 == id_dst) & |id_dst & can_bypex;

          id_bypmem_opA <= (if_src1 == ex_dst) & |ex_dst & can_bypmem;
          id_bypmem_opB <= (if_src2 == ex_dst) & |ex_dst & can_bypmem;

          id_bypwb_opA  <= (if_src1 == mem_dst) & |mem_dst & can_bypwb;
          id_bypwb_opB  <= (if_src2 == mem_dst) & |mem_dst & can_bypwb;
        end
        OPC_SYSTEM: begin
          id_bypex_opA  <= (if_src1 == id_dst) & |id_dst & can_bypex;
          id_bypex_opB  <= 1'b0;

          id_bypmem_opA <= (if_src1 == ex_dst) & |ex_dst & can_bypmem;
          id_bypmem_opB <= 1'b0;

          id_bypwb_opA  <= (if_src1 == mem_dst) & |mem_dst & can_bypwb;
          id_bypwb_opB  <= 1'b0;
        end
        default: begin
          id_bypex_opA  <= 1'b0;
          id_bypex_opB  <= 1'b0;

          id_bypmem_opA <= 1'b0;
          id_bypmem_opB <= 1'b0;

          id_bypwb_opA  <= 1'b0;
          id_bypwb_opB  <= 1'b0;
        end
      endcase
    end
  end

  // Generate STALL

  // rih: todo
  always @(*) begin
    if (bu_flush || st_flush || du_flush) begin
      id_stall = 'b0;  // flush overrules stall
    end else if (stall) begin
      id_stall = ~if_bubble;  // ignore NOPs e.g. after flush or IF-stall
    end else if (id_opcode == OPC_LOAD && !id_bubble) begin
      casex (if_opcode)
        OPC_OP_IMM:   id_stall = (if_src1 == id_dst);
        OPC_OP_IMM32: id_stall = (if_src1 == id_dst);
        OPC_OP:       id_stall = (if_src1 == id_dst) | (if_src2 == id_dst);
        OPC_OP32:     id_stall = (if_src1 == id_dst) | (if_src2 == id_dst);
        OPC_BRANCH:   id_stall = (if_src1 == id_dst) | (if_src2 == id_dst);
        OPC_JALR:     id_stall = (if_src1 == id_dst);
        OPC_LOAD:     id_stall = (if_src1 == id_dst);
        OPC_STORE:    id_stall = (if_src1 == id_dst) | (if_src2 == id_dst);
        OPC_SYSTEM:   id_stall = (if_src1 == id_dst);
        default:      id_stall = 'b0;
      endcase
    end else if (ex_opcode == OPC_LOAD && !ex_bubble) begin
      casex (if_opcode)
        OPC_OP_IMM:   id_stall = (if_src1 == ex_dst);
        OPC_OP_IMM32: id_stall = (if_src1 == ex_dst);
        OPC_OP:       id_stall = (if_src1 == ex_dst) | (if_src2 == ex_dst);
        OPC_OP32:     id_stall = (if_src1 == ex_dst) | (if_src2 == ex_dst);
        OPC_BRANCH:   id_stall = (if_src1 == ex_dst) | (if_src2 == ex_dst);
        OPC_JALR:     id_stall = (if_src1 == ex_dst);
        OPC_LOAD:     id_stall = (if_src1 == ex_dst);
        OPC_STORE:    id_stall = (if_src1 == ex_dst) | (if_src2 == ex_dst);
        OPC_SYSTEM:   id_stall = (if_src1 == ex_dst);
        default:      id_stall = 'b0;
      endcase

      //    end else if (mem_opcode == OPC_LOAD) begin
      //      casex (if_opcode)
      //        OPC_OP_IMM  : id_stall = (if_src1 == mem_dst);
      //        OPC_OP_IMM32: id_stall = (if_src1 == mem_dst);
      //        OPC_OP      : id_stall = (if_src1 == mem_dst) | (if_src2 == mem_dst);
      //        OPC_OP32    : id_stall = (if_src1 == mem_dst) | (if_src2 == mem_dst);
      //        OPC_BRANCH  : id_stall = (if_src1 == mem_dst) | (if_src2 == mem_dst);
      //        OPC_JALR    : id_stall = (if_src1 == mem_dst);
      //        OPC_LOAD    : id_stall = (if_src1 == mem_dst);
      //        OPC_STORE   : id_stall = (if_src1 == mem_dst) | (if_src2 == mem_dst);
      //        OPC_SYSTEM  : id_stall = (if_src1 == mem_dst);
      //        default     : id_stall = 'b0;
      //      endcase
      //    end

    end else begin
      id_stall = 'b0;
    end
  end

  // Generate Illegal Instruction
  always @(*) begin
    casex (if_opcode)
      OPC_LOAD:  illegal_instr = illegal_lsu_instr;
      OPC_STORE: illegal_instr = illegal_lsu_instr;
      default:   illegal_instr = illegal_alu_instr & (has_muldiv ? illegal_muldiv_instr : 1'b1);
    endcase
  end

  // ALU
  always @(*) begin
    casex (if_instr)
      FENCE:   illegal_alu_instr = 1'b0;
      FENCE_I: illegal_alu_instr = 1'b0;
      ECALL:   illegal_alu_instr = 1'b0;
      EBREAK:  illegal_alu_instr = 1'b0;
      URET:    illegal_alu_instr = ~has_u;
      SRET:    illegal_alu_instr = ~has_s || st_prv < PRV_S || (st_prv == PRV_S && st_tsr);
      MRET:    illegal_alu_instr = st_prv != PRV_M;
      default: begin
        casex ({ xlen32, if_func7, if_func3, if_opcode })
          {1'b?, LUI} :   illegal_alu_instr = 1'b0;
          {1'b?, AUIPC} : illegal_alu_instr = 1'b0;
          {1'b?, JAL} :   illegal_alu_instr = 1'b0;
          {1'b?, JALR} :  illegal_alu_instr = 1'b0;
          {1'b?, BEQ} :   illegal_alu_instr = 1'b0;
          {1'b?, BNE} :   illegal_alu_instr = 1'b0;
          {1'b?, BLT} :   illegal_alu_instr = 1'b0;
          {1'b?, BGE} :   illegal_alu_instr = 1'b0;
          {1'b?, BLTU} :  illegal_alu_instr = 1'b0;
          {1'b?, BGEU} :  illegal_alu_instr = 1'b0;
          {1'b?, ADDI} :  illegal_alu_instr = 1'b0;
          {1'b?, ADD} :   illegal_alu_instr = 1'b0;
          {1'b0, ADDIW} : illegal_alu_instr = 1'b0;  // RV64
          {1'b0, ADDW} :  illegal_alu_instr = 1'b0;  // RV64
          {1'b?, SUB} :   illegal_alu_instr = 1'b0;
          {1'b0, SUBW} :  illegal_alu_instr = 1'b0;  // RV64
          {1'b?, XORI} :  illegal_alu_instr = 1'b0;
          {1'b?, XORX} :  illegal_alu_instr = 1'b0;
          {1'b?, ORI} :   illegal_alu_instr = 1'b0;
          {1'b?, ORX} :   illegal_alu_instr = 1'b0;
          {1'b?, ANDI} :  illegal_alu_instr = 1'b0;
          {1'b?, ANDX} :  illegal_alu_instr = 1'b0;
          {1'b?, SLLI} :  illegal_alu_instr = xlen32 & if_func7[0];  // shamt[5] illegal for RV32
          {1'b?, SLLX} :  illegal_alu_instr = 1'b0;
          {1'b0, SLLIW} : illegal_alu_instr = 1'b0;  // RV64
          {1'b0, SLLW} :  illegal_alu_instr = 1'b0;  // RV64
          {1'b?, SLTI} :  illegal_alu_instr = 1'b0;
          {1'b?, SLT} :   illegal_alu_instr = 1'b0;
          {1'b?, SLTIU} : illegal_alu_instr = 1'b0;
          {1'b?, SLTU} :  illegal_alu_instr = 1'b0;
          {1'b?, SRLI} :  illegal_alu_instr = xlen32 & if_func7[0];  // shamt[5] illegal for RV32
          {1'b?, SRLX} :  illegal_alu_instr = 1'b0;
          {1'b0, SRLIW} : illegal_alu_instr = 1'b0;  // RV64
          {1'b0, SRLW} :  illegal_alu_instr = 1'b0;  // RV64
          {1'b?, SRAI} :  illegal_alu_instr = xlen32 & if_func7[0];  // shamt[5] illegal for RV32
          {1'b?, SRAX} :  illegal_alu_instr = 1'b0;
          {1'b0, SRAIW} : illegal_alu_instr = 1'b0;
          {1'b?, SRAW} :  illegal_alu_instr = 1'b0;

          // system
          {1'b?, CSRRW} :  illegal_alu_instr = illegal_csr_rd | illegal_csr_wr;
          {1'b?, CSRRS} :  illegal_alu_instr = illegal_csr_rd | (|if_src1 & illegal_csr_wr);
          {1'b?, CSRRC} :  illegal_alu_instr = illegal_csr_rd | (|if_src1 & illegal_csr_wr);
          {1'b?, CSRRWI} : illegal_alu_instr = illegal_csr_rd | (|if_src1 & illegal_csr_wr);
          {1'b?, CSRRSI} : illegal_alu_instr = illegal_csr_rd | (|if_src1 & illegal_csr_wr);
          {1'b?, CSRRCI} : illegal_alu_instr = illegal_csr_rd | (|if_src1 & illegal_csr_wr);

          default: illegal_alu_instr = 1'b1;
        endcase
      end
    endcase
  end

  // LSU
  always @(*) begin
    casex ({ xlen32, has_amo, if_func7, if_func3, if_opcode })
      {1'b?, 1'b?, LB} :  illegal_lsu_instr = 1'b0;
      {1'b?, 1'b?, LH} :  illegal_lsu_instr = 1'b0;
      {1'b?, 1'b?, LW} :  illegal_lsu_instr = 1'b0;
      {1'b0, 1'b?, LD} :  illegal_lsu_instr = 1'b0;  // RV64
      {1'b?, 1'b?, LBU} : illegal_lsu_instr = 1'b0;
      {1'b?, 1'b?, LHU} : illegal_lsu_instr = 1'b0;
      {1'b0, 1'b?, LWU} : illegal_lsu_instr = 1'b0;  // RV64
      {1'b?, 1'b?, SB} :  illegal_lsu_instr = 1'b0;
      {1'b?, 1'b?, SH} :  illegal_lsu_instr = 1'b0;
      {1'b?, 1'b?, SW} :  illegal_lsu_instr = 1'b0;
      {1'b0, 1'b?, SD} :  illegal_lsu_instr = 1'b0;  // RV64

      // AMO
      default: illegal_lsu_instr = 1'b1;
    endcase
  end

  // MULDIV
  always @(*) begin
    casex ({ xlen32, if_func7, if_func3, if_opcode })
      {1'b?, MUL} :    illegal_muldiv_instr = 1'b0;
      {1'b?, MULH} :   illegal_muldiv_instr = 1'b0;
      {1'b0, MULW} :   illegal_muldiv_instr = 1'b0;  // RV64
      {1'b?, MULHSU} : illegal_muldiv_instr = 1'b0;
      {1'b?, MULHU} :  illegal_muldiv_instr = 1'b0;
      {1'b?, DIV} :    illegal_muldiv_instr = 1'b0;
      {1'b0, DIVW} :   illegal_muldiv_instr = 1'b0;  // RV64
      {1'b?, DIVU} :   illegal_muldiv_instr = 1'b0;
      {1'b0, DIVUW} :  illegal_muldiv_instr = 1'b0;  // RV64
      {1'b?, REM} :    illegal_muldiv_instr = 1'b0;
      {1'b0, REMW} :   illegal_muldiv_instr = 1'b0;  // RV64
      {1'b?, REMU} :   illegal_muldiv_instr = 1'b0;
      {1'b0, REMUW} :  illegal_muldiv_instr = 1'b0;
      default:         illegal_muldiv_instr = 1'b1;
    endcase
  end

  // Check CSR accesses
  always @(*) begin
    case (if_instr[31:20])
      // User
      USTATUS:  illegal_csr_rd = ~has_u;
      UIE:      illegal_csr_rd = ~has_u;
      UTVEC:    illegal_csr_rd = ~has_u;
      USCRATCH: illegal_csr_rd = ~has_u;
      UEPC:     illegal_csr_rd = ~has_u;
      UCAUSE:   illegal_csr_rd = ~has_u;
      UTVAL:    illegal_csr_rd = ~has_u;
      UIP:      illegal_csr_rd = ~has_u;
      FFLAGS:   illegal_csr_rd = ~has_fpu;
      FRM:      illegal_csr_rd = ~has_fpu;
      FCSR:     illegal_csr_rd = ~has_fpu;
      CYCLE:    illegal_csr_rd = ~has_u | (~has_s & st_prv == PRV_U & ~st_mcounteren[CY]) | (has_s & st_prv == PRV_S & ~st_mcounteren[CY]) | (has_s & st_prv == PRV_U & st_mcounteren[CY] & st_scounteren[CY]);
      TIMEX:    illegal_csr_rd = 1'b1;  // trap on reading TIME. Machine mode must access external timer
      INSTRET:  illegal_csr_rd = ~has_u | (~has_s & st_prv == PRV_U & ~st_mcounteren[IR]) | (has_s & st_prv == PRV_S & ~st_mcounteren[IR]) | (has_s & st_prv == PRV_U & st_mcounteren[IR] & st_scounteren[IR]);
      CYCLEH:   illegal_csr_rd = ~has_u | ~xlen32 | (~has_s & st_prv == PRV_U & ~st_mcounteren[CY]) | (has_s & st_prv == PRV_S & ~st_mcounteren[CY]) | (has_s & st_prv == PRV_U & st_mcounteren[CY] & st_scounteren[CY]);
      TIMEH:    illegal_csr_rd = 1'b1;  // trap on reading TIMEH. Machine mode must access external timer
      INSTRETH: illegal_csr_rd = ~has_u | ~xlen32 | (~has_s & st_prv == PRV_U & ~st_mcounteren[IR]) | (has_s & st_prv == PRV_S & ~st_mcounteren[IR]) | (has_s & st_prv == PRV_U & st_mcounteren[IR] & st_scounteren[IR]);
      // TO-DO: hpmcounters

      // Supervisor
      SSTATUS:  illegal_csr_rd = ~has_s | (st_prv < PRV_S);
      SEDELEG:  illegal_csr_rd = ~has_s | (st_prv < PRV_S);
      SIDELEG:  illegal_csr_rd = ~has_s | (st_prv < PRV_S);
      SIE:      illegal_csr_rd = ~has_s | (st_prv < PRV_S);
      STVEC:    illegal_csr_rd = ~has_s | (st_prv < PRV_S);
      SSCRATCH: illegal_csr_rd = ~has_s | (st_prv < PRV_S);
      SEPC:     illegal_csr_rd = ~has_s | (st_prv < PRV_S);
      SCAUSE:   illegal_csr_rd = ~has_s | (st_prv < PRV_S);
      STVAL:    illegal_csr_rd = ~has_s | (st_prv < PRV_S);
      SIP:      illegal_csr_rd = ~has_s | (st_prv < PRV_S);
      SATP:     illegal_csr_rd = ~has_s | (st_prv < PRV_S) | (st_prv == PRV_S && st_tvm);

      // Hypervisor
      HSTATUS:  illegal_csr_rd = (HAS_HYPER == 0) | (st_prv < PRV_H);
      HEDELEG:  illegal_csr_rd = (HAS_HYPER == 0) | (st_prv < PRV_H);
      HIDELEG:  illegal_csr_rd = (HAS_HYPER == 0) | (st_prv < PRV_H);
      HIE:      illegal_csr_rd = (HAS_HYPER == 0) | (st_prv < PRV_H);
      HTVEC:    illegal_csr_rd = (HAS_HYPER == 0) | (st_prv < PRV_H);
      HSCRATCH: illegal_csr_rd = (HAS_HYPER == 0) | (st_prv < PRV_H);
      HEPC:     illegal_csr_rd = (HAS_HYPER == 0) | (st_prv < PRV_H);
      HCAUSE:   illegal_csr_rd = (HAS_HYPER == 0) | (st_prv < PRV_H);
      HTVAL:    illegal_csr_rd = (HAS_HYPER == 0) | (st_prv < PRV_H);
      HIP:      illegal_csr_rd = (HAS_HYPER == 0) | (st_prv < PRV_H);

      // Machine
      MVENDORID:  illegal_csr_rd = (st_prv < PRV_M);
      MARCHID:    illegal_csr_rd = (st_prv < PRV_M);
      MIMPID:     illegal_csr_rd = (st_prv < PRV_M);
      MHARTID:    illegal_csr_rd = (st_prv < PRV_M);
      MSTATUS:    illegal_csr_rd = (st_prv < PRV_M);
      MISA:       illegal_csr_rd = (st_prv < PRV_M);
      MEDELEG:    illegal_csr_rd = (st_prv < PRV_M);
      MIDELEG:    illegal_csr_rd = (st_prv < PRV_M);
      MIE:        illegal_csr_rd = (st_prv < PRV_M);
      MTVEC:      illegal_csr_rd = (st_prv < PRV_M);
      MCOUNTEREN: illegal_csr_rd = (st_prv < PRV_M);
      MSCRATCH:   illegal_csr_rd = (st_prv < PRV_M);
      MEPC:       illegal_csr_rd = (st_prv < PRV_M);
      MCAUSE:     illegal_csr_rd = (st_prv < PRV_M);
      MTVAL:      illegal_csr_rd = (st_prv < PRV_M);
      MIP:        illegal_csr_rd = (st_prv < PRV_M);
      PMPCFG0:    illegal_csr_rd = (st_prv < PRV_M);
      PMPCFG1:    illegal_csr_rd = (XLEN > 32) | (st_prv < PRV_M);
      PMPCFG2:    illegal_csr_rd = (XLEN > 64) | (st_prv < PRV_M);
      PMPCFG3:    illegal_csr_rd = (XLEN > 32) | (st_prv < PRV_M);
      PMPADDR0:   illegal_csr_rd = (st_prv < PRV_M);
      PMPADDR1:   illegal_csr_rd = (st_prv < PRV_M);
      PMPADDR2:   illegal_csr_rd = (st_prv < PRV_M);
      PMPADDR3:   illegal_csr_rd = (st_prv < PRV_M);
      PMPADDR4:   illegal_csr_rd = (st_prv < PRV_M);
      PMPADDR5:   illegal_csr_rd = (st_prv < PRV_M);
      PMPADDR6:   illegal_csr_rd = (st_prv < PRV_M);
      PMPADDR7:   illegal_csr_rd = (st_prv < PRV_M);
      PMPADDR8:   illegal_csr_rd = (st_prv < PRV_M);
      PMPADDR9:   illegal_csr_rd = (st_prv < PRV_M);
      PMPADDR10:  illegal_csr_rd = (st_prv < PRV_M);
      PMPADDR11:  illegal_csr_rd = (st_prv < PRV_M);
      PMPADDR12:  illegal_csr_rd = (st_prv < PRV_M);
      PMPADDR13:  illegal_csr_rd = (st_prv < PRV_M);
      PMPADDR14:  illegal_csr_rd = (st_prv < PRV_M);
      PMPADDR15:  illegal_csr_rd = (st_prv < PRV_M);
      MCYCLE:     illegal_csr_rd = (st_prv < PRV_M);
      MINSTRET:   illegal_csr_rd = (st_prv < PRV_M);

      // TO-DO: performance counters
      MCYCLEH:   illegal_csr_rd = (XLEN > 32) | (st_prv < PRV_M);
      MINSTRETH: illegal_csr_rd = (XLEN > 32) | (st_prv < PRV_M);

      default: illegal_csr_rd = 1'b1;
    endcase
  end

  always @(*) begin
    case (if_instr[31:20])
      USTATUS:  illegal_csr_wr = ~has_u;
      UIE:      illegal_csr_wr = ~has_u;
      UTVEC:    illegal_csr_wr = ~has_u;
      USCRATCH: illegal_csr_wr = ~has_u;
      UEPC:     illegal_csr_wr = ~has_u;
      UCAUSE:   illegal_csr_wr = ~has_u;
      UTVAL:    illegal_csr_wr = ~has_u;
      UIP:      illegal_csr_wr = ~has_u;
      FFLAGS:   illegal_csr_wr = ~has_fpu;
      FRM:      illegal_csr_wr = ~has_fpu;
      FCSR:     illegal_csr_wr = ~has_fpu;
      CYCLE:    illegal_csr_wr = 1'b1;
      TIMEX:    illegal_csr_wr = 1'b1;
      INSTRET:  illegal_csr_wr = 1'b1;

      // TO-DO:hpmcounters
      CYCLEH:   illegal_csr_wr = 1'b1;
      TIMEH:    illegal_csr_wr = 1'b1;
      INSTRETH: illegal_csr_wr = 1'b1;

      // Supervisor
      SSTATUS:    illegal_csr_wr = ~has_s | (st_prv < PRV_S);
      SEDELEG:    illegal_csr_wr = ~has_s | (st_prv < PRV_S);
      SIDELEG:    illegal_csr_wr = ~has_s | (st_prv < PRV_S);
      SIE:        illegal_csr_wr = ~has_s | (st_prv < PRV_S);
      STVEC:      illegal_csr_wr = ~has_s | (st_prv < PRV_S);
      SCOUNTEREN: illegal_csr_wr = ~has_s | (st_prv < PRV_S);
      SSCRATCH:   illegal_csr_wr = ~has_s | (st_prv < PRV_S);
      SEPC:       illegal_csr_wr = ~has_s | (st_prv < PRV_S);
      SCAUSE:     illegal_csr_wr = ~has_s | (st_prv < PRV_S);
      STVAL:      illegal_csr_wr = ~has_s | (st_prv < PRV_S);
      SIP:        illegal_csr_wr = ~has_s | (st_prv < PRV_S);
      SATP:       illegal_csr_wr = ~has_s | (st_prv < PRV_S) | (st_prv == PRV_S && st_tvm);

      // Hypervisor
      HSTATUS:  illegal_csr_wr = (HAS_HYPER == 0) | (st_prv < PRV_H);
      HEDELEG:  illegal_csr_wr = (HAS_HYPER == 0) | (st_prv < PRV_H);
      HIDELEG:  illegal_csr_wr = (HAS_HYPER == 0) | (st_prv < PRV_H);
      HIE:      illegal_csr_wr = (HAS_HYPER == 0) | (st_prv < PRV_H);
      HTVEC:    illegal_csr_wr = (HAS_HYPER == 0) | (st_prv < PRV_H);
      HSCRATCH: illegal_csr_wr = (HAS_HYPER == 0) | (st_prv < PRV_H);
      HEPC:     illegal_csr_wr = (HAS_HYPER == 0) | (st_prv < PRV_H);
      HCAUSE:   illegal_csr_wr = (HAS_HYPER == 0) | (st_prv < PRV_H);
      HTVAL:    illegal_csr_wr = (HAS_HYPER == 0) | (st_prv < PRV_H);
      HIP:      illegal_csr_wr = (HAS_HYPER == 0) | (st_prv < PRV_H);

      // Machine
      MVENDORID:  illegal_csr_wr = 1'b1;
      MARCHID:    illegal_csr_wr = 1'b1;
      MIMPID:     illegal_csr_wr = 1'b1;
      MHARTID:    illegal_csr_wr = 1'b1;
      MSTATUS:    illegal_csr_wr = (st_prv < PRV_M);
      MISA:       illegal_csr_wr = (st_prv < PRV_M);
      MEDELEG:    illegal_csr_wr = (st_prv < PRV_M);
      MIDELEG:    illegal_csr_wr = (st_prv < PRV_M);
      MIE:        illegal_csr_wr = (st_prv < PRV_M);
      MTVEC:      illegal_csr_wr = (st_prv < PRV_M);
      MNMIVEC:    illegal_csr_wr = (st_prv < PRV_M);
      MCOUNTEREN: illegal_csr_wr = (st_prv < PRV_M);
      MSCRATCH:   illegal_csr_wr = (st_prv < PRV_M);
      MEPC:       illegal_csr_wr = (st_prv < PRV_M);
      MCAUSE:     illegal_csr_wr = (st_prv < PRV_M);
      MTVAL:      illegal_csr_wr = (st_prv < PRV_M);
      MIP:        illegal_csr_wr = (st_prv < PRV_M);
      PMPCFG0:    illegal_csr_wr = (st_prv < PRV_M);
      PMPCFG1:    illegal_csr_wr = (XLEN > 32) | (st_prv < PRV_M);
      PMPCFG2:    illegal_csr_wr = (XLEN > 64) | (st_prv < PRV_M);
      PMPCFG3:    illegal_csr_wr = (XLEN > 32) | (st_prv < PRV_M);
      PMPADDR0:   illegal_csr_wr = (st_prv < PRV_M);
      PMPADDR1:   illegal_csr_wr = (st_prv < PRV_M);
      PMPADDR2:   illegal_csr_wr = (st_prv < PRV_M);
      PMPADDR3:   illegal_csr_wr = (st_prv < PRV_M);
      PMPADDR4:   illegal_csr_wr = (st_prv < PRV_M);
      PMPADDR5:   illegal_csr_wr = (st_prv < PRV_M);
      PMPADDR6:   illegal_csr_wr = (st_prv < PRV_M);
      PMPADDR7:   illegal_csr_wr = (st_prv < PRV_M);
      PMPADDR8:   illegal_csr_wr = (st_prv < PRV_M);
      PMPADDR9:   illegal_csr_wr = (st_prv < PRV_M);
      PMPADDR10:  illegal_csr_wr = (st_prv < PRV_M);
      PMPADDR11:  illegal_csr_wr = (st_prv < PRV_M);
      PMPADDR12:  illegal_csr_wr = (st_prv < PRV_M);
      PMPADDR13:  illegal_csr_wr = (st_prv < PRV_M);
      PMPADDR14:  illegal_csr_wr = (st_prv < PRV_M);
      PMPADDR15:  illegal_csr_wr = (st_prv < PRV_M);
      MCYCLE:     illegal_csr_wr = (st_prv < PRV_M);
      MINSTRET:   illegal_csr_wr = (st_prv < PRV_M);

      // TO-DO: performance counters
      MCYCLEH:   illegal_csr_wr = (XLEN > 32) | (st_prv < PRV_M);
      MINSTRETH: illegal_csr_wr = (XLEN > 32) | (st_prv < PRV_M);

      default: illegal_csr_wr = 1'b1;
    endcase
  end
endmodule
