////////////////////////////////////////////////////////////////////////////////
//                                           __ _      _     _                //
//                                          / _(_)    | |   | |               //
//               __ _ _   _  ___  ___ _ __ | |_ _  ___| | __| |               //
//              / _` | | | |/ _ \/ _ \ '_ \|  _| |/ _ \ |/ _` |               //
//             | (_| | |_| |  __/  __/ | | | | | |  __/ | (_| |               //
//              \__, |\__,_|\___|\___|_| |_|_| |_|\___|_|\__,_|               //
//                 | |                                                        //
//                 |_|                                                        //
//                                                                            //
//                                                                            //
//             MPSoC-RISCV CPU                                                //
//             TestBench                                                      //
//             AMBA3 AHB-Lite Bus Interface                                   //
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

`include "riscv_defines.sv"

module pu_riscv_testbench_axi4;

  // core parameters
  parameter XLEN = 64;
  parameter PLEN = 64;  // 64bit address bus
  parameter PC_INIT = 'h8000_0000;  // Start here after reset
  parameter BASE = PC_INIT;  // offset where to load program in memory
  parameter INIT_FILE = "test.hex";
  parameter MEM_LATENCY = 1;
  parameter WRITEBUFFER_SIZE = 4;
  parameter HAS_U = 1;
  parameter HAS_S = 1;
  parameter HAS_H = 1;
  parameter HAS_MMU = 1;
  parameter HAS_FPU = 1;
  parameter HAS_RVA = 1;
  parameter HAS_RVM = 1;
  parameter MULT_LATENCY = 1;
  parameter CORES = 1;

  parameter HTIF = 0;  // Host-interface
  parameter TOHOST = 32'h80001000;
  parameter UART_TX = 32'h80001080;

  // caches
  parameter ICACHE_SIZE = 64;
  parameter DCACHE_SIZE = 64;

  parameter PMA_CNT = 4;

  // MPSoC
  parameter X = 1;
  parameter Y = 1;
  parameter Z = 1;

  parameter NODES = X * Y * Z;

  ////////////////////////////////////////////////////////////////////////////////
  // Constants
  //////////////////////////////////////////////////////////////////////////////

  localparam MULLAT = MULT_LATENCY > 4 ? 4 : MULT_LATENCY;

  localparam AXI_ID_WIDTH = 10;
  localparam AXI_ADDR_WIDTH = 64;
  localparam AXI_DATA_WIDTH = 64;
  localparam AXI_STRB_WIDTH = 10;
  localparam AXI_USER_WIDTH = 10;

  localparam AHB_ADDR_WIDTH = 64;
  localparam AHB_DATA_WIDTH = 64;

  ////////////////////////////////////////////////////////////////////////////////
  // Variables
  //////////////////////////////////////////////////////////////////////////////

  genvar p;

  logic                                              HCLK;
  logic                                              HRESETn;

  // PMA configuration
  logic [         PMA_CNT-1:0][                13:0] pma_cfg;
  logic [         PMA_CNT-1:0][            PLEN-1:0] pma_adr;

  // Instruction interface
  logic [AXI_ID_WIDTH    -1:0]                       axi4_ins_aw_id;
  logic [AXI_ADDR_WIDTH  -1:0]                       axi4_ins_aw_addr;
  logic [                 7:0]                       axi4_ins_aw_len;
  logic [                 2:0]                       axi4_ins_aw_size;
  logic [                 1:0]                       axi4_ins_aw_burst;
  logic                                              axi4_ins_aw_lock;
  logic [                 3:0]                       axi4_ins_aw_cache;
  logic [                 2:0]                       axi4_ins_aw_prot;
  logic [                 3:0]                       axi4_ins_aw_qos;
  logic [                 3:0]                       axi4_ins_aw_region;
  logic [AXI_USER_WIDTH  -1:0]                       axi4_ins_aw_user;
  logic                                              axi4_ins_aw_valid;
  logic                                              axi4_ins_aw_ready;

  logic [AXI_ID_WIDTH    -1:0]                       axi4_ins_ar_id;
  logic [AXI_ADDR_WIDTH  -1:0]                       axi4_ins_ar_addr;
  logic [                 7:0]                       axi4_ins_ar_len;
  logic [                 2:0]                       axi4_ins_ar_size;
  logic [                 1:0]                       axi4_ins_ar_burst;
  logic                                              axi4_ins_ar_lock;
  logic [                 3:0]                       axi4_ins_ar_cache;
  logic [                 2:0]                       axi4_ins_ar_prot;
  logic [                 3:0]                       axi4_ins_ar_qos;
  logic [                 3:0]                       axi4_ins_ar_region;
  logic [AXI_USER_WIDTH  -1:0]                       axi4_ins_ar_user;
  logic                                              axi4_ins_ar_valid;
  logic                                              axi4_ins_ar_ready;

  logic [AXI_DATA_WIDTH  -1:0]                       axi4_ins_w_data;
  logic [AXI_STRB_WIDTH  -1:0]                       axi4_ins_w_strb;
  logic                                              axi4_ins_w_last;
  logic [AXI_USER_WIDTH  -1:0]                       axi4_ins_w_user;
  logic                                              axi4_ins_w_valid;
  logic                                              axi4_ins_w_ready;

  logic [AXI_ID_WIDTH    -1:0]                       axi4_ins_r_id;
  logic [AXI_DATA_WIDTH  -1:0]                       axi4_ins_r_data;
  logic [                 1:0]                       axi4_ins_r_resp;
  logic                                              axi4_ins_r_last;
  logic [AXI_USER_WIDTH  -1:0]                       axi4_ins_r_user;
  logic                                              axi4_ins_r_valid;
  logic                                              axi4_ins_r_ready;

  logic [AXI_ID_WIDTH    -1:0]                       axi4_ins_b_id;
  logic [                 1:0]                       axi4_ins_b_resp;
  logic [AXI_USER_WIDTH  -1:0]                       axi4_ins_b_user;
  logic                                              axi4_ins_b_valid;
  logic                                              axi4_ins_b_ready;

  // Data interface
  logic [AXI_ID_WIDTH    -1:0]                       axi4_dat_aw_id;
  logic [AXI_ADDR_WIDTH  -1:0]                       axi4_dat_aw_addr;
  logic [                 7:0]                       axi4_dat_aw_len;
  logic [                 2:0]                       axi4_dat_aw_size;
  logic [                 1:0]                       axi4_dat_aw_burst;
  logic                                              axi4_dat_aw_lock;
  logic [                 3:0]                       axi4_dat_aw_cache;
  logic [                 2:0]                       axi4_dat_aw_prot;
  logic [                 3:0]                       axi4_dat_aw_qos;
  logic [                 3:0]                       axi4_dat_aw_region;
  logic [AXI_USER_WIDTH  -1:0]                       axi4_dat_aw_user;
  logic                                              axi4_dat_aw_valid;
  logic                                              axi4_dat_aw_ready;

  logic [AXI_ID_WIDTH    -1:0]                       axi4_dat_ar_id;
  logic [AXI_ADDR_WIDTH  -1:0]                       axi4_dat_ar_addr;
  logic [                 7:0]                       axi4_dat_ar_len;
  logic [                 2:0]                       axi4_dat_ar_size;
  logic [                 1:0]                       axi4_dat_ar_burst;
  logic                                              axi4_dat_ar_lock;
  logic [                 3:0]                       axi4_dat_ar_cache;
  logic [                 2:0]                       axi4_dat_ar_prot;
  logic [                 3:0]                       axi4_dat_ar_qos;
  logic [                 3:0]                       axi4_dat_ar_region;
  logic [AXI_USER_WIDTH  -1:0]                       axi4_dat_ar_user;
  logic                                              axi4_dat_ar_valid;
  logic                                              axi4_dat_ar_ready;

  logic [AXI_DATA_WIDTH  -1:0]                       axi4_dat_w_data;
  logic [AXI_STRB_WIDTH  -1:0]                       axi4_dat_w_strb;
  logic                                              axi4_dat_w_last;
  logic [AXI_USER_WIDTH  -1:0]                       axi4_dat_w_user;
  logic                                              axi4_dat_w_valid;
  logic                                              axi4_dat_w_ready;

  logic [AXI_ID_WIDTH    -1:0]                       axi4_dat_r_id;
  logic [AXI_DATA_WIDTH  -1:0]                       axi4_dat_r_data;
  logic [                 1:0]                       axi4_dat_r_resp;
  logic                                              axi4_dat_r_last;
  logic [AXI_USER_WIDTH  -1:0]                       axi4_dat_r_user;
  logic                                              axi4_dat_r_valid;
  logic                                              axi4_dat_r_ready;

  logic [AXI_ID_WIDTH    -1:0]                       axi4_dat_b_id;
  logic [                 1:0]                       axi4_dat_b_resp;
  logic [AXI_USER_WIDTH  -1:0]                       axi4_dat_b_user;
  logic                                              axi4_dat_b_valid;
  logic                                              axi4_dat_b_ready;

  // Debug Interface
  logic                                              dbp_bp;
  logic                                              dbg_stall;
  logic                                              dbg_strb;
  logic                                              dbg_ack;
  logic                                              dbg_we;
  logic [            PLEN-1:0]                       dbg_addr;
  logic [            XLEN-1:0]                       dbg_dati;
  logic [            XLEN-1:0]                       dbg_dato;

  // Host Interface
  logic                                              host_csr_req;
  logic                                              host_csr_ack;
  logic                                              host_csr_we;
  logic [            XLEN-1:0]                       host_csr_tohost;
  logic [            XLEN-1:0]                       host_csr_fromhost;

  // Unified memory interface
  logic [                 1:0][AXI_ID_WIDTH    -1:0] mem_aw_id;
  logic [                 1:0][AXI_ADDR_WIDTH  -1:0] mem_aw_addr;
  logic [                 1:0][                 7:0] mem_aw_len;
  logic [                 1:0][                 2:0] mem_aw_size;
  logic [                 1:0][                 1:0] mem_aw_burst;
  logic [                 1:0]                       mem_aw_lock;
  logic [                 1:0][                 3:0] mem_aw_cache;
  logic [                 1:0][                 2:0] mem_aw_prot;
  logic [                 1:0][                 3:0] mem_aw_qos;
  logic [                 1:0][                 3:0] mem_aw_region;
  logic [                 1:0][AXI_USER_WIDTH  -1:0] mem_aw_user;
  logic [                 1:0]                       mem_aw_valid;
  logic [                 1:0]                       mem_aw_ready;

  logic [                 1:0][AXI_ID_WIDTH    -1:0] mem_ar_id;
  logic [                 1:0][AXI_ADDR_WIDTH  -1:0] mem_ar_addr;
  logic [                 1:0][                 7:0] mem_ar_len;
  logic [                 1:0][                 2:0] mem_ar_size;
  logic [                 1:0][                 1:0] mem_ar_burst;
  logic [                 1:0]                       mem_ar_lock;
  logic [                 1:0][                 3:0] mem_ar_cache;
  logic [                 1:0][                 2:0] mem_ar_prot;
  logic [                 1:0][                 3:0] mem_ar_qos;
  logic [                 1:0][                 3:0] mem_ar_region;
  logic [                 1:0][AXI_USER_WIDTH  -1:0] mem_ar_user;
  logic [                 1:0]                       mem_ar_valid;
  logic [                 1:0]                       mem_ar_ready;

  logic [                 1:0][AXI_DATA_WIDTH  -1:0] mem_w_data;
  logic [                 1:0][AXI_STRB_WIDTH  -1:0] mem_w_strb;
  logic [                 1:0]                       mem_w_last;
  logic [                 1:0][AXI_USER_WIDTH  -1:0] mem_w_user;
  logic [                 1:0]                       mem_w_valid;
  logic [                 1:0]                       mem_w_ready;

  logic [                 1:0][AXI_ID_WIDTH    -1:0] mem_r_id;
  logic [                 1:0][AXI_DATA_WIDTH  -1:0] mem_r_data;
  logic [                 1:0][                 1:0] mem_r_resp;
  logic [                 1:0]                       mem_r_last;
  logic [                 1:0][AXI_USER_WIDTH  -1:0] mem_r_user;
  logic [                 1:0]                       mem_r_valid;
  logic [                 1:0]                       mem_r_ready;

  logic [                 1:0][AXI_ID_WIDTH    -1:0] mem_b_id;
  logic [                 1:0][                 1:0] mem_b_resp;
  logic [                 1:0][AXI_USER_WIDTH  -1:0] mem_b_user;
  logic [                 1:0]                       mem_b_valid;
  logic [                 1:0]                       mem_b_ready;

  //////////////////////////////////////////////////////////////////////////////
  // Module Body
  //////////////////////////////////////////////////////////////////////////////

  // Define PMA regions

  // crt.0 (ROM) region
  assign pma_adr[0] = TOHOST >> 2;
  assign pma_cfg[0] = {`MEM_TYPE_MAIN, 8'b1111_1000, `AMO_TYPE_NONE, `TOR};

  // TOHOST region
  assign pma_adr[1] = ((TOHOST >> 2) & ~'hf) | 'h7;
  assign pma_cfg[1] = {`MEM_TYPE_IO, 8'b0100_0000, `AMO_TYPE_NONE, `NAPOT};

  // UART-Tx region
  assign pma_adr[2] = UART_TX >> 2;
  assign pma_cfg[2] = {`MEM_TYPE_IO, 8'b0100_0000, `AMO_TYPE_NONE, `NA4};

  // RAM region
  assign pma_adr[3] = 1 << 31;
  assign pma_cfg[3] = {`MEM_TYPE_MAIN, 8'b1111_0000, `AMO_TYPE_NONE, `TOR};

  // Hookup Device Under Test
  pu_riscv_axi4 #(
    .AXI_ID_WIDTH  (10),
    .AXI_ADDR_WIDTH(PLEN),
    .AXI_DATA_WIDTH(XLEN),
    .AXI_STRB_WIDTH(10),
    .AXI_USER_WIDTH(10),

    .AHB_ADDR_WIDTH(PLEN),
    .AHB_DATA_WIDTH(XLEN),

    .XLEN        (XLEN),
    .PLEN        (PLEN),
    .PC_INIT     (PC_INIT),
    .HAS_USER    (HAS_U),
    .HAS_SUPER   (HAS_S),
    .HAS_HYPER   (HAS_H),
    .HAS_RVA     (HAS_RVA),
    .HAS_RVM     (HAS_RVM),
    .MULT_LATENCY(MULLAT),

    .PMA_CNT         (PMA_CNT),
    .ICACHE_SIZE     (ICACHE_SIZE),
    .ICACHE_WAYS     (1),
    .DCACHE_SIZE     (DCACHE_SIZE),
    .DTCM_SIZE       (0),
    .WRITEBUFFER_SIZE(WRITEBUFFER_SIZE),

    .MTVEC_DEFAULT(32'h80000004)
  ) dut (
    .HRESETn(HRESETn),
    .HCLK   (HCLK),

    .pma_cfg_i(pma_cfg),
    .pma_adr_i(pma_adr),

    .ext_nmi (1'b0),
    .ext_tint(1'b0),
    .ext_sint(1'b0),
    .ext_int (4'h0),

    .*
  );

  // Hookup Debug Unit
  pu_riscv_dbg_bfm #(
    .XLEN(XLEN),
    .PLEN(PLEN)
  ) dbg_ctrl (
    .rstn(HRESETn),
    .clk (HCLK),

    .cpu_bp_i   (dbg_bp),
    .cpu_stall_o(dbg_stall),
    .cpu_stb_o  (dbg_strb),
    .cpu_we_o   (dbg_we),
    .cpu_adr_o  (dbg_addr),
    .cpu_dat_o  (dbg_dati),
    .cpu_dat_i  (dbg_dato),
    .cpu_ack_i  (dbg_ack)
  );

  // bus <-> memory model connections

  // Instruction interface
  assign mem_aw_id[0]      = axi4_ins_aw_id;
  assign mem_aw_addr[0]    = axi4_ins_aw_addr;
  assign mem_aw_len[0]     = axi4_ins_aw_len;
  assign mem_aw_size[0]    = axi4_ins_aw_size;
  assign mem_aw_burst[0]   = axi4_ins_aw_burst;
  assign mem_aw_lock[0]    = axi4_ins_aw_lock;
  assign mem_aw_cache[0]   = axi4_ins_aw_cache;
  assign mem_aw_prot[0]    = axi4_ins_aw_prot;
  assign mem_aw_qos[0]     = axi4_ins_aw_qos;
  assign mem_aw_region[0]  = axi4_ins_aw_region;
  assign mem_aw_user[0]    = axi4_ins_aw_user;
  assign mem_aw_valid[0]   = axi4_ins_aw_valid;

  assign axi4_ins_aw_ready = mem_aw_ready[0];

  assign mem_ar_id[0]      = axi4_ins_ar_id;
  assign mem_ar_addr[0]    = axi4_ins_ar_addr;
  assign mem_ar_len[0]     = axi4_ins_ar_len;
  assign mem_ar_size[0]    = axi4_ins_ar_size;
  assign mem_ar_burst[0]   = axi4_ins_ar_burst;
  assign mem_ar_lock[0]    = axi4_ins_ar_lock;
  assign mem_ar_cache[0]   = axi4_ins_ar_cache;
  assign mem_ar_prot[0]    = axi4_ins_ar_prot;
  assign mem_ar_qos[0]     = axi4_ins_ar_qos;
  assign mem_ar_region[0]  = axi4_ins_ar_region;
  assign mem_ar_user[0]    = axi4_ins_ar_user;
  assign mem_ar_valid[0]   = axi4_ins_ar_valid;

  assign axi4_ins_ar_ready = mem_ar_ready[0];

  assign mem_w_data[0]     = axi4_ins_w_data;
  assign mem_w_strb[0]     = axi4_ins_w_strb;
  assign mem_w_last[0]     = axi4_ins_w_last;
  assign mem_w_user[0]     = axi4_ins_w_user;
  assign mem_w_valid[0]    = axi4_ins_w_valid;

  assign axi4_ins_w_ready  = mem_w_ready[0];

  assign axi4_ins_r_id     = mem_r_id[0];
  assign axi4_ins_r_data   = mem_r_data[0];
  assign axi4_ins_r_resp   = mem_r_resp[0];
  assign axi4_ins_r_last   = mem_r_last[0];
  assign axi4_ins_r_user   = mem_r_user[0];
  assign axi4_ins_r_valid  = mem_r_valid[0];

  assign mem_r_ready[0]    = axi4_ins_r_ready;

  assign axi4_ins_b_id     = mem_b_id[0];
  assign axi4_ins_b_resp   = mem_b_resp[0];
  assign axi4_ins_b_user   = mem_b_user[0];
  assign axi4_ins_b_valid  = mem_b_valid[0];

  assign mem_b_ready[0]    = axi4_ins_b_ready;

  // Data interface
  assign mem_aw_id[1]      = axi4_dat_aw_id;
  assign mem_aw_addr[1]    = axi4_dat_aw_addr;
  assign mem_aw_len[1]     = axi4_dat_aw_len;
  assign mem_aw_size[1]    = axi4_dat_aw_size;
  assign mem_aw_burst[1]   = axi4_dat_aw_burst;
  assign mem_aw_lock[1]    = axi4_dat_aw_lock;
  assign mem_aw_cache[1]   = axi4_dat_aw_cache;
  assign mem_aw_prot[1]    = axi4_dat_aw_prot;
  assign mem_aw_qos[1]     = axi4_dat_aw_qos;
  assign mem_aw_region[1]  = axi4_dat_aw_region;
  assign mem_aw_user[1]    = axi4_dat_aw_user;
  assign mem_aw_valid[1]   = axi4_dat_aw_valid;

  assign axi4_dat_aw_ready = mem_aw_ready[1];

  assign mem_ar_id[1]      = axi4_dat_ar_id;
  assign mem_ar_addr[1]    = axi4_dat_ar_addr;
  assign mem_ar_len[1]     = axi4_dat_ar_len;
  assign mem_ar_size[1]    = axi4_dat_ar_size;
  assign mem_ar_burst[1]   = axi4_dat_ar_burst;
  assign mem_ar_lock[1]    = axi4_dat_ar_lock;
  assign mem_ar_cache[1]   = axi4_dat_ar_cache;
  assign mem_ar_prot[1]    = axi4_dat_ar_prot;
  assign mem_ar_qos[1]     = axi4_dat_ar_qos;
  assign mem_ar_region[1]  = axi4_dat_ar_region;
  assign mem_ar_user[1]    = axi4_dat_ar_user;
  assign mem_ar_valid[1]   = axi4_dat_ar_valid;

  assign axi4_dat_ar_ready = mem_ar_ready[1];

  assign mem_w_data[1]     = axi4_dat_w_data;
  assign mem_w_strb[1]     = axi4_dat_w_strb;
  assign mem_w_last[1]     = axi4_dat_w_last;
  assign mem_w_user[1]     = axi4_dat_w_user;
  assign mem_w_valid[1]    = axi4_dat_w_valid;

  assign axi4_dat_w_ready  = mem_w_ready[1];

  assign axi4_dat_r_id     = mem_r_id[1];
  assign axi4_dat_r_data   = mem_r_data[1];
  assign axi4_dat_r_resp   = mem_r_resp[1];
  assign axi4_dat_r_last   = mem_r_last[1];
  assign axi4_dat_r_user   = mem_r_user[1];
  assign axi4_dat_r_valid  = mem_r_valid[1];

  assign mem_r_ready[1]    = axi4_dat_r_ready;

  assign axi4_dat_b_id     = mem_b_id[1];
  assign axi4_dat_b_resp   = mem_b_resp[1];
  assign axi4_dat_b_user   = mem_b_user[1];
  assign axi4_dat_b_valid  = mem_b_valid[1];

  assign mem_b_ready[1]    = axi4_dat_b_ready;

  // hookup memory model
  pu_riscv_memory_model_axi4 #(
    .INIT_FILE(INIT_FILE)
  ) memory_model (
    .HRESETn(HRESETn),
    .HCLK   (HCLK),

    .axi4_aw_id    (mem_aw_id),
    .axi4_aw_addr  (mem_aw_addr),
    .axi4_aw_len   (mem_aw_len),
    .axi4_aw_size  (mem_aw_size),
    .axi4_aw_burst (mem_aw_burst),
    .axi4_aw_lock  (mem_aw_lock),
    .axi4_aw_cache (mem_aw_cache),
    .axi4_aw_prot  (mem_aw_prot),
    .axi4_aw_qos   (mem_aw_qos),
    .axi4_aw_region(mem_aw_region),
    .axi4_aw_user  (mem_aw_user),
    .axi4_aw_valid (mem_aw_valid),
    .axi4_aw_ready (mem_aw_ready),

    .axi4_ar_id    (mem_ar_id),
    .axi4_ar_addr  (mem_ar_addr),
    .axi4_ar_len   (mem_ar_len),
    .axi4_ar_size  (mem_ar_size),
    .axi4_ar_burst (mem_ar_burst),
    .axi4_ar_lock  (mem_ar_lock),
    .axi4_ar_cache (mem_ar_cache),
    .axi4_ar_prot  (mem_ar_prot),
    .axi4_ar_qos   (mem_ar_qos),
    .axi4_ar_region(mem_ar_region),
    .axi4_ar_user  (mem_ar_user),
    .axi4_ar_valid (mem_ar_valid),
    .axi4_ar_ready (mem_ar_ready),

    .axi4_w_data (mem_w_data),
    .axi4_w_strb (mem_w_strb),
    .axi4_w_last (mem_w_last),
    .axi4_w_user (mem_w_user),
    .axi4_w_valid(mem_w_valid),
    .axi4_w_ready(mem_w_ready),

    .axi4_r_id   (mem_r_id),
    .axi4_r_data (mem_r_data),
    .axi4_r_resp (mem_r_resp),
    .axi4_r_last (mem_r_last),
    .axi4_r_user (mem_r_user),
    .axi4_r_valid(mem_r_valid),
    .axi4_r_ready(mem_r_ready),

    .axi4_b_id   (mem_b_id),
    .axi4_b_resp (mem_b_resp),
    .axi4_b_user (mem_b_user),
    .axi4_b_valid(mem_b_valid),
    .axi4_b_ready(mem_b_ready)
  );

  // Front-End Server
  generate
    if (HTIF) begin
      // Old HTIF interface
      pu_riscv_htif #(XLEN) htif_frontend (
        .rstn             (HRESETn),
        .clk              (HCLK),
        .host_csr_req     (host_csr_req),
        .host_csr_ack     (host_csr_ack),
        .host_csr_we      (host_csr_we),
        .host_csr_tohost  (host_csr_tohost),
        .host_csr_fromhost(host_csr_fromhost)
      );
    end else begin
      // New MMIO interface
      pu_riscv_mmio_if_axi4 #(
        .AXI_ID_WIDTH  (10),
        .AXI_ADDR_WIDTH(PLEN),
        .AXI_DATA_WIDTH(XLEN),
        .AXI_STRB_WIDTH(10),
        .AXI_USER_WIDTH(10),

        .AHB_ADDR_WIDTH(PLEN),
        .AHB_DATA_WIDTH(XLEN),

        .CATCH_TEST   (TOHOST),
        .CATCH_UART_TX(UART_TX)
      ) mmio_if (
        .HRESETn(HRESETn),
        .HCLK   (HCLK),

        .axi4_aw_id    (axi4_dat_aw_id),
        .axi4_aw_addr  (axi4_dat_aw_addr),
        .axi4_aw_len   (axi4_dat_aw_len),
        .axi4_aw_size  (axi4_dat_aw_size),
        .axi4_aw_burst (axi4_dat_aw_burst),
        .axi4_aw_lock  (axi4_dat_aw_lock),
        .axi4_aw_cache (axi4_dat_aw_cache),
        .axi4_aw_prot  (axi4_dat_aw_prot),
        .axi4_aw_qos   (axi4_dat_aw_qos),
        .axi4_aw_region(axi4_dat_aw_region),
        .axi4_aw_user  (axi4_dat_aw_user),
        .axi4_aw_valid (axi4_dat_aw_valid),
        .axi4_aw_ready (),

        .axi4_ar_id    (axi4_dat_ar_id),
        .axi4_ar_addr  (axi4_dat_ar_addr),
        .axi4_ar_len   (axi4_dat_ar_len),
        .axi4_ar_size  (axi4_dat_ar_size),
        .axi4_ar_burst (axi4_dat_ar_burst),
        .axi4_ar_lock  (axi4_dat_ar_lock),
        .axi4_ar_cache (axi4_dat_ar_cache),
        .axi4_ar_prot  (axi4_dat_ar_prot),
        .axi4_ar_qos   (axi4_dat_ar_qos),
        .axi4_ar_region(axi4_dat_ar_region),
        .axi4_ar_user  (axi4_dat_ar_user),
        .axi4_ar_valid (axi4_dat_ar_valid),
        .axi4_ar_ready (),

        .axi4_w_data (axi4_dat_w_data),
        .axi4_w_strb (axi4_dat_w_strb),
        .axi4_w_last (axi4_dat_w_last),
        .axi4_w_user (axi4_dat_w_user),
        .axi4_w_valid(axi4_dat_w_valid),
        .axi4_w_ready(),

        .axi4_r_id   (),
        .axi4_r_data (),
        .axi4_r_resp (),
        .axi4_r_last (),
        .axi4_r_user (),
        .axi4_r_valid(),
        .axi4_r_ready(axi4_dat_r_ready),

        .axi4_b_id   (),
        .axi4_b_resp (),
        .axi4_b_user (),
        .axi4_b_valid(),
        .axi4_b_ready(axi4_dat_b_ready)
      );
    end
  endgenerate

  // Generate clock
  always #1 HCLK = ~HCLK;

  initial begin
    $display("\n");
    $display("                                                                                                         ");
    $display("                                                                                                         ");
    $display("                                                              ***                     ***          **    ");
    $display("                                                            ** ***    *                ***          **   ");
    $display("                                                           **   ***  ***                **          **   ");
    $display("                                                           **         *                 **          **   ");
    $display("    ****    **   ****                                      **                           **          **   ");
    $display("   * ***  *  **    ***  *    ***       ***    ***  ****    ******   ***        ***      **      *** **   ");
    $display("  *   ****   **     ****    * ***     * ***    **** **** * *****     ***      * ***     **     ********* ");
    $display(" **    **    **      **    *   ***   *   ***    **   ****  **         **     *   ***    **    **   ****  ");
    $display(" **    **    **      **   **    *** **    ***   **    **   **         **    **    ***   **    **    **   ");
    $display(" **    **    **      **   ********  ********    **    **   **         **    ********    **    **    **   ");
    $display(" **    **    **      **   *******   *******     **    **   **         **    *******     **    **    **   ");
    $display(" **    **    **      **   **        **          **    **   **         **    **          **    **    **   ");
    $display("  *******     ******* **  ****    * ****    *   **    **   **         **    ****    *   **    **    **   ");
    $display("   ******      *****   **  *******   *******    ***   ***  **         *** *  *******    *** *  *****     ");
    $display("       **                   *****     *****      ***   ***  **         ***    *****      ***    ***      ");
    $display("       **                                                                                                ");
    $display("       **                                                                                                ");
    $display("        **                                                                                               ");
    $display("- RISC-V Regression TestBench ---------------------------------------------------------------------------");
    $display("  XLEN | PRIV | MMU | FPU | RVA | RVM | MULLAT");
    $display("  %4d | M%C%C%C | %3d | %3d | %3d | %3d | %6d", XLEN, HAS_H > 0 ? "H" : " ", HAS_S > 0 ? "S" : " ", HAS_U > 0 ? "U" : " ", HAS_MMU, HAS_FPU, HAS_RVA, HAS_RVM, MULLAT);
    $display("------------------------------------------------------------------------------");
    $display("  CORES | NODES | X | Y | Z | CORES_PER_TILE | CORES_PER_MISD | CORES_PER_SIMD");
    $display("    1   | %5d | %1d | %1d | %1d |       --       |       --       |       --       ", NODES, X, Y, Z);
    $display("------------------------------------------------------------------------------");
    $display("  Test   = %s", INIT_FILE);
    $display("  ICache = %0dkB", ICACHE_SIZE);
    $display("  DCache = %0dkB", DCACHE_SIZE);
    $display("------------------------------------------------------------------------------");
  end

  initial begin

`ifdef WAVES
    $shm_open("waves");
    $shm_probe("AS", riscv_testbench, "AS");
    $display("INFO: Signal dump enabled ...\n");
`endif

    // memory_model.read_elf2hex;
    memory_model.read_ihex;
    // memory_model.dump;

    HCLK    = 'b0;

    HRESETn = 'b1;
    repeat (5) @(negedge HCLK);
    HRESETn = 'b0;
    repeat (5) @(negedge HCLK);
    HRESETn = 'b1;

    #112;
    // stall CPU
    dbg_ctrl.stall;

    // Enable BREAKPOINT to call external debugger
    // dbg_ctrl.write('h0004,'h0008);

    // Enable Single Stepping
    dbg_ctrl.write('h0000, 'h0001);

    // single step through 10 instructions
    repeat (100) begin
      while (!dbg_ctrl.stall_cpu) @(posedge HCLK);
      repeat (15) @(posedge HCLK);
      dbg_ctrl.write('h0001, 'h0000);  // clear single-step-hit
      dbg_ctrl.unstall;
    end

    // last time ...
    @(posedge HCLK);
    while (!dbg_ctrl.stall_cpu) @(posedge HCLK);
    // disable Single Stepping
    dbg_ctrl.write('h0000, 'h0000);
    dbg_ctrl.write('h0001, 'h0000);
    dbg_ctrl.unstall;
  end
endmodule
