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
//              Core - Debug Unit                                             //
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

  // Debug Unit
  pu_riscv_du #(
    .XLEN(XLEN),
    .PLEN(PLEN),
    .ILEN(ILEN),

    .EXCEPTION_SIZE(EXCEPTION_SIZE),

    .DU_ADDR_SIZE   (DU_ADDR_SIZE),
    .MAX_BREAKPOINTS(MAX_BREAKPOINTS),

    .BREAKPOINTS(BREAKPOINTS)
  ) du_unit (
    .rstn         (rstn),
    .clk          (clk),
    .dbg_stall    (dbg_stall),
    .dbg_strb     (dbg_strb),
    .dbg_we       (dbg_we),
    .dbg_addr     (dbg_addr),
    .dbg_dati     (dbg_dati),
    .dbg_dato     (dbg_dato),
    .dbg_ack      (dbg_ack),
    .dbg_bp       (dbg_bp),
    .du_stall     (du_stall),
    .du_stall_dly (du_stall_dly),
    .du_flush     (du_flush),
    .du_we_rf     (du_we_rf),
    .du_we_frf    (du_we_frf),
    .du_we_csr    (du_we_csr),
    .du_we_pc     (du_we_pc),
    .du_addr      (du_addr),
    .du_dato      (du_dato),
    .du_ie        (du_ie),
    .du_dati_rf   (du_dati_rf),
    .du_dati_frf  (du_dati_frf),
    .st_csr_rval  (st_csr_rval),
    .if_pc        (if_pc),
    .id_pc        (id_pc),
    .ex_pc        (ex_pc),
    .bu_nxt_pc    (bu_nxt_pc),
    .bu_flush     (bu_flush),
    .st_flush     (st_flush),
    .if_instr     (if_instr),
    .mem_instr    (mem_instr),
    .if_bubble    (if_bubble),
    .mem_bubble   (mem_bubble),
    .mem_exception(mem_exception),
    .mem_memadr   (mem_memadr),
    .dmem_ack     (dmem_ack),
    .ex_stall     (ex_stall),
    .du_exceptions(du_exceptions)
  );
