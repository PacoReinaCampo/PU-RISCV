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
//              Core - State Unit                                             //
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

  // Thread state
  pu_riscv_state #(
    .XLEN     (XLEN),
    .PC_INIT  (PC_INIT),
    .HAS_FPU  (HAS_FPU),
    .HAS_MMU  (HAS_MMU),
    .HAS_USER (HAS_USER),
    .HAS_SUPER(HAS_SUPER),
    .HAS_HYPER(HAS_HYPER),

    .MNMIVEC_DEFAULT(MNMIVEC_DEFAULT),
    .MTVEC_DEFAULT  (MTVEC_DEFAULT),
    .HTVEC_DEFAULT  (HTVEC_DEFAULT),
    .STVEC_DEFAULT  (STVEC_DEFAULT),
    .UTVEC_DEFAULT  (UTVEC_DEFAULT),

    .JEDEC_BANK           (JEDEC_BANK),
    .JEDEC_MANUFACTURER_ID(JEDEC_MANUFACTURER_ID),

    .PMP_CNT(PMP_CNT),
    .HARTID (HARTID)
  ) cpu_state (
    .rstn         (rstn),
    .clk          (clk),
    .id_pc        (id_pc),
    .id_bubble    (id_bubble),
    .id_instr     (id_instr),
    .id_stall     (id_stall),
    .bu_flush     (bu_flush),
    .bu_nxt_pc    (bu_nxt_pc),
    .st_flush     (st_flush),
    .st_nxt_pc    (st_nxt_pc),
    .wb_pc        (wb_pc),
    .wb_bubble    (wb_bubble),
    .wb_instr     (wb_instr),
    .wb_exception (wb_exception),
    .wb_badaddr   (wb_badaddr),
    .st_interrupt (st_interrupt),
    .st_prv       (st_prv),
    .st_xlen      (st_xlen),
    .st_tvm       (st_tvm),
    .st_tw        (st_tw),
    .st_tsr       (st_tsr),
    .st_mcounteren(st_mcounteren),
    .st_scounteren(st_scounteren),
    .st_pmpcfg    (st_pmpcfg),
    .st_pmpaddr   (st_pmpaddr),
    .ext_int      (ext_int),
    .ext_tint     (ext_tint),
    .ext_sint     (ext_sint),
    .ext_nmi      (ext_nmi),
    .ex_csr_reg   (ex_csr_reg),
    .ex_csr_we    (ex_csr_we),
    .ex_csr_wval  (ex_csr_wval),
    .st_csr_rval  (st_csr_rval),
    .du_stall     (du_stall),
    .du_flush     (du_flush),
    .du_we_csr    (du_we_csr),
    .du_dato      (du_dato),
    .du_addr      (du_addr),
    .du_ie        (du_ie),
    .du_exceptions(du_exceptions)
  );
