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
//              Peripheral-NTM for MPSoC                                      //
//              Neural Turing Machine for MPSoC                               //
//                                                                            //
////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2022-2025 by the author(s)
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

`include "uvm_macros.svh"
import uvm_pkg::*;

`include "peripheral_uvm_interface.sv"
`include "peripheral_uvm_test.sv"

import pu_riscv_verilog_pkg::*;

module peripheral_uvm_testbench;

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

  ////////////////////////////////////////////////////////////////////////////////
  // Variables
  ////////////////////////////////////////////////////////////////////////////////

  logic                         HCLK;
  logic                         HRESETn;

  // Host Interface
  logic                         host_csr_req;
  logic                         host_csr_ack;
  logic                         host_csr_we;
  logic [   XLEN-1:0]           host_csr_tohost;
  logic [   XLEN-1:0]           host_csr_fromhost;

  // Unified memory interface
  logic [        1:0][     1:0] mem_htrans;
  logic [        1:0][     2:0] mem_hburst;
  logic [        1:0]           mem_hready;
  logic [        1:0]           mem_hresp;
  logic [        1:0][PLEN-1:0] mem_haddr;
  logic [        1:0][XLEN-1:0] mem_hwdata;
  logic [        1:0][XLEN-1:0] mem_hrdata;
  logic [        1:0][     2:0] mem_hsize;
  logic [        1:0]           mem_hwrite;

  //////////////////////////////////////////////////////////////////////////////
  // Body
  //////////////////////////////////////////////////////////////////////////////

  // Virtual interface
  peripheral_design_if vif (
    HCLK,
    HRESETn
  );

  // Define PMA regions

  // crt.0 (ROM) region
  assign vif.pma_adr[0] = TOHOST >> 2;
  assign vif.pma_cfg[0] = {MEM_TYPE_MAIN, 8'b1111_1000, AMO_TYPE_NONE, TOR};

  // TOHOST region
  assign vif.pma_adr[1] = ((TOHOST >> 2) & ~'hf) | 'h7;
  assign vif.pma_cfg[1] = {MEM_TYPE_IO, 8'b0100_0000, AMO_TYPE_NONE, NAPOT};

  // UART-Tx region
  assign vif.pma_adr[2] = UART_TX >> 2;
  assign vif.pma_cfg[2] = {MEM_TYPE_IO, 8'b0100_0000, AMO_TYPE_NONE, NA4};

  // RAM region
  assign vif.pma_adr[3] = 1 << 31;
  assign vif.pma_cfg[3] = {MEM_TYPE_MAIN, 8'b1111_0000, AMO_TYPE_NONE, TOR};

  // Hookup Device Under Test
  pu_riscv_ahb3 #(
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
    .HRESETn(vif.HRESETn),
    .HCLK   (vif.HCLK),

    .pma_cfg_i(vif.pma_cfg),
    .pma_adr_i(vif.pma_adr),

     // AHB3 instruction
    .ins_HSEL     (vif.ins_HSEL),
    .ins_HADDR    (vif.ins_HADDR),
    .ins_HWDATA   (vif.ins_HWDATA),
    .ins_HRDATA   (vif.ins_HRDATA),
    .ins_HWRITE   (vif.ins_HWRITE),
    .ins_HSIZE    (vif.ins_HSIZE),
    .ins_HBURST   (vif.ins_HBURST),
    .ins_HPROT    (vif.ins_HPROT),
    .ins_HTRANS   (vif.ins_HTRANS),
    .ins_HMASTLOCK(vif.ins_HMASTLOCK),
    .ins_HREADY   (vif.ins_HREADY),
    .ins_HRESP    (vif.ins_HRESP),

     // AHB3 data
    .dat_HSEL     (vif.dat_HSEL),
    .dat_HADDR    (vif.dat_HADDR),
    .dat_HWDATA   (vif.dat_HWDATA),
    .dat_HRDATA   (vif.dat_HRDATA),
    .dat_HWRITE   (vif.dat_HWRITE),
    .dat_HSIZE    (vif.dat_HSIZE),
    .dat_HBURST   (vif.dat_HBURST),
    .dat_HPROT    (vif.dat_HPROT),
    .dat_HTRANS   (vif.dat_HTRANS),
    .dat_HMASTLOCK(vif.dat_HMASTLOCK),
    .dat_HREADY   (vif.dat_HREADY),
    .dat_HRESP    (vif.dat_HRESP),

    // Interrupts
    .ext_nmi (1'b0),
    .ext_tint(1'b0),
    .ext_sint(1'b0),
    .ext_int (4'h0),

    // Debug Interface
    .dbg_stall(vif.dbg_stall),
    .dbg_strb (vif.dbg_strb),
    .dbg_we   (vif.dbg_we),
    .dbg_addr (vif.dbg_addr),
    .dbg_dati (vif.dbg_dati),
    .dbg_dato (vif.dbg_dato),
    .dbg_ack  (vif.dbg_ack),
    .dbg_bp   (vif.dbg_bp)
  );

  // Hookup Debug Unit
  pu_riscv_dbg_bfm #(
    .XLEN(XLEN),
    .PLEN(PLEN)
  ) dbg_ctrl (
    .rstn(HRESETn),
    .clk (HCLK),

    .cpu_bp_i   (vif.dbg_bp),
    .cpu_stall_o(vif.dbg_stall),
    .cpu_stb_o  (vif.dbg_strb),
    .cpu_we_o   (vif.dbg_we),
    .cpu_adr_o  (vif.dbg_addr),
    .cpu_dat_o  (vif.dbg_dati),
    .cpu_dat_i  (vif.dbg_dato),
    .cpu_ack_i  (vif.dbg_ack)
  );

  // bus <-> memory model connections
  assign mem_htrans[0]  = vif.ins_HTRANS;
  assign mem_hburst[0]  = vif.ins_HBURST;
  assign mem_haddr[0]   = vif.ins_HADDR;
  assign mem_hwrite[0]  = vif.ins_HWRITE;
  assign mem_hsize[0]   = 4'h0;
  assign mem_hwdata[0]  = {XLEN{1'b0}};
  assign vif.ins_HRDATA = mem_hrdata[0];
  assign vif.ins_HREADY = mem_hready[0];
  assign vif.ins_HRESP  = mem_hresp[0];

  assign mem_htrans[1]  = vif.dat_HTRANS;
  assign mem_hburst[1]  = vif.dat_HBURST;
  assign mem_haddr[1]   = vif.dat_HADDR;
  assign mem_hwrite[1]  = vif.dat_HWRITE;
  assign mem_hsize[1]   = vif.dat_HSIZE;
  assign mem_hwdata[1]  = vif.dat_HWDATA;
  assign vif.dat_HRDATA = mem_hrdata[1];
  assign vif.dat_HREADY = mem_hready[1];
  assign vif.dat_HRESP  = mem_hresp[1];

  // hookup memory model
  pu_riscv_memory_model_ahb3 #(
    .INIT_FILE(INIT_FILE)
  ) memory_model (
    .HRESETn(HRESETn),
    .HCLK   (HCLK),
    .HTRANS (mem_htrans),
    .HREADY (mem_hready),
    .HRESP  (mem_hresp),
    .HADDR  (mem_haddr),
    .HWRITE (mem_hwrite),
    .HSIZE  (mem_hsize),
    .HBURST (mem_hburst),
    .HWDATA (mem_hwdata),
    .HRDATA (mem_hrdata)
  );

  // Front-End Server
  generate
    if (HTIF) begin
      // Old HTIF interface
      pu_riscv_htif #(
        .XLEN(XLEN)
      ) htif_frontend (
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
      pu_riscv_mmio_if_ahb3 #(
        .HDATA_SIZE   (XLEN),
        .HADDR_SIZE   (PLEN),
        .CATCH_TEST   (TOHOST),
        .CATCH_UART_TX(UART_TX)
      ) mmio_if (
        .HRESETn  (HRESETn),
        .HCLK     (HCLK),
        .HTRANS   (vif.dat_HTRANS),
        .HWRITE   (vif.dat_HWRITE),
        .HSIZE    (vif.dat_HSIZE),
        .HBURST   (vif.dat_HBURST),
        .HADDR    (vif.dat_HADDR),
        .HWDATA   (vif.dat_HWDATA),
        .HRDATA   (),
        .HREADYOUT(),
        .HRESP    ()
      );
    end
  endgenerate

  // Generate clock
  always #1 HCLK = ~HCLK;

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

  initial begin
    // Passing the interface handle to lower heirarchy using set method
    uvm_config_db#(virtual peripheral_design_if)::set(uvm_root::get(), "*", "vif", vif);

    // Enable wave dump
    $dumpfile("dump.vcd");
    $dumpvars(0);
  end

  // Calling TestCase
  initial begin
  // TO-DO  run_test("base_test");
  end
endmodule
