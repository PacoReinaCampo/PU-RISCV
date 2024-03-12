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
//              BIU Bus Interface                                             //
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

import peripheral_biu_pkg::*;

module peripheral_spram_bridge_biu #(
  parameter XLEN = 64,
  parameter PLEN = 64
) (
  input wire rst,
  input wire clk,

  // RAM Memory
  output reg             req_i,
  output reg             we_i,
  output reg  [     2:0] be_i,
  output reg  [PLEN-1:0] addr_i,
  output reg  [XLEN-1:0] data_i,
  input  wire [XLEN-1:0] data_o,

  // BIU Bus (Core ports)
  input  wire            biu_stb_i,      // strobe
  output reg             biu_stb_ack_o,  // strobe acknowledge; can send new strobe
  output reg             biu_d_ack_o,    // data acknowledge (send new biu_d_i); for pipelined buses
  input  wire [PLEN-1:0] biu_adri_i,
  output reg  [PLEN-1:0] biu_adro_o,
  input  wire [     2:0] biu_size_i,     // transfer size
  input  wire [     2:0] biu_type_i,     // burst type
  input  wire [     2:0] biu_prot_i,     // protection
  input  wire            biu_lock_i,
  input  wire            biu_we_i,
  input  wire [XLEN-1:0] biu_d_i,
  output reg  [XLEN-1:0] biu_q_o,
  output reg             biu_ack_o,      // transfer acknowledge
  output reg             biu_err_o       // transfer error
);

  //////////////////////////////////////////////////////////////////////////////
  // Constants
  //////////////////////////////////////////////////////////////////////////////

  // HPROT
  localparam HPROT_OPCODE         = 4'b0000;
  localparam HPROT_DATA           = 4'b0001;
  localparam HPROT_USER           = 4'b0000;
  localparam HPROT_PRIVILEGED     = 4'b0010;
  localparam HPROT_NON_BUFFERABLE = 4'b0000;
  localparam HPROT_BUFFERABLE     = 4'b0100;
  localparam HPROT_NON_CACHEABLE  = 4'b0000;
  localparam HPROT_CACHEABLE      = 4'b1000;

  //////////////////////////////////////////////////////////////////////////////
  // Functions
  //////////////////////////////////////////////////////////////////////////////

  function automatic [2:0] biu_size2hsize;
    input [2:0] size;

    case (size)
      3'b000:  biu_size2hsize = HSIZE_BYTE;
      3'b001:  biu_size2hsize = HSIZE_HWORD;
      3'b010:  biu_size2hsize = HSIZE_WORD;
      3'b011:  biu_size2hsize = HSIZE_DWORD;
      3'b100:  biu_size2hsize = HSIZE_QWORD;
      default: biu_size2hsize = UNDEF_SIZE;  // OOPSS
    endcase
  endfunction

  // convert burst type to counter length (actually length -1)
  function automatic [3:0] biu_type2cnt;
    input [2:0] biu_type;

    case (biu_type)
      HBURST_SINGLE:  biu_type2cnt = 0;
      HBURST_INCR:    biu_type2cnt = 0;
      HBURST_WRAP4:   biu_type2cnt = 3;
      HBURST_INCR4:   biu_type2cnt = 3;
      HBURST_WRAP8:   biu_type2cnt = 7;
      HBURST_INCR8:   biu_type2cnt = 7;
      HBURST_WRAP16:  biu_type2cnt = 15;
      HBURST_INCR16:  biu_type2cnt = 15;
      default: biu_type2cnt = 4'hx;  // OOPS
    endcase
  endfunction

  // convert burst type to counter length (actually length -1)
  function automatic [2:0] biu_type2hburst;
    input [2:0] biu_type;

    case (biu_type)
      HBURST_SINGLE:  biu_type2hburst = HBURST_SINGLE;
      HBURST_INCR:    biu_type2hburst = HBURST_INCR;
      HBURST_WRAP4:   biu_type2hburst = HBURST_WRAP4;
      HBURST_INCR4:   biu_type2hburst = HBURST_INCR4;
      HBURST_WRAP8:   biu_type2hburst = HBURST_WRAP8;
      HBURST_INCR8:   biu_type2hburst = HBURST_INCR8;
      HBURST_WRAP16:  biu_type2hburst = HBURST_WRAP16;
      HBURST_INCR16:  biu_type2hburst = HBURST_INCR16;
      default: biu_type2hburst = UNDEF_BURST;  // OOPS
    endcase
  endfunction

  // convert burst type to counter length (actually length -1)
  function automatic [3:0] biu_prot2hprot;
    input [2:0] biu_prot;

    biu_prot2hprot = biu_prot & PROT_DATA ? HPROT_DATA : HPROT_OPCODE;
    biu_prot2hprot = biu_prot2hprot | (biu_prot & PROT_PRIVILEGED ? PROT_PRIVILEGED : HPROT_USER);
    biu_prot2hprot = biu_prot2hprot | (biu_prot & PROT_CACHEABLE ? PROT_CACHEABLE : HPROT_NON_CACHEABLE);
  endfunction

  // convert burst type to counter length (actually length -1)
  function automatic [PLEN-1:0] nxt_addr;
    input [PLEN -1:0] addr;  // current address
    input [2:0] hburst;  // hburst

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

  logic [2:0] hburst;
  logic [3:0] burst_cnt;

  logic data_ena;
  logic data_ena_d;

  //////////////////////////////////////////////////////////////////////////////
  // Body
  //////////////////////////////////////////////////////////////////////////////

  // State Machine
  always @(posedge clk, negedge rst) begin
    if (~rst) begin
      data_ena  <= 1'b0;
      biu_err_o <= 1'b0;
      burst_cnt <= 0;
      req_i     <= 1'b0;
      addr_i    <= 0;
      we_i      <= 1'b0;
      be_i      <= 0;
      hburst    <= 0;
    end else begin
      // strobe/ack signals
      biu_err_o <= 1'b0;

      if (~|burst_cnt) begin  // burst complete
        if (biu_stb_i && !biu_err_o) begin
          data_ena  <= 1'b1;
          burst_cnt <= biu_type2cnt(biu_type_i);
          req_i     <= 1'b1;
          addr_i    <= biu_adri_i;
          we_i      <= biu_we_i;
          be_i      <= biu_size2hsize(biu_size_i);
          hburst    <= biu_type2hburst(biu_type_i);
        end else begin
          data_ena  <= 1'b0;
          req_i     <= 1'b0;
        end
      end else begin  // continue burst
        data_ena  <= 1'b1;
        burst_cnt <= burst_cnt - 1;
        addr_i    <= nxt_addr(addr_i, hburst);  // next address
      end
    end
  end

  // Data section
  always @(posedge clk, negedge rst) begin
    if (~rst) begin
      data_i     <= 0;
      biu_adro_o <= 0;
    end else begin
      data_i     <= biu_d_i;
      biu_adro_o <= addr_i;
    end
  end

  always @(posedge clk, negedge rst) begin
    if (~rst) begin
      data_ena_d <= 1'b0;
    end else begin
      data_ena_d <= data_ena;
    end
  end

  assign biu_q_o       = data_o;
  assign biu_ack_o     = data_ena_d;
  assign biu_d_ack_o   = data_ena;
  assign biu_stb_ack_o = ~|burst_cnt & biu_stb_i & ~biu_err_o;
endmodule
