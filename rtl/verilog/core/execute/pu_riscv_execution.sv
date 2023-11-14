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
//              Core - Execution Unit                                         //
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

module pu_riscv_execution #(
  parameter XLEN           = 64,
  parameter ILEN           = 64,
  parameter EXCEPTION_SIZE = 16,
  parameter BP_GLOBAL_BITS = 2,
  parameter HAS_RVC        = 1,
  parameter HAS_RVA        = 1,
  parameter HAS_RVM        = 1,
  parameter MULT_LATENCY   = 1,

  parameter [XLEN-1:0] PC_INIT = 'h8000_0000
) (
  input rstn,
  input clk,

  input  wb_stall,
  output ex_stall,

  // Program counter
  input      [XLEN          -1:0] id_pc,
  output reg [XLEN          -1:0] ex_pc,
  output reg [XLEN          -1:0] bu_nxt_pc,
  output                          bu_flush,
  output                          bu_cacheflush,
  input      [               1:0] id_bp_predict,
  output     [               1:0] bu_bp_predict,
  output     [BP_GLOBAL_BITS-1:0] bu_bp_history,
  output                          bu_bp_btaken,
  output                          bu_bp_update,

  // Instruction
  input                           id_bubble,
  input      [ILEN          -1:0] id_instr,
  output                          ex_bubble,
  output reg [ILEN          -1:0] ex_instr,

  input      [EXCEPTION_SIZE-1:0] id_exception,
  input      [EXCEPTION_SIZE-1:0] mem_exception,
  input      [EXCEPTION_SIZE-1:0] wb_exception,
  output reg [EXCEPTION_SIZE-1:0] ex_exception,

  // from ID
  input                      id_userf_opA,
  input                      id_userf_opB,
  input                      id_bypex_opA,
  input                      id_bypex_opB,
  input                      id_bypmem_opA,
  input                      id_bypmem_opB,
  input                      id_bypwb_opA,
  input                      id_bypwb_opB,
  input [XLEN          -1:0] id_opA,
  input [XLEN          -1:0] id_opB,

  // from RF
  input [XLEN-1:0] rf_srcv1,
  input [XLEN-1:0] rf_srcv2,

  // to MEM
  output reg [XLEN-1:0] ex_r,

  // Bypasses
  input [XLEN-1:0] mem_r,
  input [XLEN-1:0] wb_r,

  // To State
  output [    11:0] ex_csr_reg,
  output [XLEN-1:0] ex_csr_wval,
  output            ex_csr_we,

  // From State
  input [     1:0] st_prv,
  input [     1:0] st_xlen,
  input            st_flush,
  input [XLEN-1:0] st_csr_rval,

  // To DCACHE/Memory
  output [XLEN-1:0] dmem_adr,
  output [XLEN-1:0] dmem_d,
  output            dmem_req,
  output            dmem_we,
  output [     2:0] dmem_size,
  input             dmem_ack,
  input  [XLEN-1:0] dmem_q,
  input             dmem_misaligned,
  input             dmem_page_fault,

  // Debug Unit
  input            du_stall,
  input            du_stall_dly,
  input            du_flush,
  input            du_we_pc,
  input [XLEN-1:0] du_dato,
  input [    31:0] du_ie
);

  //////////////////////////////////////////////////////////////////////////////
  // Variables
  //////////////////////////////////////////////////////////////////////////////

  // Operand generation
  logic [          XLEN-1:0] opA;
  logic [          XLEN-1:0] opB;

  logic [          XLEN-1:0] alu_r;
  logic [          XLEN-1:0] lsu_r;
  logic [          XLEN-1:0] mul_r;
  logic [          XLEN-1:0] div_r;

  // Pipeline Bubbles
  logic                      alu_bubble;
  logic                      lsu_bubble;
  logic                      mul_bubble;
  logic                      div_bubble;

  // Pipeline stalls
  logic                      lsu_stall;
  logic                      mul_stall;
  logic                      div_stall;

  // Exceptions
  logic [EXCEPTION_SIZE-1:0] bu_exception;
  logic [EXCEPTION_SIZE-1:0] lsu_exception;

  //////////////////////////////////////////////////////////////////////////////
  // Module Body
  //////////////////////////////////////////////////////////////////////////////

  // Program Counter
  always @(posedge clk, negedge rstn) begin
    if (!rstn) begin
      ex_pc <= PC_INIT;
    end else if (!ex_stall && !du_stall) begin
      ex_pc <= id_pc;  // stall during DBG to retain PPC
    end
  end

  // Instruction
  always @(posedge clk) begin
    if (!ex_stall) begin
      ex_instr <= id_instr;
    end
  end

  // Bypasses

  // Ignore the bypasses during dbg_stall, use register-file instead
  // use du_stall_dly, because this is combinatorial
  // When the pipeline is longer than the time for the debugger to access the system, this fails
  always @(*) begin
    casex ({
      id_userf_opA, id_bypwb_opA, id_bypmem_opA, id_bypex_opA
    })
      4'b???1: opA = du_stall_dly ? rf_srcv1 : ex_r;
      4'b??10: opA = du_stall_dly ? rf_srcv1 : mem_r;
      4'b?100: opA = du_stall_dly ? rf_srcv1 : wb_r;
      4'b1000: opA = rf_srcv1;
      default: opA = id_opA;
    endcase
  end

  always @(*) begin
    casex ({
      id_userf_opB, id_bypwb_opB, id_bypmem_opB, id_bypex_opB
    })
      4'b???1: opB = du_stall_dly ? rf_srcv2 : ex_r;
      4'b??10: opB = du_stall_dly ? rf_srcv2 : mem_r;
      4'b?100: opB = du_stall_dly ? rf_srcv2 : wb_r;
      4'b1000: opB = rf_srcv2;
      default: opB = id_opB;
    endcase
  end

  // Execution Units

  // Arithmetic Logic Unit
  pu_riscv_alu #(
    .XLEN   (XLEN),
    .ILEN   (ILEN),
    .HAS_RVC(HAS_RVC)
  ) alu (
    .rstn       (rstn),
    .clk        (clk),
    .ex_stall   (ex_stall),
    .id_pc      (id_pc),
    .id_bubble  (id_bubble),
    .id_instr   (id_instr),
    .opA        (opA),
    .opB        (opB),
    .alu_bubble (alu_bubble),
    .alu_r      (alu_r),
    .ex_csr_reg (ex_csr_reg),
    .ex_csr_wval(ex_csr_wval),
    .ex_csr_we  (ex_csr_we),
    .st_csr_rval(st_csr_rval),
    .st_xlen    (st_xlen)
  );

  // Load-Store Unit
  pu_riscv_lsu #(
    .XLEN          (XLEN),
    .ILEN          (ILEN),
    .EXCEPTION_SIZE(EXCEPTION_SIZE)
  ) lsu (
    .rstn           (rstn),
    .clk            (clk),
    .ex_stall       (ex_stall),
    .lsu_stall      (lsu_stall),
    .id_bubble      (id_bubble),
    .id_instr       (id_instr),
    .lsu_bubble     (lsu_bubble),
    .lsu_r          (lsu_r),
    .id_exception   (id_exception),
    .ex_exception   (ex_exception),
    .mem_exception  (mem_exception),
    .wb_exception   (wb_exception),
    .lsu_exception  (lsu_exception),
    .opA            (opA),
    .opB            (opB),
    .st_xlen        (st_xlen),
    .dmem_adr       (dmem_adr),
    .dmem_d         (dmem_d),
    .dmem_req       (dmem_req),
    .dmem_we        (dmem_we),
    .dmem_size      (dmem_size),
    .dmem_ack       (dmem_ack),
    .dmem_q         (dmem_q),
    .dmem_misaligned(dmem_misaligned),
    .dmem_page_fault(dmem_page_fault)
  );

  // Branch Unit
  pu_riscv_bu #(
    .XLEN          (XLEN),
    .ILEN          (ILEN),
    .EXCEPTION_SIZE(EXCEPTION_SIZE),
    .PC_INIT       (PC_INIT),
    .BP_GLOBAL_BITS(BP_GLOBAL_BITS),
    .HAS_RVC       (HAS_RVC)
  ) bu (
    .rstn         (rstn),
    .clk          (clk),
    .ex_stall     (ex_stall),
    .st_flush     (st_flush),
    .id_pc        (id_pc),
    .bu_nxt_pc    (bu_nxt_pc),
    .bu_flush     (bu_flush),
    .bu_cacheflush(bu_cacheflush),
    .id_bp_predict(id_bp_predict),
    .bu_bp_predict(bu_bp_predict),
    .bu_bp_history(bu_bp_history),
    .bu_bp_btaken (bu_bp_btaken),
    .bu_bp_update (bu_bp_update),
    .id_bubble    (id_bubble),
    .id_instr     (id_instr),
    .id_exception (id_exception),
    .ex_exception (ex_exception),
    .mem_exception(mem_exception),
    .wb_exception (wb_exception),
    .bu_exception (ex_exception),
    .opA          (opA),
    .opB          (opB),
    .du_stall     (du_stall),
    .du_flush     (du_flush),
    .du_we_pc     (du_we_pc),
    .du_dato      (du_dato),
    .du_ie        (du_ie)
  );

  generate
    if (HAS_RVM) begin
      pu_riscv_mul #(
        .XLEN(XLEN),
        .ILEN(ILEN)
      ) mul (
        .rstn      (rstn),
        .clk       (clk),
        .ex_stall  (ex_stall),
        .mul_stall (mul_stall),
        .id_bubble (id_bubble),
        .id_instr  (id_instr),
        .opA       (opA),
        .opB       (opB),
        .st_xlen   (st_xlen),
        .mul_bubble(mul_bubble),
        .mul_r     (mul_r)
      );

      pu_riscv_div #(
        .XLEN(XLEN),
        .ILEN(ILEN)
      ) div (
        .rstn      (rstn),
        .clk       (clk),
        .ex_stall  (ex_stall),
        .div_stall (div_stall),
        .id_bubble (id_bubble),
        .id_instr  (id_instr),
        .opA       (opA),
        .opB       (opB),
        .st_xlen   (st_xlen),
        .div_bubble(div_bubble),
        .div_r     (div_r)
      );
    end else begin
      assign mul_bubble = 1'b1;
      assign mul_r      = 'h0;
      assign mul_stall  = 1'b0;

      assign div_bubble = 1'b1;
      assign div_r      = 'h0;
      assign div_stall  = 1'b0;
    end
  endgenerate

  // Combine outputs into 1 single EX output
  assign ex_bubble = alu_bubble & lsu_bubble & mul_bubble & div_bubble;
  assign ex_stall  = wb_stall | lsu_stall | mul_stall | div_stall;

  // result
  always @(*) begin
    casex ({
      mul_bubble, div_bubble, lsu_bubble
    })
      3'b110:  ex_r = lsu_r;
      3'b101:  ex_r = div_r;
      3'b011:  ex_r = mul_r;
      default: ex_r = alu_r;
    endcase
  end
endmodule
