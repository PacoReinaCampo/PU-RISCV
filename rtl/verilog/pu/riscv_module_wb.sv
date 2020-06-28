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
//              Processing Unit                                               //
//              Wishbone Bus Interface                                        //
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

module riscv_module_wb #(
  parameter            XLEN               = 32,
  parameter            PLEN               = 32,
  parameter [XLEN-1:0] PC_INIT            = 'h8000_0000,
  parameter            HAS_USER           = 1,
  parameter            HAS_SUPER          = 1,
  parameter            HAS_HYPER          = 1,
  parameter            HAS_BPU            = 1,
  parameter            HAS_FPU            = 1,
  parameter            HAS_MMU            = 1,
  parameter            HAS_RVM            = 1,
  parameter            HAS_RVA            = 1,
  parameter            HAS_RVC            = 1,
  parameter            IS_RV32E           = 0,

  parameter            MULT_LATENCY       = 1,

  parameter            BREAKPOINTS        = 8,  //Number of hardware breakpoints

  parameter            PMA_CNT            = 4,
  parameter            PMP_CNT            = 16, //Number of Physical Memory Protection entries

  parameter            BP_GLOBAL_BITS     = 2,
  parameter            BP_LOCAL_BITS      = 10,
  parameter            BP_LOCAL_BITS_LSB  = 2,

  parameter            ICACHE_SIZE        = 32,  //in KBytes
  parameter            ICACHE_BLOCK_SIZE  = 32,  //in Bytes
  parameter            ICACHE_WAYS        = 2,   //'n'-way set associative
  parameter            ICACHE_REPLACE_ALG = 0,
  parameter            ITCM_SIZE          = 0,

  parameter            DCACHE_SIZE        = 32,  //in KBytes
  parameter            DCACHE_BLOCK_SIZE  = 32,  //in Bytes
  parameter            DCACHE_WAYS        = 2,   //'n'-way set associative
  parameter            DCACHE_REPLACE_ALG = 0,
  parameter            DTCM_SIZE          = 0,
  parameter            WRITEBUFFER_SIZE   = 8,

  parameter            TECHNOLOGY         = "GENERIC",

  parameter [XLEN-1:0] MNMIVEC_DEFAULT    = PC_INIT - 'h004,
  parameter [XLEN-1:0] MTVEC_DEFAULT      = PC_INIT - 'h040,
  parameter [XLEN-1:0] HTVEC_DEFAULT      = PC_INIT - 'h080,
  parameter [XLEN-1:0] STVEC_DEFAULT      = PC_INIT - 'h0C0,
  parameter [XLEN-1:0] UTVEC_DEFAULT      = PC_INIT - 'h100,

  parameter            JEDEC_BANK            = 10,
  parameter            JEDEC_MANUFACTURER_ID = 'h6e,

  parameter            HARTID             = 0,

  parameter            PARCEL_SIZE        = 32
)
  (
    input                               HRESETn,
    input                               HCLK,

    input wire  [PMA_CNT-1:0][    13:0] pma_cfg_i,
    input wire  [PMA_CNT-1:0][XLEN-1:0] pma_adr_i,

    //WB interfaces
    output          [PLEN         -1:0] wb_ins_adr_o,
    output          [XLEN         -1:0] wb_ins_dat_o,
    output          [              3:0] wb_ins_sel_o,
    output                              wb_ins_we_o,
    output                              wb_ins_cyc_o,
    output                              wb_ins_stb_o,
    output          [              2:0] wb_ins_cti_o,
    output          [              1:0] wb_ins_bte_o,
    input           [XLEN         -1:0] wb_ins_dat_i,
    input                               wb_ins_ack_i,
    input                               wb_ins_err_i,
    input           [              2:0] wb_ins_rty_i,

    output          [PLEN         -1:0] wb_dat_adr_o,
    output          [XLEN         -1:0] wb_dat_dat_o,
    output          [              3:0] wb_dat_sel_o,
    output                              wb_dat_we_o,
    output                              wb_dat_stb_o,
    output                              wb_dat_cyc_o,
    output          [              2:0] wb_dat_cti_o,
    output          [              1:0] wb_dat_bte_o,
    input           [XLEN         -1:0] wb_dat_dat_i,
    input                               wb_dat_ack_i,
    input                               wb_dat_err_i,
    input           [              2:0] wb_dat_rty_i,

    //Interrupts
    input                               ext_nmi,
                                        ext_tint,
                                        ext_sint,
    input           [              3:0] ext_int,

    //Debug Interface
    input                               dbg_stall,
    input                               dbg_strb,
    input                               dbg_we,
    input           [PLEN         -1:0] dbg_addr,
    input           [XLEN         -1:0] dbg_dati,
    output          [XLEN         -1:0] dbg_dato,
    output                              dbg_ack,
    output                              dbg_bp
  );

  ////////////////////////////////////////////////////////////////
  //
  // Module Body
  //

  //Instantiate RISC-V PU
  riscv_pu_wb #(
    .XLEN               (XLEN),
    .PLEN               (PLEN),
    .PC_INIT            (PC_INIT),
    .HAS_USER           (HAS_USER),
    .HAS_SUPER          (HAS_SUPER),
    .HAS_HYPER          (HAS_HYPER),
    .HAS_BPU            (HAS_BPU),
    .HAS_FPU            (HAS_FPU),
    .HAS_MMU            (HAS_MMU),
    .HAS_RVM            (HAS_RVM),
    .HAS_RVA            (HAS_RVA),
    .HAS_RVC            (HAS_RVC),
    .IS_RV32E           (IS_RV32E),

    .MULT_LATENCY       (MULT_LATENCY),

    .BREAKPOINTS        (BREAKPOINTS),  //Number of hardware breakpoints

    .PMA_CNT            (PMA_CNT),
    .PMP_CNT            (PMP_CNT),  //Number of Physical Memory Protection entries

    .BP_GLOBAL_BITS     (BP_GLOBAL_BITS),
    .BP_LOCAL_BITS      (BP_LOCAL_BITS),
    .BP_LOCAL_BITS_LSB  (BP_LOCAL_BITS_LSB),

    .ICACHE_SIZE        (ICACHE_SIZE),  //in KBytes
    .ICACHE_BLOCK_SIZE  (ICACHE_BLOCK_SIZE),  //in Bytes
    .ICACHE_WAYS        (ICACHE_WAYS),  //'n'-way set associative
    .ICACHE_REPLACE_ALG (ICACHE_REPLACE_ALG),
    .ITCM_SIZE          (ITCM_SIZE),

    .DCACHE_SIZE        (DCACHE_SIZE),  //in KBytes
    .DCACHE_BLOCK_SIZE  (DCACHE_BLOCK_SIZE),  //in Bytes
    .DCACHE_WAYS        (DCACHE_WAYS),  //'n'-way set associative
    .DCACHE_REPLACE_ALG (DCACHE_REPLACE_ALG),
    .DTCM_SIZE          (DTCM_SIZE),
    .WRITEBUFFER_SIZE   (WRITEBUFFER_SIZE),

    .TECHNOLOGY         (TECHNOLOGY),

    .MNMIVEC_DEFAULT    (MNMIVEC_DEFAULT),
    .MTVEC_DEFAULT      (MTVEC_DEFAULT),
    .HTVEC_DEFAULT      (HTVEC_DEFAULT),
    .STVEC_DEFAULT      (STVEC_DEFAULT),
    .UTVEC_DEFAULT      (UTVEC_DEFAULT),

    .JEDEC_BANK            (JEDEC_BANK),
    .JEDEC_MANUFACTURER_ID (JEDEC_MANUFACTURER_ID),

    .HARTID             (HARTID),

    .PARCEL_SIZE        (PARCEL_SIZE)
  )
  pu (
    .HRESETn (HRESETn),
    .HCLK    (HCLK),

    .pma_cfg_i (pma_cfg_i),
    .pma_adr_i (pma_adr_i),

    //WB interfaces
    .wb_ins_adr_o (wb_ins_adr_o),
    .wb_ins_dat_o (wb_ins_dat_o),
    .wb_ins_sel_o (wb_ins_sel_o),
    .wb_ins_we_o  (wb_ins_we_o),
    .wb_ins_cyc_o (wb_ins_cyc_o),
    .wb_ins_stb_o (wb_ins_stb_o),
    .wb_ins_cti_o (wb_ins_cti_o),
    .wb_ins_bte_o (wb_ins_bte_o),
    .wb_ins_dat_i (wb_ins_dat_i),
    .wb_ins_ack_i (wb_ins_ack_i),
    .wb_ins_err_i (wb_ins_err_i),
    .wb_ins_rty_i (wb_ins_rty_i),

    .wb_dat_adr_o (wb_dat_adr_o),
    .wb_dat_dat_o (wb_dat_dat_o),
    .wb_dat_sel_o (wb_dat_sel_o),
    .wb_dat_we_o  (wb_dat_we_o),
    .wb_dat_cyc_o (wb_dat_cyc_o),
    .wb_dat_stb_o (wb_dat_stb_o),
    .wb_dat_cti_o (wb_dat_cti_o),
    .wb_dat_bte_o (wb_dat_bte_o),
    .wb_dat_dat_i (wb_dat_dat_i),
    .wb_dat_ack_i (wb_dat_ack_i),
    .wb_dat_err_i (wb_dat_err_i),
    .wb_dat_rty_i (wb_dat_rty_i),

    //Interrupts
    .ext_nmi  (ext_nmi),
    .ext_tint (ext_tint),
    .ext_sint (ext_sint),
    .ext_int  (ext_int),

    //Debug Interface
    .dbg_stall (dbg_stall),
    .dbg_strb  (dbg_strb),
    .dbg_we    (dbg_we),
    .dbg_addr  (dbg_addr),
    .dbg_dati  (dbg_dati),
    .dbg_dato  (dbg_dato),
    .dbg_ack   (dbg_ack),
    .dbg_bp    (dbg_bp)
  );
endmodule
