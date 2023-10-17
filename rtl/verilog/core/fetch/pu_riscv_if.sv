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
//              Core - Instruction Fetch                                      //
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

import pu_riscv_verilog_pkg::*;

module pu_riscv_if #(
  parameter XLEN           = 64,
  parameter ILEN           = 64,
  parameter PARCEL_SIZE    = 64,
  parameter EXCEPTION_SIZE = 16,

  parameter [XLEN-1:0] PC_INIT = 'h8000_0000
) (
  input rstn,     //Reset
  input clk,      //Clock
  input id_stall,

  input                      if_stall_nxt_pc,
  input [PARCEL_SIZE   -1:0] if_parcel,
  input [XLEN          -1:0] if_parcel_pc,
  input [PARCEL_SIZE/16-1:0] if_parcel_valid,
  input                      if_parcel_misaligned,
  input                      if_parcel_page_fault,

  output reg [ILEN          -1:0] if_instr,     //Instruction out
  output reg                      if_bubble,    //Insert bubble in the pipe (NOP instruction)
  output reg [EXCEPTION_SIZE-1:0] if_exception, //Exceptions


  input      [1:0] bp_bp_predict,  //Branch Prediction bits
  output reg [1:0] if_bp_predict,  //push down the pipe

  input bu_flush,  //flush pipe & load new program counter
  input st_flush,
  input du_flush,  //flush pipe after debug exit

  input [XLEN          -1:0] bu_nxt_pc,  //Branch Unit Next Program Counter
  input [XLEN          -1:0] st_nxt_pc,  //State Next Program Counter

  output reg [XLEN          -1:0] if_nxt_pc,  //next Program Counter
  output                          if_stall,   //stall instruction fetch BIU (cache/bus-interface)
  output                          if_flush,   //flush instruction fetch BIU (cache/bus-interface)
  output reg [XLEN          -1:0] if_pc       //Program Counter
);

  //////////////////////////////////////////////////////////////////////////////
  //
  // Variables
  //

  //Instruction size
  logic                      is_16bit_instruction;
  logic                      is_32bit_instruction;
  //logic is_48bit_instruction;
  //logic is_64bit_instruction;

  logic                      flushes;  //OR all flush signals

  logic [2*ILEN        -1:0] parcel_shift_register;
  logic [ILEN          -1:0] new_parcel;
  logic [ILEN          -1:0] active_parcel;
  logic [ILEN          -1:0] converted_instruction;
  logic [ILEN          -1:0] pd_instr;
  logic                      pd_bubble;

  logic [XLEN          -1:0] pd_pc;
  logic                      parcel_valid;
  logic [               2:0] parcel_sr_valid;
  logic [               2:0] parcel_sr_bubble;

  logic [               6:2] opcode;

  logic [EXCEPTION_SIZE-1:0] parcel_exception;
  logic [EXCEPTION_SIZE-1:0] pd_exception;

  logic [XLEN          -1:0] branch_pc;
  logic                      branch_taken;

  logic [XLEN          -1:0] immB;
  logic [XLEN          -1:0] immJ;

  //////////////////////////////////////////////////////////////////////////////
  //
  // Module Body
  //

  //All flush signals
  assign flushes  = bu_flush | st_flush | du_flush;

  //Flush upper layer (memory BIU) 
  assign if_flush = bu_flush | st_flush | du_flush | branch_taken;

  //stall program counter on ID-stall and when instruction-hold register is full
  assign if_stall = id_stall | (&parcel_sr_valid & ~flushes);

  //parcel is valid when bus-interface says so AND when received PC is requested PC
  always @(posedge clk, negedge rstn) begin
    if (!rstn) begin
      parcel_valid <= 1'b0;
    end else begin
      parcel_valid <= if_parcel_valid;
    end
  end

  //Next Program Counter
  always @(posedge clk, negedge rstn) begin
    if (!rstn) begin
      if_nxt_pc <= PC_INIT;
    end else if (st_flush) begin
      if_nxt_pc <= st_nxt_pc;
    end else if (bu_flush || du_flush) begin
      if_nxt_pc <= bu_nxt_pc;  //flush takes priority
    // end else if (!id_stall)
    end else begin
      if (branch_taken) begin
        if_nxt_pc <= branch_pc;
      end else if (!if_stall_nxt_pc) begin
        if_nxt_pc <= if_nxt_pc + 4;  //if_stall_nxt_pc
      end
    end
  end

  //      else if (!if_stall_nxt_pc && !id_stall) if_nxt_pc <= if_nxt_pc + 'h4;
  //TODO: handle if_stall and 16bit instructions

  always @(posedge clk, negedge rstn) begin
    if (!rstn) begin
      pd_pc <= PC_INIT;
    end else if (st_flush) begin
      pd_pc <= st_nxt_pc;
    end else if (bu_flush || du_flush) begin
      pd_pc <= bu_nxt_pc;
    end else if (branch_taken && !id_stall) begin
      pd_pc <= branch_pc;
    end else if (if_parcel_valid && !id_stall) begin
      pd_pc <= if_parcel_pc;
    end
  end

  always @(posedge clk, negedge rstn) begin
    if (!rstn) begin
      if_pc <= PC_INIT;
    end else if (st_flush) begin
      if_pc <= st_nxt_pc;
    end else if (bu_flush || du_flush) begin
      if_pc <= bu_nxt_pc;
    end else if (!id_stall) begin
      if_pc <= pd_pc;
    end
  end

  //Instruction

  //instruction shift register, for 16bit instruction support
  assign new_parcel = if_parcel;
  always @(posedge clk, negedge rstn) begin
    if (!rstn) begin
      parcel_shift_register <= {INSTR_NOP, INSTR_NOP};
    end else if (flushes) begin
      parcel_shift_register <= {INSTR_NOP, INSTR_NOP};
    end else if (!id_stall) begin
      if (branch_taken) begin
        parcel_shift_register <= {INSTR_NOP, INSTR_NOP};
      end else begin
        case (parcel_sr_valid)
          3'b000: parcel_shift_register <= {INSTR_NOP, new_parcel};
          3'b001: begin
            if (is_16bit_instruction) 
              parcel_shift_register <= {INSTR_NOP, new_parcel};
            else begin
              parcel_shift_register <= {new_parcel, parcel_shift_register[15:0]};
            end
          end
          3'b011: begin
            if (is_16bit_instruction) begin
              parcel_shift_register <= {new_parcel, parcel_shift_register[16 +: ILEN]};
            end else begin
              parcel_shift_register <= {INSTR_NOP, new_parcel};
            end
          end
          3'b111: begin
            if (is_16bit_instruction) begin
              parcel_shift_register <= {INSTR_NOP, parcel_shift_register[16 +: ILEN]};
            end else begin
              parcel_shift_register <= {new_parcel, parcel_shift_register[32 +: 16]};
            end
          end
        endcase
      end
    end
  end

  always @(posedge clk, negedge rstn) begin
    if (!rstn) begin
      parcel_sr_valid <= 'h0;
    end else if (flushes) begin
      parcel_sr_valid <= 'h0;
    end else if (!id_stall) begin
      if (branch_taken) begin
        parcel_sr_valid <= 'h0;
      end else begin
        case (parcel_sr_valid)
          //branch to 16bit address would yield 3'b010
          3'b000: parcel_sr_valid <= {1'b0, if_parcel_valid};  //3'b011;
          3'b001: begin
            if (is_16bit_instruction) begin
              parcel_sr_valid <= {1'b0, if_parcel_valid};  //3'b011;
            end else begin
              parcel_sr_valid <= {if_parcel_valid, 1'b1};  //3'b111;
            end
          end
          3'b011: begin
            if (is_16bit_instruction) begin
              parcel_sr_valid <= {if_parcel_valid, 1'b1};  //3'b111;
            end else begin
              parcel_sr_valid <= {1'b0, if_parcel_valid};  //3'b011;
            end
          end
          3'b111: begin
            if (is_16bit_instruction) begin
              parcel_sr_valid <= {1'b0, 1'b1, 1'b1};  //3'b011;
            end else begin
              parcel_sr_valid <= {if_parcel_valid, 1'b1};  //3'b111;
            end
          end
        endcase
      end
    end
  end

  assign active_parcel        = parcel_shift_register[ILEN-1:0];
  assign pd_bubble            = is_16bit_instruction ? ~parcel_sr_valid[0] : ~&parcel_sr_valid[1:0];

  assign is_16bit_instruction = ~&active_parcel[1:0];
  assign is_32bit_instruction = &active_parcel[1:0];
  //assign is_48bit_instruction =   active_parcel[5:0] == 6'b011111;
  //assign is_64bit_instruction =   active_parcel[6:0] == 7'b0111111;

  //Convert 16bit instructions to 32bit instructions here.
  always @(*) begin
    case (active_parcel)
      WFI: pd_instr = INSTR_NOP;  //Implement WFI as a nop 
      default: begin
        if (is_32bit_instruction) begin
          pd_instr = active_parcel;
        end else begin
          pd_instr = -1;  //Illegal
        end
      end
    endcase
  end

  always @(posedge clk, negedge rstn) begin
    if (!rstn) begin
      if_instr <= INSTR_NOP;
    end else if (flushes) begin
      if_instr <= INSTR_NOP;
    end else if (!id_stall) begin
      if_instr <= pd_instr;
    end
  end

  always @(posedge clk, negedge rstn) begin
    if (!rstn) begin
      if_bubble <= 1'b1;
    end else if (flushes) begin
      if_bubble <= 1'b1;
    end else if (!id_stall) begin
      if_bubble <= pd_bubble;
    end
  end

  //Branches & Jump
  assign immB   = {{XLEN - 12{pd_instr[31]}}, pd_instr[7], pd_instr[30:25], pd_instr[11:8], 1'b0};
  assign immJ   = {{XLEN - 20{pd_instr[31]}}, pd_instr[19:12], pd_instr[20], pd_instr[30:25], pd_instr[24:21], 1'b0};

  assign opcode = pd_instr[6:2];

  // Branch and Jump prediction
  always @(*) begin
    casex ({
      pd_bubble, opcode
    })
      {
        1'b0, OPC_JAL
      } : begin
        branch_taken = 1'b1;
        branch_pc    = pd_pc + immJ;
      end
      {
        1'b0, OPC_BRANCH
      } : begin
        //if this CPU has a Branch Predict Unit, then use it's prediction
        //otherwise assume backwards jumps taken, forward jumps not taken
        branch_taken = HAS_BPU ? bp_bp_predict[1] : immB[31];
        branch_pc    = pd_pc + immB;
      end
      default: begin
        branch_taken = 1'b0;
        branch_pc    = 'hx;
      end
    endcase
  end

  always @(posedge clk, negedge rstn) begin
    if (!rstn) begin
      if_bp_predict <= 2'b00;
    end else if (!id_stall) begin
      if_bp_predict <= (HAS_BPU) ? bp_bp_predict : {branch_taken, 1'b0};
    end
  end

  //Exceptions

  //parcel-fetch
  always @(posedge clk, negedge rstn) begin
    if (!rstn) begin
      parcel_exception <= 'h0;
    end else if (flushes) begin
      parcel_exception <= 'h0;
    end else if (parcel_valid && !id_stall) begin
      parcel_exception                                 <= 'h0;
      parcel_exception[CAUSE_MISALIGNED_INSTRUCTION]   <= if_parcel_misaligned;
      parcel_exception[CAUSE_INSTRUCTION_ACCESS_FAULT] <= if_parcel_page_fault;
    end
  end

  //pre-decode
  always @(posedge clk, negedge rstn) begin
    if (!rstn) begin
      pd_exception <= 'h0;
    end else if (flushes) begin
      pd_exception <= 'h0;
    end else if (parcel_valid && !id_stall) begin
      pd_exception <= parcel_exception;
    end
  end

  //instruction-fetch
  always @(posedge clk, negedge rstn) begin
    if (!rstn) begin
      if_exception <= 'h0;
    end else if (flushes) begin
      if_exception <= 'h0;
    end else if (parcel_valid && !id_stall) begin
      if_exception <= pd_exception;
    end
  end
endmodule
