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
//              BIU Bus Interface                                             //
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
//   Francisco Javier Reina Campo <pacoreinacampo@queenfield.tech>

module pu_riscv_biu #(
  parameter            XLEN      = 64,
  parameter            PLEN      = 64,
  parameter [XLEN-1:0] PC_INIT   = 'h8000_0000,
  parameter            HAS_USER  = 1,
  parameter            HAS_SUPER = 1,
  parameter            HAS_HYPER = 1,
  parameter            HAS_BPU   = 1,
  parameter            HAS_FPU   = 1,
  parameter            HAS_MMU   = 1,
  parameter            HAS_RVM   = 1,
  parameter            HAS_RVA   = 1,
  parameter            HAS_RVC   = 1,
  parameter            IS_RV32E  = 0,

  parameter MULT_LATENCY = 1,

  parameter BREAKPOINTS = 8,  // Number of hardware breakpoints

  parameter PMA_CNT = 4,
  parameter PMP_CNT = 16, // Number of Physical Memory Protection entries

  parameter BP_GLOBAL_BITS    = 2,
  parameter BP_LOCAL_BITS     = 10,
  parameter BP_LOCAL_BITS_LSB = 2,

  parameter ICACHE_SIZE        = 64,  // in KBytes
  parameter ICACHE_BLOCK_SIZE  = 64,  // in Bytes
  parameter ICACHE_WAYS        = 2,   // 'n'-way set associative
  parameter ICACHE_REPLACE_ALG = 0,
  parameter ITCM_SIZE          = 0,

  parameter DCACHE_SIZE        = 64,  // in KBytes
  parameter DCACHE_BLOCK_SIZE  = 64,  // in Bytes
  parameter DCACHE_WAYS        = 2,   // 'n'-way set associative
  parameter DCACHE_REPLACE_ALG = 0,
  parameter DTCM_SIZE          = 0,
  parameter WRITEBUFFER_SIZE   = 8,

  parameter TECHNOLOGY = "GENERIC",

  parameter [XLEN-1:0] MNMIVEC_DEFAULT = PC_INIT - 'h004,
  parameter [XLEN-1:0] MTVEC_DEFAULT   = PC_INIT - 'h040,
  parameter [XLEN-1:0] HTVEC_DEFAULT   = PC_INIT - 'h080,
  parameter [XLEN-1:0] STVEC_DEFAULT   = PC_INIT - 'h0C0,
  parameter [XLEN-1:0] UTVEC_DEFAULT   = PC_INIT - 'h100,

  parameter JEDEC_BANK            = 10,
  parameter JEDEC_MANUFACTURER_ID = 'h6e,

  parameter HARTID = 0,

  parameter PARCEL_SIZE = 32
) (
  input HRESETn,
  input HCLK,

  input wire [PMA_CNT-1:0][    13:0] pma_cfg_i,
  input wire [PMA_CNT-1:0][XLEN-1:0] pma_adr_i,

  // BIU instruction
  output reg             ibiu_stb,
  input  wire            ibiu_stb_ack,
  input  wire            ibiu_d_ack,
  output reg  [PLEN-1:0] ibiu_adri,
  input  wire [PLEN-1:0] ibiu_adro,
  output reg  [     2:0] ibiu_size,
  output reg  [     2:0] ibiu_type,
  output reg             ibiu_we,
  output reg             ibiu_lock,
  output reg  [     2:0] ibiu_prot,
  output reg  [XLEN-1:0] ibiu_d,
  input  wire [XLEN-1:0] ibiu_q,
  input  wire            ibiu_ack,
  input  wire            ibiu_err,

  // BIU data
  output reg             dbiu_stb,
  input  wire            dbiu_stb_ack,
  input  wire            dbiu_d_ack,
  output reg  [PLEN-1:0] dbiu_adri,
  input  wire [PLEN-1:0] dbiu_adro,
  output reg  [     2:0] dbiu_size,
  output reg  [     2:0] dbiu_type,
  output reg             dbiu_we,
  output reg             dbiu_lock,
  output reg  [     2:0] dbiu_prot,
  output reg  [XLEN-1:0] dbiu_d,
  input  wire [XLEN-1:0] dbiu_q,
  input  wire            dbiu_ack,
  input  wire            dbiu_err,

  // Interrupts
  input       ext_nmi,
  input       ext_tint,
  input       ext_sint,
  input [3:0] ext_int,

  // Debug Interface
  input             dbg_stall,
  input             dbg_strb,
  input             dbg_we,
  input  [PLEN-1:0] dbg_addr,
  input  [XLEN-1:0] dbg_dati,
  output [XLEN-1:0] dbg_dato,
  output            dbg_ack,
  output            dbg_bp
);

  //////////////////////////////////////////////////////////////////////////////
  // Variables
  //////////////////////////////////////////////////////////////////////////////

  logic                                if_stall_nxt_pc;
  logic [XLEN          -1:0]           if_nxt_pc;
  logic                                if_stall;
  logic                                if_flush;
  logic [PARCEL_SIZE   -1:0]           if_parcel;
  logic [XLEN          -1:0]           if_parcel_pc;
  logic [PARCEL_SIZE/16-1:0]           if_parcel_valid;
  logic                                if_parcel_misaligned;
  logic                                if_parcel_page_fault;

  logic                                dmem_req;
  logic [XLEN          -1:0]           dmem_adr;
  logic [               2:0]           dmem_size;
  logic                                dmem_we;
  logic [XLEN          -1:0]           dmem_d;
  logic [XLEN          -1:0]           dmem_q;
  logic                                dmem_ack;
  logic                                dmem_err;
  logic                                dmem_misaligned;
  logic                                dmem_page_fault;

  logic [               1:0]           st_prv;
  logic [       PMP_CNT-1:0][     7:0] st_pmpcfg;
  logic [       PMP_CNT-1:0][XLEN-1:0] st_pmpaddr;
  logic                                cacheflush;
  logic                                dcflush_rdy;

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

  // Instantiate bus interfaces and optional caches

  // Instruction Memory Access Block
  pu_riscv_imem_ctrl #(
    .XLEN(XLEN),
    .PLEN(PLEN),

    .PARCEL_SIZE(PARCEL_SIZE),

    .HAS_RVC(HAS_RVC),

    .PMA_CNT(PMA_CNT),
    .PMP_CNT(PMP_CNT),

    .ICACHE_SIZE       (ICACHE_SIZE),
    .ICACHE_BLOCK_SIZE (ICACHE_BLOCK_SIZE),
    .ICACHE_WAYS       (ICACHE_WAYS),
    .ICACHE_REPLACE_ALG(ICACHE_REPLACE_ALG),
    .ITCM_SIZE         (ITCM_SIZE),

    .TECHNOLOGY(TECHNOLOGY)
  ) imem_ctrl (
    .rst_ni(HRESETn),
    .clk_i (HCLK),

    .pma_cfg_i(pma_cfg_i),
    .pma_adr_i(pma_adr_i),

    .nxt_pc_i      (if_nxt_pc),
    .stall_nxt_pc_o(if_stall_nxt_pc),
    .stall_i       (if_stall),
    .flush_i       (if_flush),
    .parcel_pc_o   (if_parcel_pc),
    .parcel_o      (if_parcel),
    .parcel_valid_o(if_parcel_valid),
    .err_o         (),
    .misaligned_o  (if_parcel_misaligned),
    .page_fault_o  (if_parcel_page_fault),

    .cache_flush_i(cacheflush),
    .dcflush_rdy_i(dcflush_rdy),

    .st_prv_i    (st_prv),
    .st_pmpcfg_i (st_pmpcfg),
    .st_pmpaddr_i(st_pmpaddr),

    .biu_stb_o    (ibiu_stb),
    .biu_stb_ack_i(ibiu_stb_ack),
    .biu_d_ack_i  (ibiu_d_ack),
    .biu_adri_o   (ibiu_adri),
    .biu_adro_i   (ibiu_adro),
    .biu_size_o   (ibiu_size),
    .biu_type_o   (ibiu_type),
    .biu_we_o     (ibiu_we),
    .biu_lock_o   (ibiu_lock),
    .biu_prot_o   (ibiu_prot),
    .biu_d_o      (ibiu_d),
    .biu_q_i      (ibiu_q),
    .biu_ack_i    (ibiu_ack),
    .biu_err_i    (ibiu_err)
  );

  // Data Memory Access Block
  pu_riscv_dmem_ctrl #(
    .XLEN(XLEN),
    .PLEN(PLEN),

    .HAS_RVC(HAS_RVC),

    .PMA_CNT(PMA_CNT),
    .PMP_CNT(PMP_CNT),

    .DCACHE_SIZE       (DCACHE_SIZE),
    .DCACHE_BLOCK_SIZE (DCACHE_BLOCK_SIZE),
    .DCACHE_WAYS       (DCACHE_WAYS),
    .DCACHE_REPLACE_ALG(DCACHE_REPLACE_ALG),
    .DTCM_SIZE         (DTCM_SIZE),

    .TECHNOLOGY(TECHNOLOGY)
  ) dmem_ctrl (
    .rst_ni(HRESETn),
    .clk_i (HCLK),

    .pma_cfg_i(pma_cfg_i),
    .pma_adr_i(pma_adr_i),

    .mem_req_i       (dmem_req),
    .mem_adr_i       (dmem_adr),
    .mem_size_i      (dmem_size),
    .mem_lock_i      (),
    .mem_we_i        (dmem_we),
    .mem_d_i         (dmem_d),
    .mem_q_o         (dmem_q),
    .mem_ack_o       (dmem_ack),
    .mem_err_o       (dmem_err),
    .mem_misaligned_o(dmem_misaligned),
    .mem_page_fault_o(dmem_page_fault),

    .cache_flush_i(cacheflush),
    .dcflush_rdy_o(dcflush_rdy),

    .st_prv_i    (st_prv),
    .st_pmpcfg_i (st_pmpcfg),
    .st_pmpaddr_i(st_pmpaddr),

    .biu_stb_o    (dbiu_stb),
    .biu_stb_ack_i(dbiu_stb_ack),
    .biu_d_ack_i  (dbiu_d_ack),
    .biu_adri_o   (dbiu_adri),
    .biu_adro_i   (dbiu_adro),
    .biu_size_o   (dbiu_size),
    .biu_type_o   (dbiu_type),
    .biu_we_o     (dbiu_we),
    .biu_lock_o   (dbiu_lock),
    .biu_prot_o   (dbiu_prot),
    .biu_d_o      (dbiu_d),
    .biu_q_i      (dbiu_q),
    .biu_ack_i    (dbiu_ack),
    .biu_err_i    (dbiu_err)
  );
endmodule
