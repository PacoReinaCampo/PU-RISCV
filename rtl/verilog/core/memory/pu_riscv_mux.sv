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
//              Core - Bus-Interface-Unit Mux                                 //
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

import peripheral_biu_verilog_pkg::*;

module pu_riscv_mux #(
  parameter XLEN  = 64,
  parameter PLEN  = 64,
  parameter PORTS = 2
) (
  input wire rst_ni,
  input wire clk_i,

  // Input Ports
  input  wire [PORTS-1:0]           biu_req_i,      // access request
  output reg  [PORTS-1:0]           biu_req_ack_o,  // biu access acknowledge
  output reg  [PORTS-1:0]           biu_d_ack_o,    // biu early data acknowledge
  input  wire [PORTS-1:0][PLEN-1:0] biu_adri_i,     // access start address
  output reg  [PORTS-1:0][PLEN-1:0] biu_adro_o,     // biu response address
  input  wire [PORTS-1:0][     2:0] biu_size_i,     // access data size
  input  wire [PORTS-1:0][     2:0] biu_type_i,     // access burst type
  input  wire [PORTS-1:0]           biu_lock_i,     // access locked access
  input  wire [PORTS-1:0][     2:0] biu_prot_i,     // access protection
  input  wire [PORTS-1:0]           biu_we_i,       // access write enable
  input  wire [PORTS-1:0][XLEN-1:0] biu_d_i,        // access write data
  output reg  [PORTS-1:0][XLEN-1:0] biu_q_o,        // access read data
  output reg  [PORTS-1:0]           biu_ack_o,      // access acknowledge
  output reg  [PORTS-1:0]           biu_err_o,      // access error

  // Output (to BIU)
  output reg             biu_req_o,      // BIU access request
  input  wire            biu_req_ack_i,  // BIU ackowledge
  input  wire            biu_d_ack_i,    // BIU early data acknowledge
  output reg  [PLEN-1:0] biu_adri_o,     // address into BIU
  input  wire [PLEN-1:0] biu_adro_i,     // address from BIU
  output reg  [     2:0] biu_size_o,     // transfer size
  output reg  [     2:0] biu_type_o,     // burst type
  output reg             biu_lock_o,
  output reg  [     2:0] biu_prot_o,
  output reg             biu_we_o,
  output reg  [XLEN-1:0] biu_d_o,        // data into BIU
  input  wire [XLEN-1:0] biu_q_i,        // data from BIU
  input  wire            biu_ack_i,      // data acknowledge, 1 per data
  input  wire            biu_err_i       // data error
);

  //////////////////////////////////////////////////////////////////////////////
  // Functions
  //////////////////////////////////////////////////////////////////////////////

  // convert burst type to counter length (actually length -1)
  function [3:0] biu_type2cnt;
    input [2:0] biu_type;

    case (biu_type)
      SINGLE: biu_type2cnt = 0;
      INCR:   biu_type2cnt = 0;
      WRAP4:  biu_type2cnt = 3;
      INCR4:  biu_type2cnt = 3;
      WRAP8:  biu_type2cnt = 7;
      INCR8:  biu_type2cnt = 7;
      WRAP16: biu_type2cnt = 15;
      INCR16: biu_type2cnt = 15;
    endcase
  endfunction

  function automatic busor;
    input [PORTS-1:0] req;
    integer n;

    busor = 0;
    for (n = 0; n < PORTS; n = n + 1) begin
      busor = busor | req[n];
    end
  endfunction

  function automatic [$clog2(PORTS)-1:0] port_select;
    input [PORTS-1:0] req;
    integer n;

    // default port
    port_select = 0;

    // check other ports
    for (n = PORTS - 1; n > 0; n = n - 1) begin
      if (req[n]) begin
        port_select = n;
      end
    end
  endfunction

  //////////////////////////////////////////////////////////////////////////////
  // Constants
  //////////////////////////////////////////////////////////////////////////////

  parameter IDLE = 1'b0;
  parameter BURST = 1'b1;

  //////////////////////////////////////////////////////////////////////////////
  // Variables
  //////////////////////////////////////////////////////////////////////////////

  logic                     fsm_state;
  logic                     pending_req;
  logic [$clog2(PORTS)-1:0] pending_port;
  logic [$clog2(PORTS)-1:0] selected_port;
  logic [              2:0] pending_size;

  logic [              3:0] pending_burst_cnt;
  logic [              3:0] burst_cnt;

  genvar p;

  //////////////////////////////////////////////////////////////////////////////
  // Module Body
  //////////////////////////////////////////////////////////////////////////////

  assign pending_req       = busor(biu_req_i);
  assign pending_port      = port_select(biu_req_i);
  assign pending_size      = biu_size_i[pending_port];
  assign pending_burst_cnt = biu_type2cnt(biu_type_i[pending_port]);

  // Access Statemachine
  always @(posedge clk_i, negedge rst_ni) begin
    if (!rst_ni) begin
      fsm_state <= IDLE;
      burst_cnt <= 'h0;
    end else begin
      case (fsm_state)
        IDLE: begin
          if (pending_req && |pending_burst_cnt) begin
            fsm_state     <= BURST;
            burst_cnt     <= pending_burst_cnt;
            selected_port <= pending_port;
          end else selected_port <= pending_port;
        end
        BURST: begin
          if (biu_ack_i) begin
            burst_cnt <= burst_cnt - 1;
            if (~|burst_cnt) begin
              // Burst done
              if (pending_req && |pending_burst_cnt) begin
                burst_cnt     <= pending_burst_cnt;
                selected_port <= pending_port;
              end else begin
                fsm_state     <= IDLE;
                selected_port <= pending_port;
              end
            end
          end
        end
      endcase
    end
  end

  // Mux BIU ports
  always @(*) begin
    case (fsm_state)
      IDLE: begin
        biu_req_o  = pending_req;
        biu_adri_o = biu_adri_i[pending_port];
        biu_size_o = biu_size_i[pending_port];
        biu_type_o = biu_type_i[pending_port];
        biu_lock_o = biu_lock_i[pending_port];
        biu_we_o   = biu_we_i[pending_port];
        biu_d_o    = biu_d_i[pending_port];
      end
      BURST: begin
        biu_req_o  = biu_ack_i & ~|burst_cnt & pending_req;
        biu_adri_o = biu_adri_i[pending_port];
        biu_size_o = biu_size_i[pending_port];
        biu_type_o = biu_type_i[pending_port];
        biu_lock_o = biu_lock_i[pending_port];
        biu_we_o   = biu_we_i[pending_port];
        biu_d_o    = biu_ack_i & ~|burst_cnt ? biu_d_i[pending_port] : biu_d_i[selected_port];  // TO-DO: ~|burst_cnt & biu_ack_i ??
      end

      //      WAIT4BIU: begin
      //        biu_req_o  = 1'b1;
      //        biu_adri_o = biu_adri_i [ selected_port ];
      //        biu_size_o = biu_size_i [ selected_port ];
      //        biu_type_o = biu_type_i [ selected_port ];
      //        biu_lock_o = biu_lock_i [ selected_port ];
      //        biu_we_o   = biu_we_i   [ selected_port ];
      //        biu_d_o    = biu_d      [ selected_port ];
      //      end

      default: begin
        biu_req_o  = 'bx;
        biu_adri_o = 'hx;
        biu_size_o = 'hx;
        biu_type_o = 'hx;
        biu_lock_o = 'bx;
        biu_we_o   = 'bx;
        biu_d_o    = 'hx;
      end
    endcase
  end

  // Decode MEM ports
  generate
    for (p = 0; p < PORTS; p = p + 1) begin : decode_ports
      assign biu_req_ack_o[p] = (p == pending_port) ? biu_req_ack_i : 1'b0;
      assign biu_d_ack_o[p]   = (p == selected_port) ? biu_d_ack_i : 1'b0;
      assign biu_adro_o[p]    = biu_adro_i;
      assign biu_q_o[p]       = biu_q_i;
      assign biu_ack_o[p]     = (p == selected_port) ? biu_ack_i : 1'b0;
      assign biu_err_o[p]     = (p == selected_port) ? biu_err_i : 1'b0;
    end
  endgenerate

  assign biu_prot_o = 3'b0;
endmodule
