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
//              Core - Memory Unit                                            //
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
  // Memory access
  pu_riscv_memory #(
    .XLEN(XLEN),
    .ILEN(ILEN),

    .EXCEPTION_SIZE(EXCEPTION_SIZE),

    .PC_INIT(PC_INIT)

  ) memory_unit (
    .rstn         (rstn),
    .clk          (clk),
    .wb_stall     (wb_stall),
    .ex_pc        (ex_pc),
    .mem_pc       (mem_pc),
    .ex_bubble    (ex_bubble),
    .ex_instr     (ex_instr),
    .mem_bubble   (mem_bubble),
    .mem_instr    (mem_instr),
    .ex_exception (ex_exception),
    .wb_exception (wb_exception),
    .mem_exception(mem_exception),
    .ex_r         (ex_r),
    .dmem_adr     (dmem_adr),
    .mem_r        (mem_r),
    .mem_memadr   (mem_memadr)
  );
endmodule
