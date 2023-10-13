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
//              Core - Data Memory Access Block                               //
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

import pu_riscv_pkg::*;
import peripheral_biu_pkg::*;

module pu_riscv_dmem_ctrl #(
  parameter XLEN = 64,
  parameter PLEN = 64,

  parameter HAS_RVC = 1,

  parameter PMA_CNT = 4,
  parameter PMP_CNT = 16,

  parameter DCACHE_SIZE        = 64,
  parameter DCACHE_BLOCK_SIZE  = 64,
  parameter DCACHE_WAYS        = 2,
  parameter DCACHE_REPLACE_ALG = 2,
  parameter DTCM_SIZE          = 0,

  parameter TECHNOLOGY = "GENERIC"
) (
  input wire rst_ni,
  input wire clk_i,

  //Configuration
  input wire [PMA_CNT-1:0][    13:0] pma_cfg_i,
  input      [PMA_CNT-1:0][XLEN-1:0] pma_adr_i,

  //CPU side
  input  wire            mem_req_i,
  input  wire [XLEN-1:0] mem_adr_i,
  input  wire [     2:0] mem_size_i,
  input  wire            mem_lock_i,
  input  wire            mem_we_i,
  input  wire [XLEN-1:0] mem_d_i,
  output reg  [XLEN-1:0] mem_q_o,
  output reg             mem_ack_o,
  output reg             mem_err_o,
  output reg             mem_misaligned_o,
  output reg             mem_page_fault_o,
  input  wire            cache_flush_i,
  output reg             dcflush_rdy_o,

  input      [PMP_CNT-1:0][     7:0] st_pmpcfg_i,
  input wire [PMP_CNT-1:0][XLEN-1:0] st_pmpaddr_i,
  input wire [        1:0]           st_prv_i,

  //BIU ports
  output reg             biu_stb_o,
  input  wire            biu_stb_ack_i,
  input  wire            biu_d_ack_i,
  output reg  [PLEN-1:0] biu_adri_o,
  input  wire [PLEN-1:0] biu_adro_i,
  output reg  [     2:0] biu_size_o,
  output reg  [     2:0] biu_type_o,
  output reg             biu_we_o,
  output reg             biu_lock_o,
  output reg  [     2:0] biu_prot_o,
  output reg  [XLEN-1:0] biu_d_o,
  input  wire [XLEN-1:0] biu_q_i,
  input  wire            biu_ack_i,
  input  wire            biu_err_i
);

  //////////////////////////////////////////////////////////////////////////////
  //
  // Constants
  //

  localparam MUX_PORTS = (DCACHE_SIZE > 0) ? 2 : 1;

  localparam EXT = 0;
  localparam CACHE = 1;
  localparam TCM = 2;
  localparam SEL_EXT = (1 << EXT);
  localparam SEL_CACHE = (1 << CACHE);
  localparam SEL_TCM = (1 << TCM);

  //////////////////////////////////////////////////////////////////////////////
  //
  // Variables
  //

  //Buffered memory request signals
  //Virtual memory access signals
  logic [2*XLEN+5 -1:0]           queue_d;
  logic [2*XLEN+5 -1:0]           queue_q;

  logic                           buf_req;
  logic [     XLEN-1:0]           buf_adr;
  logic [          2:0]           buf_size;
  logic                           buf_lock;
  logic [          2:0]           buf_prot;
  logic                           buf_we;
  logic [     XLEN-1:0]           buf_d;

  //Misalignment check
  logic                           misaligned;

  //MMU signals
  //Physical memory access signals
  logic                           preq;
  logic [     PLEN-1:0]           padr;
  logic [          2:0]           psize;
  logic                           plock;
  logic [          2:0]           pprot;
  logic                           pwe;
  logic [     XLEN-1:0]           pd;

  //from PMA check
  logic                           pma_exception;
  logic                           is_cache_access;
  logic                           is_ext_access;
  logic                           ext_access_req;
  logic                           is_tcm_access;

  //from PMP check
  logic                           pmp_exception;

  //all exceptions
  logic                           exception;


  //From Cache Controller Core
  logic [     XLEN-1:0]           cache_q;
  logic                           cache_ack;
  logic                           cache_err;

  //From TCM
  logic [     XLEN-1:0]           tcm_q;
  logic                           tcm_ack;

  //From IO
  logic [     XLEN-1:0]           ext_q;
  logic                           ext_ack;
  logic                           ext_err;

  //BIU ports
  logic [MUX_PORTS-1:0]           biu_stb;
  logic [MUX_PORTS-1:0]           biu_stb_ack;
  logic [MUX_PORTS-1:0]           biu_d_ack;
  logic [MUX_PORTS-1:0][PLEN-1:0] biu_adro;
  logic [MUX_PORTS-1:0][PLEN-1:0] biu_adri;
  logic [MUX_PORTS-1:0][     2:0] biu_size;
  logic [MUX_PORTS-1:0][     2:0] biu_type;
  logic [MUX_PORTS-1:0]           biu_we;
  logic [MUX_PORTS-1:0]           biu_lock;
  logic [MUX_PORTS-1:0][     2:0] biu_prot;
  logic [MUX_PORTS-1:0][XLEN-1:0] biu_d;
  logic [MUX_PORTS-1:0][XLEN-1:0] biu_q;
  logic [MUX_PORTS-1:0]           biu_ack;
  logic [MUX_PORTS-1:0]           biu_err;

  //////////////////////////////////////////////////////////////////////////////
  //
  // Module Body
  //

