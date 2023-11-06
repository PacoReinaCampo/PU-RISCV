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
//              Core - Instruction Memory Access Block                        //
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

import pu_riscv_verilog_pkg::*;
import peripheral_biu_verilog_pkg::*;

module pu_riscv_imem_ctrl #(
  parameter XLEN = 64,
  parameter PLEN = 64,

  parameter PARCEL_SIZE = 64,

  parameter HAS_RVC = 1,

  parameter PMA_CNT = 4,
  parameter PMP_CNT = 16,

  parameter ICACHE_SIZE        = 64,
  parameter ICACHE_BLOCK_SIZE  = 64,
  parameter ICACHE_WAYS        = 2,
  parameter ICACHE_REPLACE_ALG = 2,
  parameter ITCM_SIZE          = 0,

  parameter TECHNOLOGY = "GENERIC"
) (
  input wire rst_ni,
  input wire clk_i,

  // Configuration
  input wire [PMA_CNT-1:0][    13:0] pma_cfg_i,
  input      [PMA_CNT-1:0][XLEN-1:0] pma_adr_i,

  // CPU side
  input  wire [XLEN          -1:0] nxt_pc_i,
  output reg                       stall_nxt_pc_o,
  input  wire                      stall_i,
  input  wire                      flush_i,
  output reg  [XLEN          -1:0] parcel_pc_o,
  output reg  [PARCEL_SIZE   -1:0] parcel_o,
  output reg  [PARCEL_SIZE/16-1:0] parcel_valid_o,
  output reg                       err_o,
  output reg                       misaligned_o,
  output reg                       page_fault_o,
  input  wire                      cache_flush_i,
  input  wire                      dcflush_rdy_i,

  input      [PMP_CNT-1:0][     7:0] st_pmpcfg_i,
  input wire [PMP_CNT-1:0][XLEN-1:0] st_pmpaddr_i,
  input wire [        1:0]           st_prv_i,

  // BIU ports
  output reg                       biu_stb_o,
  input  wire                      biu_stb_ack_i,
  input  wire                      biu_d_ack_i,
  output reg  [PLEN          -1:0] biu_adri_o,
  input  wire [PLEN          -1:0] biu_adro_i,
  output reg  [               2:0] biu_size_o,
  output reg  [               2:0] biu_type_o,
  output reg                       biu_we_o,
  output reg                       biu_lock_o,
  output reg  [               2:0] biu_prot_o,
  output reg  [XLEN          -1:0] biu_d_o,
  input  wire [XLEN          -1:0] biu_q_i,
  input  wire                      biu_ack_i,
  input  wire                      biu_err_i
);

  //////////////////////////////////////////////////////////////////////////////
  // Constants
  //////////////////////////////////////////////////////////////////////////////

  localparam TID_SIZE = 3;

  localparam MUX_PORTS = (ICACHE_SIZE > 0) ? 2 : 1;

  localparam EXT = 0;
  localparam CACHE = 1;
  localparam TCM = 2;
  localparam SEL_EXT = (1 << EXT);
  localparam SEL_CACHE = (1 << CACHE);
  localparam SEL_TCM = (1 << TCM);

  //////////////////////////////////////////////////////////////////////////////
  // Variables
  //////////////////////////////////////////////////////////////////////////////

  // Buffered memory request signals
  // Virtual memory access signals
  logic                                              buf_req;
  logic                                              buf_ack;
  logic [                        XLEN-1:0]           buf_adr;
  logic [                        XLEN-1:0]           buf_adr_dly;
  logic [                             2:0]           buf_size;
  logic                                              buf_lock;
  logic [                             2:0]           buf_prot;

  logic                                              nxt_pc_queue_req;
  logic                                              nxt_pc_queue_empty;
  logic                                              nxt_pc_queue_full;

  // Misalignment check
  logic                                              misaligned;

  // MMU signals
  // Physical memory access signals
  logic                                              preq;
  logic [                        PLEN-1:0]           padr;
  logic [                             2:0]           psize;
  logic                                              plock;
  logic [                             2:0]           pprot;
  logic                                              page_fault;

  // from PMA check
  logic                                              pma_exception;
  logic                                              pma_misaligned;
  logic                                              is_cache_access;
  logic                                              is_ext_access;
  logic                                              ext_access_req;
  logic                                              is_tcm_access;

  // from PMP check
  logic                                              pmp_exception;

  // From Cache Controller Core
  logic [                 PARCEL_SIZE-1:0]           cache_q;
  logic                                              cache_ack;
  logic                                              cache_err;

  // From TCM
  logic [                        XLEN-1:0]           tcm_q;
  logic                                              tcm_ack;

  // From IO
  logic [                        XLEN-1:0]           ext_vadr;
  logic [                        XLEN-1:0]           ext_q;
  logic                                              ext_access_ack;  // address transfer acknowledge
  logic                                              ext_ack;  // data transfer acknowledge
  logic                                              ext_err;

  // BIU ports
  logic [                   MUX_PORTS-1:0]           biu_stb;
  logic [                   MUX_PORTS-1:0]           biu_stb_ack;
  logic [                   MUX_PORTS-1:0]           biu_d_ack;
  logic [                   MUX_PORTS-1:0][PLEN-1:0] biu_adro;
  logic [                   MUX_PORTS-1:0][PLEN-1:0] biu_adri;
  logic [                   MUX_PORTS-1:0][     2:0] biu_size;
  logic [                   MUX_PORTS-1:0][     2:0] biu_type;
  logic [                   MUX_PORTS-1:0]           biu_we;
  logic [                   MUX_PORTS-1:0]           biu_lock;
  logic [                   MUX_PORTS-1:0][     2:0] biu_prot;
  logic [                   MUX_PORTS-1:0][XLEN-1:0] biu_d;
  logic [                   MUX_PORTS-1:0][XLEN-1:0] biu_q;
  logic [                   MUX_PORTS-1:0]           biu_ack;
  logic [                   MUX_PORTS-1:0]           biu_err;

  // to CPU
  logic [              PARCEL_SIZE/16-1:0]           parcel_valid;

  logic [              XLEN          -1:0]           parcel_queue_d_pc;
  logic [              PARCEL_SIZE   -1:0]           parcel_queue_d_parcel;
  logic [              PARCEL_SIZE/16-1:0]           parcel_queue_d_valid;
  logic                                              parcel_queue_d_misaligned;
  logic                                              parcel_queue_d_page_fault;
  logic                                              parcel_queue_d_error;

  logic [              XLEN          -1:0]           parcel_queue_q_pc;
  logic [              PARCEL_SIZE   -1:0]           parcel_queue_q_parcel;
  logic [              PARCEL_SIZE/16-1:0]           parcel_queue_q_valid;
  logic                                              parcel_queue_q_misaligned;
  logic                                              parcel_queue_q_page_fault;
  logic                                              parcel_queue_q_error;

  logic [XLEN+PARCEL_SIZE*(1+1/16)+3 -1:0]           parcel_queue_d;
  logic [XLEN+PARCEL_SIZE*(1+1/16)+3 -1:0]           parcel_queue_q;

  logic                                              parcel_queue_empty;
  logic                                              parcel_queue_full;

  assign parcel_queue_d = {parcel_queue_d_pc, parcel_queue_d_parcel, parcel_queue_d_valid, parcel_queue_d_misaligned, parcel_queue_d_page_fault, parcel_queue_d_error};

  assign {parcel_queue_q_pc, parcel_queue_q_parcel, parcel_queue_q_valid, parcel_queue_q_misaligned, parcel_queue_q_page_fault, parcel_queue_q_error} = parcel_queue_q;

  //////////////////////////////////////////////////////////////////////////////
  // Module Body
  //////////////////////////////////////////////////////////////////////////////

  //  // For debugging
  //  int fd;
  //  initial fd = $fopen("memtrace.dat");

  //  logic [XLEN-1:0] adr_dly, d_dly;
  //  logic            we_dly;
  //  int n = 0;

  //  always @(posedge clk_i) begin
  //    if (buf_req) begin
  //      adr_dly <= buf_adr;
  //    end

  //    else if (mem_ack_o) begin
  //      n++;
  //      if (we_dly) $fdisplay (fd, "%0d, [%0x] <= %x", n, adr_dly, d_dly);
  //      else        $fdisplay (fd, "%0d, [%0x] == %x", n, adr_dly, mem_q_o);
  //    end
  //  end

  // Hookup Access Buffer
  pu_riscv_membuf #(
    .DEPTH(2),
    .DBITS(XLEN)
  ) nxt_pc_queue_inst (
    .rst_ni(rst_ni),
    .clk_i (clk_i),

    .clr_i(flush_i),
    .ena_i(1'b1),

    .req_i(~stall_nxt_pc_o),
    .d_i  (nxt_pc_i),

    .req_o(buf_req),
    .q_o  (buf_adr),
    .ack_i(buf_ack),

    .empty_o(),
    .full_o (nxt_pc_queue_full)
  );

  // stall nxt_pc when queues full, or when DCACHE is flushing
  assign stall_nxt_pc_o = nxt_pc_queue_full | parcel_queue_full | ~dcflush_rdy_i;

  assign buf_ack        = ext_access_ack | cache_ack | tcm_ack;
  assign buf_size       = WORD;
  assign buf_lock       = 1'b0;
  assign buf_prot       = (PROT_DATA | st_prv_i == PRV_U ? PROT_USER : PROT_PRIVILEGED);

  // Hookup misalignment check
  pu_riscv_memmisaligned #(
    .XLEN   (XLEN),
    .HAS_RVC(HAS_RVC)
  ) misaligned_inst (
    .clk_i        (clk_i),
    .instruction_i(1'b1),       // instruction access
    .req_i        (buf_req),
    .adr_i        (buf_adr),
    .size_i       (buf_size),
    .misaligned_o (misaligned)
  );

  /* Hookup MMU
   * TO-DO:
   */

  pu_riscv_mmu #(
    .XLEN(XLEN),
    .PLEN(PLEN)
  ) mmu_inst (
    .rst_ni(rst_ni),
    .clk_i (clk_i),
    .clr_i (flush_i),

    .vreq_i (buf_req),
    .vadr_i (buf_adr),
    .vsize_i(buf_size),
    .vlock_i(buf_lock),
    .vprot_i(buf_prot),
    .vwe_i  (1'b0),         // instructions only read
    .vd_i   ({XLEN{1'b0}}), // no write data

    .preq_o (preq),
    .padr_o (padr),
    .psize_o(psize),
    .plock_o(plock),
    .pprot_o(pprot),
    .pwe_o  (),
    .pd_o   (),
    .pq_i   ({XLEN{1'b0}}),
    .pack_i (1'b0),

    .page_fault_o(page_fault)
  );

  // Hookup Physical Memory Atrributes Unit
  pu_riscv_pmachk #(
    .XLEN   (XLEN),
    .PLEN   (PLEN),
    .PMA_CNT(PMA_CNT)
  ) pmachk_inst (
    // Configuration
    .pma_cfg_i(pma_cfg_i),
    .pma_adr_i(pma_adr_i),

    // misaligned
    .misaligned_i(misaligned),

    // Memory Access
    .instruction_i(1'b1),   // Instruction access
    .req_i        (preq),
    .adr_i        (padr),
    .size_i       (psize),
    .lock_i       (plock),
    .we_i         (1'b0),

    // Output
    .pma_o            (),
    .exception_o      (pma_exception),
    .misaligned_o     (pma_misaligned),
    .is_cache_access_o(is_cache_access),
    .is_ext_access_o  (is_ext_access),
    .is_tcm_access_o  (is_tcm_access)
  );

  // Hookup Physical Memory Protection Unit
  pu_riscv_pmpchk #(
    .XLEN   (XLEN),
    .PLEN   (PLEN),
    .PMP_CNT(PMP_CNT)
  ) pmpchk_inst (
    .st_pmpcfg_i (st_pmpcfg_i),
    .st_pmpaddr_i(st_pmpaddr_i),
    .st_prv_i    (st_prv_i),

    .instruction_i(1'b1),   // Instruction access
    .req_i        (preq),   // Memory access request
    .adr_i        (padr),   // Physical Memory address (i.e. after translation)
    .size_i       (psize),  // Transfer size
    .we_i         (1'b0),   // Read/Write enable

    .exception_o(pmp_exception)
  );

  // Hookup Cache, TCM, external-interface
  generate
    if (ICACHE_SIZE > 0) begin
      // Instantiate Data Cache Core
      pu_riscv_icache_core #(
        .XLEN(XLEN),
        .PLEN(XLEN),

        .PARCEL_SIZE(PARCEL_SIZE),

        .ICACHE_SIZE       (ICACHE_SIZE),
        .ICACHE_BLOCK_SIZE (ICACHE_BLOCK_SIZE),
        .ICACHE_WAYS       (ICACHE_WAYS),
        .ICACHE_REPLACE_ALG(ICACHE_REPLACE_ALG),

        .TECHNOLOGY(TECHNOLOGY)
      ) icache_inst (
        // common signals
        .rst_ni(rst_ni),
        .clk_i (clk_i),
        .clr_i (flush_i),

        // from MMU/PMA
        .mem_vreq_i(buf_req),
        .mem_preq_i(is_cache_access),
        .mem_vadr_i(buf_adr),
        .mem_padr_i(padr),
        .mem_size_i(buf_size),
        .mem_lock_i(buf_lock),
        .mem_prot_i(buf_prot),
        .mem_q_o   (cache_q),
        .mem_ack_o (cache_ack),
        .mem_err_o (cache_err),
        .flush_i   (cache_flush_i),
        .flushrdy_i(1'b1),             // handled by stall_nxt_pc

        // To BIU
        .biu_stb_o    (biu_stb[CACHE]),
        .biu_stb_ack_i(biu_stb_ack[CACHE]),
        .biu_d_ack_i  (biu_d_ack[CACHE]),
        .biu_adri_o   (biu_adri[CACHE]),
        .biu_adro_i   (biu_adro[CACHE]),
        .biu_size_o   (biu_size[CACHE]),
        .biu_type_o   (biu_type[CACHE]),
        .biu_lock_o   (biu_lock[CACHE]),
        .biu_prot_o   (biu_prot[CACHE]),
        .biu_we_o     (biu_we[CACHE]),
        .biu_d_o      (biu_d[CACHE]),
        .biu_q_i      (biu_q[CACHE]),
        .biu_ack_i    (biu_ack[CACHE]),
        .biu_err_i    (biu_err[CACHE])
      );
    end else begin  // No cache
      assign cache_q   = 'h0;
      assign cache_ack = 1'b0;
      assign cache_err = 1'b0;
    end

    // Instantiate TCM block
    if (ITCM_SIZE > 0) begin
    end else begin  // No TCM
      assign tcm_q   = 'h0;
      assign tcm_ack = 1'b0;
    end

    // Instantiate EXT block
    if (ICACHE_SIZE > 0) begin
      if (ITCM_SIZE > 0) begin
        assign ext_access_req = is_ext_access;
      end else begin
        assign ext_access_req = is_ext_access | is_tcm_access;
      end
    end else begin
      if (ITCM_SIZE > 0) begin
        assign ext_access_req = is_ext_access | is_cache_access;
      end else begin
        assign ext_access_req = is_ext_access | is_cache_access | is_tcm_access;
      end
    end

    pu_riscv_dext #(
      .XLEN (XLEN),
      .PLEN (PLEN),
      .DEPTH(2)
    ) dext_inst (
      .rst_ni(rst_ni),
      .clk_i (clk_i),
      .clr_i (flush_i),

      .mem_req_i    (ext_access_req),
      .mem_adr_i    (padr),
      .mem_size_i   (psize),
      .mem_type_i   (SINGLE),
      .mem_lock_i   (plock),
      .mem_prot_i   (pprot),
      .mem_we_i     (1'b0),
      .mem_d_i      ({XLEN{1'b0}}),
      .mem_adr_ack_o(ext_access_ack),
      .mem_adr_o    (),
      .mem_q_o      (ext_q),
      .mem_ack_o    (ext_ack),
      .mem_err_o    (ext_err),

      .biu_stb_o    (biu_stb[EXT]),
      .biu_stb_ack_i(biu_stb_ack[EXT]),
      .biu_adri_o   (biu_adri[EXT]),
      .biu_adro_i   (),
      .biu_size_o   (biu_size[EXT]),
      .biu_type_o   (biu_type[EXT]),
      .biu_lock_o   (biu_lock[EXT]),
      .biu_prot_o   (biu_prot[EXT]),
      .biu_we_o     (biu_we[EXT]),
      .biu_d_o      (biu_d[EXT]),
      .biu_q_i      (biu_q[EXT]),
      .biu_ack_i    (biu_ack[EXT]),
      .biu_err_i    (biu_err[EXT])
    );

    // store virtual addresses for external access
    pu_riscv_ram_queue #(
      .DEPTH                 (8),
      .DBITS                 (XLEN),
      .ALMOST_FULL_THRESHOLD (4),
      .ALMOST_EMPTY_THRESHOLD(0)
    ) ext_vadr_queue_inst (
      .rst_ni(rst_ni),
      .clk_i (clk_i),

      .clr_i(flush_i),
      .ena_i(1'b1),

      .we_i(ext_access_req),
      .d_i (buf_adr_dly),

      .re_i(ext_ack),
      .q_o (ext_vadr),

      .almost_empty_o(),
      .almost_full_o (),
      .empty_o       (),
      .full_o        ()   // stall access requests when full (AXI bus ...)
    );
  endgenerate

  // Hookup BIU mux
  pu_riscv_mux #(
    .XLEN (XLEN),
    .PLEN (PLEN),
    .PORTS(MUX_PORTS)
  ) pu_riscv_mux_inst (
    .rst_ni(rst_ni),
    .clk_i (clk_i),

    .biu_req_i    (biu_stb),      // access request
    .biu_req_ack_o(biu_stb_ack),  // access request acknowledge
    .biu_d_ack_o  (biu_d_ack),
    .biu_adri_i   (biu_adri),     // access start address
    .biu_adro_o   (biu_adro),     // transfer addresss
    .biu_size_i   (biu_size),     // access data size
    .biu_type_i   (biu_type),     // access burst type
    .biu_lock_i   (biu_lock),     // access locked access
    .biu_prot_i   (biu_prot),     // access protection bits
    .biu_we_i     (biu_we),       // access write enable
    .biu_d_i      (biu_d),        // access write data
    .biu_q_o      (biu_q),        // access read data
    .biu_ack_o    (biu_ack),      // transfer acknowledge
    .biu_err_o    (biu_err),      // transfer error

    .biu_req_o    (biu_stb_o),
    .biu_req_ack_i(biu_stb_ack_i),
    .biu_d_ack_i  (biu_d_ack_i),
    .biu_adri_o   (biu_adri_o),
    .biu_adro_i   (biu_adro_i),
    .biu_size_o   (biu_size_o),
    .biu_type_o   (biu_type_o),
    .biu_lock_o   (biu_lock_o),
    .biu_prot_o   (biu_prot_o),
    .biu_we_o     (biu_we_o),
    .biu_d_o      (biu_d_o),
    .biu_q_i      (biu_q_i),
    .biu_ack_i    (biu_ack_i),
    .biu_err_i    (biu_err_i)
  );

  // Results back to CPU
  assign parcel_valid = {2{ext_ack | cache_ack | tcm_ack}};

  // Instruction Queue
  always @(posedge clk_i) begin
    if (buf_req) begin
      buf_adr_dly <= buf_adr;
    end
  end

  assign parcel_queue_d_pc = ext_ack ? ext_vadr : buf_adr_dly;

  always @(*) begin
    case ({
      ext_ack, cache_ack, tcm_ack
    })
      3'b001:  parcel_queue_d_parcel = tcm_q;
      3'b010:  parcel_queue_d_parcel = cache_q;
      default: parcel_queue_d_parcel = ext_q >> (16 * parcel_queue_d_pc[1 +: $clog2(XLEN/16)]);
    endcase
  end

  assign parcel_queue_d_valid      = parcel_valid;
  assign parcel_queue_d_misaligned = pma_misaligned;
  assign parcel_queue_d_page_fault = page_fault;
  assign parcel_queue_d_error      = ext_err | cache_err | pma_exception | pmp_exception;

  // Instruction queue
  // Add some extra words for inflight instructions
  pu_riscv_ram_queue #(
    .DEPTH                 (8),
    .DBITS                 (XLEN + PARCEL_SIZE * (1 + 1 / 16) + 3),
    .ALMOST_FULL_THRESHOLD (4),
    .ALMOST_EMPTY_THRESHOLD(0)
  ) parcel_queue_inst (
    .rst_ni(rst_ni),
    .clk_i (clk_i),

    .clr_i(flush_i),
    .ena_i(1'b1),

    .we_i(|parcel_valid),
    .d_i (parcel_queue_d),

    .re_i(~parcel_queue_empty & ~stall_i),
    .q_o (parcel_queue_q),

    .almost_empty_o(),
    .almost_full_o (parcel_queue_full),
    .empty_o       (parcel_queue_empty),
    .full_o        ()
  );

  // CPU signals
  assign parcel_pc_o    = parcel_queue_q_pc;
  assign parcel_o       = parcel_queue_q_parcel;
  assign parcel_valid_o = parcel_queue_q_valid & ~{PARCEL_SIZE / 16{parcel_queue_empty}};
  assign misaligned_o   = parcel_queue_q_misaligned;
  assign page_fault_o   = parcel_queue_q_page_fault;
  assign err_o          = parcel_queue_q_error;
endmodule
