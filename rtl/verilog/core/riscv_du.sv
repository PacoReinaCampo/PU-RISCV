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
//              Core - Debug Unit                                             //
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

module riscv_du #(
  parameter XLEN = 64,
  parameter PLEN = 64,
  parameter ILEN = 64,

  parameter EXCEPTION_SIZE = 16,

  parameter DU_ADDR_SIZE    = 12,
  parameter MAX_BREAKPOINTS = 8,

  parameter BREAKPOINTS = 3
)
  (
  input                           rstn,
  input                           clk,

  //Debug Port interface
  input                           dbg_stall,
  input                           dbg_strb,
  input                           dbg_we,
  input      [PLEN          -1:0] dbg_addr,
  input      [XLEN          -1:0] dbg_dati,
  output reg [XLEN          -1:0] dbg_dato,
  output                          dbg_ack,
  output reg                      dbg_bp,


  //CPU signals
  output                          du_stall,
  output reg                      du_stall_dly,
  output                          du_flush,
  output reg                      du_we_rf,
  output reg                      du_we_frf,
  output reg                      du_we_csr,
  output reg                      du_we_pc,
  output reg [DU_ADDR_SIZE  -1:0] du_addr,
  output reg [XLEN          -1:0] du_dato,
  output     [              31:0] du_ie,
  input      [XLEN          -1:0] du_dati_rf,
  input      [XLEN          -1:0] du_dati_frf,
  input      [XLEN          -1:0] st_csr_rval,
  input      [XLEN          -1:0] if_pc,
  input      [XLEN          -1:0] id_pc,
  input      [XLEN          -1:0] ex_pc,
  input      [XLEN          -1:0] bu_nxt_pc,
  input                           bu_flush,
  input                           st_flush,

  input      [ILEN          -1:0] if_instr,
  input      [ILEN          -1:0] mem_instr,
  input                           if_bubble,
  input                           mem_bubble,
  input      [EXCEPTION_SIZE-1:0] mem_exception,
  input      [XLEN          -1:0] mem_memadr,
  input                           dmem_ack,
  input                           ex_stall,
//                                mem_req,
//                                mem_we,
//input      [XLEN          -1:0] mem_adr,

  //From state
  input      [              31:0] du_exceptions
);

  //////////////////////////////////////////////////////////////////
  //
  // Variables
  //
  logic                                dbg_strb_dly;
  logic [PLEN         -1:DU_ADDR_SIZE] du_bank_addr;
  logic                                du_sel_internal;
  logic                                du_sel_gprs;
  logic                                du_sel_csrs;
  logic                                du_access;
  logic                                du_we;
  logic                     [     2:0] du_ack;

  logic                                du_we_internal;
  logic                     [XLEN-1:0] du_internal_regs;

  logic                                dbg_branch_break_ena;
  logic                                dbg_instr_break_ena;
  logic                     [    31:0] dbg_ie;
  logic                     [XLEN-1:0] dbg_cause;

  logic [MAX_BREAKPOINTS-1:0]           dbg_bp_hit;
  logic                                 dbg_branch_break_hit;
  logic                                 dbg_instr_break_hit;
  logic [MAX_BREAKPOINTS-1:0][     2:0] dbg_cc;
  logic [MAX_BREAKPOINTS-1:0]           dbg_enabled;
  logic [MAX_BREAKPOINTS-1:0]           dbg_implemented;
  logic [MAX_BREAKPOINTS-1:0][XLEN-1:0] dbg_data;

  logic                                bp_instr_hit;
  logic                                bp_branch_hit;
  logic [MAX_BREAKPOINTS-1:0]          bp_hit;

  logic                                mem_read;
  logic                                mem_write;

  genvar n;

  //////////////////////////////////////////////////////////////////
  //
  // Module Body
  //

  //Debugger Interface

  // Decode incoming address
  assign du_bank_addr    = dbg_addr[PLEN-1:DU_ADDR_SIZE];
  assign du_sel_internal = du_bank_addr == DBG_INTERNAL;
  assign du_sel_gprs     = du_bank_addr == DBG_GPRS;
  assign du_sel_csrs     = du_bank_addr == DBG_CSRS;

  //generate 1 cycle pulse strobe
  always @(posedge clk) begin
    dbg_strb_dly <= dbg_strb;
  end

  //generate (write) access signals
  assign du_access = (dbg_strb & dbg_stall) | (dbg_strb & du_sel_internal);
  assign du_we     = du_access & ~dbg_strb_dly & dbg_we;

  // generate ACK
  always @(posedge clk,negedge rstn) begin
    if      (!rstn    ) du_ack <= 'h0;
    else if (!ex_stall) du_ack <= {3{du_access & ~dbg_ack}} & {1'b1,du_ack[2:1]};
  end

  assign dbg_ack = du_ack[0];

  //actual BreakPoint signal
  always @(posedge clk,negedge rstn) begin
    if (!rstn) dbg_bp <= 'b0;
    else       dbg_bp <= ~ex_stall & ~du_stall & ~du_flush & ~bu_flush & ~st_flush & (|du_exceptions | |{dbg_bp_hit, dbg_branch_break_hit, dbg_instr_break_hit});
  end

  //CPU Interface

  // assign CPU signals
  assign du_stall = dbg_stall;

  always @(posedge clk,negedge rstn) begin
    if (!rstn) du_stall_dly <= 1'b0;
    else       du_stall_dly <= du_stall;
  end

  assign du_flush = du_stall_dly & ~dbg_stall & |du_exceptions;

  always @(posedge clk) begin
    du_addr        <= dbg_addr[DU_ADDR_SIZE-1:0];
    du_dato        <= dbg_dati;

    du_we_rf       <= du_we & du_sel_gprs & (dbg_addr[DU_ADDR_SIZE-1:0] == DBG_GPR);
    du_we_frf      <= du_we & du_sel_gprs & (dbg_addr[DU_ADDR_SIZE-1:0] == DBG_FPR);
    du_we_internal <= du_we & du_sel_internal;
    du_we_csr      <= du_we & du_sel_csrs;
    du_we_pc       <= du_we & du_sel_gprs & (dbg_addr[DU_ADDR_SIZE-1:0] == DBG_NPC);
  end

  // Return signals
  always @(*) begin
    case (du_addr)
      DBG_CTRL   : du_internal_regs = { {XLEN- 2{1'b0}}, dbg_branch_break_ena, dbg_instr_break_ena };
      DBG_HIT    : du_internal_regs = { {XLEN-16{1'b0}}, dbg_bp_hit, 6'h0, dbg_branch_break_hit, dbg_instr_break_hit};
      DBG_IE     : du_internal_regs = { {XLEN-32{1'b0}}, dbg_ie};
      DBG_CAUSE  : du_internal_regs = { {XLEN-32{1'b0}}, dbg_cause};

      DBG_BPCTRL0: du_internal_regs = { {XLEN- 7{1'b0}}, dbg_cc[0], 2'h0, dbg_enabled[0], dbg_implemented[0]};
      DBG_BPDATA0: du_internal_regs = dbg_data[0];

      DBG_BPCTRL1: du_internal_regs = { {XLEN- 7{1'b0}}, dbg_cc[1], 2'h0, dbg_enabled[1], dbg_implemented[1]};
      DBG_BPDATA1: du_internal_regs = dbg_data[1];

      DBG_BPCTRL2: du_internal_regs = { {XLEN- 7{1'b0}}, dbg_cc[2], 2'h0, dbg_enabled[2], dbg_implemented[2]};
      DBG_BPDATA2: du_internal_regs = dbg_data[2];

      DBG_BPCTRL3: du_internal_regs = { {XLEN- 7{1'b0}}, dbg_cc[3], 2'h0, dbg_enabled[3], dbg_implemented[3]};
      DBG_BPDATA3: du_internal_regs = dbg_data[3];

      DBG_BPCTRL4: du_internal_regs = { {XLEN- 7{1'b0}}, dbg_cc[4], 2'h0, dbg_enabled[4], dbg_implemented[4]};
      DBG_BPDATA4: du_internal_regs = dbg_data[4];

      DBG_BPCTRL5: du_internal_regs = { {XLEN- 7{1'b0}}, dbg_cc[5], 2'h0, dbg_enabled[5], dbg_implemented[5]};
      DBG_BPDATA5: du_internal_regs = dbg_data[5];

      DBG_BPCTRL6: du_internal_regs = { {XLEN- 7{1'b0}}, dbg_cc[6], 2'h0, dbg_enabled[6], dbg_implemented[6]};
      DBG_BPDATA6: du_internal_regs = dbg_data[6];

      DBG_BPCTRL7: du_internal_regs = { {XLEN- 7{1'b0}}, dbg_cc[7], 2'h0, dbg_enabled[7], dbg_implemented[7]};
      DBG_BPDATA7: du_internal_regs = dbg_data[7];

      default     : du_internal_regs = 'h0;
    endcase
  end

  always @(posedge clk) begin
    casex (dbg_addr)
      {DBG_INTERNAL, 12'h???}: dbg_dato <= du_internal_regs;
      {DBG_GPRS,     DBG_GPR}: dbg_dato <= du_dati_rf;
      {DBG_GPRS,     DBG_FPR}: dbg_dato <= du_dati_frf;
      {DBG_GPRS,     DBG_NPC}: dbg_dato <= bu_flush ? bu_nxt_pc : id_pc;
      {DBG_GPRS,     DBG_PPC}: dbg_dato <= ex_pc;
      {DBG_CSRS,     12'h???}: dbg_dato <= st_csr_rval;
      default                 : dbg_dato <= 'h0;
    endcase
  end

  //Registers

  //DBG CTRL
  always @(posedge clk,negedge rstn) begin
    if (!rstn) begin
      dbg_instr_break_ena  <= 1'b0;
      dbg_branch_break_ena <= 1'b0;
    end
    else if (du_we_internal && du_addr == DBG_CTRL) begin
      dbg_instr_break_ena  <= du_dato[0];
      dbg_branch_break_ena <= du_dato[1];
    end
  end

  //DBG HIT
  always @(posedge clk,negedge rstn) begin
    if (!rstn) begin
      dbg_instr_break_hit  <= 1'b0;
      dbg_branch_break_hit <= 1'b0;
    end
    else if (du_we_internal && du_addr == DBG_HIT) begin
      dbg_instr_break_hit  <= du_dato[0];
      dbg_branch_break_hit <= du_dato[1];
    end
    else begin
      if (bp_instr_hit ) dbg_instr_break_hit  <= 1'b1;
      if (bp_branch_hit) dbg_branch_break_hit <= 1'b1;
    end
  end

  generate
    for (n=0; n<MAX_BREAKPOINTS; n=n+1) begin: gen_bp_hits
      if (n < BREAKPOINTS) begin
        always @(posedge clk,negedge rstn) begin
          if      (!rstn                                 ) dbg_bp_hit[n] <= 1'b0;
          else if ( du_we_internal && du_addr == DBG_HIT ) dbg_bp_hit[n] <= du_dato[n + 4];
          else if ( bp_hit[n]                            ) dbg_bp_hit[n] <= 1'b1;
        end
      end
      //else //n >= BREAKPOINTS
        //assign dbg_bp_hit[n] = 1'b0;
    end
  endgenerate

  //DBG IE
  always @(posedge clk,negedge rstn) begin
    if      (!rstn                                ) dbg_ie <= 'h0;
    else if ( du_we_internal && du_addr == DBG_IE ) dbg_ie <= du_dato[31:0];
  end

  //send to Thread-State
  assign du_ie = dbg_ie;

  //DBG CAUSE
  always @(posedge clk,negedge rstn) begin
    if (!rstn)                                        dbg_cause <= 'h0;
    else if ( du_we_internal && du_addr == DBG_CAUSE) dbg_cause <= du_dato;
    else if (|du_exceptions[15:0]) begin //traps
      casex (du_exceptions[15:0])
        16'h???1 : dbg_cause <=  0;
        16'h???2 : dbg_cause <=  1;
        16'h???4 : dbg_cause <=  2;
        16'h???8 : dbg_cause <=  3;
        16'h??10 : dbg_cause <=  4;
        16'h??20 : dbg_cause <=  5;
        16'h??40 : dbg_cause <=  6;
        16'h??80 : dbg_cause <=  7;
        16'h?100 : dbg_cause <=  8;
        16'h?200 : dbg_cause <=  9;
        16'h?400 : dbg_cause <= 10;
        16'h?800 : dbg_cause <= 11;
        16'h1000 : dbg_cause <= 12;
        16'h2000 : dbg_cause <= 13;
        16'h4000 : dbg_cause <= 14;
        16'h8000 : dbg_cause <= 15;
        default  : dbg_cause <=  0;
      endcase
    end
    else if (|du_exceptions[31:16]) begin //Interrupts
      casex ( du_exceptions[31:16])
        16'h???1 : dbg_cause <= ('h1 << (XLEN-1)) |  0;
        16'h???2 : dbg_cause <= ('h1 << (XLEN-1)) |  1;
        16'h???4 : dbg_cause <= ('h1 << (XLEN-1)) |  2;
        16'h???8 : dbg_cause <= ('h1 << (XLEN-1)) |  3;
        16'h??10 : dbg_cause <= ('h1 << (XLEN-1)) |  4;
        16'h??20 : dbg_cause <= ('h1 << (XLEN-1)) |  5;
        16'h??40 : dbg_cause <= ('h1 << (XLEN-1)) |  6;
        16'h??80 : dbg_cause <= ('h1 << (XLEN-1)) |  7;
        16'h?100 : dbg_cause <= ('h1 << (XLEN-1)) |  8;
        16'h?200 : dbg_cause <= ('h1 << (XLEN-1)) |  9;
        16'h?400 : dbg_cause <= ('h1 << (XLEN-1)) | 10;
        16'h?800 : dbg_cause <= ('h1 << (XLEN-1)) | 11;
        16'h1000 : dbg_cause <= ('h1 << (XLEN-1)) | 12;
        16'h2000 : dbg_cause <= ('h1 << (XLEN-1)) | 13;
        16'h4000 : dbg_cause <= ('h1 << (XLEN-1)) | 14;
        16'h8000 : dbg_cause <= ('h1 << (XLEN-1)) | 15;
        default  : dbg_cause <= ('h1 << (XLEN-1)) |  0;
      endcase
    end
  end

  //DBG BPCTRL / DBG BPDATA
  generate
    for (n=0; n<MAX_BREAKPOINTS; n=n+1) begin: gen_bp
      if (n < BREAKPOINTS) begin
        assign dbg_implemented[n] = 1'b1;

        always @(posedge clk,negedge rstn) begin
          if (!rstn) begin
            dbg_enabled[n] <= 'b0;
            dbg_cc[n]      <= 'h0;
          end
          else if (du_we_internal && du_addr == (DBG_BPCTRL0 + 2*n) ) begin
            dbg_enabled[n] <= du_dato[1];
            dbg_cc[n]      <= du_dato[6:4];
          end
        end
        always @(posedge clk,negedge rstn) begin
          if (!rstn)                                                  dbg_data[n] <= 'h0;
          else if (du_we_internal && du_addr == (DBG_BPDATA0 + 2*n) ) dbg_data[n] <= du_dato;
        end
      end
      else begin
        //assign dbg_cc          [n] = 'h0;
        //assign dbg_enabled     [n] = 'h0;
        //assign dbg_implemented [n] = 'h0;
        //assign dbg_data        [n] = 'h0;
      end
    end
  endgenerate

  /*
   * BreakPoints
   *
   * Combinatorial generation of break-point hit logic
   * For actual registers see 'Registers' section
   */

  assign bp_instr_hit  =dbg_instr_break_ena  & ~if_bubble;
  assign bp_branch_hit = dbg_branch_break_ena & ~if_bubble & (if_instr[6:2] == OPC_BRANCH);

  //Memory access
  assign mem_read  = ~|mem_exception & ~mem_bubble & (mem_instr[6:2] == OPC_LOAD );
  assign mem_write = ~|mem_exception & ~mem_bubble & (mem_instr[6:2] == OPC_STORE);

  generate
    for (n=0; n<MAX_BREAKPOINTS; n=n+1) begin: gen_bp_hit
      if (n < BREAKPOINTS) begin: gen_hit_logic
        always @(*) begin
          if (!dbg_enabled[n] || !dbg_implemented[n]) bp_hit[n] = 1'b0;
          else
            case (dbg_cc[n])
              BP_CTRL_CC_FETCH    : bp_hit[n] = (if_pc      == dbg_data[n]) & ~bu_flush & ~st_flush;
              BP_CTRL_CC_LD_ADR   : bp_hit[n] = (mem_memadr == dbg_data[n]) & dmem_ack & mem_read;
              BP_CTRL_CC_ST_ADR   : bp_hit[n] = (mem_memadr == dbg_data[n]) & dmem_ack & mem_write;
              BP_CTRL_CC_LDST_ADR : bp_hit[n] = (mem_memadr == dbg_data[n]) & dmem_ack & (mem_read | mem_write);
            //BP_CTRL_CC_LD_ADR   : bp_hit[n] = (mem_adr    == dbg_data[n]) & mem_req & ~mem_we;
            //BP_CTRL_CC_ST_ADR   : bp_hit[n] = (mem_adr    == dbg_data[n]) & mem_req &  mem_we;
            //BP_CTRL_CC_LDST_ADR : bp_hit[n] = (mem_adr    == dbg_data[n]) & mem_req;
              default             : bp_hit[n] = 1'b0;
            endcase
        end
      end
      else begin //n >= BREAKPOINTS
        //assign bp_hit[n] = 1'b0;
      end
    end
  endgenerate
endmodule
