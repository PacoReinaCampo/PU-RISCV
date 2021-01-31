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

  parameter            BREAKPOINTS        = 8,  //Number of hardware breakpoints

  parameter            PMA_CNT            = 4,
  parameter            PMP_CNT            = 16, //Number of Physical Memory Protection entries

  parameter            BP_GLOBAL_BITS     = 2,
  parameter            BP_LOCAL_BITS      = 10,
  parameter            BP_LOCAL_BITS_LSB  = 2,

  parameter            ICACHE_SIZE        = 64,  //in KBytes
  parameter            ICACHE_BLOCK_SIZE  = 64,  //in Bytes
  parameter            ICACHE_WAYS        = 2,   //'n'-way set associative
  parameter            ICACHE_REPLACE_ALG = 0,
  parameter            ITCM_SIZE          = 0,

  parameter            DCACHE_SIZE        = 64,  //in KBytes
  parameter            DCACHE_BLOCK_SIZE  = 64,  //in Bytes
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

    //Interrupts
    input                               ext_nmi,
    input                               ext_tint,
    input                               ext_sint,
    input                    [     3:0] ext_int,

    //Debug Interface
    input                               dbg_stall,
    input                               dbg_strb,
    input                               dbg_we,
    input                    [PLEN-1:0] dbg_addr,
    input                    [XLEN-1:0] dbg_dati,
    output                   [XLEN-1:0] dbg_dato,
    output                              dbg_ack,
    output                              dbg_bp
  );
  
  //////////////////////////////////////////////////////////////////
  //
  // Constants
  //

  parameter HTIF             = 0;  // Host-Interface
  parameter TOHOST           = 32'h80001000;
  parameter UART_TX          = 32'h80001080;
  
  //////////////////////////////////////////////////////////////////
  //
  // Variables
  //

  //PMA configuration
  logic [PMA_CNT-1:0][    13:0] pma_cfg;
  logic [PMA_CNT-1:0][PLEN-1:0] pma_adr;

  //WB instruction
  logic              [PLEN-1:0] wb_ins_adr_o;
  logic              [XLEN-1:0] wb_ins_dat_o;
  logic              [     3:0] wb_ins_sel_o;
  logic                         wb_ins_we_o;
  logic                         wb_ins_cyc_o;
  logic                         wb_ins_stb_o;
  logic              [     2:0] wb_ins_cti_o;
  logic              [     1:0] wb_ins_bte_o;
  logic              [XLEN-1:0] wb_ins_dat_i;
  logic                         wb_ins_ack_i;
  logic                         wb_ins_err_i;
  logic              [     2:0] wb_ins_rty_i;

  //WB data
  logic              [PLEN-1:0] wb_dat_adr_o;
  logic              [XLEN-1:0] wb_dat_dat_o;
  logic              [     3:0] wb_dat_sel_o;
  logic                         wb_dat_we_o;
  logic                         wb_dat_stb_o;
  logic                         wb_dat_cyc_o;
  logic              [     2:0] wb_dat_cti_o;
  logic              [     1:0] wb_dat_bte_o;
  logic              [XLEN-1:0] wb_dat_dat_i;
  logic                         wb_dat_ack_i;
  logic                         wb_dat_err_i;
  logic              [     2:0] wb_dat_rty_i;
    
  ////////////////////////////////////////////////////////////////
  //
  // Module Body
  //

  //Define PMA regions

  //crt.0 (ROM) region
  assign pma_adr[0] = TOHOST >> 2;
  assign pma_cfg[0] = {`MEM_TYPE_MAIN, 8'b1111_1000, `AMO_TYPE_NONE, `TOR};

  //TOHOST region
  assign pma_adr[1] = ((TOHOST >> 2) & ~'hf) | 'h7;
  assign pma_cfg[1] = {`MEM_TYPE_IO, 8'b0100_0000, `AMO_TYPE_NONE, `NAPOT};

  //UART-Tx region
  assign pma_adr[2] = UART_TX >> 2;
  assign pma_cfg[2] = {`MEM_TYPE_IO, 8'b0100_0000, `AMO_TYPE_NONE, `NA4};

  //RAM region
  assign pma_adr[3] = 1 << 31;
  assign pma_cfg[3] = {`MEM_TYPE_MAIN, 8'b1111_0000, `AMO_TYPE_NONE, `TOR};

  // Processing Unit
  riscv_pu_wb #(
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

    //WB instruction
    .wb_ins_adr_o ( wb_ins_adr_o ),
    .wb_ins_dat_o ( wb_ins_dat_o ),
    .wb_ins_sel_o ( wb_ins_sel_o ),
    .wb_ins_we_o  ( wb_ins_we_o  ),
    .wb_ins_cyc_o ( wb_ins_cyc_o ),
    .wb_ins_stb_o ( wb_ins_stb_o ),
    .wb_ins_cti_o ( wb_ins_cti_o ),
    .wb_ins_bte_o ( wb_ins_bte_o ),
    .wb_ins_dat_i ( wb_ins_dat_i ),
    .wb_ins_ack_i ( wb_ins_ack_i ),
    .wb_ins_err_i ( wb_ins_err_i ),
    .wb_ins_rty_i ( wb_ins_rty_i ),

    //WB data
    .wb_dat_adr_o ( wb_dat_adr_o ),
    .wb_dat_dat_o ( wb_dat_dat_o ),
    .wb_dat_sel_o ( wb_dat_sel_o ),
    .wb_dat_we_o  ( wb_dat_we_o  ),
    .wb_dat_cyc_o ( wb_dat_cyc_o ),
    .wb_dat_stb_o ( wb_dat_stb_o ),
    .wb_dat_cti_o ( wb_dat_cti_o ),
    .wb_dat_bte_o ( wb_dat_bte_o ),
    .wb_dat_dat_i ( wb_dat_dat_i ),
    .wb_dat_ack_i ( wb_dat_ack_i ),
    .wb_dat_err_i ( wb_dat_err_i ),
    .wb_dat_rty_i ( wb_dat_rty_i ),
    
    //Interrupts
    .ext_nmi   ( ext_nmi  ),
    .ext_tint  ( ext_tint ),
    .ext_sint  ( ext_sint ),
    .ext_int   ( ext_int  ),

    //Debug Interface
    .dbg_stall ( dbg_stall ),
    .dbg_strb  ( dbg_strb  ),
    .dbg_we    ( dbg_we    ),
    .dbg_addr  ( dbg_addr  ),
    .dbg_dati  ( dbg_dati  ),
    .dbg_dato  ( db_dato   ),
    .dbg_ack   ( dbg_ack   ),
    .dbg_bp    ( dbg_bp    )
  );

  //Instruction WB
  mpsoc_wb_spram #(
    .DEPTH   ( 256  ),
    .MEMFILE ( ""   ),
    .AW      ( PLEN ),
    .DW      ( XLEN )
  )
  instruction_wb (
    .wb_clk_i ( HRESETn ),
    .wb_rst_i ( HCLK    ),

    .wb_adr_i ( wb_ins_adr_o ),
    .wb_dat_i ( wb_ins_dat_o ),
    .wb_sel_i ( wb_ins_sel_o ),
    .wb_we_i  ( wb_ins_we_o  ),
    .wb_bte_i ( wb_ins_bte_o ),
    .wb_cti_i ( wb_ins_cti_o ),
    .wb_cyc_i ( wb_ins_cyc_o ),
    .wb_stb_i ( wb_ins_stb_o ),
    .wb_ack_o ( wb_ins_ack_i ),
    .wb_err_o ( wb_ins_err_i ),
    .wb_dat_o ( wb_ins_dat_i )
  );

  //Data WB
  mpsoc_wb_spram #(
    .DEPTH   ( 256  ),
    .MEMFILE ( ""   ),
    .AW      ( PLEN ),
    .DW      ( XLEN )
  )
  data_wb (
    .wb_clk_i ( HRESETn ),
    .wb_rst_i ( HCLK    ),

    .wb_adr_i ( wb_dat_adr_o ),
    .wb_dat_i ( wb_dat_dat_o ),
    .wb_sel_i ( wb_dat_sel_o ),
    .wb_we_i  ( wb_dat_we_o  ),
    .wb_bte_i ( wb_dat_bte_o ),
    .wb_cti_i ( wb_dat_cti_o ),
    .wb_cyc_i ( wb_dat_cyc_o ),
    .wb_stb_i ( wb_dat_stb_o ),
    .wb_ack_o ( wb_dat_ack_i ),
    .wb_err_o ( wb_dat_err_i ),
    .wb_dat_o ( wb_dat_dat_i )
  );
endmodule
