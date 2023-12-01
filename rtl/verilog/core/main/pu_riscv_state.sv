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
//              Core - State Unit                                             //
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
//   Paco Reina Campo <pacoreinacampo@queenfield.tech>

import pu_riscv_verilog_pkg::*;

module pu_riscv_state #(
  parameter            XLEN           = 64,
  parameter            FLEN           = 64,
  parameter            ILEN           = 64,
  parameter            EXCEPTION_SIZE = 16,
  parameter [XLEN-1:0] PC_INIT        = 'h200,

  parameter IS_RV32E = 0,
  parameter HAS_RVN  = 1,
  parameter HAS_RVC  = 1,
  parameter HAS_FPU  = 1,
  parameter HAS_MMU  = 1,
  parameter HAS_RVM  = 1,
  parameter HAS_RVA  = 1,
  parameter HAS_RVB  = 1,
  parameter HAS_RVT  = 1,
  parameter HAS_RVP  = 1,
  parameter HAS_EXT  = 1,

  parameter HAS_USER  = 1,
  parameter HAS_SUPER = 1,
  parameter HAS_HYPER = 1,

  parameter MNMIVEC_DEFAULT = PC_INIT - 'h004,
  parameter MTVEC_DEFAULT   = PC_INIT - 'h040,
  parameter HTVEC_DEFAULT   = PC_INIT - 'h080,
  parameter STVEC_DEFAULT   = PC_INIT - 'h0C0,
  parameter UTVEC_DEFAULT   = PC_INIT - 'h100,

  parameter JEDEC_BANK            = 9,
  parameter JEDEC_MANUFACTURER_ID = 'h8a,

  parameter PMP_CNT = 16,  // number of PMP CSR blocks (max.16)
  parameter HARTID  = 0    // hardware thread-id
) (
  input rstn,
  input clk,

  input [XLEN-1:0] id_pc,
  input            id_bubble,
  input [ILEN-1:0] id_instr,
  input            id_stall,

  input                 bu_flush,
  input      [XLEN-1:0] bu_nxt_pc,
  output reg            st_flush,
  output reg [XLEN-1:0] st_nxt_pc,

  input [XLEN          -1:0] wb_pc,
  input                      wb_bubble,
  input [ILEN          -1:0] wb_instr,
  input [EXCEPTION_SIZE-1:0] wb_exception,
  input [XLEN          -1:0] wb_badaddr,

  output reg                         st_interrupt,
  output reg [        1:0]           st_prv,         // Privilege level
  output reg [        1:0]           st_xlen,        // Active Architecture
  output                             st_tvm,         // trap on satp access or SFENCE.VMA
  output                             st_tw,          // trap on WFI (after time >=0)
  output                             st_tsr,         // trap SRET
  output     [XLEN   -1:0]           st_mcounteren,
  output     [XLEN   -1:0]           st_scounteren,
  output     [PMP_CNT-1:0][     7:0] st_pmpcfg,
  output     [PMP_CNT-1:0][XLEN-1:0] st_pmpaddr,

  // interrupts (3=M-mode, 0=U-mode)
  input [3:0] ext_int,   // external interrupt (per privilege mode; determined by PIC)
  input       ext_tint,  // machine timer interrupt
  input       ext_sint,  // machine software interrupt (for ipi)
  input       ext_nmi,   // non-maskable interrupt

  // CSR interface
  input      [              11:0] ex_csr_reg,
  input                           ex_csr_we,
  input      [XLEN          -1:0] ex_csr_wval,
  output reg [XLEN          -1:0] st_csr_rval,

  // Debug interface
  input             du_stall,
  input             du_flush,
  input             du_we_csr,
  input  [XLEN-1:0] du_dato,       // output from debug unit
  input  [    11:0] du_addr,
  input  [    31:0] du_ie,
  output [    31:0] du_exceptions
);
  //////////////////////////////////////////////////////////////////////////////
  // Constants
  //////////////////////////////////////////////////////////////////////////////

  localparam EXT_XLEN = (XLEN > 32) ? XLEN - 32 : 32;

  //////////////////////////////////////////////////////////////////////////////
  // Functions
  //////////////////////////////////////////////////////////////////////////////

  function [3:0] get_trap_cause;
    input [EXCEPTION_SIZE-1:0] exception;
    integer n;

    get_trap_cause = 0;

    for (n = 0; n < EXCEPTION_SIZE; n = n + 1) begin
      if (exception[n]) begin
        get_trap_cause = n;
      end
    end
  endfunction

  //////////////////////////////////////////////////////////////////////////////
  // Variables
  //////////////////////////////////////////////////////////////////////////////

  // Floating Point registers
  logic [      2 : 0]           csr_fcsr_rm;
  logic [      4 : 0]           csr_fcsr_flags;

  logic [      7 : 0]           csr_fcsr;

  // User trap setup
  logic [  XLEN -1:0]           csr_utvec;

  // User trap handler
  logic [  XLEN -1:0]           csr_uscratch;  // scratch register
  logic [  XLEN -1:0]           csr_uepc;  // exception program counter
  logic [  XLEN -1:0]           csr_ucause;  // trap cause
  logic [  XLEN -1:0]           csr_utval;  // bad address

  // Supervisor

  // Supervisor trap setup
  logic [  XLEN -1:0]           csr_stvec;  // trap handler base address
  logic [  XLEN -1:0]           csr_scounteren;  // Enable performance counters for lower privilege level
  logic [  XLEN -1:0]           csr_sedeleg;  // trap delegation register

  // Supervisor trap handler
  logic [  XLEN -1:0]           csr_sscratch;  // scratch register
  logic [  XLEN -1:0]           csr_sepc;  // exception program counter
  logic [  XLEN -1:0]           csr_scause;  // trap cause
  logic [  XLEN -1:0]           csr_stval;  // bad address

  // Supervisor protection and Translation
  logic [  XLEN -1:0]           csr_satp;  // Address translation & protection

  // Hypervisor
  // Hypervisor Trap Setup
  logic [   XLEN-1:0]           csr_htvec;  // trap handler base address
  logic [   XLEN-1:0]           csr_hedeleg;  // trap delegation register

  // Hypervisor trap handler
  logic [   XLEN-1:0]           csr_hscratch;  // scratch register
  logic [   XLEN-1:0]           csr_hepc;  // exception program counter
  logic [   XLEN-1:0]           csr_hcause;  // trap cause
  logic [   XLEN-1:0]           csr_htval;  // bad address

  // Hypervisor protection and Translation
  // TBD per spec v1.7, somewhat defined in 1.9, removed in 1.10

  // Machine
  logic [      7 : 0]           csr_mvendorid_bank;  // Vendor-ID
  logic [      6 : 0]           csr_mvendorid_offset;  // Vendor-ID

  logic [     14 : 0]           csr_mvendorid;

  logic [  XLEN -1:0]           csr_marchid;  // Architecture ID
  logic [  XLEN -1:0]           csr_mimpid;  // Revision number
  logic [  XLEN -1:0]           csr_mhartid;  // Hardware Thread ID

  // Machine Trap Setup
  logic                         csr_mstatus_sd;
  logic [      1 : 0]           csr_mstatus_sxl;  // S-Mode XLEN
  logic [      1 : 0]           csr_mstatus_uxl;  // U-Mode XLEN
  logic [      4 : 0]           csr_mstatus_vm;  // virtualisation management
  logic                         csr_mstatus_tsr;
  logic                         csr_mstatus_tw;
  logic                         csr_mstatus_tvm;
  logic                         csr_mstatus_mxr;
  logic                         csr_mstatus_sum;
  logic                         csr_mstatus_mprv;  // memory privilege

  logic [      1 : 0]           csr_mstatus_xs;  // user extension status
  logic [      1 : 0]           csr_mstatus_fs;  // floating point status

  logic [      1 : 0]           csr_mstatus_mpp;
  logic [      1 : 0]           csr_mstatus_hpp;  // previous privilege levels
  logic                         csr_mstatus_spp;  // supervisor previous privilege level
  logic                         csr_mstatus_mpie;
  logic                         csr_mstatus_hpie;
  logic                         csr_mstatus_spie;
  logic                         csr_mstatus_upie;  // previous interrupt enable bits
  logic                         csr_mstatus_mie;
  logic                         csr_mstatus_hie;
  logic                         csr_mstatus_sie;
  logic                         csr_mstatus_uie;  // interrupt enable bits (per privilege level) 

  logic [      1 : 0]           csr_misa_base;  // Machine ISA
  logic [     25 : 0]           csr_misa_extensions;

  logic [     28 : 0]           csr_misa;

  logic [  XLEN -1:0]           csr_mnmivec;  // ROALOGIC NMI handler base address
  logic [  XLEN -1:0]           csr_mtvec;  // trap handler base address
  logic [  XLEN -1:0]           csr_mcounteren;  // Enable performance counters for lower level
  logic [  XLEN -1:0]           csr_medeleg;  // Exception delegation
  logic [  XLEN -1:0]           csr_mideleg;  // Interrupt delegation

  logic                         csr_mie_meie;
  logic                         csr_mie_heie;
  logic                         csr_mie_seie;
  logic                         csr_mie_ueie;
  logic                         csr_mie_mtie;
  logic                         csr_mie_htie;
  logic                         csr_mie_stie;
  logic                         csr_mie_utie;
  logic                         csr_mie_msie;
  logic                         csr_mie_hsie;
  logic                         csr_mie_ssie;
  logic                         csr_mie_usie;

  logic [     11 : 0]           csr_mie;  // interrupt enable

  // Machine trap handler
  logic [  XLEN -1:0]           csr_mscratch;  // scratch register
  logic [  XLEN -1:0]           csr_mepc;  // exception program counter
  logic [  XLEN -1:0]           csr_mcause;  // trap cause
  logic [  XLEN -1:0]           csr_mtval;  // bad address

  logic                         csr_mip_meip;
  logic                         csr_mip_heip;
  logic                         csr_mip_seip;
  logic                         csr_mip_ueip;
  logic                         csr_mip_mtip;
  logic                         csr_mip_htip;
  logic                         csr_mip_stip;
  logic                         csr_mip_utip;
  logic                         csr_mip_msip;
  logic                         csr_mip_hsip;
  logic                         csr_mip_ssip;
  logic                         csr_mip_usip;

  logic [     11 : 0]           csr_mip;  // interrupt pending

  // Machine protection and Translation
  logic [PMP_CNT-1:0][     7:0] csr_pmpcfg;
  logic [PMP_CNT-1:0][XLEN-1:0] csr_pmpaddr;

  // Machine counters/Timers
  logic [     31 : 0]           csr_mcycle_h;  // timer for MCYCLE
  logic [     31 : 0]           csr_mcycle_l;  // timer for MCYCLE

  logic [     63 : 0]           csr_mcycle;

  logic [     31 : 0]           csr_minstret_h;  // instruction retire count for MINSTRET
  logic [     31 : 0]           csr_minstret_l;  // instruction retire count for MINSTRET

  logic [     63 : 0]           csr_minstret;

  logic                         is_rv32;
  logic                         is_rv32e;
  logic                         is_rv64;
  logic                         is_rv128;
  logic                         has_rvc;
  logic                         has_fpu;
  logic                         has_fpud;
  logic                         has_fpuq;
  logic                         has_decfpu;
  logic                         has_mmu;
  logic                         has_muldiv;
  logic                         has_amo;
  logic                         has_bm;
  logic                         has_tmem;
  logic                         has_simd;
  logic                         has_n;
  logic                         has_u;
  logic                         has_s;
  logic                         has_h;
  logic                         has_ext;

  logic [      127:0]           mstatus;  // mstatus is special (can be larger than 32bits)
  logic [        1:0]           uxl_wval;  // u/sxl are taken from bits 35:32
  logic [        1:0]           sxl_wval;  // and can only have limited values

  logic                         soft_seip;  // software supervisor-external-interrupt
  logic                         soft_ueip;  // software user-external-interrupt

  logic                         take_interrupt;

  logic [       11:0]           st_int;
  logic [        3:0]           interrupt_cause;
  logic [        3:0]           trap_cause;

  // Mux for debug-unit
  logic [       11:0]           csr_raddr;  // CSR read address
  logic [  XLEN -1:0]           csr_wval;  // CSR write value

  genvar idx;  // a-z are used by 'misa'

  //////////////////////////////////////////////////////////////////////////////
  // Body
  //////////////////////////////////////////////////////////////////////////////

  assign csr_fcsr = {csr_fcsr_rm, csr_fcsr_flags};
  assign csr_mvendorid = {csr_mvendorid_bank, csr_mvendorid_offset};
  assign csr_misa = {csr_misa_base, csr_misa_extensions};

  assign is_rv32 = (XLEN == 32);
  assign is_rv64 = (XLEN == 64);
  assign is_rv128 = (XLEN == 128);
  assign is_rv32e = (IS_RV32E != 0) & is_rv32;
  assign has_n = (HAS_RVN != 0) & has_u;
  assign has_u = (HAS_USER != 0);
  assign has_s = (HAS_SUPER != 0) & has_u;
  assign has_h = 1'b0;  // (HAS_HYPER  !=   0) & has_s;   // No Hypervisor

  assign has_rvc = (HAS_RVC != 0);
  assign has_fpu = (HAS_FPU != 0);
  assign has_fpuq = (FLEN == 128) & has_fpu;
  assign has_fpud = ((FLEN == 64) & has_fpu) | has_fpuq;
  assign has_decfpu = 1'b0;
  assign has_mmu = (HAS_MMU != 0) & has_s;
  assign has_muldiv = (HAS_RVM != 0);
  assign has_amo = (HAS_RVA != 0);
  assign has_bm = (HAS_RVB != 0);
  assign has_tmem = (HAS_RVT != 0);
  assign has_simd = (HAS_RVP != 0);
  assign has_ext = (HAS_EXT != 0);

  // Mux address/data for Debug-Unit access
  assign csr_raddr = du_stall ? du_addr : ex_csr_reg;
  assign csr_wval = du_stall ? du_dato : ex_csr_wval;

  // Priviliged Control Registers

  // mstatus has different values for RV32 and RV64/RV128
  // treat it here as though it is a 128bit register
  assign mstatus = {
    csr_mstatus_sd,
    {128 - 37{1'b0}},
    csr_mstatus_sxl,
    csr_mstatus_uxl,
    {9{1'b0}},
    csr_mstatus_tsr,
    csr_mstatus_tw,
    csr_mstatus_tvm,
    csr_mstatus_mxr,
    csr_mstatus_sum,
    csr_mstatus_mprv,
    csr_mstatus_xs,
    csr_mstatus_fs,
    csr_mstatus_mpp,
    2'b00,
    csr_mstatus_spp,
    csr_mstatus_mpie,
    1'b0,
    csr_mstatus_spie,
    csr_mstatus_upie,
    csr_mstatus_mie,
    1'b0,
    csr_mstatus_sie,
    csr_mstatus_uie
  };

  // Read
  always @(*) begin
    case (csr_raddr)
      // User
      USTATUS:  st_csr_rval = {mstatus[127], mstatus[XLEN-2:0]} & 'h11;
      UIE:      st_csr_rval = has_n ? csr_mie & 12'h111 : 'h0;
      UTVEC:    st_csr_rval = has_n ? csr_utvec : 'h0;
      USCRATCH: st_csr_rval = has_n ? csr_uscratch : 'h0;
      UEPC:     st_csr_rval = has_n ? csr_uepc : 'h0;
      UCAUSE:   st_csr_rval = has_n ? csr_ucause : 'h0;
      UTVAL:    st_csr_rval = has_n ? csr_utval : 'h0;
      UIP:      st_csr_rval = has_n ? csr_mip & csr_mideleg & 12'h111 : 'h0;

      FFLAGS:   st_csr_rval = has_fpu ? {{XLEN - $bits(csr_fcsr_flags) {1'b0}}, csr_fcsr_flags} : 'h0;
      FRM:      st_csr_rval = has_fpu ? {{XLEN - $bits(csr_fcsr_rm) {1'b0}}, csr_fcsr_rm} : 'h0;
      FCSR:     st_csr_rval = has_fpu ? {{XLEN - $bits(csr_fcsr) {1'b0}}, csr_fcsr} : 'h0;
      CYCLE:    st_csr_rval = csr_mcycle[XLEN-1:0];
      // TIME:     st_csr_rval = csr_timer[XLEN-1:0];
      INSTRET:  st_csr_rval = csr_minstret[XLEN-1:0];
      CYCLEH:   st_csr_rval = is_rv32 ? csr_mcycle_h : 'h0;
      // TIMEH:    st_csr_rval = is_rv32 ? csr_timer_h : 'h0;
      INSTRETH: st_csr_rval = is_rv32 ? csr_minstret_h : 'h0;

      // Supervisor
      SSTATUS:    st_csr_rval = {mstatus[127], mstatus[XLEN-2:0]} & (1 << XLEN - 1 | 2'b11 << 32 | 'hde133);
      STVEC:      st_csr_rval = has_s ? csr_stvec : 'h0;
      SCOUNTEREN: st_csr_rval = has_s ? csr_scounteren : 'h0;
      SIE:        st_csr_rval = has_s ? csr_mie & 12'h333 : 'h0;
      SEDELEG:    st_csr_rval = has_s ? csr_sedeleg : 'h0;
      SIDELEG:    st_csr_rval = has_s ? csr_mideleg & 12'h111 : 'h0;
      SSCRATCH:   st_csr_rval = has_s ? csr_sscratch : 'h0;
      SEPC:       st_csr_rval = has_s ? csr_sepc : 'h0;
      SCAUSE:     st_csr_rval = has_s ? csr_scause : 'h0;
      STVAL:      st_csr_rval = has_s ? csr_stval : 'h0;
      SIP:        st_csr_rval = has_s ? csr_mip & csr_mideleg & 12'h333 : 'h0;
      SATP:       st_csr_rval = has_s && has_mmu ? csr_satp : 'h0;

      // Hypervisor
      HSTATUS:  st_csr_rval = {mstatus[127], mstatus[XLEN-2:0]} & (1 << XLEN - 1 | 2'b11 << 32 | 'hde133);
      HTVEC:    st_csr_rval = has_h ? csr_htvec : 'h0;
      HIE:      st_csr_rval = has_h ? csr_mie & 12'h777 : 'h0;
      HEDELEG:  st_csr_rval = has_h ? csr_hedeleg : 'h0;
      HIDELEG:  st_csr_rval = has_h ? csr_mideleg & 12'h333 : 'h0;
      HSCRATCH: st_csr_rval = has_h ? csr_hscratch : 'h0;
      HEPC:     st_csr_rval = has_h ? csr_hepc : 'h0;
      HCAUSE:   st_csr_rval = has_h ? csr_hcause : 'h0;
      HTVAL:    st_csr_rval = has_h ? csr_htval : 'h0;
      HIP:      st_csr_rval = has_h ? csr_mip & csr_mideleg & 12'h777 : 'h0;

      // Machine
      MISA:       st_csr_rval = {csr_misa_base, {XLEN - $bits(csr_misa) {1'b0}}, csr_misa_extensions};
      MVENDORID:  st_csr_rval = {{XLEN - $bits(csr_mvendorid) {1'b0}}, csr_mvendorid};
      MARCHID:    st_csr_rval = csr_marchid;
      MIMPID:     st_csr_rval = is_rv32 ? csr_mimpid : {{XLEN - $bits(csr_mimpid) {1'b0}}, csr_mimpid};
      MHARTID:    st_csr_rval = csr_mhartid;
      MSTATUS:    st_csr_rval = {mstatus[127], mstatus[XLEN-2:0]};
      MTVEC:      st_csr_rval = csr_mtvec;
      MCOUNTEREN: st_csr_rval = csr_mcounteren;
      MNMIVEC:    st_csr_rval = csr_mnmivec;
      MEDELEG:    st_csr_rval = csr_medeleg;
      MIDELEG:    st_csr_rval = csr_mideleg;
      MIE:        st_csr_rval = csr_mie & 12'hFFF;
      MSCRATCH:   st_csr_rval = csr_mscratch;
      MEPC:       st_csr_rval = csr_mepc;
      MCAUSE:     st_csr_rval = csr_mcause;
      MTVAL:      st_csr_rval = csr_mtval;
      MIP:        st_csr_rval = csr_mip;
      PMPCFG0:    st_csr_rval = csr_pmpcfg[00];
      PMPCFG1:    st_csr_rval = is_rv32 ? csr_pmpcfg[04] : 'h0;
      PMPCFG2:    st_csr_rval = ~is_rv128 ? csr_pmpcfg[08] : 'h0;
      PMPCFG3:    st_csr_rval = is_rv32 ? csr_pmpcfg[12] : 'h0;
      PMPADDR0:   st_csr_rval = csr_pmpaddr[00];
      PMPADDR1:   st_csr_rval = csr_pmpaddr[01];
      PMPADDR2:   st_csr_rval = csr_pmpaddr[02];
      PMPADDR3:   st_csr_rval = csr_pmpaddr[03];
      PMPADDR4:   st_csr_rval = csr_pmpaddr[04];
      PMPADDR5:   st_csr_rval = csr_pmpaddr[05];
      PMPADDR6:   st_csr_rval = csr_pmpaddr[06];
      PMPADDR7:   st_csr_rval = csr_pmpaddr[07];
      PMPADDR8:   st_csr_rval = csr_pmpaddr[08];
      PMPADDR9:   st_csr_rval = csr_pmpaddr[09];
      PMPADDR10:  st_csr_rval = csr_pmpaddr[10];
      PMPADDR11:  st_csr_rval = csr_pmpaddr[11];
      PMPADDR12:  st_csr_rval = csr_pmpaddr[12];
      PMPADDR13:  st_csr_rval = csr_pmpaddr[13];
      PMPADDR14:  st_csr_rval = csr_pmpaddr[14];
      PMPADDR15:  st_csr_rval = csr_pmpaddr[15];
      MCYCLE:     st_csr_rval = csr_mcycle[XLEN-1:0];
      MINSTRET:   st_csr_rval = csr_minstret[XLEN-1:0];
      MCYCLEH:    st_csr_rval = is_rv32 ? csr_mcycle_h : 'h0;
      MINSTRETH:  st_csr_rval = is_rv32 ? csr_minstret_h : 'h0;

      default: st_csr_rval = 32'h0;
    endcase
  end

  //////////////////////////////////////////////////////////////////////////////
  // Machine registers
  //////////////////////////////////////////////////////////////////////////////
  assign csr_misa_base = is_rv128 ? RV128I : is_rv64 ? RV64I : RV32I;
  assign csr_misa_extensions = {
    1'b0,  // reserved
    1'b0,  // reserved
    has_ext,
    1'b0,  // reserved
    1'b0,  // reserved for vector extensions
    has_u,  // user mode supported
    has_tmem,
    has_s,  // supervisor mode supported
    1'b0,  // reserved
    has_fpuq,
    has_simd,
    1'b0,  // reserved
    has_n,
    has_muldiv,
    has_decfpu,
    1'b0,  // reserved
    1'b0,  // reserved for JIT
    ~is_rv32e,
    1'b0,  // reserved
    1'b0,  // additional extensions
    has_fpu,
    is_rv32e,
    has_fpud,
    has_rvc,
    has_bm,
    has_amo
  };

  assign csr_mvendorid_bank = JEDEC_BANK - 1;
  assign csr_mvendorid_offset = JEDEC_MANUFACTURER_ID[6:0];
  assign csr_marchid = (1 << (XLEN - 1)) | ARCHID;
  assign csr_mimpid[31:24] = REVPRV_MAJOR;
  assign csr_mimpid[23:16] = REVPRV_MINOR;
  assign csr_mimpid[15:8] = REVUSR_MAJOR;
  assign csr_mimpid[7:0] = REVUSR_MINOR;
  assign csr_mhartid = HARTID;

  // mstatus
  assign csr_mstatus_sd = &csr_mstatus_fs | &csr_mstatus_xs;

  assign st_tvm = csr_mstatus_tvm;
  assign st_tw = csr_mstatus_tw;
  assign st_tsr = csr_mstatus_tsr;

  generate
    if (XLEN == 128) begin
      assign sxl_wval = |csr_wval[35:34] ? csr_wval[35:34] : csr_mstatus_sxl;
      assign uxl_wval = |csr_wval[33:32] ? csr_wval[33:32] : csr_mstatus_uxl;
    end else if (XLEN == 64) begin
      assign sxl_wval = csr_wval[35:34] == RV32I || csr_wval[35:34] == RV64I ? csr_wval[35:34] : csr_mstatus_sxl;
      assign uxl_wval = csr_wval[33:32] == RV32I || csr_wval[33:32] == RV64I ? csr_wval[33:32] : csr_mstatus_uxl;
    end else begin
      assign sxl_wval = 2'b00;
      assign uxl_wval = 2'b00;
    end
  endgenerate

  always @(*) begin
    case (st_prv)
      PRV_S:   st_xlen = has_s ? csr_mstatus_sxl : csr_misa_base;
      PRV_U:   st_xlen = has_u ? csr_mstatus_uxl : csr_misa_base;
      default: st_xlen = csr_misa_base;
    endcase
  end

  always @(posedge clk, negedge rstn) begin
    if (!rstn) begin
      st_prv           <= PRV_M;  // start in machine mode
      st_nxt_pc        <= PC_INIT;
      st_flush         <= 1'b1;

      // csr_mstatus_vm   <= VM_MBARE;
      csr_mstatus_sxl  <= has_s ? csr_misa_base : 2'b00;
      csr_mstatus_uxl  <= has_u ? csr_misa_base : 2'b00;
      csr_mstatus_tsr  <= 1'b0;
      csr_mstatus_tw   <= 1'b0;
      csr_mstatus_tvm  <= 1'b0;
      csr_mstatus_mxr  <= 1'b0;
      csr_mstatus_sum  <= 1'b0;
      csr_mstatus_mprv <= 1'b0;
      csr_mstatus_xs   <= {2{has_ext}};
      csr_mstatus_fs   <= 2'b00;

      csr_mstatus_mpp  <= 2'h3;
      csr_mstatus_hpp  <= 2'h0;  // reserved
      csr_mstatus_spp  <= has_s;
      csr_mstatus_mpie <= 1'b0;
      csr_mstatus_hpie <= 1'b0;  // reserved
      csr_mstatus_spie <= 1'b0;
      csr_mstatus_upie <= 1'b0;
      csr_mstatus_mie  <= 1'b0;
      csr_mstatus_hie  <= 1'b0;  // reserved
      csr_mstatus_sie  <= 1'b0;
      csr_mstatus_uie  <= 1'b0;
    end else begin
      st_flush <= 1'b0;

      // write from EX, Machine Mode
      if ((ex_csr_we && ex_csr_reg == MSTATUS && st_prv == PRV_M) || (du_we_csr && du_addr == MSTATUS)) begin
        //            csr_mstatus_vm    <= csr_wval[28:24];
        csr_mstatus_sxl  <= has_s && XLEN > 32 ? sxl_wval : 2'b00;
        csr_mstatus_uxl  <= has_u && XLEN > 32 ? uxl_wval : 2'b00;
        csr_mstatus_tsr  <= has_s ? csr_wval[22] : 1'b0;
        csr_mstatus_tw   <= has_s ? csr_wval[21] : 1'b0;
        csr_mstatus_tvm  <= has_s ? csr_wval[20] : 1'b0;
        csr_mstatus_mxr  <= has_s ? csr_wval[19] : 1'b0;
        csr_mstatus_sum  <= has_s ? csr_wval[18] : 1'b0;
        csr_mstatus_mprv <= has_u ? csr_wval[17] : 1'b0;
        csr_mstatus_xs   <= has_ext ? csr_wval[16:15] : 2'b00;  // TO-DO:
        csr_mstatus_fs   <= has_s && has_fpu ? csr_wval[14:13] : 2'b00;  // TO-DO:

        csr_mstatus_mpp  <= csr_wval[12:11];
        csr_mstatus_hpp  <= 2'h0;  // reserved
        csr_mstatus_spp  <= has_s ? csr_wval[8] : 1'b0;
        csr_mstatus_mpie <= csr_wval[7];
        csr_mstatus_hpie <= 1'b0;  // reserved
        csr_mstatus_spie <= has_s ? csr_wval[5] : 1'b0;
        csr_mstatus_upie <= has_n ? csr_wval[4] : 1'b0;
        csr_mstatus_mie  <= csr_wval[3];
        csr_mstatus_hie  <= 1'b0;  // reserved
        csr_mstatus_sie  <= has_s ? csr_wval[1] : 1'b0;
        csr_mstatus_uie  <= has_n ? csr_wval[0] : 1'b0;
      end

      // Supervisor Mode access
      if (has_s) begin
        if ((ex_csr_we && ex_csr_reg == SSTATUS && st_prv >= PRV_S) || (du_we_csr && du_addr == SSTATUS)) begin
          csr_mstatus_uxl  <= uxl_wval;
          csr_mstatus_mxr  <= csr_wval[19];
          csr_mstatus_sum  <= csr_wval[18];
          csr_mstatus_xs   <= has_ext ? csr_wval[16:15] : 2'b00;  // TO-DO:
          csr_mstatus_fs   <= has_fpu ? csr_wval[14:13] : 2'b00;  // TO-DO:

          csr_mstatus_spp  <= csr_wval[7];
          csr_mstatus_spie <= csr_wval[5];
          csr_mstatus_upie <= has_n ? csr_wval[4] : 1'b0;
          csr_mstatus_sie  <= csr_wval[1];
          csr_mstatus_uie  <= csr_wval[0];
        end
      end

      // MRET,HRET,SRET,URET
      if (!id_bubble && !bu_flush && !du_stall) begin
        case (id_instr)
          // pop privilege stack
          MRET: begin
            // set privilege level
            st_prv           <= csr_mstatus_mpp;
            st_nxt_pc        <= csr_mepc;
            st_flush         <= 1'b1;

            // set MIE
            csr_mstatus_mie  <= csr_mstatus_mpie;
            csr_mstatus_mpie <= 1'b1;
            csr_mstatus_mpp  <= has_u ? PRV_U : PRV_M;
          end
          HRET: begin
            // set privilege level
            st_prv           <= csr_mstatus_hpp;
            st_nxt_pc        <= csr_hepc;
            st_flush         <= 1'b1;

            // set HIE
            csr_mstatus_hie  <= csr_mstatus_hpie;
            csr_mstatus_hpie <= 1'b1;
            csr_mstatus_hpp  <= has_u ? PRV_U : PRV_M;
          end
          SRET: begin
            // set privilege level
            st_prv           <= {1'b0, csr_mstatus_spp};
            st_nxt_pc        <= csr_sepc;
            st_flush         <= 1'b1;

            // set SIE
            csr_mstatus_sie  <= csr_mstatus_spie;
            csr_mstatus_spie <= 1'b1;
            csr_mstatus_spp  <= 1'b0;  // Must have User-mode. SPP is only 1 bit
          end
          URET: begin
            // set privilege level
            st_prv           <= PRV_U;
            st_nxt_pc        <= csr_uepc;
            st_flush         <= 1'b1;

            // set UIE
            csr_mstatus_uie  <= csr_mstatus_upie;
            csr_mstatus_upie <= 1'b1;
          end
        endcase
      end

      // push privilege stack
      if (ext_nmi) begin
        // NMI always at Machine-mode
        st_prv           <= PRV_M;
        st_nxt_pc        <= csr_mnmivec;
        st_flush         <= 1'b1;

        // store current state
        csr_mstatus_mpie <= csr_mstatus_mie;
        csr_mstatus_mie  <= 1'b0;
        csr_mstatus_mpp  <= st_prv;
      end else if (take_interrupt) begin
        st_flush <= ~du_stall & ~du_flush;

        // Check if interrupts are delegated
        if (has_n && st_prv == PRV_U && (st_int & csr_mideleg & 12'h111)) begin
          st_prv           <= PRV_U;
          st_nxt_pc        <= csr_utvec & ~'h3 + (csr_utvec[0] ? interrupt_cause << 2 : 0);

          csr_mstatus_upie <= csr_mstatus_uie;
          csr_mstatus_uie  <= 1'b0;
        end else if (has_s && st_prv >= PRV_S && (st_int & csr_mideleg & 12'h333)) begin
          st_prv           <= PRV_S;
          st_nxt_pc        <= csr_stvec & ~'h3 + (csr_stvec[0] ? interrupt_cause << 2 : 0);

          csr_mstatus_spie <= csr_mstatus_sie;
          csr_mstatus_sie  <= 1'b0;
          csr_mstatus_spp  <= st_prv[0];
        end else if (has_h && st_prv >= PRV_H && (st_int & csr_mideleg & 12'h777)) begin
          st_prv           <= PRV_H;
          st_nxt_pc        <= csr_htvec;

          csr_mstatus_hpie <= csr_mstatus_hie;
          csr_mstatus_hie  <= 1'b0;
          csr_mstatus_hpp  <= st_prv;
        end else begin
          st_prv           <= PRV_M;
          st_nxt_pc        <= csr_mtvec & ~'h3 + (csr_mtvec[0] ? interrupt_cause << 2 : 0);

          csr_mstatus_mpie <= csr_mstatus_mie;
          csr_mstatus_mie  <= 1'b0;
          csr_mstatus_mpp  <= st_prv;
        end
      end else if (|(wb_exception & ~du_ie[15:0])) begin
        st_flush <= 1'b1;

        if (has_n && st_prv == PRV_U && |(wb_exception & csr_medeleg)) begin
          st_prv           <= PRV_U;
          st_nxt_pc        <= csr_utvec;

          csr_mstatus_upie <= csr_mstatus_uie;
          csr_mstatus_uie  <= 1'b0;
        end else if (has_s && st_prv >= PRV_S && |(wb_exception & csr_medeleg)) begin
          st_prv           <= PRV_S;
          st_nxt_pc        <= csr_stvec;

          csr_mstatus_spie <= csr_mstatus_sie;
          csr_mstatus_sie  <= 1'b0;
          csr_mstatus_spp  <= st_prv[0];

        end else if (has_h && st_prv >= PRV_H && |(wb_exception & csr_medeleg)) begin
          st_prv           <= PRV_H;
          st_nxt_pc        <= csr_htvec;

          csr_mstatus_hpie <= csr_mstatus_hie;
          csr_mstatus_hie  <= 1'b0;
          csr_mstatus_hpp  <= st_prv;
        end else begin
          st_prv           <= PRV_M;
          st_nxt_pc        <= csr_mtvec & ~'h3;

          csr_mstatus_mpie <= csr_mstatus_mie;
          csr_mstatus_mie  <= 1'b0;
          csr_mstatus_mpp  <= st_prv;
        end
      end
    end
  end

  // mcycle, minstret
  generate
    if (XLEN == 32) begin
      always @(posedge clk, negedge rstn) begin
        if (!rstn) begin
          csr_mcycle   <= 'h0;
          csr_minstret <= 'h0;
        end else begin
          // cycle always counts (thread active time)
          if ((ex_csr_we && ex_csr_reg == MCYCLE && st_prv == PRV_M) || (du_we_csr && du_addr == MCYCLE)) begin
            csr_mcycle_l <= csr_wval;
          end else if ((ex_csr_we && ex_csr_reg == MCYCLEH && st_prv == PRV_M) || (du_we_csr && du_addr == MCYCLEH)) begin
            csr_mcycle_h <= csr_wval;
          end else begin
            csr_mcycle <= csr_mcycle + 'h1;
          end

          // instruction retire counter
          if ((ex_csr_we && ex_csr_reg == MINSTRET && st_prv == PRV_M) || (du_we_csr && du_addr == MINSTRET)) begin
            csr_minstret_l <= csr_wval;
          end else if ((ex_csr_we && ex_csr_reg == MINSTRETH && st_prv == PRV_M) || (du_we_csr && du_addr == MINSTRETH)) begin
            csr_minstret_h <= csr_wval;
          end else if (!wb_bubble) begin
            csr_minstret <= csr_minstret + 'h1;
          end
        end
      end
    end else begin  // (XLEN > 32) begin
      always @(posedge clk, negedge rstn) begin
        if (!rstn) begin
          csr_mcycle   <= 'h0;
          csr_minstret <= 'h0;
        end else begin
          // cycle always counts (thread active time)
          if ((ex_csr_we && ex_csr_reg == MCYCLE && st_prv == PRV_M) || (du_we_csr && du_addr == MCYCLE)) begin
            csr_mcycle <= csr_wval[63:0];
          end else begin
            csr_mcycle <= csr_mcycle + 'h1;
          end

          // instruction retire counter
          if ((ex_csr_we && ex_csr_reg == MINSTRET && st_prv == PRV_M) || (du_we_csr && du_addr == MINSTRET)) begin
            csr_minstret <= csr_wval[63:0];
          end else if (!wb_bubble) begin
            csr_minstret <= csr_minstret + 'h1;
          end
        end
      end
    end
  endgenerate

  // mnmivec - RoaLogic Extension
  always @(posedge clk, negedge rstn) begin
    if (!rstn) begin
      csr_mnmivec <= MNMIVEC_DEFAULT;
    end else if ((ex_csr_we && ex_csr_reg == MNMIVEC && st_prv == PRV_M) || (du_we_csr && du_addr == MNMIVEC)) begin
      csr_mnmivec <= {csr_wval[XLEN-1:2], 2'b00};
    end
  end

  // mtvec
  always @(posedge clk, negedge rstn) begin
    if (!rstn) begin
      csr_mtvec <= MTVEC_DEFAULT;
    end else if ((ex_csr_we && ex_csr_reg == MTVEC && st_prv == PRV_M) || (du_we_csr && du_addr == MTVEC)) begin
      csr_mtvec <= csr_wval & ~'h2;
    end
  end

  // mcounteren
  always @(posedge clk, negedge rstn) begin
    if (!rstn) begin
      csr_mcounteren <= 'h0;
    end else if ((ex_csr_we && ex_csr_reg == MCOUNTEREN && st_prv == PRV_M) || (du_we_csr && du_addr == MCOUNTEREN)) begin
      csr_mcounteren <= csr_wval & 'h7;
    end
  end

  assign st_mcounteren = csr_mcounteren;

  // medeleg, mideleg
  generate
    if (!HAS_HYPER && !HAS_SUPER && !HAS_USER) begin
      assign csr_medeleg = 0;
      assign csr_mideleg = 0;
    end else begin
      // medeleg
      always @(posedge clk, negedge rstn) begin
        if (!rstn) begin
          csr_medeleg <= 'h0;
        end else if ((ex_csr_we && ex_csr_reg == MEDELEG && st_prv == PRV_M) || (du_we_csr && du_addr == MEDELEG)) begin
          csr_medeleg <= csr_wval & {EXCEPTION_SIZE{1'b1}};
        end
      end

      // mideleg
      always @(posedge clk, negedge rstn) begin
        if (!rstn) begin
          csr_mideleg <= 'h0;
        end else if ((ex_csr_we && ex_csr_reg == MIDELEG && st_prv == PRV_M) || (du_we_csr && du_addr == MIDELEG)) begin
          csr_mideleg[SSI] <= has_s & csr_wval[SSI];
          csr_mideleg[USI] <= has_n & csr_wval[USI];
        end else if (has_h) begin
          if ((ex_csr_we && ex_csr_reg == HIDELEG && st_prv >= PRV_H) || (du_we_csr && du_addr == HIDELEG)) begin
            csr_mideleg[SSI] <= has_s & csr_wval[SSI];
            csr_mideleg[USI] <= has_n & csr_wval[USI];
          end
        end else if (has_s) begin
          if ((ex_csr_we && ex_csr_reg == SIDELEG && st_prv >= PRV_S) || (du_we_csr && du_addr == SIDELEG)) begin
            csr_mideleg[USI] <= has_n & csr_wval[USI];
          end
        end
      end
    end
  endgenerate

  // mip
  always @(posedge clk, negedge rstn) begin
    if (!rstn) begin
      csr_mip   <= 'h0;
      soft_seip <= 1'b0;
      soft_ueip <= 1'b0;
    end else begin
      // external interrupts
      csr_mip_meip <= ext_int[PRV_M];
      csr_mip_heip <= has_h & ext_int[PRV_H];
      csr_mip_seip <= has_s & (ext_int[PRV_S] | soft_seip);
      csr_mip_ueip <= has_n & (ext_int[PRV_U] | soft_ueip);

      // may only be written by M-mode
      if ((ex_csr_we & ex_csr_reg == MIP & st_prv == PRV_M) || (du_we_csr & du_addr == MIP)) begin
        soft_seip <= csr_wval[SEI] & has_s;
        soft_ueip <= csr_wval[UEI] & has_n;
      end

      // timer interrupts
      csr_mip_mtip <= ext_tint;

      // may only be written by M-mode
      if ((ex_csr_we & ex_csr_reg == MIP & st_prv == PRV_M) || (du_we_csr & du_addr == MIP)) begin
        csr_mip_htip <= csr_wval[HTI] & has_h;
        csr_mip_stip <= csr_wval[STI] & has_s;
        csr_mip_utip <= csr_wval[UTI] & has_n;
      end

      // software interrupts
      csr_mip_msip <= ext_sint;
      // Machine Mode write
      if ((ex_csr_we && ex_csr_reg == MIP && st_prv == PRV_M) || (du_we_csr && du_addr == MIP)) begin
        csr_mip_hsip <= csr_wval[HSI] & has_h;
        csr_mip_ssip <= csr_wval[SSI] & has_s;
        csr_mip_usip <= csr_wval[USI] & has_n;
      end else if (has_h) begin
        // Hypervisor Mode write
        if ((ex_csr_we && ex_csr_reg == HIP && st_prv >= PRV_H) || (du_we_csr && du_addr == HIP)) begin
          csr_mip_hsip <= csr_wval[HSI] & csr_mideleg[HSI];
          csr_mip_ssip <= csr_wval[SSI] & csr_mideleg[SSI] & has_s;
          csr_mip_usip <= csr_wval[USI] & csr_mideleg[USI] & has_n;
        end
      end else if (has_s) begin
        // Supervisor Mode write
        if ((ex_csr_we && ex_csr_reg == SIP && st_prv >= PRV_S) || (du_we_csr && du_addr == SIP)) begin
          csr_mip_ssip <= csr_wval[SSI] & csr_mideleg[SSI];
          csr_mip_usip <= csr_wval[USI] & csr_mideleg[USI] & has_n;
        end
      end else if (has_n) begin
        // User Mode write
        if ((ex_csr_we && ex_csr_reg == UIP) || (du_we_csr && du_addr == UIP)) begin
          csr_mip_usip <= csr_wval[USI] & csr_mideleg[USI];
        end
      end
    end
  end

  // mie
  always @(posedge clk, negedge rstn) begin
    if (!rstn) begin
      csr_mie <= 'h0;
    end else if ((ex_csr_we && ex_csr_reg == MIE && st_prv == PRV_M) || (du_we_csr && du_addr == MIE)) begin
      csr_mie_meie <= csr_wval[MEI];
      csr_mie_heie <= csr_wval[HEI] & has_h;
      csr_mie_seie <= csr_wval[SEI] & has_s;
      csr_mie_ueie <= csr_wval[UEI] & has_n;
      csr_mie_mtie <= csr_wval[MTI];
      csr_mie_htie <= csr_wval[HTI] & has_h;
      csr_mie_stie <= csr_wval[STI] & has_s;
      csr_mie_utie <= csr_wval[UTI] & has_n;
      csr_mie_msie <= csr_wval[MSI];
      csr_mie_hsie <= csr_wval[HSI] & has_h;
      csr_mie_ssie <= csr_wval[SSI] & has_s;
      csr_mie_usie <= csr_wval[USI] & has_n;
    end else if (has_h) begin
      if ((ex_csr_we && ex_csr_reg == HIE && st_prv >= PRV_H) || (du_we_csr && du_addr == HIE)) begin
        csr_mie_heie <= csr_wval[HEI];
        csr_mie_seie <= csr_wval[SEI] & has_s;
        csr_mie_ueie <= csr_wval[UEI] & has_n;
        csr_mie_htie <= csr_wval[HTI];
        csr_mie_stie <= csr_wval[STI] & has_s;
        csr_mie_utie <= csr_wval[UTI] & has_n;
        csr_mie_hsie <= csr_wval[HSI];
        csr_mie_ssie <= csr_wval[SSI] & has_s;
        csr_mie_usie <= csr_wval[USI] & has_n;
      end
    end else if (has_s) begin
      if ((ex_csr_we && ex_csr_reg == SIE && st_prv >= PRV_S) || (du_we_csr && du_addr == SIE)) begin
        csr_mie_seie <= csr_wval[SEI];
        csr_mie_ueie <= csr_wval[UEI] & has_n;
        csr_mie_stie <= csr_wval[STI];
        csr_mie_utie <= csr_wval[UTI] & has_n;
        csr_mie_ssie <= csr_wval[SSI];
        csr_mie_usie <= csr_wval[USI] & has_n;
      end
    end else if (has_n) begin
      if ((ex_csr_we && ex_csr_reg == UIE) || (du_we_csr && du_addr == UIE)) begin
        csr_mie_ueie <= csr_wval[UEI];
        csr_mie_utie <= csr_wval[UTI];
        csr_mie_usie <= csr_wval[USI];
      end
    end
  end

  // mscratch
  always @(posedge clk, negedge rstn) begin
    if (!rstn) begin
      csr_mscratch <= 'h0;
    end else if ((ex_csr_we && ex_csr_reg == MSCRATCH && st_prv == PRV_M) || (du_we_csr && du_addr == MSCRATCH)) begin
      csr_mscratch <= csr_wval;
    end
  end

  assign trap_cause          = get_trap_cause(wb_exception & ~du_ie[15:0]);

  // decode interrupts
  // priority external, software, timer
  assign st_int[CAUSE_MEINT] = (((st_prv < PRV_M) | (st_prv == PRV_M & csr_mstatus_mie)) & (csr_mip_meip & csr_mie_meie));
  assign st_int[CAUSE_HEINT] = (((st_prv < PRV_H) | (st_prv == PRV_H & csr_mstatus_hie)) & (csr_mip_heip & csr_mie_heie));
  assign st_int[CAUSE_SEINT] = (((st_prv < PRV_S) | (st_prv == PRV_S & csr_mstatus_sie)) & (csr_mip_seip & csr_mie_seie));
  assign st_int[CAUSE_UEINT] = ((st_prv == PRV_U & csr_mstatus_uie) & (csr_mip_ueip & csr_mie_ueie));

  assign st_int[CAUSE_MSINT] = (((st_prv < PRV_M) | (st_prv == PRV_M & csr_mstatus_mie)) & (csr_mip_msip & csr_mie_msie)) & ~st_int[CAUSE_MEINT];
  assign st_int[CAUSE_HSINT] = (((st_prv < PRV_H) | (st_prv == PRV_H & csr_mstatus_hie)) & (csr_mip_hsip & csr_mie_hsie)) & ~st_int[CAUSE_HEINT];
  assign st_int[CAUSE_SSINT] = (((st_prv < PRV_S) | (st_prv == PRV_S & csr_mstatus_sie)) & (csr_mip_ssip & csr_mie_ssie)) & ~st_int[CAUSE_SEINT];
  assign st_int[CAUSE_USINT] = ((st_prv == PRV_U & csr_mstatus_uie) & (csr_mip_usip & csr_mie_usie)) & ~st_int[CAUSE_UEINT];

  assign st_int[CAUSE_MTINT] = (((st_prv < PRV_M) | (st_prv == PRV_M & csr_mstatus_mie)) & (csr_mip_mtip & csr_mie_mtie)) & ~(st_int[CAUSE_MEINT] | st_int[CAUSE_MSINT]);
  assign st_int[CAUSE_HTINT] = (((st_prv < PRV_H) | (st_prv == PRV_H & csr_mstatus_hie)) & (csr_mip_htip & csr_mie_htie)) & ~(st_int[CAUSE_HEINT] | st_int[CAUSE_HSINT]);
  assign st_int[CAUSE_STINT] = (((st_prv < PRV_S) | (st_prv == PRV_S & csr_mstatus_sie)) & (csr_mip_stip & csr_mie_stie)) & ~(st_int[CAUSE_SEINT] | st_int[CAUSE_SSINT]);
  assign st_int[CAUSE_UTINT] = ((st_prv == PRV_U & csr_mstatus_uie) & (csr_mip_utip & csr_mie_utie)) & ~(st_int[CAUSE_UEINT] | st_int[CAUSE_USINT]);

  // interrupt cause priority
  always @(*) begin
    casex (st_int & ~du_ie[31:16])
      12'h??1: interrupt_cause = 0;
      12'h??2: interrupt_cause = 1;
      12'h??4: interrupt_cause = 2;
      12'h??8: interrupt_cause = 3;
      12'h?10: interrupt_cause = 4;
      12'h?20: interrupt_cause = 5;
      12'h?40: interrupt_cause = 6;
      12'h?80: interrupt_cause = 7;
      12'h100: interrupt_cause = 8;
      12'h200: interrupt_cause = 9;
      12'h400: interrupt_cause = 10;
      12'h800: interrupt_cause = 11;
      default: interrupt_cause = 0;
    endcase
  end

  assign take_interrupt = |(st_int & ~du_ie[31:16]);

  // for Debug Unit
  assign du_exceptions  = {{16 - $bits(st_int) {1'b0}}, st_int, {16 - $bits(wb_exception) {1'b0}}, wb_exception} & du_ie;

  // Update mepc and mcause
  always @(posedge clk, negedge rstn) begin
    if (!rstn) begin
      st_interrupt <= 'b0;

      csr_mepc     <= 'h0;
      csr_hepc     <= 'h0;
      csr_sepc     <= 'h0;
      csr_uepc     <= 'h0;

      csr_mcause   <= 'h0;
      csr_hcause   <= 'h0;
      csr_scause   <= 'h0;
      csr_ucause   <= 'h0;

      csr_mtval    <= 'h0;
      csr_htval    <= 'h0;
      csr_stval    <= 'h0;
      csr_utval    <= 'h0;
    end else begin
      // Write access to regs (lowest priority)
      if ((ex_csr_we && ex_csr_reg == MEPC && st_prv == PRV_M) || (du_we_csr && du_addr == MEPC)) begin
        csr_mepc <= {csr_wval[XLEN-1:2], csr_wval[1] & has_rvc, 1'b0};
      end

      if ((ex_csr_we && ex_csr_reg == HEPC && st_prv >= PRV_H) || (du_we_csr && du_addr == HEPC)) begin
        csr_hepc <= {csr_wval[XLEN-1:2], csr_wval[1] & has_rvc, 1'b0};
      end

      if ((ex_csr_we && ex_csr_reg == SEPC && st_prv >= PRV_S) || (du_we_csr && du_addr == SEPC)) begin
        csr_sepc <= {csr_wval[XLEN-1:2], csr_wval[1] & has_rvc, 1'b0};
      end

      if ((ex_csr_we && ex_csr_reg == UEPC && st_prv >= PRV_U) || (du_we_csr && du_addr == UEPC)) begin
        csr_uepc <= {csr_wval[XLEN-1:2], csr_wval[1] & has_rvc, 1'b0};
      end

      if ((ex_csr_we && ex_csr_reg == MCAUSE && st_prv == PRV_M) || (du_we_csr && du_addr == MCAUSE)) begin
        csr_mcause <= csr_wval;
      end

      if ((ex_csr_we && ex_csr_reg == HCAUSE && st_prv >= PRV_H) || (du_we_csr && du_addr == HCAUSE)) begin
        csr_hcause <= csr_wval;
      end

      if ((ex_csr_we && ex_csr_reg == SCAUSE && st_prv >= PRV_S) || (du_we_csr && du_addr == SCAUSE)) begin
        csr_scause <= csr_wval;
      end

      if ((ex_csr_we && ex_csr_reg == UCAUSE && st_prv >= PRV_U) || (du_we_csr && du_addr == UCAUSE)) begin
        csr_ucause <= csr_wval;
      end

      if ((ex_csr_we && ex_csr_reg == MTVAL && st_prv == PRV_M) || (du_we_csr && du_addr == MTVAL)) begin
        csr_mtval <= csr_wval;
      end

      if ((ex_csr_we && ex_csr_reg == HTVAL && st_prv >= PRV_H) || (du_we_csr && du_addr == HTVAL)) begin
        csr_htval <= csr_wval;
      end

      if ((ex_csr_we && ex_csr_reg == STVAL && st_prv >= PRV_S) || (du_we_csr && du_addr == STVAL)) begin
        csr_stval <= csr_wval;
      end

      if ((ex_csr_we && ex_csr_reg == UTVAL && st_prv >= PRV_U) || (du_we_csr && du_addr == UTVAL)) begin
        csr_utval <= csr_wval;
      end

      // Handle exceptions
      st_interrupt <= 1'b0;

      // priority external interrupts, software interrupts, timer interrupts, traps
      if (ext_nmi) begin  // TO-DO: doesn't this cause a deadlock? Need to hold of NMI once handled
        // NMI always at Machine Level
        st_interrupt <= 1'b1;
        csr_mepc     <= bu_flush ? bu_nxt_pc : id_pc;
        csr_mcause   <= (1 << (XLEN - 1)) | 'h0;  // Implementation dependent. '0' indicates 'unknown cause'
      end else if (take_interrupt) begin
        st_interrupt <= 1'b1;

        // Check if interrupts are delegated
        if (has_n && st_prv == PRV_U && (st_int & csr_mideleg & 12'h111)) begin
          csr_ucause <= (1 << (XLEN - 1)) | interrupt_cause;
          csr_uepc   <= id_pc;
        end else if (has_s && st_prv >= PRV_S && (st_int & csr_mideleg & 12'h333)) begin
          csr_scause <= (1 << (XLEN - 1)) | interrupt_cause;
          csr_sepc   <= id_pc;
        end else if (has_h && st_prv >= PRV_H && (st_int & csr_mideleg & 12'h777)) begin
          csr_hcause <= (1 << (XLEN - 1)) | interrupt_cause;
          csr_hepc   <= id_pc;
        end else begin
          csr_mcause <= (1 << (XLEN - 1)) | interrupt_cause;
          csr_mepc   <= id_pc;
        end
      end else if (|(wb_exception & ~du_ie[15:0])) begin
        // Trap
        if (has_n && st_prv == PRV_U && |(wb_exception & csr_medeleg)) begin
          csr_uepc   <= wb_pc;
          csr_ucause <= trap_cause;
          csr_utval  <= wb_badaddr;
        end else if (has_s && st_prv >= PRV_S && |(wb_exception & csr_medeleg)) begin
          csr_sepc   <= wb_pc;
          csr_scause <= trap_cause;

          if (wb_exception[CAUSE_ILLEGAL_INSTRUCTION]) begin
            csr_stval <= wb_instr;
          end else if (wb_exception[CAUSE_MISALIGNED_INSTRUCTION] || wb_exception[CAUSE_INSTRUCTION_ACCESS_FAULT] || wb_exception[CAUSE_INSTRUCTION_PAGE_FAULT] ||
                       wb_exception[CAUSE_MISALIGNED_LOAD       ] || wb_exception[CAUSE_LOAD_ACCESS_FAULT       ] || wb_exception[CAUSE_LOAD_PAGE_FAULT       ] ||
                       wb_exception[CAUSE_MISALIGNED_STORE      ] || wb_exception[CAUSE_STORE_ACCESS_FAULT      ] || wb_exception[CAUSE_STORE_PAGE_FAULT      ] ) begin
            csr_stval <= wb_badaddr;
          end
        end else if (has_h && st_prv >= PRV_H && |(wb_exception & csr_medeleg)) begin
          csr_hepc   <= wb_pc;
          csr_hcause <= trap_cause;

          if (wb_exception[CAUSE_ILLEGAL_INSTRUCTION]) begin
            csr_htval <= wb_instr;
          end else if (wb_exception[CAUSE_MISALIGNED_INSTRUCTION] || wb_exception[CAUSE_INSTRUCTION_ACCESS_FAULT] || wb_exception[CAUSE_INSTRUCTION_PAGE_FAULT] ||
                       wb_exception[CAUSE_MISALIGNED_LOAD       ] || wb_exception[CAUSE_LOAD_ACCESS_FAULT       ] || wb_exception[CAUSE_LOAD_PAGE_FAULT       ] ||
                       wb_exception[CAUSE_MISALIGNED_STORE      ] || wb_exception[CAUSE_STORE_ACCESS_FAULT      ] || wb_exception[CAUSE_STORE_PAGE_FAULT      ] ) begin
            csr_htval <= wb_badaddr;
          end
        end else begin
          csr_mepc   <= wb_pc;
          csr_mcause <= trap_cause;

          if (wb_exception[CAUSE_ILLEGAL_INSTRUCTION]) begin
            csr_mtval <= wb_instr;
          end else if (wb_exception[CAUSE_MISALIGNED_INSTRUCTION] || wb_exception[CAUSE_INSTRUCTION_ACCESS_FAULT] || wb_exception[CAUSE_INSTRUCTION_PAGE_FAULT] ||
                       wb_exception[CAUSE_MISALIGNED_LOAD       ] || wb_exception[CAUSE_LOAD_ACCESS_FAULT       ] || wb_exception[CAUSE_LOAD_PAGE_FAULT       ] ||
                       wb_exception[CAUSE_MISALIGNED_STORE      ] || wb_exception[CAUSE_STORE_ACCESS_FAULT      ] || wb_exception[CAUSE_STORE_PAGE_FAULT      ] ) begin
            csr_mtval <= wb_badaddr;
          end
        end
      end
    end
  end

  // Physical Memory Protection & Translation registers
  generate
    if (XLEN > 64) begin  // RV128
      for (idx = 0; idx < 16; idx = idx + 1) begin : gen_pmpcfg0
        if (idx < PMP_CNT) begin
          always @(posedge clk, negedge rstn) begin
            if (!rstn) begin
              csr_pmpcfg[idx] <= 'h0;
            end else if ((ex_csr_we && ex_csr_reg == PMPCFG0 && st_prv == PRV_M) || (du_we_csr && du_addr == PMPCFG0)) begin
              if (!csr_pmpcfg[idx][7]) begin
                csr_pmpcfg[idx] <= csr_wval[idx*8 +: 8] & PMPCFG_MASK;
              end
            end
          end
        end else begin
          assign csr_pmpcfg[idx] = 'h0;
        end
      end  // next idx

      // pmpaddr not defined for RV128 yet
    end else if (XLEN > 32) begin  // RV64 
      for (idx = 0; idx < 8; idx = idx + 1) begin : gen_pmpcfg0
        always @(posedge clk, negedge rstn) begin
          if (!rstn) begin
            csr_pmpcfg[idx] <= 'h0;
          end else if ((ex_csr_we && ex_csr_reg == PMPCFG0 && st_prv == PRV_M) || (du_we_csr && du_addr == PMPCFG0)) begin
            if (idx < PMP_CNT && !csr_pmpcfg[idx][7]) begin
              csr_pmpcfg[idx] <= csr_wval[0 + idx*8 +: 8] & PMPCFG_MASK;
            end
          end
        end
      end  // next idx

      for (idx = 8; idx < 16; idx = idx + 1) begin : gen_pmpcfg2
        always @(posedge clk, negedge rstn) begin
          if (!rstn) begin
            csr_pmpcfg[idx] <= 'h0;
          end else if ((ex_csr_we && ex_csr_reg == PMPCFG2 && st_prv == PRV_M) || (du_we_csr && du_addr == PMPCFG2)) begin
            if (idx < PMP_CNT && !csr_pmpcfg[idx][7]) begin
              csr_pmpcfg[idx] <= csr_wval[(idx-8)*8 +: 8] & PMPCFG_MASK;
            end
          end
        end
      end  // next idx

      for (idx = 0; idx < 16; idx = idx + 1) begin : gen_pmpaddr
        if (idx < PMP_CNT) begin
          if (idx == 15) begin
            always @(posedge clk, negedge rstn) begin
              if (!rstn) begin
                csr_pmpaddr[idx] <= 'h0;
              end else if ((ex_csr_we && ex_csr_reg == (PMPADDR0 + idx) && st_prv == PRV_M && !csr_pmpcfg[idx][7]) || (du_we_csr && du_addr == (PMPADDR0 + idx))) begin
                csr_pmpaddr[idx] <= {10'h0, csr_wval[53:0]};
              end
            end
          end else begin
            always @(posedge clk, negedge rstn) begin
              if (!rstn) begin
                csr_pmpaddr[idx] <= 'h0;
              end else if ((ex_csr_we && ex_csr_reg == (PMPADDR0 + idx) && st_prv == PRV_M && !csr_pmpcfg[idx][7] && !(csr_pmpcfg[idx+1][4:3] == TOR && csr_pmpcfg[idx+1][7])) || (du_we_csr && du_addr == (PMPADDR0 + idx))) begin
                csr_pmpaddr[idx] <= {10'h0, csr_wval[53:0]};
              end
            end
          end
        end else begin
          assign csr_pmpaddr[idx] = 'h0;
        end
      end  // next idx
    end else begin  // RV32
      for (idx = 0; idx < 4; idx = idx + 1) begin : gen_pmpcfg0
        always @(posedge clk, negedge rstn) begin
          if (!rstn) begin
            csr_pmpcfg[idx] <= 'h0;
          end else if ((ex_csr_we && ex_csr_reg == PMPCFG0 && st_prv == PRV_M) || (du_we_csr && du_addr == PMPCFG0)) begin
            if (idx < PMP_CNT && !csr_pmpcfg[idx][7]) begin
              csr_pmpcfg[idx] <= csr_wval[idx*8 +: 8] & PMPCFG_MASK;
            end
          end
        end
      end  // next idx

      for (idx = 4; idx < 8; idx = idx + 1) begin : gen_pmpcfg1
        always @(posedge clk, negedge rstn) begin
          if (!rstn) begin
            csr_pmpcfg[idx] <= 'h0;
          end else if ((ex_csr_we && ex_csr_reg == PMPCFG1 && st_prv == PRV_M) || (du_we_csr && du_addr == PMPCFG1)) begin
            if (idx < PMP_CNT && !csr_pmpcfg[idx][7]) begin
              csr_pmpcfg[idx] <= csr_wval[(idx-4)*8 +: 8] & PMPCFG_MASK;
            end
          end
        end
      end  // next idx

      for (idx = 8; idx < 12; idx = idx + 1) begin : gen_pmpcfg2
        always @(posedge clk, negedge rstn) begin
          if (!rstn) begin
            csr_pmpcfg[idx] <= 'h0;
          end else if ((ex_csr_we && ex_csr_reg == PMPCFG2 && st_prv == PRV_M) || (du_we_csr && du_addr == PMPCFG2)) begin
            if (idx < PMP_CNT && !csr_pmpcfg[idx][7]) begin
              csr_pmpcfg[idx] <= csr_wval[(idx-8)*8 +: 8] & PMPCFG_MASK;
            end
          end
        end
      end  // next idx

      for (idx = 12; idx < 16; idx = idx + 1) begin : gen_pmpcfg3
        always @(posedge clk, negedge rstn) begin
          if (!rstn) begin
            csr_pmpcfg[idx] <= 'h0;
          end else if ((ex_csr_we && ex_csr_reg == PMPCFG3 && st_prv == PRV_M) || (du_we_csr && du_addr == PMPCFG3)) begin
            if (idx < PMP_CNT && !csr_pmpcfg[idx][7]) begin
              csr_pmpcfg[idx] <= csr_wval[(idx-12)*8 +: 8] & PMPCFG_MASK;
            end
          end
        end
      end  // next idx

      for (idx = 0; idx < 16; idx = idx + 1) begin : gen_pmpaddr
        if (idx < PMP_CNT) begin
          if (idx == 15) begin
            always @(posedge clk, negedge rstn) begin
              if (!rstn) begin
                csr_pmpaddr[idx] <= 'h0;
              end else if ((ex_csr_we && ex_csr_reg == (PMPADDR0 + idx) && st_prv == PRV_M && !csr_pmpcfg[idx][7]) || (du_we_csr && du_addr == (PMPADDR0 + idx))) begin
                csr_pmpaddr[idx] <= csr_wval;
              end
            end
          end else begin
            always @(posedge clk, negedge rstn) begin
              if (!rstn) begin
                csr_pmpaddr[idx] <= 'h0;
              end else if ((ex_csr_we && ex_csr_reg == (PMPADDR0 + idx) && st_prv == PRV_M && !csr_pmpcfg[idx][7] && !(csr_pmpcfg[idx+1][4:3] == TOR && csr_pmpcfg[idx+1][7])) || (du_we_csr && du_addr == (PMPADDR0 + idx))) begin
                csr_pmpaddr[idx] <= csr_wval;
              end
            end
          end
        end else begin
          assign csr_pmpaddr[idx] = 'h0;
        end
      end  // next idx
    end
  endgenerate

  assign st_pmpcfg  = csr_pmpcfg;
  assign st_pmpaddr = csr_pmpaddr;

  //////////////////////////////////////////////////////////////////////////////
  // Supervisor Registers
  //
  generate
    if (HAS_SUPER) begin
      // stvec
      always @(posedge clk, negedge rstn) begin
        if (!rstn) begin
          csr_stvec <= STVEC_DEFAULT;
        end else if ((ex_csr_we && ex_csr_reg == STVEC && st_prv >= PRV_S) || (du_we_csr && du_addr == STVEC)) begin
          csr_stvec <= csr_wval & ~'h2;
        end
      end

      // scounteren
      always @(posedge clk, negedge rstn) begin
        if (!rstn) begin
          csr_scounteren <= 'h0;
        end else if ((ex_csr_we && ex_csr_reg == SCOUNTEREN && st_prv == PRV_M) || (du_we_csr && du_addr == SCOUNTEREN)) begin
          csr_scounteren <= csr_wval & 'h7;
        end
      end

      // sedeleg
      always @(posedge clk, negedge rstn) begin
        if (!rstn) begin
          csr_sedeleg <= 'h0;
        end else if ((ex_csr_we && ex_csr_reg == SEDELEG && st_prv >= PRV_S) || (du_we_csr && du_addr == SEDELEG)) begin
          csr_sedeleg <= csr_wval & ((1 << CAUSE_UMODE_ECALL) | (1 << CAUSE_SMODE_ECALL));
        end
      end

      // sscratch
      always @(posedge clk, negedge rstn) begin
        if (!rstn) begin
          csr_sscratch <= 'h0;
        end else if ((ex_csr_we && ex_csr_reg == SSCRATCH && st_prv >= PRV_S) || (du_we_csr && du_addr == SSCRATCH)) begin
          csr_sscratch <= csr_wval;
        end
      end

      // satp
      always @(posedge clk, negedge rstn) begin
        if (!rstn) begin
          csr_satp <= 'h0;
        end else if ((ex_csr_we && ex_csr_reg == SATP && st_prv >= PRV_S) || (du_we_csr && du_addr == SATP)) begin
          csr_satp <= ex_csr_wval;
        end
      end
    end else begin  // NO SUPERVISOR MODE
      assign csr_stvec      = 'h0;
      assign csr_scounteren = 'h0;
      assign csr_sedeleg    = 'h0;
      assign csr_sscratch   = 'h0;
      assign csr_satp       = 'h0;
    end
  endgenerate

  assign st_scounteren = csr_scounteren;

  //////////////////////////////////////////////////////////////////////////////
  // User Registers
  //////////////////////////////////////////////////////////////////////////////
  generate
    if (HAS_USER) begin
      // utvec
      always @(posedge clk, negedge rstn) begin
        if (!rstn) begin
          csr_utvec <= UTVEC_DEFAULT;
        end else if ((ex_csr_we && ex_csr_reg == UTVEC) || (du_we_csr && du_addr == UTVEC)) begin
          csr_utvec <= {csr_wval[XLEN-1:2], 2'b00};
        end
      end

      // uscratch
      always @(posedge clk, negedge rstn) begin
        if (!rstn) begin
          csr_uscratch <= 'h0;
        end else if ((ex_csr_we && ex_csr_reg == USCRATCH) || (du_we_csr && du_addr == USCRATCH)) begin
          csr_uscratch <= csr_wval;
        end
      end

      // Floating point registers
      if (HAS_FPU) begin
        // TO-DO:
      end
    end else begin  // NO USER MODE
      assign csr_utvec      = 'h0;
      assign csr_uscratch   = 'h0;

      assign csr_fcsr_rm    = 'h0;
      assign csr_fcsr_flags = 'h0;
    end
  endgenerate
endmodule
