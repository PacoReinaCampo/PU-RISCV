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
//              Core - Data Memory Access (Write Back)                        //
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

module riscv_wb #(
  parameter XLEN = 64,
  parameter ILEN = 64,

  parameter EXCEPTION_SIZE = 16,

  parameter [XLEN-1:0] PC_INIT = 'h8000_0000
)
  (
  input  logic                      rst_ni,        //Reset
  input  logic                      clk_i,         //Clock

  output logic                      wb_stall_o,    //Stall on memory-wait

  input  logic [XLEN          -1:0] mem_pc_i,
  output logic [XLEN          -1:0] wb_pc_o,

  input  logic [ILEN          -1:0] mem_instr_i,
  input  logic                      mem_bubble_i,
  output logic [ILEN          -1:0] wb_instr_o,
  output logic                      wb_bubble_o,

  input  logic [EXCEPTION_SIZE-1:0] mem_exception_i,
  output logic [EXCEPTION_SIZE-1:0] wb_exception_o,
  output logic [XLEN          -1:0] wb_badaddr_o,

  input  logic [XLEN          -1:0] mem_r_i,
  input  logic [XLEN          -1:0] mem_memadr_i,

  //From Memory System
  input  logic                      dmem_ack_i,
  input  logic                      dmem_err_i,
  input  logic [XLEN          -1:0] dmem_q_i,
  input  logic                      dmem_misaligned_i,
  input  logic                      dmem_page_fault_i,

  //To Register File
  output logic [               4:0] wb_dst_o,
  output logic [XLEN          -1:0] wb_r_o,
  output logic                      wb_we_o
);

  ////////////////////////////////////////////////////////////////
  //
  // Variables
  //

  logic [               6:2] opcode;
  logic [               2:0] func3;
  logic [               6:0] func7;
  logic [               4:0] dst;

  logic [EXCEPTION_SIZE-1:0] exception;

  logic [XLEN          -1:0] m_data;
  logic [               7:0] m_qb;
  logic [              15:0] m_qh;
  logic [              31:0] m_qw;

  logic [XLEN          -1:0] m_qd;

  ////////////////////////////////////////////////////////////////
  //
  // Module Body
  //

  //Program Counter
  always @(posedge clk_i, negedge rst_ni) begin
    if      (!rst_ni    ) wb_pc_o <= PC_INIT;
    else if (!wb_stall_o) wb_pc_o <= mem_pc_i;
  end

  //Instruction
  always @(posedge clk_i, negedge rst_ni) begin
    if      (!rst_ni    ) wb_instr_o <= `INSTR_NOP;
    else if (!wb_stall_o) wb_instr_o <= mem_instr_i;
  end

  assign func7  = mem_instr_i[31:25];
  assign func3  = mem_instr_i[14:12];
  assign opcode = mem_instr_i[ 6: 2];
  assign dst    = mem_instr_i[11: 7];

  //Exception
  always @(*) begin
    exception = mem_exception_i;

    if (opcode == `OPC_LOAD && ~mem_bubble_i)
      exception[`CAUSE_MISALIGNED_LOAD   ] = dmem_misaligned_i;

    if (opcode == `OPC_STORE && ~mem_bubble_i)
      exception[`CAUSE_MISALIGNED_STORE  ] = dmem_misaligned_i;

    if (opcode == `OPC_LOAD & ~mem_bubble_i)
      exception[`CAUSE_LOAD_ACCESS_FAULT ] = dmem_err_i;

    if (opcode == `OPC_STORE & ~mem_bubble_i)
      exception[`CAUSE_STORE_ACCESS_FAULT] = dmem_err_i;

    if (opcode == `OPC_LOAD && ~mem_bubble_i)
      exception[`CAUSE_LOAD_PAGE_FAULT   ] = dmem_page_fault_i;

    if (opcode == `OPC_STORE && ~mem_bubble_i)
      exception[`CAUSE_STORE_PAGE_FAULT  ] = dmem_page_fault_i;
  end

  always @(posedge clk_i, negedge rst_ni) begin
    if      (!rst_ni    ) wb_exception_o <= 'h0;
    else if (!wb_stall_o) wb_exception_o <= exception;
  end

  always @(posedge clk_i, negedge rst_ni) begin
    if (!rst_ni)
      wb_badaddr_o <= 'h0;
    else if (exception[`CAUSE_MISALIGNED_LOAD   ] ||
             exception[`CAUSE_MISALIGNED_STORE  ] ||
             exception[`CAUSE_LOAD_ACCESS_FAULT ] ||
             exception[`CAUSE_STORE_ACCESS_FAULT] ||
             exception[`CAUSE_LOAD_PAGE_FAULT   ] ||
             exception[`CAUSE_STORE_PAGE_FAULT  ] )
      wb_badaddr_o <= mem_memadr_i;
    else
      wb_badaddr_o <= mem_pc_i;
  end

  //From Memory
  always @(*) begin
    casex ( {mem_bubble_i,|mem_exception_i, opcode} )
      {2'b00,`OPC_LOAD } : wb_stall_o = ~(dmem_ack_i | dmem_err_i | dmem_misaligned_i | dmem_page_fault_i);
      {2'b00,`OPC_STORE} : wb_stall_o = ~(dmem_ack_i | dmem_err_i | dmem_misaligned_i | dmem_page_fault_i);
      default            : wb_stall_o = 1'b0;
    endcase
  end

  // data from memory
  generate
    if (XLEN==64) begin
      assign m_qb = dmem_q_i >> (8* mem_memadr_i[2:0]);
      assign m_qh = dmem_q_i >> (8* mem_memadr_i[2:0]);
      assign m_qw = dmem_q_i >> (8* mem_memadr_i[2:0]);
      assign m_qd = dmem_q_i;

      always @(*) begin
        casex ( {func7,func3,opcode} )
          `LB     : m_data = { {XLEN- 8{m_qb[ 7]}},m_qb};
          `LH     : m_data = { {XLEN-16{m_qh[15]}},m_qh};
          `LW     : m_data = { {XLEN-32{m_qw[31]}},m_qw};
          `LD     : m_data = {                     m_qd};
          `LBU    : m_data = { {XLEN- 8{    1'b0}},m_qb};
          `LHU    : m_data = { {XLEN-16{    1'b0}},m_qh};
          `LWU    : m_data = { {XLEN-32{    1'b0}},m_qw};
          default : m_data = 'hx;
        endcase
      end
    end
    else begin
      assign m_qb = dmem_q_i >> (8* mem_memadr_i[1:0]);
      assign m_qh = dmem_q_i >> (8* mem_memadr_i[1:0]);
      assign m_qw = dmem_q_i;

      always @(*) begin
        casex ( {func7,func3,opcode} )
          `LB     : m_data = { {XLEN- 8{m_qb[ 7]}},m_qb};
          `LH     : m_data = { {XLEN-16{m_qh[15]}},m_qh};
          `LW     : m_data = {                     m_qw};
          `LBU    : m_data = { {XLEN- 8{    1'b0}},m_qb};
          `LHU    : m_data = { {XLEN-16{    1'b0}},m_qh};
          default : m_data = 'hx;
        endcase
      end
    end
  endgenerate

  //Register File Write Back

  // Destination register
  always @(posedge clk_i) begin
    if (!wb_stall_o) wb_dst_o <= dst;
  end

  // Result
  always @(posedge clk_i) begin
    if (!wb_stall_o)
      casex (opcode)
        `OPC_LOAD: wb_r_o <= m_data;
        default  : wb_r_o <= mem_r_i;
      endcase
  end

  // Register File Write
  always @(posedge clk_i, negedge rst_ni) begin
    if      (!rst_ni   ) wb_we_o <= 'b0;
    else if (|exception) wb_we_o <= 'b0;
    else casex (opcode)
      `OPC_MISC_MEM : wb_we_o <= 'b0;
      `OPC_LOAD     : wb_we_o <= ~mem_bubble_i & |dst & ~wb_stall_o;
      `OPC_STORE    : wb_we_o <= 'b0;
      `OPC_STORE_FP : wb_we_o <= 'b0;
      `OPC_BRANCH   : wb_we_o <= 'b0;
      //`OPC_SYSTEM : wb_we_o <= 'b0;
      default       : wb_we_o <= ~mem_bubble_i & |dst;
    endcase
  end

  // Write Back Bubble
  always @(posedge clk_i, negedge rst_ni) begin
    if      (!rst_ni    ) wb_bubble_o <= 1'b1;
    else if (!wb_stall_o) wb_bubble_o <= mem_bubble_i;
  end
endmodule
