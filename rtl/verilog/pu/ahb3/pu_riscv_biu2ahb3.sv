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

import peripheral_ahb3_pkg::*;
import peripheral_biu_pkg::*;

module pu_riscv_biu2ahb3 #(
  parameter XLEN = 64,
  parameter PLEN = 64
) (
  input wire HRESETn,
  input wire HCLK,

  //AHB3 Lite Bus
  output reg              HSEL,
  output reg  [PLEN -1:0] HADDR,
  input  wire [XLEN -1:0] HRDATA,
  output reg  [XLEN -1:0] HWDATA,
  output reg              HWRITE,
  output reg  [      2:0] HSIZE,
  output reg  [      2:0] HBURST,
  output reg  [      3:0] HPROT,
  output reg  [      1:0] HTRANS,
  output reg              HMASTLOCK,
  input  wire             HREADY,
  input  wire             HRESP,

  //BIU Bus (Core ports)
  input  wire             biu_stb_i,      //strobe
  output reg              biu_stb_ack_o,  //strobe acknowledge; can send new strobe
  output reg              biu_d_ack_o,    //data acknowledge (send new biu_d_i); for pipelined buses
  input  wire [PLEN -1:0] biu_adri_i,
  output reg  [PLEN -1:0] biu_adro_o,
  input  wire [      2:0] biu_size_i,     //transfer size
  input  wire [      2:0] biu_type_i,     //burst type
  input  wire [      2:0] biu_prot_i,     //protection
  input  wire             biu_lock_i,
  input  wire             biu_we_i,
  input  wire [XLEN -1:0] biu_d_i,
  output reg  [XLEN -1:0] biu_q_o,
  output reg              biu_ack_o,      //transfer acknowledge
  output reg              biu_err_o       //transfer error
);

  //////////////////////////////////////////////////////////////////////////////
  //
  // Functions
  //

  function automatic [2:0] biu_size2hsize;
    input [2:0] size;

    case (size)
      3'b000:  biu_size2hsize = HSIZE_BYTE;
      3'b001:  biu_size2hsize = HSIZE_HWORD;
      3'b010:  biu_size2hsize = HSIZE_WORD;
      3'b011:  biu_size2hsize = HSIZE_DWORD;
      default: biu_size2hsize = 3'hx;  //OOPSS
    endcase
  endfunction

  //convert burst type to counter length (actually length -1)
  function automatic [3:0] biu_type2cnt;
    input [2:0] biu_type;

    case (biu_type)
      SINGLE:  biu_type2cnt = 0;
      INCR:    biu_type2cnt = 0;
      WRAP4:   biu_type2cnt = 3;
      INCR4:   biu_type2cnt = 3;
      WRAP8:   biu_type2cnt = 7;
      INCR8:   biu_type2cnt = 7;
      WRAP16:  biu_type2cnt = 15;
      INCR16:  biu_type2cnt = 15;
      default: biu_type2cnt = 4'hx;  //OOPS
    endcase
  endfunction

  //convert burst type to counter length (actually length -1)
  function automatic [2:0] biu_type2hburst;
    input [2:0] biu_type;

    case (biu_type)
      SINGLE:  biu_type2hburst = HBURST_SINGLE;
      INCR:    biu_type2hburst = HBURST_INCR;
      WRAP4:   biu_type2hburst = HBURST_WRAP4;
      INCR4:   biu_type2hburst = HBURST_INCR4;
      WRAP8:   biu_type2hburst = HBURST_WRAP8;
      INCR8:   biu_type2hburst = HBURST_INCR8;
      WRAP16:  biu_type2hburst = HBURST_WRAP16;
      INCR16:  biu_type2hburst = HBURST_INCR16;
      default: biu_type2hburst = 3'hx;  //OOPS
    endcase
  endfunction

  //convert burst type to counter length (actually length -1)
  function automatic [3:0] biu_prot2hprot;
    input [2:0] biu_prot;

    biu_prot2hprot = biu_prot & PROT_DATA ? HPROT_DATA : HPROT_OPCODE;
    biu_prot2hprot = biu_prot2hprot | (biu_prot & PROT_PRIVILEGED ? HPROT_PRIVILEGED : HPROT_USER);
    biu_prot2hprot = biu_prot2hprot | (biu_prot & PROT_CACHEABLE ? HPROT_CACHEABLE : HPROT_NON_CACHEABLE);
  endfunction

  //convert burst type to counter length (actually length -1)
  function automatic [PLEN-1:0] nxt_addr;
    input [PLEN -1:0] addr;  //current address
    input [2:0] hburst;  //AHB HBURST

    //next linear address
    if (XLEN == 32) nxt_addr = (addr + 'h4) & ~'h3;
    else nxt_addr = (addr + 'h8) & ~'h7;

    //wrap?
    case (hburst)
      HBURST_WRAP4:  nxt_addr = (XLEN == 32) ? {addr[PLEN-1:4], nxt_addr[3:0]} : {addr[PLEN-1:5], nxt_addr[4:0]};
      HBURST_WRAP8:  nxt_addr = (XLEN == 32) ? {addr[PLEN-1:5], nxt_addr[4:0]} : {addr[PLEN-1:6], nxt_addr[5:0]};
      HBURST_WRAP16: nxt_addr = (XLEN == 32) ? {addr[PLEN-1:6], nxt_addr[5:0]} : {addr[PLEN-1:7], nxt_addr[6:0]};
      default:       ;
    endcase
  endfunction

  //////////////////////////////////////////////////////////////////////////////
  //
  // Variables
  //

  logic [3:0] burst_cnt;
  logic data_ena, data_ena_d;
  logic [XLEN -1:0] biu_di_dly;

  //////////////////////////////////////////////////////////////////////////////
  //
  // Module Body
  //

  //State Machine
  always @(posedge HCLK, negedge HRESETn)
    if (!HRESETn) begin
      data_ena  <= 1'b0;
      biu_err_o <= 1'b0;
      burst_cnt <= 'h0;

      HSEL      <= 1'b0;
      HADDR     <= 'h0;
      HWRITE    <= 1'b0;
      HSIZE     <= 'h0;  //dont care
      HBURST    <= 'h0;  //dont care
      HPROT     <= HPROT_DATA | HPROT_PRIVILEGED | HPROT_NON_BUFFERABLE | HPROT_NON_CACHEABLE;
      HTRANS    <= HTRANS_IDLE;
      HMASTLOCK <= 1'b0;
    end else begin
      //strobe/ack signals
      biu_err_o <= 1'b0;

      if (HREADY) begin
        if (~|burst_cnt) begin  //burst complete
          if (biu_stb_i && !biu_err_o) begin
            data_ena  <= 1'b1;
            burst_cnt <= biu_type2cnt(biu_type_i);

            HSEL      <= 1'b1;
            HTRANS    <= HTRANS_NONSEQ;  //start of burst
            HADDR     <= biu_adri_i;
            HWRITE    <= biu_we_i;
            HSIZE     <= biu_size2hsize(biu_size_i);
            HBURST    <= biu_type2hburst(biu_type_i);
            HPROT     <= biu_prot2hprot(biu_prot_i);
            HMASTLOCK <= biu_lock_i;
          end else begin
            data_ena  <= 1'b0;

            HSEL      <= 1'b0;
            HTRANS    <= HTRANS_IDLE;  //no new transfer
            HMASTLOCK <= biu_lock_i;
          end
        end else begin  //continue burst
          data_ena  <= 1'b1;
          burst_cnt <= burst_cnt - 1;

          HTRANS    <= HTRANS_SEQ;  //continue burst
          HADDR     <= nxt_addr(HADDR, HBURST);  //next address
        end
      end else begin
        //error response
        if (HRESP == HRESP_ERROR) begin
          burst_cnt <= 'h0;  //burst done (interrupted)

          HSEL      <= 1'b0;
          HTRANS    <= HTRANS_IDLE;

          data_ena  <= 1'b0;
          biu_err_o <= 1'b1;
        end
      end
    end

  //Data section
  always @(posedge HCLK) begin
    if (HREADY) biu_di_dly <= biu_d_i;
  end

  always @(posedge HCLK) begin
    if (HREADY) begin
      HWDATA     <= biu_di_dly;
      biu_adro_o <= HADDR;
    end
  end

  always @(posedge HCLK, negedge HRESETn) begin
    if (!HRESETn) data_ena_d <= 1'b0;
    else if (HREADY) data_ena_d <= data_ena;
  end

  assign biu_q_o       = HRDATA;
  assign biu_ack_o     = HREADY & data_ena_d;
  assign biu_d_ack_o   = HREADY & data_ena;
  assign biu_stb_ack_o = HREADY & ~|burst_cnt & biu_stb_i & ~biu_err_o;
endmodule