//  //For debugging
//  int fd;
//  initial fd = $fopen("memtrace.dat");

//  logic [XLEN-1:0] adr_dly, d_dly;
//  logic            we_dly;
//  int n = 0;

//  always @(posedge clk_i) begin
//    if (buf_req) begin
//      adr_dly <= buf_adr;
//      d_dly   <= buf_d;
//      we_dly  <= buf_we;
//    end

//    else if (mem_ack_o) begin
//      n++;
//      if (we_dly) $fdisplay (fd, "%0d, [%0x] <= %x", n, adr_dly, d_dly);
//      else        $fdisplay (fd, "%0d, [%0x] == %x", n, adr_dly, mem_q_o);
//    end
//  end

  //Hookup Access Buffer

  //Queue Input Data
  assign queue_d[2*XLEN+4:XLEN+5] = mem_adr_i;
  assign queue_d[XLEN+4:XLEN+2]   = mem_size_i;
  assign queue_d[XLEN+1]          = mem_lock_i;
  assign queue_d[XLEN]            = mem_we_i;
  assign queue_d[XLEN-1:0]        = mem_d_i;

  pu_riscv_membuf #(
    .DEPTH(2),
    .DBITS(2 * XLEN + 5)
  ) membuf_inst (
    .rst_ni(rst_ni),
    .clk_i (clk_i),

    .clr_i(exception),
    .ena_i(1'b1),

    .req_i(mem_req_i),
    .d_i  (queue_d),

    .req_o(buf_req),
    .q_o  (queue_q),
    .ack_i(mem_ack_o),

    .empty_o(),
    .full_o ()
  );

  assign buf_adr  = queue_q[2*XLEN+4:XLEN+5];
  assign buf_size = queue_q[XLEN+4:XLEN+2];
  assign buf_lock = queue_q[XLEN+1];
  assign buf_we   = queue_q[XLEN];
  assign buf_d    = queue_q[XLEN-1:0];
  assign buf_prot = (PROT_DATA | st_prv_i == PRV_U ? PROT_USER : PROT_PRIVILEGED);

  //Hookup misalignment check
  pu_riscv_memmisaligned #(
    .XLEN   (XLEN),
    .HAS_RVC(HAS_RVC)
  ) misaligned_inst (
    .clk_i        (clk_i),
    .instruction_i(1'b0),       //data cache
    .req_i        (buf_req),
    .adr_i        (buf_adr),
    .size_i       (buf_size),
    .misaligned_o (misaligned)
  );

  /* Hookup MMU
   * TODO
   */

  pu_riscv_mmu #(
    .XLEN(XLEN),
    .PLEN(PLEN)
  ) mmu_inst (
    .rst_ni(rst_ni),
    .clk_i (clk_i),
    .clr_i (exception),

    .vreq_i (buf_req),
    .vadr_i (buf_adr),
    .vsize_i(buf_size),
    .vlock_i(buf_lock),
    .vprot_i(buf_prot),
    .vwe_i  (buf_we),
    .vd_i   (buf_d),

    .preq_o (preq),
    .padr_o (padr),
    .psize_o(psize),
    .plock_o(plock),
    .pprot_o(pprot),
    .pwe_o  (pwe),
    .pd_o   (pd),
    .pq_i   ({XLEN{1'b0}}),
    .pack_i (1'b0),

    .page_fault_o(mem_page_fault_o)
  );

  //Hookup Physical Memory Atrributes Unit
  pu_riscv_pmachk #(
    .XLEN   (XLEN),
    .PLEN   (PLEN),
    .PMA_CNT(PMA_CNT)
  ) pmachk_inst (
    //Configuration
    .pma_cfg_i(pma_cfg_i),
    .pma_adr_i(pma_adr_i),

    //misaligned
    .misaligned_i(misaligned),

    //Memory Access
    .instruction_i(1'b0),   //Data access
    .req_i        (preq),
    .adr_i        (padr),
    .size_i       (psize),
    .lock_i       (plock),
    .we_i         (pwe),

    //Output
    .pma_o            (),
    .exception_o      (pma_exception),
    .misaligned_o     (mem_misaligned_o),
    .is_cache_access_o(is_cache_access),
    .is_ext_access_o  (is_ext_access),
    .is_tcm_access_o  (is_tcm_access)
  );

  //Hookup Physical Memory Protection Unit
  pu_riscv_pmpchk #(
    .XLEN   (XLEN),
    .PLEN   (PLEN),
    .PMP_CNT(PMP_CNT)
  ) pmpchk_inst (
    .st_pmpcfg_i (st_pmpcfg_i),
    .st_pmpaddr_i(st_pmpaddr_i),
    .st_prv_i    (st_prv_i),

    .instruction_i(1'b0),   //This is a data access
    .req_i        (preq),   //Memory access request
    .adr_i        (padr),   //Physical Memory address (i.e. after translation)
    .size_i       (psize),  //Transfer size
    .we_i         (pwe),    //Read/Write enable

    .exception_o(pmp_exception)
  );

  //Hookup Cache, TCM, external-interface
  generate
    if (DCACHE_SIZE > 0) begin
      //Instantiate Data Cache Core
      pu_riscv_dcache_core #(
        .XLEN(XLEN),
        .PLEN(XLEN),

        .DCACHE_SIZE       (DCACHE_SIZE),
        .DCACHE_BLOCK_SIZE (DCACHE_BLOCK_SIZE),
        .DCACHE_WAYS       (DCACHE_WAYS),
        .DCACHE_REPLACE_ALG(DCACHE_REPLACE_ALG),

        .TECHNOLOGY(TECHNOLOGY)
      ) dcache_inst (
        //common signals
        .rst_ni(rst_ni),
        .clk_i (clk_i),

        //from MMU/PMA
        .mem_vreq_i(buf_req),
        .mem_preq_i(is_cache_access),
        .mem_vadr_i(mem_adr_i),        //TODO Shouldn't this be buf_adr ??
        .mem_padr_i(padr),
        .mem_size_i(buf_size),
        .mem_lock_i(buf_lock),
        .mem_prot_i(buf_prot),
        .mem_we_i  (buf_we),
        .mem_d_i   (buf_d),
        .mem_q_o   (cache_q),
        .mem_ack_o (cache_ack),
        .mem_err_o (cache_err),
        .flush_i   (cache_flush_i),
        .flushrdy_o(dcflush_rdy_o),

        //To BIU
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
    end else begin  //No cache
      assign cache_q       = 'h0;
      assign cache_ack     = 1'b0;
      assign cache_err     = 1'b0;
      assign dcflush_rdy_o = 1'b1;
    end

    /* Instantiate TCM block
     * TODO: speculative read (vmadr)
     *       needs write buffer (clear write when not qualified)
     */

    if (DTCM_SIZE > 0) begin
    end else begin  //No TCM
      assign tcm_q   = 'h0;
      assign tcm_ack = 1'b0;
    end

    //Instantiate EXT block
    if (DCACHE_SIZE > 0) begin
      if (DTCM_SIZE > 0) assign ext_access_req = is_ext_access;
      else assign ext_access_req = is_ext_access | is_tcm_access;
    end else begin
      if (DTCM_SIZE > 0) assign ext_access_req = is_ext_access | is_cache_access;
      else assign ext_access_req = is_ext_access | is_cache_access | is_tcm_access;
    end

    pu_riscv_dext #(
      .XLEN (XLEN),
      .PLEN (PLEN),
      .DEPTH(2)
    ) dext_inst (
      .rst_ni(rst_ni),
      .clk_i (clk_i),
      .clr_i (exception),

      .mem_req_i    (ext_access_req),
      .mem_adr_i    (padr),
      .mem_size_i   (psize),
      .mem_type_i   (SINGLE),
      .mem_lock_i   (plock),
      .mem_prot_i   (pprot),
      .mem_we_i     (pwe),
      .mem_d_i      (pd),
      .mem_adr_ack_o(),
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
  endgenerate

  //Hookup BIU mux
  pu_riscv_mux #(
    .XLEN (XLEN),
    .PLEN (PLEN),
    .PORTS(MUX_PORTS)
  ) pu_riscv_mux_inst (
    .rst_ni(rst_ni),
    .clk_i (clk_i),

    .biu_req_i    (biu_stb),      //access request
    .biu_req_ack_o(biu_stb_ack),  //access request acknowledge
    .biu_d_ack_o  (biu_d_ack),
    .biu_adri_i   (biu_adri),     //access start address
    .biu_adro_o   (biu_adro),     //transfer addresss
    .biu_size_i   (biu_size),     //access data size
    .biu_type_i   (biu_type),     //access burst type
    .biu_lock_i   (biu_lock),     //access locked access
    .biu_prot_i   (biu_prot),     //access protection bits
    .biu_we_i     (biu_we),       //access write enable
    .biu_d_i      (biu_d),        //access write data
    .biu_q_o      (biu_q),        //access read data
    .biu_ack_o    (biu_ack),      //transfer acknowledge
    .biu_err_o    (biu_err),      //transfer error

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

  //Results back to CPU
  assign mem_ack_o = ext_ack | cache_ack | tcm_ack;
  assign mem_err_o = ext_err | cache_err | pma_exception | pmp_exception;

  always @(*) begin
    case ({
      ext_ack, cache_ack, tcm_ack
    })
      3'b001:  mem_q_o = tcm_q;
      3'b010:  mem_q_o = cache_q;
      default: mem_q_o = ext_q;
    endcase
  end

  //All exceptions
  assign exception = mem_misaligned_o | mem_err_o | mem_page_fault_o;
endmodule
