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
//   Francisco Javier Reina Campo <pacoreinacampo@queenfield.tech>

module pu_riscv_module_ahb4 #(
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

  // AHB4 instruction
  output                     ins_HSEL,
  output [PLEN         -1:0] ins_HADDR,
  output [XLEN         -1:0] ins_HWDATA,
  input  [XLEN         -1:0] ins_HRDATA,
  output                     ins_HWRITE,
  output [              2:0] ins_HSIZE,
  output [              2:0] ins_HBURST,
  output [              3:0] ins_HPROT,
  output [              1:0] ins_HTRANS,
  output                     ins_HMASTLOCK,
  input                      ins_HREADY,
  input                      ins_HRESP,

  // AHB4 data
  output                     dat_HSEL,
  output [PLEN         -1:0] dat_HADDR,
  output [XLEN         -1:0] dat_HWDATA,
  input  [XLEN         -1:0] dat_HRDATA,
  output                     dat_HWRITE,
  output [              2:0] dat_HSIZE,
  output [              2:0] dat_HBURST,
  output [              3:0] dat_HPROT,
  output [              1:0] dat_HTRANS,
  output                     dat_HMASTLOCK,
  input                      dat_HREADY,
  input                      dat_HRESP,

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
  pu_riscv_ahb4 #(
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

    // AHB4 instruction
    .ins_HSEL     (ins_HSEL),
    .ins_HADDR    (ins_HADDR),
    .ins_HWDATA   (ins_HWDATA),
    .ins_HRDATA   (ins_HRDATA),
    .ins_HWRITE   (ins_HWRITE),
    .ins_HSIZE    (ins_HSIZE),
    .ins_HBURST   (ins_HBURST),
    .ins_HPROT    (ins_HPROT),
    .ins_HTRANS   (ins_HTRANS),
    .ins_HMASTLOCK(ins_HMASTLOCK),
    .ins_HREADY   (ins_HREADY),
    .ins_HRESP    (ins_HRESP),

    // AHB4 data
    .dat_HSEL     (dat_HSEL),
    .dat_HADDR    (dat_HADDR),
    .dat_HWDATA   (dat_HWDATA),
    .dat_HRDATA   (dat_HRDATA),
    .dat_HWRITE   (dat_HWRITE),
    .dat_HSIZE    (dat_HSIZE),
    .dat_HBURST   (dat_HBURST),
    .dat_HPROT    (dat_HPROT),
    .dat_HTRANS   (dat_HTRANS),
    .dat_HMASTLOCK(dat_HMASTLOCK),
    .dat_HREADY   (dat_HREADY),
    .dat_HRESP    (dat_HRESP),

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
