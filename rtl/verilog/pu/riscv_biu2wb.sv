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
//              Bus Interface Unit                                            //
//              Wishbone Bus Interface                                        //
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

module riscv_biu2wb #(
  parameter XLEN = 64,
  parameter PLEN = 64
)
  (
    input  wire              HRESETn,
    input  wire              HCLK,

    //WB Bus
    output reg   [PLEN -1:0] wb_adr_o,
    output reg   [XLEN -1:0] wb_dat_o,
    output reg   [      3:0] wb_sel_o,
    output reg               wb_we_o,
    output reg               wb_cyc_o,
    output reg               wb_stb_o,
    output reg   [      2:0] wb_cti_o,
    output reg   [      1:0] wb_bte_o,

    input  wire  [XLEN -1:0] wb_dat_i,
    input  wire              wb_ack_i,
    input  wire              wb_err_i,
    input  wire  [      2:0] wb_rty_i,

    //BIU Bus (Core ports)
    input  wire              biu_stb_i,      //strobe
    output reg               biu_stb_ack_o,  //strobe acknowledge; can send new strobe
    output reg               biu_d_ack_o,    //data acknowledge (send new biu_d_i); for pipelined buses
    input  wire  [PLEN -1:0] biu_adri_i,
    output reg   [PLEN -1:0] biu_adro_o,  
    input  wire  [      2:0] biu_size_i,     //transfer size
    input  wire  [      2:0] biu_type_i,     //burst type
    input  wire  [      2:0] biu_prot_i,     //protection
    input  wire              biu_lock_i,
    input  wire              biu_we_i,
    input  wire  [XLEN -1:0] biu_d_i,
    output reg   [XLEN -1:0] biu_q_o,
    output reg               biu_ack_o,      //transfer acknowledge
    output reg               biu_err_o       //transfer error
);

  //////////////////////////////////////////////////////////////////
  //
  // Functions
  //

  function automatic [2:0] biu_size2hsize;
    input [2:0] size;

    case (size)
      3'b000  : biu_size2hsize = `HSIZE_BYTE;
      3'b001  : biu_size2hsize = `HSIZE_HWORD;
      3'b010  : biu_size2hsize = `HSIZE_WORD;
      3'b011  : biu_size2hsize = `HSIZE_DWORD;
      default : biu_size2hsize = 3'hx; //OOPSS
    endcase
  endfunction

  //convert burst type to counter length (actually length -1)
  function automatic [3:0] biu_type2cnt;
    input [2:0] biu_type;

    case (biu_type)
      `SINGLE  : biu_type2cnt =  0;
      `INCR    : biu_type2cnt =  0;
      `WRAP4   : biu_type2cnt =  3;
      `INCR4   : biu_type2cnt =  3;
      `WRAP8   : biu_type2cnt =  7;
      `INCR8   : biu_type2cnt =  7;
      `WRAP16  : biu_type2cnt = 15;
      `INCR16  : biu_type2cnt = 15;
      default  : biu_type2cnt = 4'hx; //OOPS
    endcase
  endfunction

  //convert burst type to counter length (actually length -1)
  function automatic [2:0] biu_type2hburst;
    input [2:0] biu_type;

    case (biu_type)
      `SINGLE  : biu_type2hburst = `HBURST_SINGLE;
      `INCR    : biu_type2hburst = `HBURST_INCR;
      `WRAP4   : biu_type2hburst = `HBURST_WRAP4;
      `INCR4   : biu_type2hburst = `HBURST_INCR4;
      `WRAP8   : biu_type2hburst = `HBURST_WRAP8;
      `INCR8   : biu_type2hburst = `HBURST_INCR8;
      `WRAP16  : biu_type2hburst = `HBURST_WRAP16;
      `INCR16  : biu_type2hburst = `HBURST_INCR16;
      default  : biu_type2hburst = 3'hx; //OOPS
    endcase
  endfunction

  //convert burst type to counter length (actually length -1)
  function automatic [3:0] biu_prot2hprot;
    input [2:0] biu_prot;

    biu_prot2hprot  = biu_prot & `PROT_DATA                         ? `HPROT_DATA       : `HPROT_OPCODE;
    biu_prot2hprot  = biu_prot2hprot | (biu_prot & `PROT_PRIVILEGED ? `HPROT_PRIVILEGED : `HPROT_USER);
    biu_prot2hprot  = biu_prot2hprot | (biu_prot & `PROT_CACHEABLE  ? `HPROT_CACHEABLE  : `HPROT_NON_CACHEABLE);
  endfunction

  //convert burst type to counter length (actually length -1)
  function automatic [PLEN-1:0] nxt_addr;
    input [PLEN -1:0] addr;   //current address
    input [      2:0] hburst; //AHB wb_cti_o

    //next linear address
    if (XLEN==32) nxt_addr = (addr + 'h4) & ~'h3;
    else          nxt_addr = (addr + 'h8) & ~'h7;

    //wrap?
    case (hburst)
      `HBURST_WRAP4  : nxt_addr = (XLEN==32) ? {addr[PLEN-1: 4],nxt_addr[3:0]} : {addr[PLEN-1:5],nxt_addr[4:0]};
      `HBURST_WRAP8  : nxt_addr = (XLEN==32) ? {addr[PLEN-1: 5],nxt_addr[4:0]} : {addr[PLEN-1:6],nxt_addr[5:0]};
      `HBURST_WRAP16 : nxt_addr = (XLEN==32) ? {addr[PLEN-1: 6],nxt_addr[5:0]} : {addr[PLEN-1:7],nxt_addr[6:0]};
      default        : ;
    endcase
  endfunction

  //////////////////////////////////////////////////////////////////
  //
  // Variables
  //

  logic [      3:0] burst_cnt;
  logic             data_ena,
                    data_ena_d;
  logic [XLEN -1:0] biu_di_dly;

  //////////////////////////////////////////////////////////////////
  //
  // Module Body
  //

  //State Machine
  always @(posedge HCLK, negedge HRESETn)
    if (!HRESETn) begin
      data_ena    <= 1'b0;
      biu_err_o   <= 1'b0;
      burst_cnt   <= 'h0;

      wb_stb_o        <= 1'b0;
      wb_adr_o       <= 'h0;
      wb_we_o      <= 1'b0;
      HSIZE       <= 'h0; //dont care
      wb_cti_o      <= 'h0; //dont care
      wb_sel_o       <= `HPROT_DATA | `HPROT_PRIVILEGED | `HPROT_NON_BUFFERABLE | `HPROT_NON_CACHEABLE;
      wb_bte_o      <= `HTRANS_IDLE;
      wb_cyc_o   <= 1'b0;
    end
  else begin
    //strobe/ack signals
    biu_err_o   <= 1'b0;

    if (wb_ack_i) begin
      if (~|burst_cnt) begin //burst complete
        if (biu_stb_i && !biu_err_o) begin
          data_ena    <= 1'b1;
          burst_cnt   <= biu_type2cnt(biu_type_i);

          wb_stb_o        <= 1'b1;
          wb_bte_o      <= `HTRANS_NONSEQ; //start of burst
          wb_adr_o       <= biu_adri_i;
          wb_we_o      <= biu_we_i;
          HSIZE       <= biu_size2hsize (biu_size_i);
          wb_cti_o      <= biu_type2hburst(biu_type_i);
          wb_sel_o       <= biu_prot2hprot (biu_prot_i);
          wb_cyc_o   <= biu_lock_i;
        end
        else begin
          data_ena  <= 1'b0;

          wb_stb_o      <= 1'b0;
          wb_bte_o    <= `HTRANS_IDLE; //no new transfer
          wb_cyc_o <= biu_lock_i;
        end
      end
      else begin //continue burst
        data_ena  <= 1'b1;
        burst_cnt <= burst_cnt - 1;

        wb_bte_o    <= `HTRANS_SEQ; //continue burst
        wb_adr_o     <= nxt_addr(wb_adr_o,wb_cti_o); //next address
      end
    end
    else begin
      //error response
      if (wb_err_i == `HRESP_ERROR) begin
        burst_cnt <= 'h0; //burst done (interrupted)

        wb_stb_o      <= 1'b0;
        wb_bte_o    <= `HTRANS_IDLE;

        data_ena  <= 1'b0;
        biu_err_o <= 1'b1;
      end
    end
  end

  //Data section
  always @(posedge HCLK) begin
    if (wb_ack_i) biu_di_dly <= biu_d_i;
  end

  always @(posedge HCLK) begin
    if (wb_ack_i) begin
      wb_dat_o     <= biu_di_dly;
      biu_adro_o <= wb_adr_o;
    end
  end

  always @(posedge HCLK, negedge HRESETn) begin
    if      (!HRESETn) data_ena_d <= 1'b0;
    else if ( wb_ack_i ) data_ena_d <= data_ena;
  end

  assign biu_q_o        = wb_dat_i;
  assign biu_ack_o      = wb_ack_i & data_ena_d;
  assign biu_d_ack_o    = wb_ack_i & data_ena;
  assign biu_stb_ack_o  = wb_ack_i & ~|burst_cnt & biu_stb_i & ~biu_err_o;
endmodule
