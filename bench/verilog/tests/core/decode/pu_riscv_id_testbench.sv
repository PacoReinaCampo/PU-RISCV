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
//              Core - Instruction Decoder                                    //
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

module pu_riscv_div_testbench;

  //////////////////////////////////////////////////////////////////////////////
  // Module Body
  //////////////////////////////////////////////////////////////////////////////

  // DUT
  pu_riscv_id #(
    .XLEN(XLEN),
    .ILEN(ILEN),

    .EXCEPTION_SIZE(EXCEPTION_SIZE)
  ) id_unit (
    .rstn         (rstn),
    .clk          (clk),
    .id_stall     (id_stall),
    .ex_stall     (ex_stall),
    .du_stall     (du_stall),
    .bu_flush     (bu_flush),
    .st_flush     (st_flush),
    .du_flush     (du_flush),
    .bu_nxt_pc    (bu_nxt_pc),
    .st_nxt_pc    (st_nxt_pc),
    .if_pc        (if_pc),
    .id_pc        (id_pc),
    .if_bp_predict(if_bp_predict),
    .id_bp_predict(id_bp_predict),
    .if_instr     (if_instr),
    .if_bubble    (if_bubble),
    .id_instr     (id_instr),
    .id_bubble    (id_bubble),
    .ex_instr     (ex_instr),
    .ex_bubble    (ex_bubble),
    .mem_instr    (mem_instr),
    .mem_bubble   (mem_bubble),
    .wb_instr     (wb_instr),
    .wb_bubble    (wb_bubble),
    .if_exception (if_exception),
    .ex_exception (ex_exception),
    .mem_exception(mem_exception),
    .wb_exception (wb_exception),
    .id_exception (id_exception),
    .st_prv       (st_prv),
    .st_xlen      (st_xlen),
    .st_tvm       (st_tvm),
    .st_tw        (st_tw),
    .st_tsr       (st_tsr),
    .st_mcounteren(st_mcounteren),
    .st_scounteren(st_scounteren),

    .id_src1(rf_src1[0]),
    .id_src2(rf_src2[0]),

    .id_opA       (id_opA),
    .id_opB       (id_opB),
    .id_userf_opA (id_userf_opA),
    .id_userf_opB (id_userf_opB),
    .id_bypex_opA (id_bypex_opA),
    .id_bypex_opB (id_bypex_opB),
    .id_bypmem_opA(id_bypmem_opA),
    .id_bypmem_opB(id_bypmem_opB),
    .id_bypwb_opA (id_bypwb_opA),
    .id_bypwb_opB (id_bypwb_opB),
    .mem_r        (mem_r),
    .wb_r         (wb_r)
  );
endmodule
