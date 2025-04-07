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
//              PU-RISCV                                                      //
//              Synthesis                                                     //
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
//   Paco Reina Campo <pacoreinacampo@queenfield.tech>

`include "riscv_defines.sv"

module pu_riscv_synthesis #(
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

  parameter            BREAKPOINTS        = 8,  // Number of hardware breakpoints

  parameter            PMA_CNT            = 4,
  parameter            PMP_CNT            = 16, // Number of Physical Memory Protection entries

  parameter            BP_GLOBAL_BITS     = 2,
  parameter            BP_LOCAL_BITS      = 10,
  parameter            BP_LOCAL_BITS_LSB  = 2,

  parameter            ICACHE_SIZE        = 64,  // in KBytes
  parameter            ICACHE_BLOCK_SIZE  = 64,  // in Bytes
  parameter            ICACHE_WAYS        = 2,   //'n'-way set associative
  parameter            ICACHE_REPLACE_ALG = 0,
  parameter            ITCM_SIZE          = 0,

  parameter            DCACHE_SIZE        = 64,  // in KBytes
  parameter            DCACHE_BLOCK_SIZE  = 64,  // in Bytes
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

    // Interrupts
    input                               ext_nmi,
    input                               ext_tint,
    input                               ext_sint,
    input                    [     3:0] ext_int,

    // Debug Interface
    input                               dbg_stall,
    input                               dbg_strb,
    input                               dbg_we,
    input                    [PLEN-1:0] dbg_addr,
    input                    [XLEN-1:0] dbg_dati,
    output                   [XLEN-1:0] dbg_dato,
    output                              dbg_ack,
    output                              dbg_bp
  );
  
  //////////////////////////////////////////////////////////////////////////////
  // Variables
  //////////////////////////////////////////////////////////////////////////////

  parameter HTIF             = 0;  // Host-Interface
  parameter TOHOST           = 32'h80001000;
  parameter UART_TX          = 32'h80001080;

  localparam AXI_ID_WIDTH   = 10;
  localparam AXI_ADDR_WIDTH = 64;
  localparam AXI_DATA_WIDTH = 64;
  localparam AXI_STRB_WIDTH = 8;
  localparam AXI_USER_WIDTH = 10;
  
  //////////////////////////////////////////////////////////////////////////////
  // Variables
  //////////////////////////////////////////////////////////////////////////////

  // PMA configuration
  logic [PMA_CNT-1:0][    13:0] pma_cfg;
  logic [PMA_CNT-1:0][PLEN-1:0] pma_adr;

  // AXI4 Instruction
  logic [AXI_ID_WIDTH    -1:0] axi4_ins_aw_id;
  logic [AXI_ADDR_WIDTH  -1:0] axi4_ins_aw_addr;
  logic [                 7:0] axi4_ins_aw_len;
  logic [                 2:0] axi4_ins_aw_size;
  logic [                 1:0] axi4_ins_aw_burst;
  logic                        axi4_ins_aw_lock;
  logic [                 3:0] axi4_ins_aw_cache;
  logic [                 2:0] axi4_ins_aw_prot;
  logic [                 3:0] axi4_ins_aw_qos;
  logic [                 3:0] axi4_ins_aw_region;
  logic [AXI_USER_WIDTH  -1:0] axi4_ins_aw_user;
  logic                        axi4_ins_aw_valid;
  logic                        axi4_ins_aw_ready;

  logic [AXI_ID_WIDTH    -1:0] axi4_ins_ar_id;
  logic [AXI_ADDR_WIDTH  -1:0] axi4_ins_ar_addr;
  logic [                 7:0] axi4_ins_ar_len;
  logic [                 2:0] axi4_ins_ar_size;
  logic [                 1:0] axi4_ins_ar_burst;
  logic                        axi4_ins_ar_lock;
  logic [                 3:0] axi4_ins_ar_cache;
  logic [                 2:0] axi4_ins_ar_prot;
  logic [                 3:0] axi4_ins_ar_qos;
  logic [                 3:0] axi4_ins_ar_region;
  logic [AXI_USER_WIDTH  -1:0] axi4_ins_ar_user;
  logic                        axi4_ins_ar_valid;
  logic                        axi4_ins_ar_ready;

  logic [AXI_DATA_WIDTH  -1:0] axi4_ins_w_data;
  logic [AXI_STRB_WIDTH  -1:0] axi4_ins_w_strb;
  logic                        axi4_ins_w_last;
  logic [AXI_USER_WIDTH  -1:0] axi4_ins_w_user;
  logic                        axi4_ins_w_valid;
  logic                        axi4_ins_w_ready;

  logic [AXI_ID_WIDTH    -1:0] axi4_ins_r_id;
  logic [AXI_DATA_WIDTH  -1:0] axi4_ins_r_data;
  logic [                 1:0] axi4_ins_r_resp;
  logic                        axi4_ins_r_last;
  logic [AXI_USER_WIDTH  -1:0] axi4_ins_r_user;
  logic                        axi4_ins_r_valid;
  logic                        axi4_ins_r_ready;

  logic [AXI_ID_WIDTH    -1:0] axi4_ins_b_id;
  logic [                 1:0] axi4_ins_b_resp;
  logic [AXI_USER_WIDTH  -1:0] axi4_ins_b_user;
  logic                        axi4_ins_b_valid;
  logic                        axi4_ins_b_ready;

  // AXI4 Data
  logic [AXI_ID_WIDTH    -1:0] axi4_dat_aw_id;
  logic [AXI_ADDR_WIDTH  -1:0] axi4_dat_aw_addr;
  logic [                 7:0] axi4_dat_aw_len;
  logic [                 2:0] axi4_dat_aw_size;
  logic [                 1:0] axi4_dat_aw_burst;
  logic                        axi4_dat_aw_lock;
  logic [                 3:0] axi4_dat_aw_cache;
  logic [                 2:0] axi4_dat_aw_prot;
  logic [                 3:0] axi4_dat_aw_qos;
  logic [                 3:0] axi4_dat_aw_region;
  logic [AXI_USER_WIDTH  -1:0] axi4_dat_aw_user;
  logic                        axi4_dat_aw_valid;
  logic                        axi4_dat_aw_ready;

  logic [AXI_ID_WIDTH    -1:0] axi4_dat_ar_id;
  logic [AXI_ADDR_WIDTH  -1:0] axi4_dat_ar_addr;
  logic [                 7:0] axi4_dat_ar_len;
  logic [                 2:0] axi4_dat_ar_size;
  logic [                 1:0] axi4_dat_ar_burst;
  logic                        axi4_dat_ar_lock;
  logic [                 3:0] axi4_dat_ar_cache;
  logic [                 2:0] axi4_dat_ar_prot;
  logic [                 3:0] axi4_dat_ar_qos;
  logic [                 3:0] axi4_dat_ar_region;
  logic [AXI_USER_WIDTH  -1:0] axi4_dat_ar_user;
  logic                        axi4_dat_ar_valid;
  logic                        axi4_dat_ar_ready;

  logic [AXI_DATA_WIDTH  -1:0] axi4_dat_w_data;
  logic [AXI_STRB_WIDTH  -1:0] axi4_dat_w_strb;
  logic                        axi4_dat_w_last;
  logic [AXI_USER_WIDTH  -1:0] axi4_dat_w_user;
  logic                        axi4_dat_w_valid;
  logic                        axi4_dat_w_ready;

  logic [AXI_ID_WIDTH    -1:0] axi4_dat_r_id;
  logic [AXI_DATA_WIDTH  -1:0] axi4_dat_r_data;
  logic [                 1:0] axi4_dat_r_resp;
  logic                        axi4_dat_r_last;
  logic [AXI_USER_WIDTH  -1:0] axi4_dat_r_user;
  logic                        axi4_dat_r_valid;
  logic                        axi4_dat_r_ready;

  logic [AXI_ID_WIDTH    -1:0] axi4_dat_b_id;
  logic [                 1:0] axi4_dat_b_resp;
  logic [AXI_USER_WIDTH  -1:0] axi4_dat_b_user;
  logic                        axi4_dat_b_valid;
  logic                        axi4_dat_b_ready;
    
  ////////////////////////////////////////////////////////////////
  // Body
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

  // Processing Unit
  pu_riscv_axi4 #(
    .XLEN             ( XLEN             ),
    .PLEN             ( PLEN             ),
    .PC_INIT          ( PC_INIT          ),
    .HAS_USER         ( HAS_USER         ),
    .HAS_SUPER        ( HAS_SUPER        ),
    .HAS_HYPER        ( HAS_HYPER        ),
    .HAS_RVA          ( HAS_RVA          ),
    .HAS_RVM          ( HAS_RVM          ),

    .MULT_LATENCY     ( MULT_LATENCY     ),

    .PMA_CNT          ( PMA_CNT          ),

    .ICACHE_SIZE      ( ICACHE_SIZE      ),
    .ICACHE_WAYS      ( 1                ),
 
    .DCACHE_SIZE      ( DCACHE_SIZE      ),
    .DTCM_SIZE        ( 0                ),

    .WRITEBUFFER_SIZE ( WRITEBUFFER_SIZE ),

    .MTVEC_DEFAULT    ( 32'h80000004     )
  )
  dut (
    .HRESETn   ( HRESETn ),
    .HCLK      ( HCLK    ),

    .pma_cfg_i ( pma_cfg ),
    .pma_adr_i ( pma_adr ),

    // AXI4 instruction
    .axi4_ins_aw_id     ( axi4_ins_aw_id ),
    .axi4_ins_aw_addr   ( axi4_ins_aw_addr ),
    .axi4_ins_aw_len    ( axi4_ins_aw_len ),
    .axi4_ins_aw_size   ( axi4_ins_aw_size ),
    .axi4_ins_aw_burst  ( axi4_ins_aw_burst ),
    .axi4_ins_aw_lock   ( axi4_ins_aw_lock ),
    .axi4_ins_aw_cache  ( axi4_ins_aw_cache ),
    .axi4_ins_aw_prot   ( axi4_ins_aw_prot ),
    .axi4_ins_aw_qos    ( axi4_ins_aw_qos ),
    .axi4_ins_aw_region ( axi4_ins_aw_region ),
    .axi4_ins_aw_user   ( axi4_ins_aw_user ),
    .axi4_ins_aw_valid  ( axi4_ins_aw_valid ),
    .axi4_ins_aw_ready  ( axi4_ins_aw_ready ),
 
    .axi4_ins_ar_id     ( axi4_ins_ar_id ),
    .axi4_ins_ar_addr   ( axi4_ins_ar_addr ),
    .axi4_ins_ar_len    ( axi4_ins_ar_len ),
    .axi4_ins_ar_size   ( axi4_ins_ar_size ),
    .axi4_ins_ar_burst  ( axi4_ins_ar_burst ),
    .axi4_ins_ar_lock   ( axi4_ins_ar_lock ),
    .axi4_ins_ar_cache  ( axi4_ins_ar_cache ),
    .axi4_ins_ar_prot   ( axi4_ins_ar_prot ),
    .axi4_ins_ar_qos    ( axi4_ins_ar_qos ),
    .axi4_ins_ar_region ( axi4_ins_ar_region ),
    .axi4_ins_ar_user   ( axi4_ins_ar_user ),
    .axi4_ins_ar_valid  ( axi4_ins_ar_valid ),
    .axi4_ins_ar_ready  ( axi4_ins_ar_ready ),
 
    .axi4_ins_w_data    ( axi4_ins_w_data ),
    .axi4_ins_w_strb    ( axi4_ins_w_strb ),
    .axi4_ins_w_last    ( axi4_ins_w_last ),
    .axi4_ins_w_user    ( axi4_ins_w_user ),
    .axi4_ins_w_valid   ( axi4_ins_w_valid ),
    .axi4_ins_w_ready   ( axi4_ins_w_ready ),
 
    .axi4_ins_r_id      ( axi4_ins_r_id ),
    .axi4_ins_r_data    ( axi4_ins_r_data ),
    .axi4_ins_r_resp    ( axi4_ins_r_resp ),
    .axi4_ins_r_last    ( axi4_ins_r_last ),
    .axi4_ins_r_user    ( axi4_ins_r_user ),
    .axi4_ins_r_valid   ( axi4_ins_r_valid ),
    .axi4_ins_r_ready   ( axi4_ins_r_ready ),
 
    .axi4_ins_b_id      ( axi4_ins_b_id ),
    .axi4_ins_b_resp    ( axi4_ins_b_resp ),
    .axi4_ins_b_user    ( axi4_ins_b_user ),
    .axi4_ins_b_valid   ( axi4_ins_b_valid ),
    .axi4_ins_b_ready   ( axi4_ins_b_ready),

    // AXI4 data
    .axi4_dat_aw_id     ( axi4_dat_aw_id ),
    .axi4_dat_aw_addr   ( axi4_dat_aw_addr ),
    .axi4_dat_aw_len    ( axi4_dat_aw_len ),
    .axi4_dat_aw_size   ( axi4_dat_aw_size ),
    .axi4_dat_aw_burst  ( axi4_dat_aw_burst ),
    .axi4_dat_aw_lock   ( axi4_dat_aw_lock ),
    .axi4_dat_aw_cache  ( axi4_dat_aw_cache ),
    .axi4_dat_aw_prot   ( axi4_dat_aw_prot ),
    .axi4_dat_aw_qos    ( axi4_dat_aw_qos ),
    .axi4_dat_aw_region ( axi4_dat_aw_region ),
    .axi4_dat_aw_user   ( axi4_dat_aw_user ),
    .axi4_dat_aw_valid  ( axi4_dat_aw_valid ),
    .axi4_dat_aw_ready  ( axi4_dat_aw_ready ),
 
    .axi4_dat_ar_id     ( axi4_dat_ar_id ),
    .axi4_dat_ar_addr   ( axi4_dat_ar_addr ),
    .axi4_dat_ar_len    ( axi4_dat_ar_len ),
    .axi4_dat_ar_size   ( axi4_dat_ar_size ),
    .axi4_dat_ar_burst  ( axi4_dat_ar_burst ),
    .axi4_dat_ar_lock   ( axi4_dat_ar_lock ),
    .axi4_dat_ar_cache  ( axi4_dat_ar_cache ),
    .axi4_dat_ar_prot   ( axi4_dat_ar_prot ),
    .axi4_dat_ar_qos    ( axi4_dat_ar_qos ),
    .axi4_dat_ar_region ( axi4_dat_ar_region ),
    .axi4_dat_ar_user   ( axi4_dat_ar_user ),
    .axi4_dat_ar_valid  ( axi4_dat_ar_valid ),
    .axi4_dat_ar_ready  ( axi4_dat_ar_ready ),
 
    .axi4_dat_w_data    ( axi4_dat_w_data ),
    .axi4_dat_w_strb    ( axi4_dat_w_strb ),
    .axi4_dat_w_last    ( axi4_dat_w_last ),
    .axi4_dat_w_user    ( axi4_dat_w_user ),
    .axi4_dat_w_valid   ( axi4_dat_w_valid ),
    .axi4_dat_w_ready   ( axi4_dat_w_ready ),
 
    .axi4_dat_r_id      ( axi4_dat_r_id ),
    .axi4_dat_r_data    ( axi4_dat_r_data ),
    .axi4_dat_r_resp    ( axi4_dat_r_resp ),
    .axi4_dat_r_last    ( axi4_dat_r_last ),
    .axi4_dat_r_user    ( axi4_dat_r_user ),
    .axi4_dat_r_valid   ( axi4_dat_r_valid ),
    .axi4_dat_r_ready   ( axi4_dat_r_ready ),
 
    .axi4_dat_b_id      ( axi4_dat_b_id ),
    .axi4_dat_b_resp    ( axi4_dat_b_resp ),
    .axi4_dat_b_user    ( axi4_dat_b_user ),
    .axi4_dat_b_valid   ( axi4_dat_b_valid ),
    .axi4_dat_b_ready   ( axi4_dat_b_ready),
    
    // Interrupts
    .ext_nmi   ( ext_nmi  ),
    .ext_tint  ( ext_tint ),
    .ext_sint  ( ext_sint ),
    .ext_int   ( ext_int  ),

    // Debug Interface
    .dbg_stall ( dbg_stall ),
    .dbg_strb  ( dbg_strb  ),
    .dbg_we    ( dbg_we    ),
    .dbg_addr  ( dbg_addr  ),
    .dbg_dati  ( dbg_dati  ),
    .dbg_dato  ( db_dato   ),
    .dbg_ack   ( dbg_ack   ),
    .dbg_bp    ( dbg_bp    )
  );

  // Instruction AXI4
  peripheral_design #(
    .AXI_ID_WIDTH   ( AXI_ID_WIDTH   ),
    .AXI_ADDR_WIDTH ( AXI_ADDR_WIDTH ),
    .AXI_DATA_WIDTH ( AXI_DATA_WIDTH ),
    .AXI_STRB_WIDTH ( AXI_STRB_WIDTH ),
    .AXI_USER_WIDTH ( AXI_USER_WIDTH )
  )
  instruction_axi4 (
    .clk_i  ( HCLK    ),  // Clock
    .rst_ni ( HRESETn ),  // Asynchronous reset active low

    .axi_aw_id     ( axi4_ins_aw_id     ),
    .axi_aw_addr   ( axi4_ins_aw_addr   ),
    .axi_aw_len    ( axi4_ins_aw_len    ),
    .axi_aw_size   ( axi4_ins_aw_size   ),
    .axi_aw_burst  ( axi4_ins_aw_burst  ),
    .axi_aw_lock   ( axi4_ins_aw_lock   ),
    .axi_aw_cache  ( axi4_ins_aw_cache  ),
    .axi_aw_prot   ( axi4_ins_aw_prot   ),
    .axi_aw_qos    ( axi4_ins_aw_qos    ),
    .axi_aw_region ( axi4_ins_aw_region ),
    .axi_aw_user   ( axi4_ins_aw_user   ),
    .axi_aw_valid  ( axi4_ins_aw_valid  ),
    .axi_aw_ready  ( axi4_ins_aw_ready  ),

    .axi_ar_id     ( axi4_ins_ar_id     ),
    .axi_ar_addr   ( axi4_ins_ar_addr   ),
    .axi_ar_len    ( axi4_ins_ar_len    ),
    .axi_ar_size   ( axi4_ins_ar_size   ),
    .axi_ar_burst  ( axi4_ins_ar_burst  ),
    .axi_ar_lock   ( axi4_ins_ar_lock   ),
    .axi_ar_cache  ( axi4_ins_ar_cache  ),
    .axi_ar_prot   ( axi4_ins_ar_prot   ),
    .axi_ar_qos    ( axi4_ins_ar_qos    ),
    .axi_ar_region ( axi4_ins_ar_region ),
    .axi_ar_user   ( axi4_ins_ar_user   ),
    .axi_ar_valid  ( axi4_ins_ar_valid  ),
    .axi_ar_ready  ( axi4_ins_ar_ready  ),

    .axi_w_data  ( axi4_ins_w_data  ),
    .axi_w_strb  ( axi4_ins_w_strb  ),
    .axi_w_last  ( axi4_ins_w_last  ),
    .axi_w_user  ( axi4_ins_w_user  ),
    .axi_w_valid ( axi4_ins_w_valid ),
    .axi_w_ready ( axi4_ins_w_ready ),

    .axi_r_id    ( axi4_ins_r_id    ),
    .axi_r_data  ( axi4_ins_r_data  ),
    .axi_r_resp  ( axi4_ins_r_resp  ),
    .axi_r_last  ( axi4_ins_r_last  ),
    .axi_r_user  ( axi4_ins_r_user  ),
    .axi_r_valid ( axi4_ins_r_valid ),
    .axi_r_ready ( axi4_ins_r_ready ),

    .axi_b_id    ( axi4_ins_b_id    ),
    .axi_b_resp  ( axi4_ins_b_resp  ),
    .axi_b_user  ( axi4_ins_b_user  ),
    .axi_b_valid ( axi4_ins_b_valid ),
    .axi_b_ready ( axi4_ins_b_ready ),

    .req_o  (   ),
    .we_o   (   ),
    .addr_o (   ),
    .be_o   (   ),
    .data_o (   ),
    .data_i ( 0 )
  );

  // Data AXI4
  peripheral_design #(
    .AXI_ID_WIDTH   ( AXI_ID_WIDTH   ),
    .AXI_ADDR_WIDTH ( AXI_ADDR_WIDTH ),
    .AXI_DATA_WIDTH ( AXI_DATA_WIDTH ),
    .AXI_STRB_WIDTH ( AXI_STRB_WIDTH ),
    .AXI_USER_WIDTH ( AXI_USER_WIDTH )
  )
  data_axi4 (
    .clk_i  ( HCLK    ),  // Clock
    .rst_ni ( HRESETn ),  // Asynchronous reset active low

    .axi_aw_id     ( axi4_dat_aw_id     ),
    .axi_aw_addr   ( axi4_dat_aw_addr   ),
    .axi_aw_len    ( axi4_dat_aw_len    ),
    .axi_aw_size   ( axi4_dat_aw_size   ),
    .axi_aw_burst  ( axi4_dat_aw_burst  ),
    .axi_aw_lock   ( axi4_dat_aw_lock   ),
    .axi_aw_cache  ( axi4_dat_aw_cache  ),
    .axi_aw_prot   ( axi4_dat_aw_prot   ),
    .axi_aw_qos    ( axi4_dat_aw_qos    ),
    .axi_aw_region ( axi4_dat_aw_region ),
    .axi_aw_user   ( axi4_dat_aw_user   ),
    .axi_aw_valid  ( axi4_dat_aw_valid  ),
    .axi_aw_ready  ( axi4_dat_aw_ready  ),

    .axi_ar_id     ( axi4_dat_ar_id     ),
    .axi_ar_addr   ( axi4_dat_ar_addr   ),
    .axi_ar_len    ( axi4_dat_ar_len    ),
    .axi_ar_size   ( axi4_dat_ar_size   ),
    .axi_ar_burst  ( axi4_dat_ar_burst  ),
    .axi_ar_lock   ( axi4_dat_ar_lock   ),
    .axi_ar_cache  ( axi4_dat_ar_cache  ),
    .axi_ar_prot   ( axi4_dat_ar_prot   ),
    .axi_ar_qos    ( axi4_dat_ar_qos    ),
    .axi_ar_region ( axi4_dat_ar_region ),
    .axi_ar_user   ( axi4_dat_ar_user   ),
    .axi_ar_valid  ( axi4_dat_ar_valid  ),
    .axi_ar_ready  ( axi4_dat_ar_ready  ),

    .axi_w_data  ( axi4_dat_w_data  ),
    .axi_w_strb  ( axi4_dat_w_strb  ),
    .axi_w_last  ( axi4_dat_w_last  ),
    .axi_w_user  ( axi4_dat_w_user  ),
    .axi_w_valid ( axi4_dat_w_valid ),
    .axi_w_ready ( axi4_dat_w_ready ),

    .axi_r_id    ( axi4_dat_r_id    ),
    .axi_r_data  ( axi4_dat_r_data  ),
    .axi_r_resp  ( axi4_dat_r_resp  ),
    .axi_r_last  ( axi4_dat_r_last  ),
    .axi_r_user  ( axi4_dat_r_user  ),
    .axi_r_valid ( axi4_dat_r_valid ),
    .axi_r_ready ( axi4_dat_r_ready ),

    .axi_b_id    ( axi4_dat_b_id    ),
    .axi_b_resp  ( axi4_dat_b_resp  ),
    .axi_b_user  ( axi4_dat_b_user  ),
    .axi_b_valid ( axi4_dat_b_valid ),
    .axi_b_ready ( axi4_dat_b_ready ),

    .req_o  (   ),
    .we_o   (   ),
    .addr_o (   ),
    .be_o   (   ),
    .data_o (   ),
    .data_i ( 0 )
  );
endmodule
