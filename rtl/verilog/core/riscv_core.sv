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

module riscv_core #(
  parameter            XLEN                  = 64,
  parameter            PLEN                  = 64,
  parameter            ILEN                  = 64,
  parameter            EXCEPTION_SIZE        = 16,
  parameter [XLEN-1:0] PC_INIT               = 'h200,
  parameter            HAS_USER              = 1,
  parameter            HAS_SUPER             = 1,
  parameter            HAS_HYPER             = 1,
  parameter            HAS_BPU               = 1,
  parameter            HAS_FPU               = 1,
  parameter            HAS_MMU               = 1,
  parameter            HAS_RVA               = 1,
  parameter            HAS_RVM               = 1,
  parameter            HAS_RVC               = 1,
  parameter            IS_RV32E              = 1,

  parameter            MULT_LATENCY          = 1,

  parameter            BREAKPOINTS           = 8,

  parameter            PMA_CNT               = 4,
  parameter            PMP_CNT               = 16,

  parameter            BP_GLOBAL_BITS        = 2,
  parameter            BP_LOCAL_BITS         = 10,
  parameter            BP_LOCAL_BITS_LSB     = 2,

  parameter            DU_ADDR_SIZE          = 12,
  parameter            MAX_BREAKPOINTS       = 8,

  parameter            TECHNOLOGY            = "GENERIC",

  parameter            MNMIVEC_DEFAULT       = PC_INIT - 'h004,
  parameter            MTVEC_DEFAULT         = PC_INIT - 'h040,
  parameter            HTVEC_DEFAULT         = PC_INIT - 'h080,
  parameter            STVEC_DEFAULT         = PC_INIT - 'h0C0,
  parameter            UTVEC_DEFAULT         = PC_INIT - 'h100,

  parameter            JEDEC_BANK            = 10,
  parameter            JEDEC_MANUFACTURER_ID = 'h6e,

  parameter            HARTID                = 0,

  parameter            PARCEL_SIZE           = 64
)
  (
    input                             rstn,   //Reset
    input                             clk,    //Clock

    //Instruction Memory Access bus
    input                             if_stall_nxt_pc,
    output       [XLEN          -1:0] if_nxt_pc,
    output                            if_stall,
    output                            if_flush,
    input        [PARCEL_SIZE   -1:0] if_parcel,
    input        [XLEN          -1:0] if_parcel_pc,
    input        [PARCEL_SIZE/16-1:0] if_parcel_valid,
    input                             if_parcel_misaligned,
    input                             if_parcel_page_fault,

    //Data Memory Access bus
    output       [XLEN         -1:0] dmem_adr,
                                     dmem_d,
    input        [XLEN         -1:0] dmem_q,
    output                           dmem_we,
    output                     [2:0] dmem_size,
    output                           dmem_req,
    input                            dmem_ack,
    input                            dmem_err,
    input                            dmem_misaligned,
    input                            dmem_page_fault,

    //cpu state
    output                    [     1:0] st_prv,
    output       [PMP_CNT-1:0][     7:0] st_pmpcfg,
    output       [PMP_CNT-1:0][XLEN-1:0] st_pmpaddr,

    output                           bu_cacheflush,

    //Interrupts
    input                            ext_nmi,
    input                            ext_tint,
    input                            ext_sint,
    input        [              3:0] ext_int,

    //Debug Interface
    input                            dbg_stall,
    input                            dbg_strb,
    input                            dbg_we,
    input        [PLEN         -1:0] dbg_addr,
    input        [XLEN         -1:0] dbg_dati,
    output       [XLEN         -1:0] dbg_dato,
    output                           dbg_ack,
    output                           dbg_bp
  );

  ////////////////////////////////////////////////////////////////
  //
  // Variables
  //

  logic [XLEN           -1:0] bu_nxt_pc;
  logic [XLEN           -1:0] st_nxt_pc;
  logic [XLEN           -1:0] if_pc;
  logic [XLEN           -1:0] id_pc;
  logic [XLEN           -1:0] ex_pc;
  logic [XLEN           -1:0] mem_pc;
  logic [XLEN           -1:0] wb_pc;

  logic [ILEN           -1:0] if_instr;
  logic [ILEN           -1:0] id_instr;
  logic [ILEN           -1:0] ex_instr;
  logic [ILEN           -1:0] mem_instr;
  logic [ILEN           -1:0] wb_instr;

  logic                       if_bubble;
  logic                       id_bubble;
  logic                       ex_bubble;
  logic                       mem_bubble;
  logic                       wb_bubble;

  logic                       bu_flush;
  logic                       st_flush;
  logic                       du_flush;

  logic                       id_stall;
  logic                       ex_stall;
  logic                       wb_stall;
  logic                       du_stall;
  logic                       du_stall_dly;

  //Branch Prediction
  logic [                1:0] bp_bp_predict;
  logic [                1:0] if_bp_predict;
  logic [                1:0] id_bp_predict;
  logic [                1:0] bu_bp_predict;

  logic [BP_GLOBAL_BITS -1:0] bu_bp_history;
  logic                       bu_bp_btaken;
  logic                       bu_bp_update;


  //Exceptions
  logic [EXCEPTION_SIZE -1:0] if_exception;
  logic [EXCEPTION_SIZE -1:0] id_exception;
  logic [EXCEPTION_SIZE -1:0] ex_exception;
  logic [EXCEPTION_SIZE -1:0] mem_exception;
  logic [EXCEPTION_SIZE -1:0] wb_exception;

  //RF access
  parameter AR_BITS = 5;
  parameter RDPORTS = 2;
  parameter WRPORTS = 1;

  logic              [XLEN   -1:0] id_srcv2;
  logic [RDPORTS-1:0][AR_BITS-1:0] rf_src1;
  logic [RDPORTS-1:0][AR_BITS-1:0] rf_src2;
  logic [WRPORTS-1:0][AR_BITS-1:0] rf_dst;
  logic [RDPORTS-1:0][XLEN   -1:0] rf_srcv1;
  logic [RDPORTS-1:0][XLEN   -1:0] rf_srcv2;
  logic [WRPORTS-1:0][XLEN   -1:0] rf_dstv;
  logic [WRPORTS-1:0]              rf_we;             

  //ALU signals
  logic [XLEN           -1:0] id_opA;
  logic [XLEN           -1:0] id_opB;
  logic [XLEN           -1:0] ex_r;
  logic [XLEN           -1:0] ex_memadr;
  logic [XLEN           -1:0] mem_r;
  logic [XLEN           -1:0] mem_memadr;

  logic                       id_userf_opA;
  logic                       id_userf_opB;
  logic                       id_bypex_opA;
  logic                       id_bypex_opB;
  logic                       id_bypmem_opA;
  logic                       id_bypmem_opB;
  logic                       id_bypwb_opA;
  logic                       id_bypwb_opB;

  //CPU state
  logic [                1:0] st_xlen;
  logic                       st_tvm;
  logic                       st_tw;
  logic                       st_tsr;
  logic [XLEN           -1:0] st_mcounteren;
  logic [XLEN           -1:0] st_scounteren;
  logic                       st_interrupt;
  logic [               11:0] ex_csr_reg;
  logic [XLEN           -1:0] ex_csr_wval;
  logic [XLEN           -1:0] st_csr_rval;
  logic                       ex_csr_we;

  //Write back
  logic [                4:0] wb_dst;
  logic [XLEN           -1:0] wb_r;
  logic [                0:0] wb_we;
  logic [XLEN           -1:0] wb_badaddr;

  //Debug
  logic                       du_we_rf;
  logic                       du_we_frf;
  logic                       du_we_csr;
  logic                       du_we_pc;
  logic [DU_ADDR_SIZE   -1:0] du_addr;
  logic [XLEN           -1:0] du_dato;
  logic [XLEN           -1:0] du_dati_rf;
  logic [XLEN           -1:0] du_dati_frf;
  logic [XLEN           -1:0] du_dati_csr;
  logic [               31:0] du_ie;
  logic [               31:0] du_exceptions;

  ////////////////////////////////////////////////////////////////
  //
  // Module Body
  //

  /*
   * Instruction Fetch
   *
   * Calculate next Program Counter
   * Fetch next instruction
   */

  riscv_if #(
    .XLEN ( XLEN ),
    .ILEN ( ILEN ),

    .PARCEL_SIZE    ( PARCEL_SIZE ),
    .EXCEPTION_SIZE ( EXCEPTION_SIZE )
  )
  if_unit (
    .rstn                 ( rstn                 ),
    .clk                  ( clk                  ),
    .id_stall             ( id_stall             ),
    .if_stall_nxt_pc      ( if_stall_nxt_pc      ),
    .if_parcel            ( if_parcel            ),
    .if_parcel_pc         ( if_parcel_pc         ),
    .if_parcel_valid      ( if_parcel_valid      ),
    .if_parcel_misaligned ( if_parcel_misaligned ),
    .if_parcel_page_fault ( if_parcel_page_fault ),
    .if_instr             ( if_instr             ),
    .if_bubble            ( if_bubble            ),
    .if_exception         ( if_exception         ),
    .bp_bp_predict        ( bp_bp_predict        ),
    .if_bp_predict        ( if_bp_predict        ),
    .bu_flush             ( bu_flush             ),
    .st_flush             ( st_flush             ),
    .du_flush             ( du_flush             ),
    .bu_nxt_pc            ( bu_nxt_pc            ),
    .st_nxt_pc            ( st_nxt_pc            ),
    .if_nxt_pc            ( if_nxt_pc            ),
    .if_stall             ( if_stall             ),
    .if_flush             ( if_flush             ),
    .if_pc                ( if_pc                )
  );

  /*
   * Instruction Decoder
   *
   * Data from RF/ROB is available here
   */

  riscv_id #(
    .XLEN ( XLEN ),
    .ILEN ( ILEN ),

    .EXCEPTION_SIZE ( EXCEPTION_SIZE )
  )
  id_unit (
    .rstn          ( rstn                 ),
    .clk           ( clk                  ),
    .id_stall      ( id_stall             ),
    .ex_stall      ( ex_stall             ),
    .du_stall      ( du_stall             ),
    .bu_flush      ( bu_flush             ),
    .st_flush      ( st_flush             ),
    .du_flush      ( du_flush             ),
    .bu_nxt_pc     ( bu_nxt_pc            ),
    .st_nxt_pc     ( st_nxt_pc            ),
    .if_pc         ( if_pc                ),
    .id_pc         ( id_pc                ),
    .if_bp_predict ( if_bp_predict        ),
    .id_bp_predict ( id_bp_predict        ),
    .if_instr      ( if_instr             ),
    .if_bubble     ( if_bubble            ),
    .id_instr      ( id_instr             ),
    .id_bubble     ( id_bubble            ),
    .ex_instr      ( ex_instr             ),
    .ex_bubble     ( ex_bubble            ),
    .mem_instr     ( mem_instr            ),
    .mem_bubble    ( mem_bubble           ),
    .wb_instr      ( wb_instr             ),
    .wb_bubble     ( wb_bubble            ),
    .if_exception  ( if_exception         ),
    .ex_exception  ( ex_exception         ),
    .mem_exception ( mem_exception        ),
    .wb_exception  ( wb_exception         ),
    .id_exception  ( id_exception         ),
    .st_prv        ( st_prv               ),
    .st_xlen       ( st_xlen              ),
    .st_tvm        ( st_tvm               ),
    .st_tw         ( st_tw                ),
    .st_tsr        ( st_tsr               ),
    .st_mcounteren ( st_mcounteren        ),
    .st_scounteren ( st_scounteren        ),

    .id_src1       ( rf_src1[0]           ),
    .id_src2       ( rf_src2[0]           ),

    .id_opA        ( id_opA               ),
    .id_opB        ( id_opB               ),
    .id_userf_opA  ( id_userf_opA         ),
    .id_userf_opB  ( id_userf_opB         ),
    .id_bypex_opA  ( id_bypex_opA         ),
    .id_bypex_opB  ( id_bypex_opB         ),
    .id_bypmem_opA ( id_bypmem_opA        ),
    .id_bypmem_opB ( id_bypmem_opB        ),
    .id_bypwb_opA  ( id_bypwb_opA         ),
    .id_bypwb_opB  ( id_bypwb_opB         ),
    .mem_r         ( mem_r                ),
    .wb_r          ( wb_r                 )
  );

  //Execution units
  riscv_execution #(
    .XLEN ( XLEN ),
    .ILEN ( ILEN ),

    .EXCEPTION_SIZE ( EXCEPTION_SIZE ),
    .BP_GLOBAL_BITS ( BP_GLOBAL_BITS ),

    .HAS_RVC ( HAS_RVC ),
    .HAS_RVA ( HAS_RVA ),
    .HAS_RVM ( HAS_RVM ),

    .MULT_LATENCY ( MULT_LATENCY ),

    .PC_INIT ( PC_INIT )

  )
  execution_unit (
    .rstn            ( rstn               ),
    .clk             ( clk                ),
    .wb_stall        ( wb_stall           ),
    .ex_stall        ( ex_stall           ),
    .id_pc           ( id_pc              ),
    .ex_pc           ( ex_pc              ),
    .bu_nxt_pc       ( bu_nxt_pc          ),
    .bu_flush        ( bu_flush           ),
    .bu_cacheflush   ( bu_cacheflush      ),
    .id_bp_predict   ( id_bp_predict      ),
    .bu_bp_predict   ( bu_bp_predict      ),
    .bu_bp_history   ( bu_bp_history      ),
    .bu_bp_btaken    ( bu_bp_btaken       ),
    .bu_bp_update    ( bu_bp_update       ),
    .id_bubble       ( id_bubble          ),
    .id_instr        ( id_instr           ),
    .ex_bubble       ( ex_bubble          ),
    .ex_instr        ( ex_instr           ),
    .id_exception    ( id_exception       ),
    .mem_exception   ( mem_exception      ),
    .wb_exception    ( wb_exception       ),
    .ex_exception    ( ex_exception       ),
    .id_userf_opA    ( id_userf_opA       ),
    .id_userf_opB    ( id_userf_opB       ),
    .id_bypex_opA    ( id_bypex_opA       ),
    .id_bypex_opB    ( id_bypex_opB       ),
    .id_bypmem_opA   ( id_bypmem_opA      ),
    .id_bypmem_opB   ( id_bypmem_opB      ),
    .id_bypwb_opA    ( id_bypwb_opA       ),
    .id_bypwb_opB    ( id_bypwb_opB       ),
    .id_opA          ( id_opA             ),
    .id_opB          ( id_opB             ),

    .rf_srcv1        ( rf_srcv1[0]        ),
    .rf_srcv2        ( rf_srcv2[0]        ),

    .ex_r            ( ex_r               ),
    .mem_r           ( mem_r              ),
    .wb_r            ( wb_r               ),
    .ex_csr_reg      ( ex_csr_reg         ),
    .ex_csr_wval     ( ex_csr_wval        ),
    .ex_csr_we       ( ex_csr_we          ),
    .st_prv          ( st_prv             ),
    .st_xlen         ( st_xlen            ),
    .st_flush        ( st_flush           ),
    .st_csr_rval     ( st_csr_rval        ),
    .dmem_adr        ( dmem_adr           ),
    .dmem_d          ( dmem_d             ),
    .dmem_req        ( dmem_req           ),
    .dmem_we         ( dmem_we            ),
    .dmem_size       ( dmem_size          ),
    .dmem_ack        ( dmem_ack           ),
    .dmem_q          ( dmem_q             ),
    .dmem_misaligned ( dmem_misaligned    ),
    .dmem_page_fault ( dmem_page_fault    ),
    .du_stall        ( du_stall           ),
    .du_stall_dly    ( du_stall_dly       ),
    .du_flush        ( du_flush           ),
    .du_we_pc        ( du_we_pc           ),
    .du_dato         ( du_dato            ),
    .du_ie           ( du_ie              )
  );

  //Memory access
  riscv_memory #(
    .XLEN ( XLEN ),
    .ILEN ( ILEN ),

    .EXCEPTION_SIZE ( EXCEPTION_SIZE ),

    .PC_INIT ( PC_INIT )

  )
  memory_unit (
    .rstn          ( rstn          ),
    .clk           ( clk           ),
    .wb_stall      ( wb_stall      ),
    .ex_pc         ( ex_pc         ),
    .mem_pc        ( mem_pc        ),
    .ex_bubble     ( ex_bubble     ),
    .ex_instr      ( ex_instr      ),
    .mem_bubble    ( mem_bubble    ),
    .mem_instr     ( mem_instr     ),
    .ex_exception  ( ex_exception  ),
    .wb_exception  ( wb_exception  ),
    .mem_exception ( mem_exception ),
    .ex_r          ( ex_r          ),
    .dmem_adr      ( dmem_adr      ),
    .mem_r         ( mem_r         ),
    .mem_memadr    ( mem_memadr    )
  );

  //Memory acknowledge + Write Back unit
  riscv_wb #(
    .XLEN ( XLEN ),
    .ILEN ( ILEN ),

    .EXCEPTION_SIZE ( EXCEPTION_SIZE ),

    .PC_INIT ( PC_INIT )

  )
  wb_unit (
    .rst_ni            ( rstn            ),
    .clk_i             ( clk             ),
    .mem_pc_i          ( mem_pc          ),
    .mem_instr_i       ( mem_instr       ),
    .mem_bubble_i      ( mem_bubble      ),
    .mem_r_i           ( mem_r           ),
    .mem_exception_i   ( mem_exception   ),
    .mem_memadr_i      ( mem_memadr      ),
    .wb_pc_o           ( wb_pc           ),
    .wb_stall_o        ( wb_stall        ),
    .wb_instr_o        ( wb_instr        ),
    .wb_bubble_o       ( wb_bubble       ),
    .wb_exception_o    ( wb_exception    ),
    .wb_badaddr_o      ( wb_badaddr      ),
    .dmem_ack_i        ( dmem_ack        ),
    .dmem_err_i        ( dmem_err        ),
    .dmem_q_i          ( dmem_q          ),
    .dmem_misaligned_i ( dmem_misaligned ),
    .dmem_page_fault_i ( dmem_page_fault ),
    .wb_dst_o          ( wb_dst          ),
    .wb_r_o            ( wb_r            ),
    .wb_we_o           ( wb_we           )
  );

  assign rf_dst  [0] = wb_dst;
  assign rf_dstv [0] = wb_r;
  assign rf_we   [0] = wb_we;

  //Thread state
  riscv_state #(
    .XLEN                  ( XLEN                  ),
    .PC_INIT               ( PC_INIT               ),
    .HAS_FPU               ( HAS_FPU               ),
    .HAS_MMU               ( HAS_MMU               ),
    .HAS_USER              ( HAS_USER              ),
    .HAS_SUPER             ( HAS_SUPER             ),
    .HAS_HYPER             ( HAS_HYPER             ),

    .MNMIVEC_DEFAULT       ( MNMIVEC_DEFAULT       ),
    .MTVEC_DEFAULT         ( MTVEC_DEFAULT         ),
    .HTVEC_DEFAULT         ( HTVEC_DEFAULT         ),
    .STVEC_DEFAULT         ( STVEC_DEFAULT         ),
    .UTVEC_DEFAULT         ( UTVEC_DEFAULT         ),

    .JEDEC_BANK            ( JEDEC_BANK            ),
    .JEDEC_MANUFACTURER_ID ( JEDEC_MANUFACTURER_ID ),

    .PMP_CNT               ( PMP_CNT               ),
    .HARTID                ( HARTID                )
  )
  cpu_state (
    .rstn          ( rstn          ),
    .clk           ( clk           ),
    .id_pc         ( id_pc         ),
    .id_bubble     ( id_bubble     ),
    .id_instr      ( id_instr      ),
    .id_stall      ( id_stall      ),
    .bu_flush      ( bu_flush      ),
    .bu_nxt_pc     ( bu_nxt_pc     ),
    .st_flush      ( st_flush      ),
    .st_nxt_pc     ( st_nxt_pc     ),
    .wb_pc         ( wb_pc         ),
    .wb_bubble     ( wb_bubble     ),
    .wb_instr      ( wb_instr      ),
    .wb_exception  ( wb_exception  ),
    .wb_badaddr    ( wb_badaddr    ),
    .st_interrupt  ( st_interrupt  ),
    .st_prv        ( st_prv        ),
    .st_xlen       ( st_xlen       ),
    .st_tvm        ( st_tvm        ),
    .st_tw         ( st_tw         ),
    .st_tsr        ( st_tsr        ),
    .st_mcounteren ( st_mcounteren ),
    .st_scounteren ( st_scounteren ),
    .st_pmpcfg     ( st_pmpcfg     ),
    .st_pmpaddr    ( st_pmpaddr    ),
    .ext_int       ( ext_int       ),
    .ext_tint      ( ext_tint      ),
    .ext_sint      ( ext_sint      ),
    .ext_nmi       ( ext_nmi       ),
    .ex_csr_reg    ( ex_csr_reg    ),
    .ex_csr_we     ( ex_csr_we     ),
    .ex_csr_wval   ( ex_csr_wval   ),
    .st_csr_rval   ( st_csr_rval   ),
    .du_stall      ( du_stall      ),
    .du_flush      ( du_flush      ),
    .du_we_csr     ( du_we_csr     ),
    .du_dato       ( du_dato       ),
    .du_addr       ( du_addr       ),
    .du_ie         ( du_ie         ),
    .du_exceptions ( du_exceptions )
  );

  //Integer Register File
  riscv_rf #(
    .XLEN ( XLEN ),

    .AR_BITS ( AR_BITS ),

    .RDPORTS ( RDPORTS ),
    .WRPORTS ( WRPORTS )
  )
  rf_unit (
    .rstn       ( rstn       ),
    .clk        ( clk        ),
    .rf_src1    ( rf_src1    ),
    .rf_src2    ( rf_src2    ),
    .rf_srcv1   ( rf_srcv1   ),
    .rf_srcv2   ( rf_srcv2   ),
    .rf_dst     ( rf_dst     ),
    .rf_dstv    ( rf_dstv    ),
    .rf_we      ( rf_we      ),
    .du_stall   ( du_stall   ),
    .du_we_rf   ( du_we_rf   ),
    .du_dato    ( du_dato    ),
    .du_dati_rf ( du_dati_rf ),
    .du_addr    ( du_addr    )
  );

  //Branch Prediction Unit

  //Get Branch Prediction for Next Program Counter
  generate
    if (HAS_BPU == 0) begin
      assign bp_bp_predict = 2'b00;
    end
    else
      riscv_bp #(
        .XLEN ( XLEN ),

        .BP_GLOBAL_BITS    ( BP_GLOBAL_BITS ),
        .BP_LOCAL_BITS     ( BP_LOCAL_BITS ),
        .BP_LOCAL_BITS_LSB ( BP_LOCAL_BITS_LSB ),

        .TECHNOLOGY ( TECHNOLOGY ),

        .PC_INIT ( PC_INIT )
      )
      bp_unit(
        .rst_ni          ( rstn          ),
        .clk_i           ( clk           ),

        .id_stall_i      ( id_stall      ),
        .if_parcel_pc_i  ( if_parcel_pc  ),
        .bp_bp_predict_o ( bp_bp_predict ),

        .ex_pc_i         ( ex_pc ),
        .bu_bp_history_i ( bu_bp_history ),
        .bu_bp_predict_i ( bu_bp_predict ),      //prediction bits for branch
        .bu_bp_btaken_i  ( bu_bp_btaken  ),
        .bu_bp_update_i  ( bu_bp_update  )
      );
  endgenerate

  //Debug Unit
  riscv_du #(
    .XLEN ( XLEN ),
    .PLEN ( PLEN ),
    .ILEN ( ILEN ),

    .EXCEPTION_SIZE ( EXCEPTION_SIZE ),

    .DU_ADDR_SIZE    ( DU_ADDR_SIZE    ),
    .MAX_BREAKPOINTS ( MAX_BREAKPOINTS ),

    .BREAKPOINTS ( BREAKPOINTS )
  )
  du_unit (
    .rstn          ( rstn          ),
    .clk           ( clk           ),
    .dbg_stall     ( dbg_stall     ),
    .dbg_strb      ( dbg_strb      ),
    .dbg_we        ( dbg_we        ),
    .dbg_addr      ( dbg_addr      ),
    .dbg_dati      ( dbg_dati      ),
    .dbg_dato      ( dbg_dato      ),
    .dbg_ack       ( dbg_ack       ),
    .dbg_bp        ( dbg_bp        ),
    .du_stall      ( du_stall      ),
    .du_stall_dly  ( du_stall_dly  ),
    .du_flush      ( du_flush      ),
    .du_we_rf      ( du_we_rf      ),
    .du_we_frf     ( du_we_frf     ),
    .du_we_csr     ( du_we_csr     ),
    .du_we_pc      ( du_we_pc      ),
    .du_addr       ( du_addr       ),
    .du_dato       ( du_dato       ),
    .du_ie         ( du_ie         ),
    .du_dati_rf    ( du_dati_rf    ),
    .du_dati_frf   ( du_dati_frf   ),
    .st_csr_rval   ( st_csr_rval   ),
    .if_pc         ( if_pc         ),
    .id_pc         ( id_pc         ),
    .ex_pc         ( ex_pc         ),
    .bu_nxt_pc     ( bu_nxt_pc     ),
    .bu_flush      ( bu_flush      ),
    .st_flush      ( st_flush      ),
    .if_instr      ( if_instr      ),
    .mem_instr     ( mem_instr     ),
    .if_bubble     ( if_bubble     ),
    .mem_bubble    ( mem_bubble    ),
    .mem_exception ( mem_exception ),
    .mem_memadr    ( mem_memadr    ),
    .dmem_ack      ( dmem_ack      ),
    .ex_stall      ( ex_stall      ),
    .du_exceptions ( du_exceptions )
  );
endmodule
