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
//   Francisco Javier Reina Campo <pacoreinacampo@queenfield.tech>

import peripheral_ahb3_verilog_pkg::*;
import peripheral_ahb3_verilog_pkg::*;

module pu_riscv_ahb32ahb3 #(
  parameter XLEN = 64,
  parameter PLEN = 64
) (
  input wire HRESETn,
  input wire HCLK,

  // AHB3 Lite Bus
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

  // BIU Bus (Core ports)
  input  wire             ahb3_stb_i,      // strobe
  output reg              ahb3_stb_ack_o,  // strobe acknowledge; can send new strobe
  output reg              ahb3_d_ack_o,    // data acknowledge (send new ahb3_d_i); for pipelined buses
  input  wire [PLEN -1:0] ahb3_adri_i,
  output reg  [PLEN -1:0] ahb3_adro_o,
  input  wire [      2:0] ahb3_size_i,     // transfer size
  input  wire [      2:0] ahb3_type_i,     // burst type
  input  wire [      2:0] ahb3_prot_i,     // protection
  input  wire             ahb3_lock_i,
  input  wire             ahb3_we_i,
  input  wire [XLEN -1:0] ahb3_d_i,
  output reg  [XLEN -1:0] ahb3_q_o,
  output reg              ahb3_ack_o,      // transfer acknowledge
  output reg              ahb3_err_o       // transfer error
);

  //////////////////////////////////////////////////////////////////////////////
  // Functions
  //////////////////////////////////////////////////////////////////////////////

  function automatic [2:0] ahb3_size2hsize;
    input [2:0] size;

    case (size)
      3'b000:  ahb3_size2hsize = HSIZE_BYTE;
      3'b001:  ahb3_size2hsize = HSIZE_HWORD;
      3'b010:  ahb3_size2hsize = HSIZE_WORD;
      3'b011:  ahb3_size2hsize = HSIZE_DWORD;
      default: ahb3_size2hsize = 3'hx;  // OOPSS
    endcase
  endfunction

  // convert burst type to counter length (actually length -1)
  function automatic [3:0] ahb3_type2cnt;
    input [2:0] ahb3_type;

    case (ahb3_type)
      SINGLE:  ahb3_type2cnt = 0;
      INCR:    ahb3_type2cnt = 0;
      WRAP4:   ahb3_type2cnt = 3;
      INCR4:   ahb3_type2cnt = 3;
      WRAP8:   ahb3_type2cnt = 7;
      INCR8:   ahb3_type2cnt = 7;
      WRAP16:  ahb3_type2cnt = 15;
      INCR16:  ahb3_type2cnt = 15;
      default: ahb3_type2cnt = 4'hx;  // OOPS
    endcase
  endfunction

  // convert burst type to counter length (actually length -1)
  function automatic [2:0] ahb3_type2hburst;
    input [2:0] ahb3_type;

    case (ahb3_type)
      SINGLE:  ahb3_type2hburst = HBURST_SINGLE;
      INCR:    ahb3_type2hburst = HBURST_INCR;
      WRAP4:   ahb3_type2hburst = HBURST_WRAP4;
      INCR4:   ahb3_type2hburst = HBURST_INCR4;
      WRAP8:   ahb3_type2hburst = HBURST_WRAP8;
      INCR8:   ahb3_type2hburst = HBURST_INCR8;
      WRAP16:  ahb3_type2hburst = HBURST_WRAP16;
      INCR16:  ahb3_type2hburst = HBURST_INCR16;
      default: ahb3_type2hburst = 3'hx;  // OOPS
    endcase
  endfunction

  // convert burst type to counter length (actually length -1)
  function automatic [3:0] ahb3_prot2hprot;
    input [2:0] ahb3_prot;

    ahb3_prot2hprot = ahb3_prot & PROT_DATA ? HPROT_DATA : HPROT_OPCODE;
    ahb3_prot2hprot = ahb3_prot2hprot | (ahb3_prot & PROT_PRIVILEGED ? HPROT_PRIVILEGED : HPROT_USER);
    ahb3_prot2hprot = ahb3_prot2hprot | (ahb3_prot & PROT_CACHEABLE ? HPROT_CACHEABLE : HPROT_NON_CACHEABLE);
  endfunction

  // convert burst type to counter length (actually length -1)
  function automatic [PLEN-1:0] nxt_addr;
    input [PLEN -1:0] addr;  // current address
    input [2:0] hburst;  // AHB HBURST

    // next linear address
    if (XLEN == 32) begin
      nxt_addr = (addr + 'h4) & ~'h3;
    end else begin
      nxt_addr = (addr + 'h8) & ~'h7;
    end

    // wrap?
    case (hburst)
      HBURST_WRAP4: begin
        nxt_addr = (XLEN == 32) ? {addr[PLEN-1:4], nxt_addr[3:0]} : {addr[PLEN-1:5], nxt_addr[4:0]};
      end
      HBURST_WRAP8: begin
        nxt_addr = (XLEN == 32) ? {addr[PLEN-1:5], nxt_addr[4:0]} : {addr[PLEN-1:6], nxt_addr[5:0]};
      end
      HBURST_WRAP16: begin
        nxt_addr = (XLEN == 32) ? {addr[PLEN-1:6], nxt_addr[5:0]} : {addr[PLEN-1:7], nxt_addr[6:0]};
      end
      default: begin
      end
    endcase
  endfunction

  //////////////////////////////////////////////////////////////////////////////
  // Variables
  //////////////////////////////////////////////////////////////////////////////

  logic [3:0] burst_cnt;
  logic data_ena, data_ena_d;
  logic [XLEN -1:0] ahb3_di_dly;

  //////////////////////////////////////////////////////////////////////////////
  // Body
  //////////////////////////////////////////////////////////////////////////////

  // State Machine
  always @(posedge HCLK, negedge HRESETn)
    if (!HRESETn) begin
      data_ena  <= 1'b0;
      ahb3_err_o <= 1'b0;
      burst_cnt <= 'h0;

      HSEL      <= 1'b0;
      HADDR     <= 'h0;
      HWRITE    <= 1'b0;
      HSIZE     <= 'h0;  // don't care
      HBURST    <= 'h0;  // don't care
      HPROT     <= HPROT_DATA | HPROT_PRIVILEGED | HPROT_NON_BUFFERABLE | HPROT_NON_CACHEABLE;
      HTRANS    <= HTRANS_IDLE;
      HMASTLOCK <= 1'b0;
    end else begin
      // strobe/ack signals
      ahb3_err_o <= 1'b0;

      if (HREADY) begin
        if (~|burst_cnt) begin  // burst complete
          if (ahb3_stb_i && !ahb3_err_o) begin
            data_ena  <= 1'b1;
            burst_cnt <= ahb3_type2cnt(ahb3_type_i);

            HSEL      <= 1'b1;
            HTRANS    <= HTRANS_NONSEQ;  // start of burst
            HADDR     <= ahb3_adri_i;
            HWRITE    <= ahb3_we_i;
            HSIZE     <= ahb3_size2hsize(ahb3_size_i);
            HBURST    <= ahb3_type2hburst(ahb3_type_i);
            HPROT     <= ahb3_prot2hprot(ahb3_prot_i);
            HMASTLOCK <= ahb3_lock_i;
          end else begin
            data_ena  <= 1'b0;

            HSEL      <= 1'b0;
            HTRANS    <= HTRANS_IDLE;  // no new transfer
            HMASTLOCK <= ahb3_lock_i;
          end
        end else begin  // continue burst
          data_ena  <= 1'b1;
          burst_cnt <= burst_cnt - 1;

          HTRANS    <= HTRANS_SEQ;  // continue burst
          HADDR     <= nxt_addr(HADDR, HBURST);  // next address
        end
      end else begin
        // error response
        if (HRESP == HRESP_ERROR) begin
          burst_cnt <= 'h0;  // burst done (interrupted)

          HSEL      <= 1'b0;
          HTRANS    <= HTRANS_IDLE;

          data_ena  <= 1'b0;
          ahb3_err_o <= 1'b1;
        end
      end
    end

  // Data section
  always @(posedge HCLK) begin
    if (HREADY) begin
      ahb3_di_dly <= ahb3_d_i;
    end
  end

  always @(posedge HCLK) begin
    if (HREADY) begin
      HWDATA     <= ahb3_di_dly;
      ahb3_adro_o <= HADDR;
    end
  end

  always @(posedge HCLK, negedge HRESETn) begin
    if (!HRESETn) begin
      data_ena_d <= 1'b0;
    end else if (HREADY) begin
      data_ena_d <= data_ena;
    end
  end

  assign ahb3_q_o       = HRDATA;
  assign ahb3_ack_o     = HREADY & data_ena_d;
  assign ahb3_d_ack_o   = HREADY & data_ena;
  assign ahb3_stb_ack_o = HREADY & ~|burst_cnt & ahb3_stb_i & ~ahb3_err_o;
endmodule