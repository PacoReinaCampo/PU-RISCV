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
//              Core - Branch Unit                                            //
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

import pu_riscv_verilog_pkg::*;

module pu_riscv_divider_testbench;

  //////////////////////////////////////////////////////////////////////////////
  // Module Body
  //////////////////////////////////////////////////////////////////////////////

  // DUT
  // Branch Unit
  pu_riscv_bu #(
    .XLEN          (XLEN),
    .ILEN          (ILEN),
    .EXCEPTION_SIZE(EXCEPTION_SIZE),
    .PC_INIT       (PC_INIT),
    .BP_GLOBAL_BITS(BP_GLOBAL_BITS),
    .HAS_RVC       (HAS_RVC)
  ) bu (
    .rstn         (rstn),
    .clk          (clk),
    .ex_stall     (ex_stall),
    .st_flush     (st_flush),
    .id_pc        (id_pc),
    .bu_nxt_pc    (bu_nxt_pc),
    .bu_flush     (bu_flush),
    .bu_cacheflush(bu_cacheflush),
    .id_bp_predict(id_bp_predict),
    .bu_bp_predict(bu_bp_predict),
    .bu_bp_history(bu_bp_history),
    .bu_bp_btaken (bu_bp_btaken),
    .bu_bp_update (bu_bp_update),
    .id_bubble    (id_bubble),
    .id_instr     (id_instr),
    .id_exception (id_exception),
    .ex_exception (ex_exception),
    .mem_exception(mem_exception),
    .wb_exception (wb_exception),
    .bu_exception (ex_exception),
    .opA          (opA),
    .opB          (opB),
    .du_stall     (du_stall),
    .du_flush     (du_flush),
    .du_we_pc     (du_we_pc),
    .du_dato      (du_dato),
    .du_ie        (du_ie)
  );
endmodule
