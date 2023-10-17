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
//              Core - Physical Memory Protection Checker                     //
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
import peripheral_biu_verilog_pkg::*;

module pu_riscv_pmpchk #(
  parameter XLEN    = 64,
  parameter PLEN    = 64,
  parameter PMP_CNT = 16
) (
  //From State
  input [PMP_CNT-1:0][     7:0] st_pmpcfg_i,
  input [PMP_CNT-1:0][XLEN-1:0] st_pmpaddr_i,

  input [1:0] st_prv_i,

  //Memory Access
  input                 instruction_i,  //This is an instruction access
  input                 req_i,          //Memory access requested
  input      [PLEN-1:0] adr_i,          //Physical Memory address (i.e. after translation)
  input wire [     2:0] size_i,         //Transfer size
  input                 we_i,           //Read/Write enable

  //Output
  output exception_o
);

  //////////////////////////////////////////////////////////////////////////////
  //
  // Functions
  //

  //convert transfer size in number of bytes in transfer
  function automatic integer size2bytes;
    input [2:0] size;

    case (size)
      BYTE:  size2bytes = 1;
      HWORD: size2bytes = 2;
      WORD:  size2bytes = 4;
      DWORD: size2bytes = 8;
      QWORD: size2bytes = 16;
      default: begin
        size2bytes = 0 - 1;
        //$error ("Illegal biu_size_t");
      end
    endcase
  endfunction

  //Lower and Upper bounds for NA4/NAPOT
  function automatic [PLEN-1:2] napot_lb;
    input na4;  //special case na4
    input [PLEN-1:2] pmaddr;

    integer n, i;
    bit              true;
    logic [PLEN-1:2] mask;

    //find 'n' boundary = 2^(n+2) bytes
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

    //create mask
    mask     = {$bits(mask) {1'b1}} << n;

    //lower bound address
    napot_lb = pmaddr & mask;
  endfunction

  function automatic [PLEN-1:2] napot_ub;
    input na4;  //special case na4
    input [PLEN-1:2] pmaddr;

    integer n, i;
    bit              true;
    logic [PLEN-1:2] mask;
    logic [PLEN-1:2] incr;

    //find 'n' boundary = 2^(n+2) bytes
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

    //create mask and increment
    mask     = {$bits(mask) {1'b1}} << n;
    incr     = 1'h1 << n;

    //upper bound address
    napot_ub = (pmaddr + incr) & mask;
  endfunction

  //Is ANY byte of 'access' in pma range?
  function automatic match_any;
    input [PLEN-1:2] access_lb;
    input [PLEN-1:2] access_ub;
    input [PLEN-1:2] pma_lb;
    input [PLEN-1:2] pma_ub;

    /* Check if ANY byte of the access lies within the PMA range
     *   pma_lb <= range < pma_ub
     * 
     *   match_none = (access_lb >= pma_ub) OR (access_ub < pma_lb)  (1)
     *   match_any  = !match_none                                    (2)
     */

    match_any = (access_lb >= pma_ub) || (access_ub < pma_lb) ? 1'b0 : 1'b1;
  endfunction

  //Are ALL bytes of 'access' in PMA range?
  function automatic match_all;
    input [PLEN-1:2] access_lb;
    input [PLEN-1:2] access_ub;
    input [PLEN-1:2] pma_lb;
    input [PLEN-1:2] pma_ub;

    match_all = (access_lb >= pma_lb) && (access_ub < pma_ub) ? 1'b1 : 1'b0;
  endfunction

  //get highest priority (==lowest number) PMP that matches
  function automatic integer highest_priority_match;
    input [PMP_CNT-1:0] m;

    integer n;

    highest_priority_match = 0;  //default value

    for (n = PMP_CNT - 1; n >= 0; n = n - 1) begin
      if (m[n]) begin
        highest_priority_match = n;
      end
    end
  endfunction

  //////////////////////////////////////////////////////////////////////////////
  //
  // Variables
  //
  genvar i;

  logic [   PLEN-1:0]           access_ub;
  logic [   PLEN-1:0]           access_lb;
  logic [PMP_CNT-1:0][PLEN-1:2] pmp_ub;
  logic [PMP_CNT-1:0][PLEN-1:2] pmp_lb;
  logic [PMP_CNT-1:0]           pmp_match;
  logic [PMP_CNT-1:0]           pmp_match_all;
  logic                         matched_pmp;
  logic [        7:0]           matched_pmpcfg;

  //////////////////////////////////////////////////////////////////////////////
  //
  // Module Body
  //

  /*
   * Address Range Matching
   * Access Exception
   * Cacheable
   */

  assign access_lb = adr_i;
  assign access_ub = adr_i + size2bytes(size_i) - 1;

  generate
    for (i = 0; i < PMP_CNT; i = i + 1) begin : gen_pmp_bounds
      //lower bounds
      always @(*) begin
        case (st_pmpcfg_i[i][4:3])
          TOR:     pmp_lb[i] = (i == 0) ? 0 : st_pmpcfg_i[i][4:3] != TOR ? pmp_ub[i] : st_pmpaddr_i[i][PLEN-3:0];
          NA4:     pmp_lb[i] = napot_lb(1'b1, st_pmpaddr_i[i]);
          NAPOT:   pmp_lb[i] = napot_lb(1'b0, st_pmpaddr_i[i]);
          default: pmp_lb[i] = 'hx;
        endcase
      end

      //upper bounds
      always @(*) begin
        case (st_pmpcfg_i[i][4:3])
          TOR:     pmp_ub[i] = st_pmpaddr_i[i][PLEN-3:0];
          NA4:     pmp_ub[i] = napot_ub(1'b1, st_pmpaddr_i[i]);
          NAPOT:   pmp_ub[i] = napot_ub(1'b0, st_pmpaddr_i[i]);
          default: pmp_ub[i] = 'hx;
        endcase
      end

      //match-any
      assign pmp_match[i]     = match_any(access_lb[PLEN-1:2], access_ub[PLEN-1:2], pmp_lb[i], pmp_ub[i]) & (st_pmpcfg_i[i][4:3] != OFF);

      assign pmp_match_all[i] = match_all(access_lb[PLEN-1:2], access_ub[PLEN-1:2], pmp_lb[i], pmp_ub[i]);
    end
  endgenerate

  assign matched_pmp = highest_priority_match(pmp_match);
  assign matched_pmpcfg = st_pmpcfg_i[matched_pmp];

  /* Access FAIL when:
   * 1. some bytes matched highest priority PMP, but not the entire transfer range OR
   * 2. pmpcfg.l is set AND privilegel level is S or U AND pmpcfg.rwx tests fail OR
   * 3. privilegel level is S or U AND no PMPs matched AND PMPs are implemented
   */

  assign exception_o = req_i & (~|pmp_match ? (st_prv_i != PRV_M) & (PMP_CNT > 0)  //Prv.Lvl != M-Mode, no PMP matched, but PMPs implemented -> FAIL
    : ~pmp_match_all[matched_pmp] | (((st_prv_i != PRV_M) | matched_pmpcfg[7]) &  //pmpcfg.l set or privilege level != M-mode
    ((~matched_pmpcfg[0] & ~we_i) |  // read-access while not allowed          -> FAIL
    (~matched_pmpcfg[1] & we_i) |  // write-access while not allowed         -> FAIL
    (~matched_pmpcfg[2] & instruction_i))  // instruction read, but not instruction  -> FAIL
    ));
endmodule
