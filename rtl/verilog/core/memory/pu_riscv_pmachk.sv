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
//              Core - Physical Memory Attributes Checker                     //
//              AMBA4 AHB-Lite Bus Interface                                  //
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

import pu_riscv_verilog_pkg::*;
import peripheral_biu_verilog_pkg::*;

module pu_riscv_pmachk #(
  parameter XLEN    = 64,
  parameter PLEN    = 64,
  parameter PMA_CNT = 4
) (
  // PMA  configuration
  input wire [PMA_CNT-1:0][    13:0] pma_cfg_i,
  input wire [PMA_CNT-1:0][XLEN-1:0] pma_adr_i,

  // Memory Access
  input wire            instruction_i,  // This is an instruction access
  input wire            req_i,          // Memory access requested
  input wire [PLEN-1:0] adr_i,          // Physical Memory address (i.e. after translation)
  input wire [     2:0] size_i,         // Transfer size
  input wire            lock_i,         // AMO : TO-DO: specify AMO type
  input wire            we_i,

  input wire misaligned_i,  // Misaligned access

  // Output
  output     [13:0] pma_o,
  output reg        exception_o,
  output reg        misaligned_o,
  output reg        is_cache_access_o,
  output reg        is_ext_access_o,
  output reg        is_tcm_access_o
);

  //////////////////////////////////////////////////////////////////////////////
  // Functions
  //////////////////////////////////////////////////////////////////////////////

  // convert transfer size in number of bytes in transfer
  function automatic integer size2bytes;
    input [2:0] size;

    case (size)
      BYTE: begin
        size2bytes = 1;
      end
      HWORD: begin
        size2bytes = 2;
      end
      WORD: begin
        size2bytes = 4;
      end
      DWORD: begin
        size2bytes = 8;
      end
      QWORD: begin
        size2bytes = 16;
      end
      default: begin
        size2bytes = -1;
        // $error ("Illegal biu_size_t");
      end
    endcase
  endfunction

  // Lower and Upper bounds for NA4/NAPOT
  function automatic [PLEN-1:2] napot_lb;
    input na4;  // special case na4
    input [PLEN-1:2] pmaddr;

    integer n, i;
    bit              true;
    logic [PLEN-1:2] mask;

    // find 'n' boundary = 2^(n+2) bytes
    n = 0;
    if (!na4) begin
      true = 1'b1;
      for (i = 0; i < $bits(pmaddr); i = i + 1) begin
        if (true) begin
          if (pmaddr[i+2]) begin
            n = n + 1;
          end else begin
            true = 1'b0;
          end
        end
      end
      n = n + 1;
    end

    // create mask
    mask     = {$bits(mask) {1'b1}} << n;

    // lower bound address
    napot_lb = pmaddr & mask;
  endfunction

  function automatic [PLEN-1:2] napot_ub;
    input na4;  // special case na4
    input [PLEN-1:2] pmaddr;

    integer n, i;
    bit              true;
    logic [PLEN-1:2] mask;
    logic [PLEN-1:2] incr;

    // find 'n' boundary = 2^(n+2) bytes
    n = 0;
    if (!na4) begin
      true = 1'b1;
      for (i = 0; i < $bits(pmaddr); i = i + 1) begin
        if (true) begin
          if (pmaddr[i+2]) begin
            n = n + 1;
          end else begin
            true = 1'b0;
          end
        end
      end
      n = n + 1;
    end

    // create mask and increment
    mask     = {$bits(mask) {1'b1}} << n;
    incr     = 1'h1 << n;

    // upper bound address
    napot_ub = (pmaddr + incr) & mask;
  endfunction

  // Is ANY byte of 'access' in pma range?
  function automatic match_any;
    input [PLEN-1:2] access_lb;
    input [PLEN-1:2] access_ub;
    input [PLEN-1:2] pma_lb;
    input [PLEN-1:2] pma_ub;

    // Check if ANY byte of the access lies within the PMA range
    //   pma_lb <= range < pma_ub
    // 
    //   match_none = (access_lb >= pma_ub) OR (access_ub < pma_lb)  (1)
    //   match_any  = !match_none                                    (2)
   
    match_any = (access_lb >= pma_ub) || (access_ub < pma_lb) ? 1'b0 : 1'b1;
  endfunction

  // Are ALL bytes of 'access' in PMA range?
  function automatic match_all;
    input [PLEN-1:2] access_lb;
    input [PLEN-1:2] access_ub;
    input [PLEN-1:2] pma_lb;
    input [PLEN-1:2] pma_ub;

    match_all = (access_lb >= pma_lb) && (access_ub < pma_ub) ? 1'b1 : 1'b0;
  endfunction

  // get highest priority (==lowest number) PMP that matches
  function automatic integer highest_priority_match;
    input [PMA_CNT-1:0] m;

    integer n;

    highest_priority_match = 0;  // default value

    for (n = PMA_CNT - 1; n >= 0; n = n - 1) begin
      if (m[n]) begin
        highest_priority_match = n;
      end
    end
  endfunction

  //////////////////////////////////////////////////////////////////////////////
  // Variables
  //////////////////////////////////////////////////////////////////////////////

  genvar i;

  logic   [PLEN   -1:0] access_ub;
  logic   [PLEN   -1:0] access_lb;
  logic   [PLEN   -1:2] pma_ub          [PMA_CNT];
  logic   [PLEN   -1:2] pma_lb          [PMA_CNT];
  logic   [PMA_CNT-1:0] pma_match;
  logic   [PMA_CNT-1:0] pma_match_all;
  integer               matched_pma_idx;
  logic   [       13:0] pmacfg          [PMA_CNT];
  logic   [       13:0] matched_pma;

  //////////////////////////////////////////////////////////////////////////////
  // Body
  //////////////////////////////////////////////////////////////////////////////

  // PMA configurations
  generate
    for (i = 0; i < PMA_CNT; i = i + 1) begin : set_pmacfg
      assign pmacfg[i][13:12] = pma_cfg_i[i][13:12] == MEM_TYPE_EMPTY ? MEM_TYPE_IO : pma_cfg_i[i][13:12];
      assign pmacfg[i][3:2]   = pma_cfg_i[i][13:12] == MEM_TYPE_EMPTY ? AMO_TYPE_NONE : pma_cfg_i[i][3:2];
      assign pmacfg[i][11]    = pma_cfg_i[i][13:12] == MEM_TYPE_EMPTY ? 1'b0 : pma_cfg_i[i][11];
      assign pmacfg[i][10]    = pma_cfg_i[i][13:12] == MEM_TYPE_EMPTY ? 1'b0 : pma_cfg_i[i][10];
      assign pmacfg[i][9]     = pma_cfg_i[i][13:12] == MEM_TYPE_EMPTY ? 1'b0 : pma_cfg_i[i][9];
      assign pmacfg[i][8]     = pma_cfg_i[i][13:12] == MEM_TYPE_MAIN ? pma_cfg_i[i][8] : 1'b0;
      assign pmacfg[i][7]     = pma_cfg_i[i][7] & pmacfg[i][8];
      assign pmacfg[i][6]     = pma_cfg_i[i][13:12] == MEM_TYPE_IO ? pma_cfg_i[i][6] : 1'b1;
      assign pmacfg[i][5]     = pma_cfg_i[i][13:12] == MEM_TYPE_IO ? pma_cfg_i[i][5] : 1'b1;
      assign pmacfg[i][4]     = pma_cfg_i[i][4];
      assign pmacfg[i][1:0]   = pma_cfg_i[i][1:0];
    end
  endgenerate

  // Address Range Matching
  assign access_lb = adr_i;
  assign access_ub = adr_i + size2bytes(size_i) - 1;

  generate
    for (i = 0; i < PMA_CNT; i = i + 1) begin : gen_pma_bounds
      // lower bounds
      always @(*) begin
        case (pmacfg[i][1:0])
          // TOR after NAPOT ...
          TOR:     pma_lb[i] = (i == 0) ? {PLEN - 2{1'b0}} : pmacfg[i-1][1:0] != TOR ? pma_ub[i-1] : pma_adr_i[i-1][PLEN-2 - 1:0];
          NA4:     pma_lb[i] = napot_lb(1'b1, pma_adr_i[i]);
          NAPOT:   pma_lb[i] = napot_lb(1'b0, pma_adr_i[i]);
          default: pma_lb[i] = {$bits(pma_lb[i]) {1'bx}};
        endcase
      end

      // upper bounds
      always @(*) begin
        case (pmacfg[i][1:0])
          TOR:     pma_ub[i] = pma_adr_i[i][PLEN-2 - 1:0];
          NA4:     pma_ub[i] = napot_ub(1'b1, pma_adr_i[i]);
          NAPOT:   pma_ub[i] = napot_ub(1'b0, pma_adr_i[i]);
          default: pma_ub[i] = {$bits(pma_ub[i]) {1'bx}};
        endcase
      end

      // match
      assign pma_match[i]     = match_any(access_lb[PLEN-1:2], access_ub[PLEN-1:2], pma_lb[i], pma_ub[i]) & (pmacfg[i][1:0] != OFF);
      assign pma_match_all[i] = match_all(access_lb[PLEN-1:2], access_ub[PLEN-1:2], pma_lb[i], pma_ub[i]) & (pmacfg[i][1:0] != OFF);
    end
  endgenerate

  assign matched_pma_idx   = highest_priority_match(pma_match_all);
  assign matched_pma       = pmacfg[matched_pma_idx];
  assign pma_o             = matched_pma;

  // Access/Misaligned Exception
  assign exception_o       = req_i & (~|pma_match_all |  // no memory range matched
                   (instruction_i & ~matched_pma[09]) |  // not executable
                            (we_i & ~matched_pma[10]) |  // not writeable
                           (~we_i & ~matched_pma[11]));  // not readable

  assign misaligned_o      = misaligned_i & ~matched_pma[4];

  // Access Types
  assign is_cache_access_o = req_i & ~exception_o & ~misaligned_o & matched_pma[8];  // implies MEM_TYPE_MAIN
  assign is_ext_access_o   = req_i & ~exception_o & ~misaligned_o & ~matched_pma[8] & matched_pma[13:12] != MEM_TYPE_TCM;
  assign is_tcm_access_o   = req_i & ~exception_o & ~misaligned_o & (matched_pma[13:12] == MEM_TYPE_TCM);
endmodule
