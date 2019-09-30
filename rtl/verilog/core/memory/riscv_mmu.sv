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
//              Core - Memory Management Unit                                 //
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

module riscv_mmu #(
  parameter XLEN  = 64,
  parameter PLEN  = 64
)
  (
    input  logic            rst_ni,
    input  logic            clk_i,
    input  logic            clr_i,   //clear pending request

  //Mode
//input  logic [XLEN-1:0] st_satp;

  //CPU side
    input  logic            vreq_i,  //Request from CPU
    input  logic [XLEN-1:0] vadr_i,  //Virtual Memory Address
    input  logic [     2:0] vsize_i,
    input  logic            vlock_i,
    input  logic [     2:0] vprot_i,
    input  logic            vwe_i,
    input  logic [XLEN-1:0] vd_i,

  //Memory system side
    output logic            preq_o,
    output logic [PLEN-1:0] padr_o,  //Physical Memory Address
    output logic [     2:0] psize_o,
    output logic            plock_o,
    output logic [     2:0] pprot_o,
    output logic            pwe_o,
    output logic [XLEN-1:0] pd_o,
    input  logic [XLEN-1:0] pq_i,
    input  logic            pack_i,

  //Exception
    output logic            page_fault_o
  );

  //////////////////////////////////////////////////////////////////
  //
  // Variables
  //

  //////////////////////////////////////////////////////////////////
  //
  // Module Body
  //

  always @(posedge clk_i) begin
    if (vreq_i) padr_o <= vadr_i; //TODO: actual translation
  end

  //Insert state machine here
  always @(posedge clk_i) begin
    if (clr_i) preq_o <= 1'b0;
    else       preq_o <= vreq_i;
  end

  always @(posedge clk_i) begin
    psize_o <= vsize_i;
    plock_o <= vlock_i;
    pprot_o <= vprot_i;
    pwe_o   <= vwe_i;
  end

  //MMU does not write data
  always @(posedge clk_i) begin
    pd_o <= vd_i;
  end

  //No page fault yet
  assign page_fault_o = 1'b0;
endmodule
