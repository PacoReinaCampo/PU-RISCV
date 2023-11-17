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
//              Core - Data Memory Access (Write Back)                        //
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

  // Memory acknowledge + Write Back unit
  pu_riscv_wb #(
    .XLEN(XLEN),
    .ILEN(ILEN),

    .EXCEPTION_SIZE(EXCEPTION_SIZE),

    .PC_INIT(PC_INIT)

  ) wb_unit (
    .rst_ni           (rstn),
    .clk_i            (clk),
    .mem_pc_i         (mem_pc),
    .mem_instr_i      (mem_instr),
    .mem_bubble_i     (mem_bubble),
    .mem_r_i          (mem_r),
    .mem_exception_i  (mem_exception),
    .mem_memadr_i     (mem_memadr),
    .wb_pc_o          (wb_pc),
    .wb_stall_o       (wb_stall),
    .wb_instr_o       (wb_instr),
    .wb_bubble_o      (wb_bubble),
    .wb_exception_o   (wb_exception),
    .wb_badaddr_o     (wb_badaddr),
    .dmem_ack_i       (dmem_ack),
    .dmem_err_i       (dmem_err),
    .dmem_q_i         (dmem_q),
    .dmem_misaligned_i(dmem_misaligned),
    .dmem_page_fault_i(dmem_page_fault),
    .wb_dst_o         (wb_dst),
    .wb_r_o           (wb_r),
    .wb_we_o          (wb_we)
  );
endmodule
