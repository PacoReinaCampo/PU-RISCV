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
//              AMBA4 AXI-Lite Bus Interface                                  //
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

module pu_riscv_module_tl #(
  parameter AXI_ID_WIDTH   = 10,
  parameter AXI_ADDR_WIDTH = 64,
  parameter AXI_DATA_WIDTH = 64,
  parameter AXI_STRB_WIDTH = 10,
  parameter AXI_USER_WIDTH = 10,

  parameter AHB_ADDR_WIDTH = 64,
  parameter AHB_DATA_WIDTH = 64,

  parameter            XLEN      = 32,
  parameter            PLEN      = 32,
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

  parameter ICACHE_SIZE        = 32,  // in KBytes
  parameter ICACHE_BLOCK_SIZE  = 32,  // in Bytes
  parameter ICACHE_WAYS        = 2,   // 'n'-way set associative
  parameter ICACHE_REPLACE_ALG = 0,
  parameter ITCM_SIZE          = 0,

  parameter DCACHE_SIZE        = 32,  // in KBytes
  parameter DCACHE_BLOCK_SIZE  = 32,  // in Bytes
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

  // AXI4 instruction
  output reg  [AXI_ID_WIDTH    -1:0] tl_ins_aw_id,
  output reg  [AXI_ADDR_WIDTH  -1:0] tl_ins_aw_addr,
  output reg  [                 7:0] tl_ins_aw_len,
  output reg  [                 2:0] tl_ins_aw_size,
  output reg  [                 1:0] tl_ins_aw_burst,
  output reg                         tl_ins_aw_lock,
  output reg  [                 3:0] tl_ins_aw_cache,
  output reg  [                 2:0] tl_ins_aw_prot,
  output reg  [                 3:0] tl_ins_aw_qos,
  output reg  [                 3:0] tl_ins_aw_region,
  output reg  [AXI_USER_WIDTH  -1:0] tl_ins_aw_user,
  output reg                         tl_ins_aw_valid,
  input  wire                        tl_ins_aw_ready,

  output reg  [AXI_ID_WIDTH    -1:0] tl_ins_ar_id,
  output reg  [AXI_ADDR_WIDTH  -1:0] tl_ins_ar_addr,
  output reg  [                 7:0] tl_ins_ar_len,
  output reg  [                 2:0] tl_ins_ar_size,
  output reg  [                 1:0] tl_ins_ar_burst,
  output reg                         tl_ins_ar_lock,
  output reg  [                 3:0] tl_ins_ar_cache,
  output reg  [                 2:0] tl_ins_ar_prot,
  output reg  [                 3:0] tl_ins_ar_qos,
  output reg  [                 3:0] tl_ins_ar_region,
  output reg  [AXI_USER_WIDTH  -1:0] tl_ins_ar_user,
  output reg                         tl_ins_ar_valid,
  input  wire                        tl_ins_ar_ready,

  output reg  [AXI_DATA_WIDTH  -1:0] tl_ins_w_data,
  output reg  [AXI_STRB_WIDTH  -1:0] tl_ins_w_strb,
  output reg                         tl_ins_w_last,
  output reg  [AXI_USER_WIDTH  -1:0] tl_ins_w_user,
  output reg                         tl_ins_w_valid,
  input  wire                        tl_ins_w_ready,

  input  wire [AXI_ID_WIDTH    -1:0] tl_ins_r_id,
  input  wire [AXI_DATA_WIDTH  -1:0] tl_ins_r_data,
  input  wire [                 1:0] tl_ins_r_resp,
  input  wire                        tl_ins_r_last,
  input  wire [AXI_USER_WIDTH  -1:0] tl_ins_r_user,
  input  wire                        tl_ins_r_valid,
  output reg                         tl_ins_r_ready,

  input  wire [AXI_ID_WIDTH    -1:0] tl_ins_b_id,
  input  wire [                 1:0] tl_ins_b_resp,
  input  wire [AXI_USER_WIDTH  -1:0] tl_ins_b_user,
  input  wire                        tl_ins_b_valid,
  output reg                         tl_ins_b_ready,

  // AXI4 data
  output reg  [AXI_ID_WIDTH    -1:0] tl_dat_aw_id,
  output reg  [AXI_ADDR_WIDTH  -1:0] tl_dat_aw_addr,
  output reg  [                 7:0] tl_dat_aw_len,
  output reg  [                 2:0] tl_dat_aw_size,
  output reg  [                 1:0] tl_dat_aw_burst,
  output reg                         tl_dat_aw_lock,
  output reg  [                 3:0] tl_dat_aw_cache,
  output reg  [                 2:0] tl_dat_aw_prot,
  output reg  [                 3:0] tl_dat_aw_qos,
  output reg  [                 3:0] tl_dat_aw_region,
  output reg  [AXI_USER_WIDTH  -1:0] tl_dat_aw_user,
  output reg                         tl_dat_aw_valid,
  input  wire                        tl_dat_aw_ready,

  output reg  [AXI_ID_WIDTH    -1:0] tl_dat_ar_id,
  output reg  [AXI_ADDR_WIDTH  -1:0] tl_dat_ar_addr,
  output reg  [                 7:0] tl_dat_ar_len,
  output reg  [                 2:0] tl_dat_ar_size,
  output reg  [                 1:0] tl_dat_ar_burst,
  output reg                         tl_dat_ar_lock,
  output reg  [                 3:0] tl_dat_ar_cache,
  output reg  [                 2:0] tl_dat_ar_prot,
  output reg  [                 3:0] tl_dat_ar_qos,
  output reg  [                 3:0] tl_dat_ar_region,
  output reg  [AXI_USER_WIDTH  -1:0] tl_dat_ar_user,
  output reg                         tl_dat_ar_valid,
  input  wire                        tl_dat_ar_ready,

  output reg  [AXI_DATA_WIDTH  -1:0] tl_dat_w_data,
  output reg  [AXI_STRB_WIDTH  -1:0] tl_dat_w_strb,
  output reg                         tl_dat_w_last,
  output reg  [AXI_USER_WIDTH  -1:0] tl_dat_w_user,
  output reg                         tl_dat_w_valid,
  input  wire                        tl_dat_w_ready,

  input  wire [AXI_ID_WIDTH    -1:0] tl_dat_r_id,
  input  wire [AXI_DATA_WIDTH  -1:0] tl_dat_r_data,
  input  wire [                 1:0] tl_dat_r_resp,
  input  wire                        tl_dat_r_last,
  input  wire [AXI_USER_WIDTH  -1:0] tl_dat_r_user,
  input  wire                        tl_dat_r_valid,
  output reg                         tl_dat_r_ready,

  input  wire [AXI_ID_WIDTH    -1:0] tl_dat_b_id,
  input  wire [                 1:0] tl_dat_b_resp,
  input  wire [AXI_USER_WIDTH  -1:0] tl_dat_b_user,
  input  wire                        tl_dat_b_valid,
  output reg                         tl_dat_b_ready,

  // Interrupts
  input       ext_nmi,
  input       ext_tint,
  input       ext_sint,
  input [3:0] ext_int,

  // Debug Interface
  input                      dbg_stall,
  input                      dbg_strb,
  input                      dbg_we,
  input  [PLEN         -1:0] dbg_addr,
  input  [XLEN         -1:0] dbg_dati,
  output [XLEN         -1:0] dbg_dato,
  output                     dbg_ack,
  output                     dbg_bp
);

  //////////////////////////////////////////////////////////////////////////////
  // Body
  //////////////////////////////////////////////////////////////////////////////

  // Instantiate RISC-V PU
  pu_riscv_tl #(
    .XLEN     (XLEN),
    .PLEN     (PLEN),
    .PC_INIT  (PC_INIT),
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

    .BREAKPOINTS(BREAKPOINTS),  // Number of hardware breakpoints

    .PMA_CNT(PMA_CNT),
    .PMP_CNT(PMP_CNT),  // Number of Physical Memory Protection entries

    .BP_GLOBAL_BITS   (BP_GLOBAL_BITS),
    .BP_LOCAL_BITS    (BP_LOCAL_BITS),
    .BP_LOCAL_BITS_LSB(BP_LOCAL_BITS_LSB),

    .ICACHE_SIZE       (ICACHE_SIZE),         // in KBytes
    .ICACHE_BLOCK_SIZE (ICACHE_BLOCK_SIZE),   // in Bytes
    .ICACHE_WAYS       (ICACHE_WAYS),         // 'n'-way set associative
    .ICACHE_REPLACE_ALG(ICACHE_REPLACE_ALG),
    .ITCM_SIZE         (ITCM_SIZE),

    .DCACHE_SIZE       (DCACHE_SIZE),         // in KBytes
    .DCACHE_BLOCK_SIZE (DCACHE_BLOCK_SIZE),   // in Bytes
    .DCACHE_WAYS       (DCACHE_WAYS),         // 'n'-way set associative
    .DCACHE_REPLACE_ALG(DCACHE_REPLACE_ALG),
    .DTCM_SIZE         (DTCM_SIZE),
    .WRITEBUFFER_SIZE  (WRITEBUFFER_SIZE),

    .TECHNOLOGY(TECHNOLOGY),

    .MNMIVEC_DEFAULT(MNMIVEC_DEFAULT),
    .MTVEC_DEFAULT  (MTVEC_DEFAULT),
    .HTVEC_DEFAULT  (HTVEC_DEFAULT),
    .STVEC_DEFAULT  (STVEC_DEFAULT),
    .UTVEC_DEFAULT  (UTVEC_DEFAULT),

    .JEDEC_BANK           (JEDEC_BANK),
    .JEDEC_MANUFACTURER_ID(JEDEC_MANUFACTURER_ID),

    .HARTID(HARTID),

    .PARCEL_SIZE(PARCEL_SIZE)
  ) pu (
    .HRESETn(HRESETn),
    .HCLK   (HCLK),

    .pma_cfg_i(pma_cfg_i),
    .pma_adr_i(pma_adr_i),

    // AXI4 instruction
    .tl_ins_aw_id    (tl_ins_aw_id),
    .tl_ins_aw_addr  (tl_ins_aw_addr),
    .tl_ins_aw_len   (tl_ins_aw_len),
    .tl_ins_aw_size  (tl_ins_aw_size),
    .tl_ins_aw_burst (tl_ins_aw_burst),
    .tl_ins_aw_lock  (tl_ins_aw_lock),
    .tl_ins_aw_cache (tl_ins_aw_cache),
    .tl_ins_aw_prot  (tl_ins_aw_prot),
    .tl_ins_aw_qos   (tl_ins_aw_qos),
    .tl_ins_aw_region(tl_ins_aw_region),
    .tl_ins_aw_user  (tl_ins_aw_user),
    .tl_ins_aw_valid (tl_ins_aw_valid),
    .tl_ins_aw_ready (tl_ins_aw_ready),

    .tl_ins_ar_id    (tl_ins_ar_id),
    .tl_ins_ar_addr  (tl_ins_ar_addr),
    .tl_ins_ar_len   (tl_ins_ar_len),
    .tl_ins_ar_size  (tl_ins_ar_size),
    .tl_ins_ar_burst (tl_ins_ar_burst),
    .tl_ins_ar_lock  (tl_ins_ar_lock),
    .tl_ins_ar_cache (tl_ins_ar_cache),
    .tl_ins_ar_prot  (tl_ins_ar_prot),
    .tl_ins_ar_qos   (tl_ins_ar_qos),
    .tl_ins_ar_region(tl_ins_ar_region),
    .tl_ins_ar_user  (tl_ins_ar_user),
    .tl_ins_ar_valid (tl_ins_ar_valid),
    .tl_ins_ar_ready (tl_ins_ar_ready),

    .tl_ins_w_data (tl_ins_w_data),
    .tl_ins_w_strb (tl_ins_w_strb),
    .tl_ins_w_last (tl_ins_w_last),
    .tl_ins_w_user (tl_ins_w_user),
    .tl_ins_w_valid(tl_ins_w_valid),
    .tl_ins_w_ready(tl_ins_w_ready),

    .tl_ins_r_id   (tl_ins_r_id),
    .tl_ins_r_data (tl_ins_r_data),
    .tl_ins_r_resp (tl_ins_r_resp),
    .tl_ins_r_last (tl_ins_r_last),
    .tl_ins_r_user (tl_ins_r_user),
    .tl_ins_r_valid(tl_ins_r_valid),
    .tl_ins_r_ready(tl_ins_r_ready),

    .tl_ins_b_id   (tl_ins_b_id),
    .tl_ins_b_resp (tl_ins_b_resp),
    .tl_ins_b_user (tl_ins_b_user),
    .tl_ins_b_valid(tl_ins_b_valid),
    .tl_ins_b_ready(tl_ins_b_ready),

    // AXI4 data
    .tl_dat_aw_id    (tl_dat_aw_id),
    .tl_dat_aw_addr  (tl_dat_aw_addr),
    .tl_dat_aw_len   (tl_dat_aw_len),
    .tl_dat_aw_size  (tl_dat_aw_size),
    .tl_dat_aw_burst (tl_dat_aw_burst),
    .tl_dat_aw_lock  (tl_dat_aw_lock),
    .tl_dat_aw_cache (tl_dat_aw_cache),
    .tl_dat_aw_prot  (tl_dat_aw_prot),
    .tl_dat_aw_qos   (tl_dat_aw_qos),
    .tl_dat_aw_region(tl_dat_aw_region),
    .tl_dat_aw_user  (tl_dat_aw_user),
    .tl_dat_aw_valid (tl_dat_aw_valid),
    .tl_dat_aw_ready (tl_dat_aw_ready),

    .tl_dat_ar_id    (tl_dat_ar_id),
    .tl_dat_ar_addr  (tl_dat_ar_addr),
    .tl_dat_ar_len   (tl_dat_ar_len),
    .tl_dat_ar_size  (tl_dat_ar_size),
    .tl_dat_ar_burst (tl_dat_ar_burst),
    .tl_dat_ar_lock  (tl_dat_ar_lock),
    .tl_dat_ar_cache (tl_dat_ar_cache),
    .tl_dat_ar_prot  (tl_dat_ar_prot),
    .tl_dat_ar_qos   (tl_dat_ar_qos),
    .tl_dat_ar_region(tl_dat_ar_region),
    .tl_dat_ar_user  (tl_dat_ar_user),
    .tl_dat_ar_valid (tl_dat_ar_valid),
    .tl_dat_ar_ready (tl_dat_ar_ready),

    .tl_dat_w_data (tl_dat_w_data),
    .tl_dat_w_strb (tl_dat_w_strb),
    .tl_dat_w_last (tl_dat_w_last),
    .tl_dat_w_user (tl_dat_w_user),
    .tl_dat_w_valid(tl_dat_w_valid),
    .tl_dat_w_ready(tl_dat_w_ready),

    .tl_dat_r_id   (tl_dat_r_id),
    .tl_dat_r_data (tl_dat_r_data),
    .tl_dat_r_resp (tl_dat_r_resp),
    .tl_dat_r_last (tl_dat_r_last),
    .tl_dat_r_user (tl_dat_r_user),
    .tl_dat_r_valid(tl_dat_r_valid),
    .tl_dat_r_ready(tl_dat_r_ready),

    .tl_dat_b_id   (tl_dat_b_id),
    .tl_dat_b_resp (tl_dat_b_resp),
    .tl_dat_b_user (tl_dat_b_user),
    .tl_dat_b_valid(tl_dat_b_valid),
    .tl_dat_b_ready(tl_dat_b_ready),

    // Interrupts
    .ext_nmi (ext_nmi),
    .ext_tint(ext_tint),
    .ext_sint(ext_sint),
    .ext_int (ext_int),

    // Debug Interface
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
