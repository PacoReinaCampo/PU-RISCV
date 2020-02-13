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
//              Core - Load Store Unit                                        //
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

module riscv_lsu #(
  parameter XLEN           = 64,
  parameter ILEN           = 64,
  parameter EXCEPTION_SIZE = 16
)
  (
    input                           rstn,
    input                           clk,

    input                           ex_stall,
    output reg                      lsu_stall,

    //Instruction
    input                           id_bubble,
    input      [ILEN          -1:0] id_instr,

    output reg                      lsu_bubble,
    output     [XLEN          -1:0] lsu_r,

    input      [EXCEPTION_SIZE-1:0] id_exception,
    input      [EXCEPTION_SIZE-1:0] ex_exception,
    input      [EXCEPTION_SIZE-1:0] mem_exception,
    input      [EXCEPTION_SIZE-1:0] wb_exception,
    output reg [EXCEPTION_SIZE-1:0] lsu_exception,

    //Operands
    input      [XLEN          -1:0] opA,
    input      [XLEN          -1:0] opB,

    //From State
    input      [               1:0] st_xlen,

    //To Memory
    output reg [XLEN          -1:0] dmem_adr,
    output reg [XLEN          -1:0] dmem_d,
    output reg                      dmem_req,
    output reg                      dmem_we,
    output logic              [2:0] dmem_size,

    //From Memory (for AMO)
    input                           dmem_ack,
    input      [XLEN          -1:0] dmem_q,
    input                           dmem_misaligned,
    input                           dmem_page_fault
  );

  ////////////////////////////////////////////////////////////////
  //
  // Constants
  //
  localparam IDLE = 2'b00;

  ////////////////////////////////////////////////////////////////
  //
  // Variables
  //
  logic [       6:2] opcode;
  logic [       2:0] func3;
  logic [       6:0] func7;
  logic              xlen32;

  //Operand generation
  logic [XLEN  -1:0] immS;

  //FSM
  logic [       1:0] state;

  logic [XLEN  -1:0] adr;
  logic [XLEN  -1:0] d;
  logic [       2:0] size;

  ////////////////////////////////////////////////////////////////
  //
  // Module Body
  //

  //Instruction
  assign func7  = id_instr[31:25];
  assign func3  = id_instr[14:12];
  assign opcode = id_instr[ 6: 2];

  assign xlen32 = (st_xlen == `RV32I);

  assign lsu_r  = 'h0; //for AMO

  //Decode Immediates
  assign immS = { {XLEN-11{id_instr[31]}}, id_instr[30:25],id_instr[11:8],id_instr[7] };

  //Access Statemachine
  always @(posedge clk, negedge rstn) begin
    if (!rstn) begin
      state      <= IDLE;
      lsu_stall  <= 1'b0;
      lsu_bubble <= 1'b1;
      dmem_req   <= 1'b0;
    end
    else begin
      dmem_req   <= 1'b0;

      case (state)
        IDLE : if (!ex_stall) begin
          if (!id_bubble && ~(|id_exception || |ex_exception || |mem_exception || |wb_exception)) begin
            case (opcode)
              `OPC_LOAD : begin
                dmem_req   <= 1'b1;
                lsu_stall  <= 1'b0;
                lsu_bubble <= 1'b0;
                state      <= IDLE;
              end
              `OPC_STORE: begin
                dmem_req   <= 1'b1;
                lsu_stall  <= 1'b0;
                lsu_bubble <= 1'b0;
                state      <= IDLE;
              end
              default  : begin
                dmem_req   <= 1'b0;
                lsu_stall  <= 1'b0;
                lsu_bubble <= 1'b1;
                state      <= IDLE;
              end
            endcase
          end
          else begin
            dmem_req   <= 1'b0;
            lsu_stall  <= 1'b0;
            lsu_bubble <= 1'b1;
            state      <= IDLE;
          end
        end

        default: begin
          dmem_req   <= 1'b0;
          lsu_stall  <= 1'b0;
          lsu_bubble <= 1'b1;
          state      <= IDLE;
        end
      endcase
    end
  end

  //Memory Control Signals
  always @(posedge clk) begin
    case (state)
      IDLE   : if (!id_bubble)
        case (opcode)
          `OPC_LOAD : begin
            dmem_we   <= 1'b0;
            dmem_size <= size;
            dmem_adr  <= adr;
            dmem_d    <=  'hx;
          end
          `OPC_STORE: begin
            dmem_we   <= 1'b1;
            dmem_size <= size;
            dmem_adr  <= adr;
            dmem_d    <= d;
          end
          default  : ; //do nothing
        endcase

      default: begin
        dmem_we   <= 1'bx;
        dmem_size <= `UNDEF_SIZE;
        dmem_adr  <=  'hx;
        dmem_d    <=  'hx;
      end
    endcase
  end

  //memory address
  always @(*) begin
    casex ( {xlen32,func7,func3,opcode} )
      {1'b?,`LB    }: adr = opA + opB;
      {1'b?,`LH    }: adr = opA + opB;
      {1'b?,`LW    }: adr = opA + opB;
      {1'b0,`LD    }: adr = opA + opB;  //RV64
      {1'b?,`LBU   }: adr = opA + opB;
      {1'b?,`LHU   }: adr = opA + opB;
      {1'b0,`LWU   }: adr = opA + opB;  //RV64
      {1'b?,`SB    }: adr = opA + immS;
      {1'b?,`SH    }: adr = opA + immS;
      {1'b?,`SW    }: adr = opA + immS;
      {1'b0,`SD    }: adr = opA + immS;  //RV64
      default       : adr = opA + opB;   //'hx;
    endcase
  end

  generate
    //memory byte enable
    if (XLEN==64) begin //RV64
      always @(*) begin
        casex ( {func7,func3,opcode} ) //func7 is don't care
          `LB     : size = `BYTE;
          `LH     : size = `HWORD;
          `LW     : size = `WORD;
          `LD     : size = `DWORD;
          `LBU    : size = `BYTE;
          `LHU    : size = `HWORD;
          `LWU    : size = `WORD;
          `SB     : size = `BYTE;
          `SH     : size = `HWORD;
          `SW     : size = `WORD;
          `SD     : size = `DWORD;
          default : size = `UNDEF_SIZE;
        endcase
      end

      //memory write data
      always @(*) begin
        casex ( {func7,func3,opcode} ) //func7 is don't care
          `SB     : d = opB[ 7:0] << (8* adr[2:0]);
          `SH     : d = opB[15:0] << (8* adr[2:0]);
          `SW     : d = opB[31:0] << (8* adr[2:0]);
          `SD     : d = opB;
          default : d = 'hx;
        endcase
      end
    end
    else begin //RV32
      always @(*) begin
        casex ( {func7,func3,opcode} ) //func7 is don't care
          `LB     : size = `BYTE;
          `LH     : size = `HWORD;
          `LW     : size = `WORD;
          `LBU    : size = `BYTE;
          `LHU    : size = `HWORD;
          `SB     : size = `BYTE;
          `SH     : size = `HWORD;
          `SW     : size = `WORD;
          default : size = `UNDEF_SIZE;
        endcase
      end

      //memory write data
      always @(*) begin
        casex ( {func7,func3,opcode} ) //func7 is don't care
          `SB     : d = opB[ 7:0] << (8* adr[1:0]);
          `SH     : d = opB[15:0] << (8* adr[1:0]);
          `SW     : d = opB;
          default : d = 'hx;
        endcase
      end
    end
  endgenerate

  /*
   * Exceptions
   * Regular memory exceptions are caught in the WB stage
   * However AMO accesses handle the 'load' here.
   */

  always @(posedge clk, negedge rstn) begin
    if      (!rstn     ) begin
      lsu_exception <= 'h0;
    end
    else if (!lsu_stall) begin
      lsu_exception <= id_exception;
    end
  end

  //Assertions

  //assert that address is known when memory is accessed
  //assert property ( @(posedge clk)(dmem_req) |-> (!isunknown(dmem_adr)) );
endmodule
