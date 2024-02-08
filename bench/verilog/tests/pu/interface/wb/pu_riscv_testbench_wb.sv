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
//             Wishbone Bus Interface                                         //
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

module pu_riscv_testbench_wb;

  // core parameters
  parameter XLEN = 64;
  parameter PLEN = 64;  // 64bit address bus
  parameter PC_INIT = 'h8000_0000;  // Start here after reset
  parameter BASE = PC_INIT;  // offset where to load program in memory
  parameter HEX_FILE = "test.hex";
  parameter MEM_FILE = "test.mem";
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

  ////////////////////////////////////////////////////////////////////////////////
  // Variables
  //////////////////////////////////////////////////////////////////////////////

  genvar p;

  logic                         HCLK;
  logic                         HRESETn;

  // PMA configuration
  logic [PMA_CNT-1:0][    13:0] pma_cfg;
  logic [PMA_CNT-1:0][PLEN-1:0] pma_adr;

  // Instruction interface
  logic [   PLEN-1:0]           wb_ins_adr_i;
  logic [   XLEN-1:0]           wb_ins_dat_i;
  logic [        3:0]           wb_ins_sel_i;
  logic                         wb_ins_we_i;
  logic                         wb_ins_cyc_i;
  logic                         wb_ins_stb_i;
  logic [        2:0]           wb_ins_cti_i;
  logic [        1:0]           wb_ins_bte_i;
  logic [   XLEN-1:0]           wb_ins_dat_o;
  logic                         wb_ins_ack_o;
  logic                         wb_ins_err_o;
  logic [        2:0]           wb_ins_rty_o;

  // Data interface
  logic [   PLEN-1:0]           wb_dat_adr_i;
  logic [   XLEN-1:0]           wb_dat_dat_i;
  logic [        3:0]           wb_dat_sel_i;
  logic                         wb_dat_we_i;
  logic                         wb_dat_cyc_i;
  logic                         wb_dat_stb_i;
  logic [        2:0]           wb_dat_cti_i;
  logic [        1:0]           wb_dat_bte_i;
  logic [   XLEN-1:0]           wb_dat_dat_o;
  logic                         wb_dat_ack_o;
  logic                         wb_dat_err_o;
  logic [        2:0]           wb_dat_rty_o;

  // Debug Interface
  logic                         dbp_bp;
  logic                         dbg_stall;
  logic                         dbg_strb;
  logic                         dbg_ack;
  logic                         dbg_we;
  logic [   PLEN-1:0]           dbg_addr;
  logic [   XLEN-1:0]           dbg_dati;
  logic [   XLEN-1:0]           dbg_dato;

  // Host Interface
  logic                         host_csr_req;
  logic                         host_csr_ack;
  logic                         host_csr_we;
  logic [   XLEN-1:0]           host_csr_tohost;
  logic [   XLEN-1:0]           host_csr_fromhost;

  // Unified memory interface
  logic [        1:0][PLEN-1:0] wb_mem_adr_i;
  logic [        1:0][XLEN-1:0] wb_mem_dat_i;
  logic [        1:0][     3:0] wb_mem_sel_i;
  logic [        1:0]           wb_mem_we_i;
  logic [        1:0]           wb_mem_cyc_i;
  logic [        1:0]           wb_mem_stb_i;
  logic [        1:0][     2:0] wb_mem_cti_i;
  logic [        1:0][     1:0] wb_mem_bte_i;
  logic [        1:0][XLEN-1:0] wb_mem_dat_o;
  logic [        1:0]           wb_mem_ack_o;
  logic [        1:0]           wb_mem_err_o;
  logic [        1:0][     2:0] wb_mem_rty_o;

  //////////////////////////////////////////////////////////////////////////////
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

  // Hookup Device Under Test
  pu_riscv_wb #(
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
  assign wb_mem_adr_i[0] = wb_ins_adr_i;
  assign wb_mem_dat_i[0] = wb_ins_dat_i;
  assign wb_mem_sel_i[0] = wb_ins_sel_i;
  assign wb_mem_we_i[0]  = wb_ins_we_i;
  assign wb_mem_cyc_i[0] = wb_ins_cyc_i;
  assign wb_mem_stb_i[0] = wb_ins_stb_i;
  assign wb_mem_cti_i[0] = wb_ins_cti_i;
  assign wb_mem_bte_i[0] = wb_ins_bte_i;

  assign wb_ins_dat_o    = wb_mem_dat_o[0];
  assign wb_ins_ack_o    = wb_mem_ack_o[0];
  assign wb_ins_err_o    = wb_mem_err_o[0];
  assign wb_ins_rty_o    = wb_mem_rty_o[0];

  assign wb_mem_adr_i[1] = wb_dat_adr_i;
  assign wb_mem_dat_i[1] = wb_dat_dat_i;
  assign wb_mem_sel_i[1] = wb_dat_sel_i;
  assign wb_mem_we_i[1]  = wb_dat_we_i;
  assign wb_mem_cyc_i[1] = wb_dat_cyc_i;
  assign wb_mem_stb_i[1] = wb_dat_stb_i;
  assign wb_mem_cti_i[1] = wb_dat_cti_i;
  assign wb_mem_bte_i[1] = wb_dat_bte_i;

  assign wb_dat_dat_o    = wb_mem_dat_o[1];
  assign wb_dat_ack_o    = wb_mem_ack_o[1];
  assign wb_dat_err_o    = wb_mem_err_o[1];
  assign wb_dat_rty_o    = wb_mem_rty_o[1];

  // hookup memory model
  pu_riscv_memory_model_wb #(
    .HEX_FILE(HEX_FILE),
    .MEM_FILE(MEM_FILE)
  ) memory_model (
    .HRESETn(HRESETn),
    .HCLK   (HCLK),

    .wb_adr_i(wb_mem_adr_i),
    .wb_dat_i(wb_mem_dat_i),
    .wb_sel_i(wb_mem_sel_i),
    .wb_we_i (wb_mem_we_i),
    .wb_cyc_i(wb_mem_cyc_i),
    .wb_stb_i(wb_mem_stb_i),
    .wb_cti_i(wb_mem_cti_i),
    .wb_bte_i(wb_mem_bte_i),
    .wb_dat_o(wb_mem_dat_o),
    .wb_ack_o(wb_mem_ack_o),
    .wb_err_o(wb_mem_err_o),
    .wb_rty_o(wb_mem_rty_o)
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
      pu_riscv_mmio_if_wb #(
        .HDATA_SIZE   (XLEN),
        .HADDR_SIZE   (PLEN),
        .CATCH_TEST   (TOHOST),
        .CATCH_UART_TX(UART_TX)
      ) mmio_if (
        .HRESETn(HRESETn),
        .HCLK   (HCLK),

        .wb_adr_i(wb_dat_adr_i),
        .wb_dat_i(wb_dat_dat_i),
        .wb_sel_i(wb_dat_sel_i),
        .wb_we_i (wb_dat_we_i),
        .wb_cyc_i(wb_dat_cyc_i),
        .wb_stb_i(wb_dat_stb_i),
        .wb_cti_i(wb_dat_cti_i),
        .wb_bte_i(wb_dat_bte_i),
        .wb_dat_o(wb_dat_dat_o),
        .wb_ack_o(wb_dat_ack_o),
        .wb_err_o(wb_dat_err_o),
        .wb_rty_o(wb_dat_rty_o)
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
    $display("  Test   = %s", HEX_FILE);
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
    // memory_model.read_mem;

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
