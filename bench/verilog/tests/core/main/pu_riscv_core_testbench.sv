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
//              Core - Core                                                   //
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

module pu_riscv_core_testbench;

  //////////////////////////////////////////////////////////////////////////////
  // Body
  //////////////////////////////////////////////////////////////////////////////

  // Instantiate RISC-V core
  pu_riscv_core #(
    .XLEN     (XLEN),
    .PLEN     (PLEN),
    .HAS_USER (HAS_USER),
    .HAS_SUPER(HAS_SUPER),
    .HAS_HYPER(HAS_HYPER),
    .HAS_BPU  (HAS_BPU),
    .HAS_FPU  (HAS_FPU),
    .HAS_MMU  (HAS_MMU),
    .HAS_RVM  (HAS_RVM),
    .HAS_RVA  (HAS_RVA),
    .HAS_RVC  (HAS_RVC),
    .IS_RV32E (IS_RV32E),

    .MULT_LATENCY(MULT_LATENCY),

    .BREAKPOINTS(BREAKPOINTS),
    .PMP_CNT    (PMP_CNT),

    .BP_GLOBAL_BITS(BP_GLOBAL_BITS),
    .BP_LOCAL_BITS (BP_LOCAL_BITS),

    .TECHNOLOGY(TECHNOLOGY),

    .MNMIVEC_DEFAULT(MNMIVEC_DEFAULT),
    .MTVEC_DEFAULT  (MTVEC_DEFAULT),
    .HTVEC_DEFAULT  (HTVEC_DEFAULT),
    .STVEC_DEFAULT  (STVEC_DEFAULT),
    .UTVEC_DEFAULT  (UTVEC_DEFAULT),

    .JEDEC_BANK           (JEDEC_BANK),
    .JEDEC_MANUFACTURER_ID(JEDEC_MANUFACTURER_ID),

    .HARTID(HARTID),

    .PC_INIT    (PC_INIT),
    .PARCEL_SIZE(PARCEL_SIZE)
  ) core (
    .rstn(HRESETn),
    .clk (HCLK),

    .if_stall_nxt_pc     (if_stall_nxt_pc),
    .if_nxt_pc           (if_nxt_pc),
    .if_stall            (if_stall),
    .if_flush            (if_flush),
    .if_parcel           (if_parcel),
    .if_parcel_pc        (if_parcel_pc),
    .if_parcel_valid     (if_parcel_valid),
    .if_parcel_misaligned(if_parcel_misaligned),
    .if_parcel_page_fault(if_parcel_page_fault),
    .dmem_adr            (dmem_adr),
    .dmem_d              (dmem_d),
    .dmem_q              (dmem_q),
    .dmem_we             (dmem_we),
    .dmem_size           (dmem_size),
    .dmem_req            (dmem_req),
    .dmem_ack            (dmem_ack),
    .dmem_err            (dmem_err),
    .dmem_misaligned     (dmem_misaligned),
    .dmem_page_fault     (dmem_page_fault),
    .st_prv              (st_prv),
    .st_pmpcfg           (st_pmpcfg),
    .st_pmpaddr          (st_pmpaddr),

    .bu_cacheflush(cacheflush),

    .ext_nmi  (ext_nmi),
    .ext_tint (ext_tint),
    .ext_sint (ext_sint),
    .ext_int  (ext_int),
    .dbg_stall(dbg_stall),
    .dbg_strb (dbg_strb),
    .dbg_we   (dbg_we),
    .dbg_addr (dbg_addr),
    .dbg_dati (dbg_dati),
    .dbg_dato (dbg_dato),
    .dbg_ack  (dbg_ack),
    .dbg_bp   (dbg_bp)
  );
endmodule
