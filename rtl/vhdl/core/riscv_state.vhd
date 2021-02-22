-- Converted from rtl/verilog/core/riscv_state.sv
-- by verilog2vhdl - QueenField

--//////////////////////////////////////////////////////////////////////////////
--                                            __ _      _     _               //
--                                           / _(_)    | |   | |              //
--                __ _ _   _  ___  ___ _ __ | |_ _  ___| | __| |              //
--               / _` | | | |/ _ \/ _ \ '_ \|  _| |/ _ \ |/ _` |              //
--              | (_| | |_| |  __/  __/ | | | | | |  __/ | (_| |              //
--               \__, |\__,_|\___|\___|_| |_|_| |_|\___|_|\__,_|              //
--                  | |                                                       //
--                  |_|                                                       //
--                                                                            //
--                                                                            //
--              MPSoC-RISCV CPU                                               //
--              Core - State Unit                                             //
--              AMBA3 AHB-Lite Bus Interface                                  //
--                                                                            //
--//////////////////////////////////////////////////////////////////////////////

-- Copyright (c) 2017-2018 by the author(s)
-- *
-- * Permission is hereby granted, free of charge, to any person obtaining a copy
-- * of this software and associated documentation files (the "Software"), to deal
-- * in the Software without restriction, including without limitation the rights
-- * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
-- * copies of the Software, and to permit persons to whom the Software is
-- * furnished to do so, subject to the following conditions:
-- *
-- * The above copyright notice and this permission notice shall be included in
-- * all copies or substantial portions of the Software.
-- *
-- * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
-- * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
-- * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
-- * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
-- * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
-- * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
-- * THE SOFTWARE.
-- *
-- * =============================================================================
-- * Author(s):
-- *   Paco Reina Campo <pacoreinacampo@queenfield.tech>
-- */

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.pu_riscv_pkg.all;
use work.vhdl_pkg.all;

entity riscv_state is
  generic (
    XLEN            : integer := 64;
    FLEN            : integer := 64;
    ILEN            : integer := 64;
    EXCEPTION_SIZE  : integer := 16;

    IS_RV32E        : std_logic := '0';
    HAS_RVN         : std_logic := '1';
    HAS_RVC         : std_logic := '1';
    HAS_FPU         : std_logic := '1';
    HAS_MMU         : std_logic := '1';
    HAS_RVM         : std_logic := '1';
    HAS_RVA         : std_logic := '1';
    HAS_RVB         : std_logic := '1';
    HAS_RVT         : std_logic := '1';
    HAS_RVP         : std_logic := '1';
    HAS_EXT         : std_logic := '1';

    HAS_USER        : std_logic := '1';
    HAS_SUPER       : std_logic := '1';
    HAS_HYPER       : std_logic := '1';

    PC_INIT         : std_logic_vector(63 downto 0) := X"0000000080000000";

    MNMIVEC_DEFAULT : std_logic_vector(63 downto 0) := X"0000000000000004";
    MTVEC_DEFAULT   : std_logic_vector(63 downto 0) := X"0000000000000040";
    HTVEC_DEFAULT   : std_logic_vector(63 downto 0) := X"0000000000000080";
    STVEC_DEFAULT   : std_logic_vector(63 downto 0) := X"00000000000000C0";
    UTVEC_DEFAULT   : std_logic_vector(63 downto 0) := X"0000000000000100";

    JEDEC_BANK            : integer := 10;
    JEDEC_MANUFACTURER_ID : std_logic_vector(7 downto 0) := X"6E";

    PMP_CNT               : integer := 16;
    HARTID                : integer := 0
  );
  port (
    rstn : in std_logic;
    clk  : in std_logic;

    id_pc     : in std_logic_vector(XLEN-1 downto 0);
    id_bubble : in std_logic;
    id_instr  : in std_logic_vector(63 downto 0);
    id_stall  : in std_logic;

    bu_flush  : in  std_logic;
    bu_nxt_pc : in  std_logic_vector(XLEN-1 downto 0);
    st_flush  : out std_logic;
    st_nxt_pc : out std_logic_vector(XLEN-1 downto 0);

    wb_pc        : in std_logic_vector(XLEN-1 downto 0);
    wb_bubble    : in std_logic;
    wb_instr     : in std_logic_vector(ILEN-1 downto 0);
    wb_exception : in std_logic_vector(EXCEPTION_SIZE-1 downto 0);
    wb_badaddr   : in std_logic_vector(XLEN-1 downto 0);

    st_interrupt  : out std_logic;
    st_prv        : out std_logic_vector(1 downto 0);  --Privilege level
    st_xlen       : out std_logic_vector(1 downto 0);  --Active Architecture
    st_tvm        : out std_logic;      --trap on satp access or SFENCE.VMA
    st_tw         : out std_logic;      --trap on WFI (after time >=0)
    st_tsr        : out std_logic;      --trap SRET
    st_mcounteren : out std_logic_vector(XLEN-1 downto 0);
    st_scounteren : out std_logic_vector(XLEN-1 downto 0);
    st_pmpcfg     : out std_logic_matrix(PMP_CNT-1 downto 0)(7 downto 0);
    st_pmpaddr    : out std_logic_matrix(PMP_CNT-1 downto 0)(PLEN-1 downto 0);

    --interrupts (3=M-mode, 0=U-mode)
    ext_int  : in std_logic_vector(3 downto 0);  --external interrupt (per privilege mode; determined by PIC)
    ext_tint : in std_logic;            --machine timer interrupt
    ext_sint : in std_logic;            --machine software interrupt (for ipi)
    ext_nmi  : in std_logic;            --non-maskable interrupt

    --CSR interface
    ex_csr_reg  : in  std_logic_vector(11 downto 0);
    ex_csr_we   : in  std_logic;
    ex_csr_wval : in  std_logic_vector(XLEN-1 downto 0);
    st_csr_rval : out std_logic_vector(XLEN-1 downto 0);

    --Debug interface
    du_stall      : in  std_logic;
    du_flush      : in  std_logic;
    du_we_csr     : in  std_logic;
    du_dato       : in  std_logic_vector(XLEN-1 downto 0);  --output from debug unit
    du_addr       : in  std_logic_vector(11 downto 0);
    du_ie         : in  std_logic_vector(31 downto 0);
    du_exceptions : out std_logic_vector(31 downto 0)
    );
end riscv_state;

architecture RTL of riscv_state is
  --//////////////////////////////////////////////////////////////
  --
  -- Constants
  --
  constant EXT_XLEN : integer := XLEN-32;

  --//////////////////////////////////////////////////////////////
  --
  -- Functions
  --
  function get_trap_cause (
    exception : std_logic_vector(EXCEPTION_SIZE-1 downto 0)
    ) return std_logic_vector is
    variable get_trap_cause_return : std_logic_vector(3 downto 0);
  begin
    get_trap_cause_return := "0000";

    for n in 0 to EXCEPTION_SIZE - 1 loop
      if (exception(n) = '1') then
        get_trap_cause_return := std_logic_vector(to_unsigned(n, 4));
      end if;
    end loop;
    return get_trap_cause_return;
  end get_trap_cause;

  --//////////////////////////////////////////////////////////////
  --
  -- Variables
  --
  --Floating point registers
  signal csr_fcsr_rm    : std_logic_vector(2 downto 0);
  signal csr_fcsr_flags : std_logic_vector(4 downto 0);

  signal csr_fcsr : std_logic_vector(7 downto 0);

  --User trap setup
  signal csr_utvec : std_logic_vector(XLEN-1 downto 0);

  signal csr_utvec_we : std_logic_vector(XLEN-1 downto 0);

  --User trap handler
  signal csr_uscratch : std_logic_vector(XLEN-1 downto 0);  --scratch register
  signal csr_uepc     : std_logic_vector(XLEN-1 downto 0);  --exception program counter
  signal csr_ucause   : std_logic_vector(XLEN-1 downto 0);  --trap cause
  signal csr_utval    : std_logic_vector(XLEN-1 downto 0);  --bad address

  --Supervisor

  --Supervisor trap setup
  signal csr_stvec      : std_logic_vector(XLEN-1 downto 0);  --trap handler base address
  signal csr_scounteren : std_logic_vector(XLEN-1 downto 0);  --Enable performance counters for lower privilege level
  signal csr_sedeleg    : std_logic_vector(XLEN-1 downto 0);  --trap delegation register

  signal csr_stvec_we : std_logic_vector(XLEN-1 downto 0);

  --Supervisor trap handler
  signal csr_sscratch : std_logic_vector(XLEN-1 downto 0);  --scratch register
  signal csr_sepc     : std_logic_vector(XLEN-1 downto 0);  --exception program counter
  signal csr_scause   : std_logic_vector(XLEN-1 downto 0);  --trap cause
  signal csr_stval    : std_logic_vector(XLEN-1 downto 0);  --bad address

  --Supervisor protection and Translation
  signal csr_satp : std_logic_vector(XLEN-1 downto 0);  --Address translation & protection

--  //Hypervisor
--  //Hypervisor Trap Setup
--  logic  [XLEN-1:0] csr_htvec;    //trap handler base address
--  logic  [XLEN-1:0] csr_hedeleg;  //trap delegation register
--
--  //Hypervisor trap handler
--  logic  [XLEN-1:0] csr_hscratch; //scratch register
--  logic  [XLEN-1:0] csr_hepc;     //exception program counter
--  logic  [XLEN-1:0] csr_hcause;   //trap cause
--  logic  [XLEN-1:0] csr_htval;    //bad address
--
--  //Hypervisor protection and Translation
--  //TBD per spec v1.7, somewhat defined in 1.9, removed in 1.10

  -- Machine
  signal csr_mvendorid_bank   : std_logic_vector(7 downto 0);  --Vendor-ID
  signal csr_mvendorid_offset : std_logic_vector(6 downto 0);  --Vendor-ID

  signal csr_mvendorid : std_logic_vector(14 downto 0);

  signal csr_marchid : std_logic_vector(XLEN-1 downto 0);  --Architecture ID
  signal csr_mimpid  : std_logic_vector(XLEN-1 downto 0);  --Revision number
  signal csr_mhartid : std_logic_vector(XLEN-1 downto 0);  --Hardware Thread ID

  --Machine Trap Setup
  signal csr_mstatus_sd   : std_logic;
  signal csr_mstatus_sxl  : std_logic_vector(1 downto 0);  --S-Mode XLEN
  signal csr_mstatus_uxl  : std_logic_vector(1 downto 0);  --U-Mode XLEN
  --logic  [4      :0] csr_mstatus_vm;   //virtualisation management
  signal csr_mstatus_tsr  : std_logic;
  signal csr_mstatus_tw   : std_logic;
  signal csr_mstatus_tvm  : std_logic;
  signal csr_mstatus_mxr  : std_logic;
  signal csr_mstatus_sum  : std_logic;
  signal csr_mstatus_mprv : std_logic;                     --memory privilege

  signal csr_mstatus_xs : std_logic_vector(1 downto 0);  --user extension status
  signal csr_mstatus_fs : std_logic_vector(1 downto 0);  --floating point status

  signal csr_mstatus_mpp  : std_logic_vector(1 downto 0);
  signal csr_mstatus_hpp  : std_logic_vector(1 downto 0);  --previous privilege levels
  signal csr_mstatus_spp  : std_logic;  --supervisor previous privilege level
  signal csr_mstatus_mpie : std_logic;
  signal csr_mstatus_hpie : std_logic;
  signal csr_mstatus_spie : std_logic;
  signal csr_mstatus_upie : std_logic;  --previous interrupt enable bits
  signal csr_mstatus_mie  : std_logic;
  signal csr_mstatus_hie  : std_logic;
  signal csr_mstatus_sie  : std_logic;
  signal csr_mstatus_uie  : std_logic;  --interrupt enable bits (per privilege level) 

  signal csr_misa_base       : std_logic_vector(1 downto 0);  --Machine ISA
  signal csr_misa_extensions : std_logic_vector(25 downto 0);

  signal csr_mnmivec    : std_logic_vector(XLEN-1 downto 0);  --ROALOGIC NMI handler base address
  signal csr_mtvec      : std_logic_vector(XLEN-1 downto 0);  --trap handler base address
  signal csr_mcounteren : std_logic_vector(XLEN-1 downto 0);  --Enable performance counters for lower level
  signal csr_medeleg    : std_logic_vector(XLEN-1 downto 0);  --Exception delegation
  signal csr_mideleg    : std_logic_vector(XLEN-1 downto 0);  --Interrupt delegation

  signal csr_mtvec_we : std_logic_vector(XLEN-1 downto 0);

  signal csr_mie_meie : std_logic;
  signal csr_mie_heie : std_logic;
  signal csr_mie_seie : std_logic;
  signal csr_mie_ueie : std_logic;
  signal csr_mie_mtie : std_logic;
  signal csr_mie_htie : std_logic;
  signal csr_mie_stie : std_logic;
  signal csr_mie_utie : std_logic;
  signal csr_mie_msie : std_logic;
  signal csr_mie_hsie : std_logic;
  signal csr_mie_ssie : std_logic;
  signal csr_mie_usie : std_logic;

  --interrupt enable
  signal csr_mie      : std_logic_vector(11 downto 0);
  --Machine trap handler
  signal csr_mscratch : std_logic_vector(XLEN-1 downto 0);  --scratch register
  signal csr_mepc     : std_logic_vector(XLEN-1 downto 0);  --exception program counter
  signal csr_mcause   : std_logic_vector(XLEN-1 downto 0);  --trap cause
  signal csr_mtval    : std_logic_vector(XLEN-1 downto 0);  --bad address

  signal csr_mip_meip : std_logic;
  signal csr_mip_heip : std_logic;
  signal csr_mip_seip : std_logic;
  signal csr_mip_ueip : std_logic;
  signal csr_mip_mtip : std_logic;
  signal csr_mip_htip : std_logic;
  signal csr_mip_stip : std_logic;
  signal csr_mip_utip : std_logic;
  signal csr_mip_msip : std_logic;
  signal csr_mip_hsip : std_logic;
  signal csr_mip_ssip : std_logic;
  signal csr_mip_usip : std_logic;

  --interrupt pending
  signal csr_mip     : std_logic_vector(11 downto 0);
  --Machine protection and Translation
  signal csr_pmpcfg  : std_logic_matrix(PMP_CNT-1 downto 0)(7 downto 0);
  signal csr_pmpaddr : std_logic_matrix(PMP_CNT-1 downto 0)(PLEN-1 downto 0);

  --Machine counters/Timers
  signal csr_mcycle_h : std_logic_vector(31 downto 0);  --timer for MCYCLE
  signal csr_mcycle_l : std_logic_vector(31 downto 0);  --timer for MCYCLE

  signal csr_mcycle : std_logic_vector(63 downto 0);

  signal csr_minstret_h : std_logic_vector(31 downto 0);  --instruction retire count for MINSTRET
  signal csr_minstret_l : std_logic_vector(31 downto 0);  --instruction retire count for MINSTRET

  signal csr_minstret : std_logic_vector(63 downto 0);

  signal is_rv32    : std_logic;
  signal is_rv32e_s : std_logic;
  signal is_rv64    : std_logic;
  signal is_rv128   : std_logic;
  signal has_rvc_s  : std_logic;
  signal has_fpu_s  : std_logic;
  signal has_fpud   : std_logic;
  signal has_fpuq   : std_logic;
  signal has_decfpu : std_logic;
  signal has_mmu_s  : std_logic;
  signal has_muldiv : std_logic;
  signal has_amo    : std_logic;
  signal has_bm     : std_logic;
  signal has_tmem   : std_logic;
  signal has_simd   : std_logic;
  signal has_n      : std_logic;
  signal has_u      : std_logic;
  signal has_s      : std_logic;
  signal has_h      : std_logic;
  signal has_ext_s  : std_logic;

  signal mstatus_s  : std_logic_vector(127 downto 0);  --mstatus_s is special (can be larger than 32bits)
  signal uxl_wval : std_logic_vector(1 downto 0);  --u/sxl are taken from bits 35:32
  signal sxl_wval : std_logic_vector(1 downto 0);  --and can only have limited values

  signal soft_seip : std_logic;  --software supervisor-external-interrupt
  signal soft_ueip : std_logic;         --software user-external-interrupt

  signal take_interrupt : std_logic;

  signal st_int          : std_logic_vector(11 downto 0);
  signal interrupt_cause : std_logic_vector(3 downto 0);
  signal trap_cause      : std_logic_vector(3 downto 0);

  --Mux for debug-unit
  signal csr_raddr : std_logic_vector(11 downto 0);      --CSR read address
  signal csr_wval  : std_logic_vector(XLEN-1 downto 0);  --CSR write value

  signal st_prv_sgn : std_logic_vector(1 downto 0);  --Privilege level

begin
  --//////////////////////////////////////////////////////////////
  --
  -- Module Body
  --

  csr_mvendorid <= (csr_mvendorid_bank & csr_mvendorid_offset);

  is_rv32      <= to_stdlogic(XLEN = 32);
  is_rv64      <= to_stdlogic(XLEN = 64);
  is_rv128     <= to_stdlogic(XLEN = 128);
  is_rv32e_s   <= to_stdlogic(IS_RV32E /= '0') and is_rv32;
  has_n        <= to_stdlogic(HAS_RVN /= '0') and has_u;
  has_u        <= to_stdlogic(HAS_USER /= '0');
  has_s        <= to_stdlogic(HAS_SUPER /= '0') and has_u;
  has_h        <= '0';  --(HAS_HYPER  !=   0) & has_s;   //No Hypervisor

  has_rvc_s  <= to_stdlogic(HAS_RVC /= '0');
  has_fpu_s  <= to_stdlogic(HAS_FPU /= '0');
  has_fpuq   <= to_stdlogic(FLEN = 128) and has_fpu_s;
  has_fpud   <= (to_stdlogic(FLEN = 64) and has_fpu_s) or has_fpuq;
  has_decfpu <= '0';
  has_mmu_s  <= to_stdlogic(HAS_MMU /= '0') and has_s;
  has_muldiv <= to_stdlogic(HAS_RVM /= '0');
  has_amo    <= to_stdlogic(HAS_RVA /= '0');
  has_bm     <= to_stdlogic(HAS_RVB /= '0');
  has_tmem   <= to_stdlogic(HAS_RVT /= '0');
  has_simd   <= to_stdlogic(HAS_RVP /= '0');
  has_ext_s  <= to_stdlogic(HAS_EXT /= '0');

  --Mux address/data for Debug-Unit access
  csr_raddr <= du_addr
               when du_stall = '1' else ex_csr_reg;
  csr_wval <= du_dato
              when du_stall = '1' else ex_csr_wval;

  --Priviliged Control Registers

  --mstatus_s has different values for RV32 and RV64/RV128
  --treat it here as though it is a 128bit register
  mstatus_s <= (csr_mstatus_sd & "0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000" & csr_mstatus_sxl & csr_mstatus_uxl & "000000000" & csr_mstatus_tsr & csr_mstatus_tw & csr_mstatus_tvm & csr_mstatus_mxr & csr_mstatus_sum & csr_mstatus_mprv & csr_mstatus_xs & csr_mstatus_fs & csr_mstatus_mpp & "00" & csr_mstatus_spp & csr_mstatus_mpie & '0' & csr_mstatus_spie & csr_mstatus_upie & csr_mstatus_mie & '0' & csr_mstatus_sie & csr_mstatus_uie);

  --Read
  processing_0 : process (csr_raddr, csr_fcsr_flags, csr_fcsr_rm, csr_marchid, csr_mcause, csr_mcounteren, csr_mcycle, csr_mcycle_h, csr_medeleg, csr_mepc, csr_mhartid, csr_mideleg, csr_mie, csr_mimpid, csr_minstret, csr_minstret_h, csr_mip, csr_misa_base, csr_misa_extensions, csr_mnmivec, csr_mscratch, csr_mtval, csr_mtvec, csr_mvendorid, csr_pmpaddr, csr_pmpcfg, csr_satp, csr_scause, csr_scounteren, csr_sedeleg, csr_sepc, csr_sscratch, csr_stval, csr_stvec, csr_ucause, csr_uepc, csr_uscratch, csr_utval, csr_utvec, has_fpu_s, has_mmu_s, has_n, has_s, is_rv128, is_rv32, mstatus_s)
  begin
    case (csr_raddr) is
      --User
      when USTATUS =>
        st_csr_rval <= (mstatus_s(127) & mstatus_s(XLEN-2 downto 0)) and (XLEN-1 downto 0 => '1');
      when UIE =>
        if (has_n = '1') then
          st_csr_rval <= (XLEN-1 downto 12 => '0') & (csr_mie and X"111");
        else
          st_csr_rval <= (others => '0');
        end if;
      when UTVEC =>
        if (has_n = '1') then
          st_csr_rval <= csr_utvec;
        else
          st_csr_rval <= (others => '0');
        end if;
      when USCRATCH =>
        if (has_n = '1') then
          st_csr_rval <= csr_uscratch;
        else
          st_csr_rval <= (others => '0');
        end if;
      when UEPC =>
        if (has_n = '1') then
          st_csr_rval <= csr_uepc;
        else
          st_csr_rval <= (others => '0');
        end if;
      when UCAUSE =>
        if (has_n = '1') then
          st_csr_rval <= csr_ucause;
        else
          st_csr_rval <= (others => '0');
        end if;
      when UTVAL =>
        if (has_n = '1') then
          st_csr_rval <= csr_utval;
        else
          st_csr_rval <= (others => '0');
        end if;
      when UIP =>
        if (has_n = '1') then
          st_csr_rval <=  (XLEN-1 downto 12 => '0') & (csr_mip and csr_mideleg(11 downto 0) and X"111");
        else
          st_csr_rval <= (others => '0');
        end if;
      when FFLAGS =>
        if (has_fpu_s = '1') then
          st_csr_rval <= (XLEN-1 downto 5 => '0') & csr_fcsr_flags;
        else
          st_csr_rval <= (others => '0');
        end if;
      when FRM =>
        if (has_fpu_s = '1') then
          st_csr_rval <= (XLEN-1 downto 3 => '0') & csr_fcsr_rm;
        else
          st_csr_rval <= (others => '0');
        end if;
      when FCSR =>
        if (has_fpu_s = '1') then
          st_csr_rval <= (XLEN-1 downto 3 => '0') & csr_fcsr_rm;
        else
          st_csr_rval <= (others => '0');
        end if;
      when CYCLE =>
        st_csr_rval <= csr_mcycle(XLEN-1 downto 0);
      --TIME      : st_csr_rval = csr_timer[XLEN-1:0];
      when INSTRET =>
        st_csr_rval <= csr_minstret(XLEN-1 downto 0);
      when CYCLEH =>
        if (is_rv32 = '1') then
          st_csr_rval <= (XLEN-1 downto 32 => '0') & csr_mcycle_h;
        else
          st_csr_rval <= (others => '0');
        end if;
      --TIMEH     : st_csr_rval = is_rv32 ? csr_timer_h    : 'h0;
      when INSTRETH =>
        if (is_rv32 = '1') then
          st_csr_rval <= (XLEN-1 downto 32 => '0') & csr_minstret_h;
        else
          st_csr_rval <= (others => '0');
        end if;
      --Supervisor
      when SSTATUS =>
        st_csr_rval <= (mstatus_s(127) & mstatus_s(XLEN-2 downto 0)) and (std_logic_vector(to_unsigned(1, XLEN) sll (XLEN-1)) or std_logic_vector(to_unsigned(1, XLEN) sll 32) or X"00000000000DE133");
      when STVEC =>
        if (has_s = '1') then
          st_csr_rval <= csr_stvec;
        else
          st_csr_rval <= (others => '0');
        end if;
      when SCOUNTEREN =>
        if (has_s = '1') then
          st_csr_rval <= csr_scounteren;
        else
          st_csr_rval <= (others => '0');
        end if;
      when SIE =>
        if (has_s = '1') then
          st_csr_rval <= (XLEN-1 downto 12 => '0') & (csr_mie and X"333");
        else
          st_csr_rval <= (others => '0');
        end if;
      when SEDELEG =>
        if (has_s = '1') then
          st_csr_rval <= csr_sedeleg;
        else
          st_csr_rval <= (others => '0');
        end if;
      when SIDELEG =>
        if (has_s = '1') then
          st_csr_rval <= csr_mideleg and (XLEN-1 downto 0 => '1');
        else
          st_csr_rval <= (others => '0');
        end if;
      when SSCRATCH =>
        if (has_s = '1') then
          st_csr_rval <= csr_sscratch;
        else
          st_csr_rval <= (others => '0');
        end if;
      when SEPC =>
        if (has_s = '1') then
          st_csr_rval <= csr_sepc;
        else
          st_csr_rval <= (others => '0');
        end if;
      when SCAUSE =>
        if (has_s = '1') then
          st_csr_rval <= csr_scause;
        else
          st_csr_rval <= (others => '0');
        end if;
      when STVAL =>
        if (has_s = '1') then
          st_csr_rval <= csr_stval;
        else
          st_csr_rval <= (others => '0');
        end if;
      when SIP =>
        if (has_s = '1') then
          st_csr_rval <= (XLEN-1 downto 12 => '0') &  (csr_mip and csr_mideleg(11 downto 0) and X"333");
        else
          st_csr_rval <= (others => '0');
        end if;
      when SATP =>
        if (has_s = '1' and has_mmu_s = '1') then
          st_csr_rval <= csr_satp;
        else
          st_csr_rval <= (others => '0');
        end if;

--      //Hypervisor
--      HSTATUS   : st_csr_rval = {mstatus_s[127],mstatus_s[XLEN-2:0] & (1 << XLEN-1 | 2'b11 << 32 | 'hde133);
--      HTVEC     : st_csr_rval = has_h ? csr_htvec                       : 'h0;
--      HIE       : st_csr_rval = has_h ? csr_mie & 12'h777               : 'h0;
--      HEDELEG   : st_csr_rval = has_h ? csr_hedeleg                     : 'h0;
--      HIDELEG   : st_csr_rval = has_h ? csr_mideleg & 12'h333           : 'h0;
--      HSCRATCH  : st_csr_rval = has_h ? csr_hscratch                    : 'h0;
--      HEPC      : st_csr_rval = has_h ? csr_hepc                        : 'h0;
--      HCAUSE    : st_csr_rval = has_h ? csr_hcause                      : 'h0;
--      HTVAL     : st_csr_rval = has_h ? csr_htval                       : 'h0;
--      HIP       : st_csr_rval = has_h ? csr_mip & csr_mideleg & 12'h777 : 'h0;

      --Machine
      when MISA =>
        st_csr_rval <= (csr_misa_base & (XLEN-3 downto 26 => '0') & csr_misa_extensions);
      when MVENDORID =>
        st_csr_rval <= (XLEN-1 downto csr_mvendorid'length => '0') & csr_mvendorid;
      when MARCHID =>
        st_csr_rval <= csr_marchid;
      when MIMPID =>
        if (is_rv32 = '1') then
          st_csr_rval <= csr_mimpid;
        else
          st_csr_rval <= csr_mimpid;
        end if;
      when MHARTID =>
        st_csr_rval <= csr_mhartid;
      when MSTATUS =>
        st_csr_rval <= (mstatus_s(127) & mstatus_s(XLEN-2 downto 0));
      when MTVEC =>
        st_csr_rval <= csr_mtvec;
      when MCOUNTEREN =>
        st_csr_rval <= csr_mcounteren;
      when MNMIVEC =>
        st_csr_rval <= csr_mnmivec;
      when MEDELEG =>
        st_csr_rval <= csr_medeleg;
      when MIDELEG =>
        st_csr_rval <= csr_mideleg;
      when MIE =>
        st_csr_rval <= (XLEN-1 downto 12 => '0') & (csr_mie and X"FFF");
      when MSCRATCH =>
        st_csr_rval <= csr_mscratch;
      when MEPC =>
        st_csr_rval <= csr_mepc;
      when MCAUSE =>
        st_csr_rval <= csr_mcause;
      when MTVAL =>
        st_csr_rval <= csr_mtval;
      when MIP =>
        st_csr_rval <= (XLEN-1 downto 12 => '0') & csr_mip;
      when PMPCFG0 =>
        st_csr_rval <= (XLEN-1 downto 8 => '0') & csr_pmpcfg(00);
      when PMPCFG1 =>
        if (is_rv32 = '1') then
          st_csr_rval <= (XLEN-1 downto 8 => '0') & csr_pmpcfg(04);
        else
          st_csr_rval <= (others => '0');
        end if;
      when PMPCFG2 =>
        if (is_rv128 = '1') then
          st_csr_rval <= (XLEN-1 downto 8 => '0') & csr_pmpcfg(08);
        else
          st_csr_rval <= (others => '0');
        end if;
      when PMPCFG3 =>
        if (is_rv32 = '1') then
          st_csr_rval <= (XLEN-1 downto 8 => '0') & csr_pmpcfg(12);
        else
          st_csr_rval <= (others => '0');
        end if;
      when PMPADDR0 =>
        st_csr_rval <= csr_pmpaddr(00);
      when PMPADDR1 =>
        st_csr_rval <= csr_pmpaddr(01);
      when PMPADDR2 =>
        st_csr_rval <= csr_pmpaddr(02);
      when PMPADDR3 =>
        st_csr_rval <= csr_pmpaddr(03);
      when PMPADDR4 =>
        st_csr_rval <= csr_pmpaddr(04);
      when PMPADDR5 =>
        st_csr_rval <= csr_pmpaddr(05);
      when PMPADDR6 =>
        st_csr_rval <= csr_pmpaddr(06);
      when PMPADDR7 =>
        st_csr_rval <= csr_pmpaddr(07);
      when PMPADDR8 =>
        st_csr_rval <= csr_pmpaddr(08);
      when PMPADDR9 =>
        st_csr_rval <= csr_pmpaddr(09);
      when PMPADDR10 =>
        st_csr_rval <= csr_pmpaddr(10);
      when PMPADDR11 =>
        st_csr_rval <= csr_pmpaddr(11);
      when PMPADDR12 =>
        st_csr_rval <= csr_pmpaddr(12);
      when PMPADDR13 =>
        st_csr_rval <= csr_pmpaddr(13);
      when PMPADDR14 =>
        st_csr_rval <= csr_pmpaddr(14);
      when PMPADDR15 =>
        st_csr_rval <= csr_pmpaddr(15);
      when MCYCLE =>
        st_csr_rval <= csr_mcycle(XLEN-1 downto 0);
      when MINSTRET =>
        st_csr_rval <= csr_minstret(XLEN-1 downto 0);
      when MCYCLEH =>
        if (is_rv32 = '1') then
          st_csr_rval <= (XLEN-1 downto 32 => '0') & csr_mcycle_h;
        else
          st_csr_rval <= (others => '0');
        end if;
      when MINSTRETH =>
        if (is_rv32 = '1') then
          st_csr_rval <= (XLEN-1 downto 32 => '0') & csr_minstret_h;
        else
          st_csr_rval <= (others => '0');
        end if;
      when others =>
        st_csr_rval <= (others => '0');
    end case;
  end process;

  --//////////////////////////////////////////////////////////////
  -- Machine registers
  --
  csr_misa_base <= RV128I
                   when is_rv128 = '1' else RV64I
                   when is_rv64 = '1'  else RV32I;
  --reserved
  --reserved
  --reserved
  --reserved for vector extensions
  --user mode supported
  --supervisor mode supported
  --reserved
  --reserved
  --reserved
  --reserved for JIT
  --reserved
  --additional extensions
  csr_misa_extensions <= ('0' & '0' & has_ext_s & '0' & '0' & has_u & has_tmem & has_s & '0' & has_fpuq & has_simd & '0' & has_n & has_muldiv & has_decfpu & '0' & '0' & not is_rv32e_s & '0' & '0' & has_fpu_s & is_rv32e_s & has_fpud & has_rvc_s & has_bm & has_amo);

  csr_mvendorid_bank       <= std_logic_vector(to_unsigned(JEDEC_BANK-1, 8));
  csr_mvendorid_offset     <= JEDEC_MANUFACTURER_ID(6 downto 0);
  csr_marchid              <= std_logic_vector(to_unsigned(1, XLEN) sll (XLEN-1)) or std_logic_vector(to_unsigned(ARCHID, XLEN));
  csr_mimpid(31 downto 24) <= std_logic_vector(to_unsigned(REVPRV_MAJOR, 8));
  csr_mimpid(23 downto 16) <= std_logic_vector(to_unsigned(REVPRV_MINOR, 8));
  csr_mimpid(15 downto 8)  <= std_logic_vector(to_unsigned(REVUSR_MAJOR, 8));
  csr_mimpid(7 downto 0)   <= std_logic_vector(to_unsigned(REVUSR_MINOR, 8));
  csr_mhartid              <= std_logic_vector(to_unsigned(HARTID, XLEN));

  --mstatus_s
  csr_mstatus_sd <= reduce_and(csr_mstatus_fs) or reduce_and(csr_mstatus_xs);

  st_tvm <= csr_mstatus_tvm;
  st_tw  <= csr_mstatus_tw;
  st_tsr <= csr_mstatus_tsr;

  generating_0 : if (XLEN = 128) generate
    sxl_wval <= csr_wval(35 downto 34)
                when reduce_or(csr_wval(35 downto 34)) = '1' else csr_mstatus_sxl;
    uxl_wval <= csr_wval(33 downto 32)
                when reduce_or(csr_wval(33 downto 32)) = '1' else csr_mstatus_uxl;
  elsif (XLEN = 64) generate
    sxl_wval <= csr_wval(35 downto 34)
                when csr_wval(35 downto 34) = RV32I or csr_wval(35 downto 34) = RV64I else csr_mstatus_sxl;
    uxl_wval <= csr_wval(33 downto 32)
                when csr_wval(33 downto 32) = RV32I or csr_wval(33 downto 32) = RV64I else csr_mstatus_uxl;
  elsif (XLEN /= 32 and XLEN /= 64) generate
    sxl_wval <= "00";
    uxl_wval <= "00";
  end generate;

  processing_1 : process (csr_misa_base, csr_mstatus_sxl, csr_mstatus_uxl, has_s, has_u, st_prv_sgn)
  begin
    case (st_prv_sgn) is
      when PRV_S =>
        if (has_s = '1') then
          st_xlen <= csr_mstatus_sxl;
        else
          st_xlen <= csr_misa_base;
        end if;
      when PRV_U =>
        if (has_u = '1') then
          st_xlen <= csr_mstatus_uxl;
        else
          st_xlen <= csr_misa_base;
        end if;
      when others =>
        st_xlen <= csr_misa_base;
    end case;
  end process;

  processing_2 : process (clk, rstn, csr_misa_base, has_ext_s, has_s, has_u)
  begin
    if (rstn = '0') then
      st_prv_sgn          <= PRV_M;         --start in machine mode
      st_nxt_pc       <= PC_INIT;
      st_flush        <= '1';
      --csr_mstatus_vm   <= VM_MBARE;
      if (has_s = '1') then
        csr_mstatus_sxl <= csr_misa_base;
      else
        csr_mstatus_sxl <= "00";
      end if;

      if (has_u = '1') then
        csr_mstatus_uxl <= csr_misa_base;
      else
        csr_mstatus_uxl <= "00";
      end if;

      csr_mstatus_tsr  <= '0';
      csr_mstatus_tw   <= '0';
      csr_mstatus_tvm  <= '0';
      csr_mstatus_mxr  <= '0';
      csr_mstatus_sum  <= '0';
      csr_mstatus_mprv <= '0';
      csr_mstatus_xs   <= (has_ext_s & has_ext_s);
      csr_mstatus_fs   <= "00";

      csr_mstatus_mpp  <= "11";
      csr_mstatus_hpp  <= (others => '0');                     --reserved
      csr_mstatus_spp  <= has_s;
      csr_mstatus_mpie <= '0';
      csr_mstatus_hpie <= '0';                                 --reserved
      csr_mstatus_spie <= '0';
      csr_mstatus_upie <= '0';
      csr_mstatus_mie  <= '0';
      csr_mstatus_hie  <= '0';                                 --reserved
      csr_mstatus_sie  <= '0';
      csr_mstatus_uie  <= '0';
    elsif (rising_edge(clk)) then
      st_flush <= '0';
      --write from EX, Machine Mode
      if ((ex_csr_we = '1' and ex_csr_reg = MSTATUS and st_prv_sgn = PRV_M) or (du_we_csr = '1' and du_addr = MSTATUS)) then
        --            csr_mstatus_vm    <= csr_wval[28:24];

        if (has_s = '1' and XLEN > 32) then
          csr_mstatus_sxl <= sxl_wval;
        else
          csr_mstatus_sxl <= "00";
        end if;

        if (has_u = '1' and XLEN > 32) then
          csr_mstatus_uxl <= uxl_wval;
        else
          csr_mstatus_uxl <= "00";
        end if;

        if (has_s = '1') then
          csr_mstatus_tsr <= csr_wval(22);
        else
          csr_mstatus_tsr <= '0';
        end if;

        if (has_s = '1') then
          csr_mstatus_tw <= csr_wval(21);
        else
          csr_mstatus_tw <= '0';
        end if;

        if (has_s = '1') then
          csr_mstatus_tvm <= csr_wval(20);
        else
          csr_mstatus_tvm <= '0';
        end if;

        if (has_s = '1') then
          csr_mstatus_mxr <= csr_wval(19);
        else
          csr_mstatus_mxr <= '0';
        end if;

        if (has_s = '1') then
          csr_mstatus_sum <= csr_wval(18);
        else
          csr_mstatus_sum <= '0';
        end if;

        if (has_s = '1') then
          csr_mstatus_mprv <= csr_wval(17);
        else
          csr_mstatus_mprv <= '0';
        end if;

        if (has_ext_s = '1') then
          csr_mstatus_uxl <= csr_wval(16 downto 15);
        else
          csr_mstatus_uxl <= "00";
        end if;

        if (has_s = '1') then
          csr_mstatus_fs <= csr_wval(14 downto 13);
        else
          csr_mstatus_fs <= "00";
        end if;

        csr_mstatus_mpp <= csr_wval(12 downto 11);
        csr_mstatus_hpp <= (others => '0');                    --reserved

        if (has_s = '1') then
          csr_mstatus_spp <= csr_wval(8);
        else
          csr_mstatus_spp <= '0';
        end if;

        csr_mstatus_mpie <= csr_wval(7);
        csr_mstatus_hpie <= '0';                               --reserved

        if (has_s = '1') then
          csr_mstatus_spie <= csr_wval(5);
        else
          csr_mstatus_spie <= '0';
        end if;

        if (has_n = '1') then
          csr_mstatus_upie <= csr_wval(4);
        else
          csr_mstatus_upie <= '0';
        end if;

        csr_mstatus_mie <= csr_wval(3);
        csr_mstatus_hie <= '0';                                --reserved

        if (has_s = '1') then
          csr_mstatus_sie <= csr_wval(1);
        else
          csr_mstatus_sie <= '0';
        end if;

        if (has_n = '1') then
          csr_mstatus_uie <= csr_wval(0);
        else
          csr_mstatus_uie <= '0';
        end if;
      end if;
      --Supervisor Mode access
      if (has_s = '1') then
        if ((ex_csr_we = '1' and ex_csr_reg = SSTATUS and st_prv_sgn >= PRV_S) or (du_we_csr = '1' and du_addr = SSTATUS)) then
          csr_mstatus_uxl <= uxl_wval;
          csr_mstatus_mxr <= csr_wval(19);
          csr_mstatus_sum <= csr_wval(18);

          if (has_ext_s = '1') then
            csr_mstatus_xs <= csr_wval(16 downto 15);
          else
            csr_mstatus_xs <= "00";
          end if;

          if (has_fpu_s = '1') then
            csr_mstatus_fs <= csr_wval(14 downto 13);
          else
            csr_mstatus_fs <= "00";
          end if;

          csr_mstatus_spp  <= csr_wval(7);
          csr_mstatus_spie <= csr_wval(5);

          if (has_n = '1') then
            csr_mstatus_upie <= csr_wval(4);
          else
            csr_mstatus_upie <= '0';
          end if;

          csr_mstatus_sie <= csr_wval(1);
          csr_mstatus_uie <= csr_wval(0);
        end if;
      end if;
      --MRET,HRET,SRET,URET
      if (id_bubble = '0' and bu_flush = '0' and du_stall = '0') then
        case (id_instr) is
          --pop privilege stack
          when MRET =>
            --set privilege level
            st_prv_sgn           <= csr_mstatus_mpp;
            st_nxt_pc        <= csr_mepc;
            st_flush         <= '1';
            --set MIE
            csr_mstatus_mie  <= csr_mstatus_mpie;
            csr_mstatus_mpie <= '1';

            if (has_u = '1') then
              csr_mstatus_mpp <= PRV_U;
            else
              csr_mstatus_mpp <= PRV_M;
            end if;

--          HRET : begin
--            //set privilege level
--            st_prv_sgn    <= csr_mstatus_hpp;
--            st_nxt_pc <= csr_hepc;
--            st_flush  <= 1'b1;
--
--            //set HIE
--            csr_mstatus_hie  <= csr_mstatus_hpie;
--            csr_mstatus_hpie <= 1'b1;
--            csr_mstatus_hpp  <= has_u ? PRV_U : PRV_M;
--          end
          when SRET =>
            --set privilege level
            st_prv_sgn           <= ('0' & csr_mstatus_spp);
            st_nxt_pc        <= csr_sepc;
            st_flush         <= '1';
            --set SIE
            csr_mstatus_sie  <= csr_mstatus_spie;
            csr_mstatus_spie <= '1';
            csr_mstatus_spp  <= '0';  --Must have User-mode. SPP is only 1 bit
          when URET =>
            --set privilege level
            st_prv_sgn       <= PRV_U;
            st_nxt_pc        <= csr_uepc;
            st_flush         <= '1';
            --set UIE
            csr_mstatus_uie  <= csr_mstatus_upie;
            csr_mstatus_upie <= '1';
          when others =>
            null;
        end case;
      end if;
      --push privilege stack
      if (ext_nmi = '1') then
        --NMI always at Machine-mode
        st_prv_sgn           <= PRV_M;
        st_nxt_pc        <= csr_mnmivec;
        st_flush         <= '1';
        --store current state
        csr_mstatus_mpie <= csr_mstatus_mie;
        csr_mstatus_mie  <= '0';
        csr_mstatus_mpp  <= st_prv_sgn;
      elsif (take_interrupt = '1') then
        st_flush <= not du_stall and not du_flush;

        --Check if interrupts are delegated
        if (has_n = '1' and st_prv_sgn = PRV_U and (st_int and csr_mideleg(11 downto 0) and X"111") = X"111") then
          st_prv_sgn <= PRV_U;
          st_nxt_pc <= std_logic_vector(unsigned(csr_utvec and not std_logic_vector(to_unsigned(3, XLEN))) + unsigned(csr_utvec_we));

          if (csr_utvec(0) = '1') then
            csr_utvec_we <= (XLEN-1 downto 4 => '0') & std_logic_vector(unsigned(interrupt_cause) sll 2);
          else
            csr_utvec_we <= (others => '0');
          end if;

          csr_mstatus_upie <= csr_mstatus_uie;
          csr_mstatus_uie  <= '0';
        elsif (has_s = '1' and st_prv_sgn >= PRV_S and (st_int and csr_mideleg(11 downto 0) and X"333") = X"111") then
          st_prv_sgn <= PRV_S;
          st_nxt_pc <= std_logic_vector(unsigned(csr_stvec and not std_logic_vector(to_unsigned(3, XLEN))) + unsigned(csr_stvec_we));

          if (csr_stvec(0) = '1') then
            csr_stvec_we <= (XLEN-1 downto 4 => '0') & std_logic_vector(unsigned(interrupt_cause) sll 2);
          else
            csr_stvec_we <= (others => '0');
          end if;

          csr_mstatus_spie <= csr_mstatus_sie;
          csr_mstatus_sie  <= '0';
          csr_mstatus_spp  <= st_prv_sgn(0);
        else                            --
--        else if (has_h && st_prv_sgn >= PRV_H && (st_int & csr_mideleg & 12'h777) ) begin
--          st_prv_sgn    <= PRV_H;
--          st_nxt_pc <= csr_htvec;
--
--          csr_mstatus_hpie <= csr_mstatus_hie;
--          csr_mstatus_hie  <= 1'b0;
--          csr_mstatus_hpp  <= st_prv_sgn;
--        end
          st_prv_sgn <= PRV_M;
          st_nxt_pc <= std_logic_vector(unsigned(csr_mtvec and not std_logic_vector(to_unsigned(3, XLEN))) + unsigned(csr_mtvec_we));

          if (csr_mtvec(0) = '1') then
            csr_mtvec_we <=  (XLEN-1 downto 4 => '0') & std_logic_vector(unsigned(interrupt_cause) sll 2);
          else
            csr_mtvec_we <= (others => '0');
          end if;

          csr_mstatus_mpie <= csr_mstatus_mie;
          csr_mstatus_mie  <= '0';
          csr_mstatus_mpp  <= st_prv_sgn;
        end if;
      elsif (reduce_or(wb_exception and not du_ie(15 downto 0)) = '1') then
        st_flush <= '1';
        if (has_n = '1' and st_prv_sgn = PRV_U and reduce_or(wb_exception and csr_medeleg(EXCEPTION_SIZE-1 downto 0)) = '1') then
          st_prv_sgn           <= PRV_U;
          st_nxt_pc        <= csr_utvec;
          csr_mstatus_upie <= csr_mstatus_uie;
          csr_mstatus_uie  <= '0';
        elsif (has_s = '1' and st_prv_sgn >= PRV_S and reduce_or(wb_exception and csr_medeleg(EXCEPTION_SIZE-1 downto 0)) = '1') then
          st_prv_sgn           <= PRV_S;
          st_nxt_pc        <= csr_stvec;
          csr_mstatus_spie <= csr_mstatus_sie;
          csr_mstatus_sie  <= '0';
          csr_mstatus_spp  <= st_prv_sgn(0);
        else

--        else if (has_h && st_prv_sgn >= PRV_H && |(wb_exception & csr_medeleg)) begin
--          st_prv_sgn <= PRV_H;
--          st_nxt_pc  <= csr_htvec;
--
--          csr_mstatus_hpie <= csr_mstatus_hie;
--          csr_mstatus_hie  <= 1'b0;
--          csr_mstatus_hpp  <= st_prv_sgn;
--        end

          st_prv_sgn           <= PRV_M;
          st_nxt_pc        <= csr_mtvec and not X"0000000000000003";
          csr_mstatus_mpie <= csr_mstatus_mie;
          csr_mstatus_mie  <= '0';
          csr_mstatus_mpp  <= st_prv_sgn;
        end if;
      end if;
    end if;
  end process;

  st_prv <= st_prv_sgn;

  --mcycle, minstret
  generating_3 : if (XLEN = 32) generate
    processing_3 : process (clk, rstn)
    begin
      if (rstn = '0') then
        csr_mcycle   <= (others => '0');
        csr_minstret <= (others => '0');
      elsif (rising_edge(clk)) then
        --cycle always counts (thread active time)
        if ((ex_csr_we = '1' and ex_csr_reg = MCYCLE and st_prv_sgn = PRV_M) or (du_we_csr = '1' and du_addr = MCYCLE)) then
          csr_mcycle_l <= csr_wval(31 downto 0);
        elsif ((ex_csr_we = '1' and ex_csr_reg = MCYCLEH and st_prv_sgn = PRV_M) or (du_we_csr = '1' and du_addr = MCYCLEH)) then
          csr_mcycle_h <= csr_wval(31 downto 0);
        else
          csr_mcycle <= std_logic_vector(unsigned(csr_mcycle)+X"0000000000000001");
        end if;
        --instruction retire counter
        if ((ex_csr_we = '1' and ex_csr_reg = MINSTRET and st_prv_sgn = PRV_M) or (du_we_csr = '1' and du_addr = MINSTRET)) then
          csr_minstret_l <= csr_wval(31 downto 0);
        elsif ((ex_csr_we = '1' and ex_csr_reg = MINSTRETH and st_prv_sgn = PRV_M) or (du_we_csr = '1' and du_addr = MINSTRETH)) then
          csr_minstret_h <= csr_wval(31 downto 0);
        elsif (wb_bubble = '0') then
          csr_minstret <= std_logic_vector(unsigned(csr_minstret)+X"0000000000000001");
        end if;
      end if;
    end process;
  elsif (XLEN > 32) generate  --(XLEN > 32) begin
      processing_4 : process (clk, rstn)
      begin
        if (rstn = '0') then
          csr_mcycle   <= (others => '0');
          csr_minstret <= (others => '0');
        elsif (rising_edge(clk)) then
          --cycle always counts (thread active time)
          if ((ex_csr_we = '1' and ex_csr_reg = MCYCLE and st_prv_sgn = PRV_M) or (du_we_csr = '1' and du_addr = MCYCLE)) then
            csr_mcycle <= csr_wval(63 downto 0);
          else
            csr_mcycle <= std_logic_vector(unsigned(csr_mcycle)+X"0000000000000001");
          end if;
          --instruction retire counter
          if ((ex_csr_we = '1' and ex_csr_reg = MINSTRET and st_prv_sgn = PRV_M) or (du_we_csr = '1' and du_addr = MINSTRET)) then
            csr_minstret <= csr_wval(63 downto 0);
          elsif (wb_bubble = '0') then
            csr_minstret <= std_logic_vector(unsigned(csr_minstret)+X"0000000000000001");
          end if;
        end if;
      end process;
    end generate;

  --mnmivec - RoaLogic Extension
  processing_5 : process (clk, rstn)
  begin
    if (rstn = '0') then
      csr_mnmivec <= MNMIVEC_DEFAULT;
    elsif (rising_edge(clk)) then
      if ((ex_csr_we = '1' and ex_csr_reg = MNMIVEC and st_prv_sgn = PRV_M) or (du_we_csr = '1' and du_addr = MNMIVEC)) then
        csr_mnmivec <= (csr_wval(XLEN-1 downto 2) & "00");
      end if;
    end if;
  end process;

  --mtvec
  processing_6 : process (clk, rstn)
  begin
    if (rstn = '0') then
      csr_mtvec <= MTVEC_DEFAULT;
    elsif (rising_edge(clk)) then
      if ((ex_csr_we = '1' and ex_csr_reg = MTVEC and st_prv_sgn = PRV_M) or (du_we_csr = '1' and du_addr = MTVEC)) then
        csr_mtvec <= csr_wval and not X"0000000000000007";
      end if;
    end if;
  end process;

  --mcounteren
  processing_7 : process (clk, rstn)
  begin
    if (rstn = '0') then
      csr_mcounteren <= (others => '0');
    elsif (rising_edge(clk)) then
      if ((ex_csr_we = '1' and ex_csr_reg = MCOUNTEREN and st_prv_sgn = PRV_M) or (du_we_csr = '1' and du_addr = MCOUNTEREN)) then
        csr_mcounteren <= csr_wval and X"0000000000000007";
      end if;
    end if;
  end process;

  st_mcounteren <= csr_mcounteren;

  --medeleg, mideleg
  generating_5 : if ((HAS_HYPER and HAS_SUPER and HAS_USER) = '0') generate
    --csr_medeleg <= (others => '0');
    --csr_mideleg <= (others => '0');
  elsif ((HAS_HYPER or HAS_SUPER or HAS_USER) = '1') generate  --medeleg
    processing_8 : process (clk, rstn)
    begin
      if (rstn = '0') then
        csr_medeleg <= (others => '0');
      elsif (rising_edge(clk)) then
        if ((ex_csr_we = '1' and ex_csr_reg = MEDELEG and st_prv_sgn = PRV_M) or (du_we_csr = '1' and du_addr = MEDELEG)) then
          csr_medeleg <= csr_wval and (XLEN-1 downto 0 => '1');
        end if;
      end if;
    end process;

    --mideleg
    processing_9 : process (clk, rstn)
    begin
      if (rstn = '0') then
        csr_mideleg <= (others => '0');
      elsif (rising_edge(clk)) then
        if ((ex_csr_we = '1' and ex_csr_reg = MIDELEG and st_prv_sgn = PRV_M) or (du_we_csr = '1' and du_addr = MIDELEG)) then
          csr_mideleg(SSI) <= has_s and csr_wval(SSI);
          csr_mideleg(USI) <= has_n and csr_wval(USI);
--
--        else if (has_h) begin
--          if ( (ex_csr_we && ex_csr_reg == HIDELEG && st_prv_sgn >= PRV_H) ||
--               (du_we_csr && du_addr    == HIDELEG)                  ) begin
--            csr_mideleg[SSI] <= has_s & csr_wval[SSI];
--            csr_mideleg[USI] <= has_n & csr_wval[USI];
--          end
--        end
        elsif (has_s = '1') then
          if ((ex_csr_we = '1' and ex_csr_reg = SIDELEG and st_prv_sgn >= PRV_S) or (du_we_csr = '1' and du_addr = SIDELEG)) then
            csr_mideleg(USI) <= has_n and csr_wval(USI);
          end if;
        end if;
      end if;
    end process;
  end generate;

  --mip
  processing_10 : process (clk, rstn)
  begin
    if (rstn = '0') then
      csr_mip   <= (others => '0');
      soft_seip <= '0';
      soft_ueip <= '0';
    elsif (rising_edge(clk)) then
      --external interrupts
      csr_mip_meip <= ext_int(to_integer(unsigned(PRV_M)));
      csr_mip_heip <= has_h and ext_int(to_integer(unsigned(PRV_H)));
      csr_mip_seip <= has_s and (ext_int(to_integer(unsigned(PRV_S))) or soft_seip);
      csr_mip_ueip <= has_n and (ext_int(to_integer(unsigned(PRV_U))) or soft_ueip);
      --may only be written by M-mode
      if ((ex_csr_we = '1' and ex_csr_reg = MIP and st_prv_sgn = PRV_M) or (du_we_csr = '1' and du_addr = MIP)) then
        soft_seip <= csr_wval(SEI) and has_s;
        soft_ueip <= csr_wval(UEI) and has_n;
      end if;
      --timer interrupts
      csr_mip_mtip <= ext_tint;
      --may only be written by M-mode
      if ((ex_csr_we = '1' and ex_csr_reg = MIP and st_prv_sgn = PRV_M) or (du_we_csr = '1' and du_addr = MIP)) then
        csr_mip_htip <= csr_wval(HTI) and has_h;
        csr_mip_stip <= csr_wval(STI) and has_s;
        csr_mip_utip <= csr_wval(UTI) and has_n;
      end if;
      --software interrupts
      csr_mip_msip <= ext_sint;
      --Machine Mode write
      if ((ex_csr_we = '1' and ex_csr_reg = MIP and st_prv_sgn = PRV_M) or (du_we_csr = '1' and du_addr = MIP)) then
        csr_mip_hsip <= csr_wval(HSI) and has_h;
        csr_mip_ssip <= csr_wval(SSI) and has_s;
        csr_mip_usip <= csr_wval(USI) and has_n;
--        else if (has_h) begin
--          //Hypervisor Mode write
--          if ( (ex_csr_we && ex_csr_reg == HIP && st_prv_sgn >= PRV_H) ||
--               (du_we_csr && du_addr    == HIP)                   ) begin
--              csr_mip_hsip <= csr_wval[HSI] & csr_mideleg[HSI];
--              csr_mip_ssip <= csr_wval[SSI] & csr_mideleg[SSI] & has_s;
--              csr_mip_usip <= csr_wval[USI] & csr_mideleg[USI] & has_n;
--            end
--        end
      elsif (has_s = '1') then
        --Supervisor Mode write
        if ((ex_csr_we = '1' and ex_csr_reg = SIP and st_prv_sgn >= PRV_S) or (du_we_csr = '1' and du_addr = SIP)) then
          csr_mip_ssip <= csr_wval(SSI) and csr_mideleg(SSI);
          csr_mip_usip <= csr_wval(USI) and csr_mideleg(USI) and has_n;
        end if;
      elsif (has_n = '1') then
        --User Mode write
        if ((ex_csr_we = '1' and ex_csr_reg = UIP) or (du_we_csr = '1' and du_addr = UIP)) then
          csr_mip_usip <= csr_wval(USI) and csr_mideleg(USI);
        end if;
      end if;
    end if;
  end process;

  --mie
  processing_11 : process (clk, rstn)
  begin
    if (rstn = '0') then
      csr_mie <= (others => '0');
    elsif (rising_edge(clk)) then
      if ((ex_csr_we = '1' and ex_csr_reg = MIE and st_prv_sgn = PRV_M) or (du_we_csr = '1' and du_addr = MIE)) then
        csr_mie_meie <= csr_wval(MEI);
        csr_mie_heie <= csr_wval(HEI) and has_h;
        csr_mie_seie <= csr_wval(SEI) and has_s;
        csr_mie_ueie <= csr_wval(UEI) and has_n;
        csr_mie_mtie <= csr_wval(MTI);
        csr_mie_htie <= csr_wval(HTI) and has_h;
        csr_mie_stie <= csr_wval(STI) and has_s;
        csr_mie_utie <= csr_wval(UTI) and has_n;
        csr_mie_msie <= csr_wval(MSI);
        csr_mie_hsie <= csr_wval(HSI) and has_h;
        csr_mie_ssie <= csr_wval(SSI) and has_s;
        csr_mie_usie <= csr_wval(USI) and has_n;

--    else if (has_h) begin
--      if ( (ex_csr_we && ex_csr_reg == HIE && st_prv_sgn >= PRV_H) ||
--           (du_we_csr && du_addr    == HIE)                  ) begin
--        csr_mie_heie <= csr_wval[HEI];
--        csr_mie_seie <= csr_wval[SEI] & has_s;
--        csr_mie_ueie <= csr_wval[UEI] & has_n;
--        csr_mie_htie <= csr_wval[HTI];
--        csr_mie_stie <= csr_wval[STI] & has_s;
--        csr_mie_utie <= csr_wval[UTI] & has_n;
--        csr_mie_hsie <= csr_wval[HSI];
--        csr_mie_ssie <= csr_wval[SSI] & has_s;
--        csr_mie_usie <= csr_wval[USI] & has_n;
--      end
--    end

      elsif (has_s = '1') then
        if ((ex_csr_we = '1' and ex_csr_reg = SIE and st_prv_sgn >= PRV_S) or (du_we_csr = '1' and du_addr = SIE)) then
          csr_mie_seie <= csr_wval(SEI);
          csr_mie_ueie <= csr_wval(UEI) and has_n;
          csr_mie_stie <= csr_wval(STI);
          csr_mie_utie <= csr_wval(UTI) and has_n;
          csr_mie_ssie <= csr_wval(SSI);
          csr_mie_usie <= csr_wval(USI) and has_n;
        end if;
      elsif (has_n = '1') then
        if ((ex_csr_we = '1' and ex_csr_reg = UIE) or (du_we_csr = '1' and du_addr = UIE)) then
          csr_mie_ueie <= csr_wval(UEI);
          csr_mie_utie <= csr_wval(UTI);
          csr_mie_usie <= csr_wval(USI);
        end if;
      end if;
    end if;
  end process;

  --mscratch
  processing_12 : process (clk, rstn)
  begin
    if (rstn = '0') then
      csr_mscratch <= (others => '0');
    elsif (rising_edge(clk)) then
      if ((ex_csr_we = '1' and ex_csr_reg = MSCRATCH and st_prv_sgn = PRV_M) or (du_we_csr = '1' and du_addr = MSCRATCH)) then
        csr_mscratch <= csr_wval;
      end if;
    end if;
  end process;

  trap_cause <= get_trap_cause(wb_exception and not du_ie(15 downto 0));

  --decode interrupts
  --priority external, software, timer
  st_int(CAUSE_MEINT) <= ((to_stdlogic(st_prv_sgn < PRV_M) or (to_stdlogic(st_prv_sgn = PRV_M) and csr_mstatus_mie)) and (csr_mip_meip and csr_mie_meie));
  st_int(CAUSE_HEINT) <= ((to_stdlogic(st_prv_sgn < PRV_H) or (to_stdlogic(st_prv_sgn = PRV_H) and csr_mstatus_hie)) and (csr_mip_heip and csr_mie_heie));
  st_int(CAUSE_SEINT) <= ((to_stdlogic(st_prv_sgn < PRV_S) or (to_stdlogic(st_prv_sgn = PRV_S) and csr_mstatus_sie)) and (csr_mip_seip and csr_mie_seie));
  st_int(CAUSE_UEINT) <= ((to_stdlogic(st_prv_sgn = PRV_U) and csr_mstatus_uie) and (csr_mip_ueip and csr_mie_ueie));

  st_int(CAUSE_MSINT) <= ((to_stdlogic(st_prv_sgn < PRV_M) or (to_stdlogic(st_prv_sgn = PRV_M) and csr_mstatus_mie)) and (csr_mip_msip and csr_mie_msie)) and not st_int(CAUSE_MEINT);
  st_int(CAUSE_HSINT) <= ((to_stdlogic(st_prv_sgn < PRV_H) or (to_stdlogic(st_prv_sgn = PRV_H) and csr_mstatus_hie)) and (csr_mip_hsip and csr_mie_hsie)) and not st_int(CAUSE_HEINT);
  st_int(CAUSE_SSINT) <= ((to_stdlogic(st_prv_sgn < PRV_S) or (to_stdlogic(st_prv_sgn = PRV_S) and csr_mstatus_sie)) and (csr_mip_ssip and csr_mie_ssie)) and not st_int(CAUSE_SEINT);
  st_int(CAUSE_USINT) <= ((to_stdlogic(st_prv_sgn = PRV_U) and csr_mstatus_uie) and (csr_mip_usip and csr_mie_usie)) and not st_int(CAUSE_UEINT);

  st_int(CAUSE_MTINT) <= ((to_stdlogic(st_prv_sgn < PRV_M) or (to_stdlogic(st_prv_sgn = PRV_M) and csr_mstatus_mie)) and (csr_mip_mtip and csr_mie_mtie)) and not (st_int(CAUSE_MEINT) or st_int(CAUSE_MSINT));
  st_int(CAUSE_HTINT) <= ((to_stdlogic(st_prv_sgn < PRV_H) or (to_stdlogic(st_prv_sgn = PRV_H) and csr_mstatus_hie)) and (csr_mip_htip and csr_mie_htie)) and not (st_int(CAUSE_HEINT) or st_int(CAUSE_HSINT));
  st_int(CAUSE_STINT) <= ((to_stdlogic(st_prv_sgn < PRV_S) or (to_stdlogic(st_prv_sgn = PRV_S) and csr_mstatus_sie)) and (csr_mip_stip and csr_mie_stie)) and not (st_int(CAUSE_SEINT) or st_int(CAUSE_SSINT));
  st_int(CAUSE_UTINT) <= ((to_stdlogic(st_prv_sgn = PRV_U) and csr_mstatus_uie) and (csr_mip_utip and csr_mie_utie)) and not (st_int(CAUSE_UEINT) or st_int(CAUSE_USINT));

  --interrupt cause priority
  processing_13 : process (du_ie, st_int)
    variable state : std_logic_vector(11 downto 0);
  begin
    case (state) is
      when X"001" =>
        interrupt_cause <= std_logic_vector(to_unsigned(00, 4));
      when X"002" =>
        interrupt_cause <= std_logic_vector(to_unsigned(01, 4));
      when X"004" =>
        interrupt_cause <= std_logic_vector(to_unsigned(02, 4));
      when X"008" =>
        interrupt_cause <= std_logic_vector(to_unsigned(03, 4));
      when X"010" =>
        interrupt_cause <= std_logic_vector(to_unsigned(04, 4));
      when X"020" =>
        interrupt_cause <= std_logic_vector(to_unsigned(05, 4));
      when X"040" =>
        interrupt_cause <= std_logic_vector(to_unsigned(06, 4));
      when X"080" =>
        interrupt_cause <= std_logic_vector(to_unsigned(07, 4));
      when X"100" =>
        interrupt_cause <= std_logic_vector(to_unsigned(08, 4));
      when X"200" =>
        interrupt_cause <= std_logic_vector(to_unsigned(09, 4));
      when X"400" =>
        interrupt_cause <= std_logic_vector(to_unsigned(10, 4));
      when X"800" =>
        interrupt_cause <= std_logic_vector(to_unsigned(11, 4));
      when others =>
        interrupt_cause <= std_logic_vector(to_unsigned(00, 4));
    end case;
    state := st_int and not du_ie(31 downto 20);
  end process;

  take_interrupt <= reduce_or(st_int and not du_ie(31 downto 20));

  --for Debug Unit
  du_exceptions <= (st_int & (4+EXCEPTION_SIZE-1 downto EXCEPTION_SIZE => '0') & wb_exception) and du_ie;

  --Update mepc and mcause
  processing_14 : process (clk, rstn)
  begin
    if (rstn = '0') then
      st_interrupt <= '0';

      csr_mepc <= (others => '0');
      --csr_hepc     <= 'h0;
      csr_sepc <= (others => '0');
      csr_uepc <= (others => '0');

      csr_mcause <= (others => '0');
      --csr_hcause   <= 'h0;
      csr_scause <= (others => '0');
      csr_ucause <= (others => '0');

      csr_mtval <= (others => '0');
      --csr_htval    <= 'h0;
      csr_stval <= (others => '0');
      csr_utval <= (others => '0');
    elsif (rising_edge(clk)) then
      --Write access to regs (lowest priority)
      if ((ex_csr_we = '1' and ex_csr_reg = MEPC and st_prv_sgn = PRV_M) or (du_we_csr = '1' and du_addr = MEPC)) then
        csr_mepc <= (csr_wval(XLEN-1 downto 2) & (csr_wval(1) and has_rvc_s) & '0');
      end if;

--      if ( (ex_csr_we && ex_csr_reg == HEPC && st_prv_sgn >= PRV_H) ||
--           (du_we_csr && du_addr    == HEPC)                  )
--        csr_hepc <= {csr_wval[XLEN-1:2], csr_wval[1] & has_rvc_s, 1'b0};

      if ((ex_csr_we = '1' and ex_csr_reg = SEPC and st_prv_sgn >= PRV_S) or (du_we_csr = '1' and du_addr = SEPC)) then
        csr_sepc <= (csr_wval(XLEN-1 downto 2) & (csr_wval(1) and has_rvc_s) & '0');
      end if;
      if ((ex_csr_we = '1' and ex_csr_reg = UEPC and st_prv_sgn >= PRV_U) or (du_we_csr = '1' and du_addr = UEPC)) then
        csr_uepc <= (csr_wval(XLEN-1 downto 2) & (csr_wval(1) and has_rvc_s) & '0');
      end if;
      if ((ex_csr_we = '1' and ex_csr_reg = MCAUSE and st_prv_sgn = PRV_M) or (du_we_csr = '1' and du_addr = MCAUSE)) then
        csr_mcause <= csr_wval;
      end if;

--      if ( (ex_csr_we && ex_csr_reg == HCAUSE && st_prv_sgn >= PRV_H) ||
--           (du_we_csr && du_addr    == HCAUSE)                  )
--        csr_hcause <= csr_wval;

      if ((ex_csr_we = '1' and ex_csr_reg = SCAUSE and st_prv_sgn >= PRV_S) or (du_we_csr = '1' and du_addr = SCAUSE)) then
        csr_scause <= csr_wval;
      end if;
      if ((ex_csr_we = '1' and ex_csr_reg = UCAUSE and st_prv_sgn >= PRV_U) or (du_we_csr = '1' and du_addr = UCAUSE)) then
        csr_ucause <= csr_wval;
      end if;
      if ((ex_csr_we = '1' and ex_csr_reg = MTVAL and st_prv_sgn = PRV_M) or (du_we_csr = '1' and du_addr = MTVAL)) then
        csr_mtval <= csr_wval;
      end if;

--      if ( (ex_csr_we && ex_csr_reg == HTVAL && st_prv_sgn >= PRV_H) ||
--           (du_we_csr && du_addr    == HTVAL)                  )
--        csr_htval <= csr_wval;

      if ((ex_csr_we = '1' and ex_csr_reg = STVAL and st_prv_sgn >= PRV_S) or (du_we_csr = '1' and du_addr = STVAL)) then
        csr_stval <= csr_wval;
      end if;
      if ((ex_csr_we = '1' and ex_csr_reg = UTVAL and st_prv_sgn >= PRV_U) or (du_we_csr = '1' and du_addr = UTVAL)) then
        csr_utval <= csr_wval;
      end if;
      --Handle exceptions
      st_interrupt <= '0';

      --priority external interrupts, software interrupts, timer interrupts, traps
      if (ext_nmi = '1') then  --TODO: doesn't this cause a deadlock? Need to hold of NMI once handled
        --NMI always at Machine Level
        st_interrupt <= '1';

        if (bu_flush = '1') then
          csr_mepc <= bu_nxt_pc;
        else
          csr_mepc <= id_pc;
        end if;

        csr_mcause <= std_logic_vector(to_unsigned(1, XLEN) sll (XLEN-1)) or (csr_mcause'range => '0');  --Implementation dependent. '0' indicates 'unknown cause'
      elsif (take_interrupt = '1') then
        st_interrupt <= '1';
        --Check if interrupts are delegated
        if (has_n = '1' and st_prv_sgn = PRV_U and (st_int and csr_mideleg(11 downto 0) and X"111") = X"111") then
          csr_ucause <= std_logic_vector(to_unsigned(1, XLEN) sll (XLEN-1)) or ((XLEN-1 downto 4 => '0') & interrupt_cause);
          csr_uepc   <= id_pc;
        elsif (has_s = '1' and st_prv_sgn >= PRV_S and (st_int and csr_mideleg(11 downto 0) and X"333") = X"111") then
          csr_scause <= std_logic_vector(to_unsigned(1, XLEN) sll (XLEN-1)) or ((XLEN-1 downto 4 => '0') & interrupt_cause);
          csr_sepc   <= id_pc;
        else                            --
--        else if (has_h && st_prv_sgn >= PRV_H && (st_int & csr_mideleg & 12'h777) ) begin
--          csr_hcause <= (1 << (XLEN-1)) | interrupt_cause;
--          csr_hepc   <= id_pc;
--        end
          csr_mcause <= std_logic_vector(to_unsigned(1, XLEN) sll (XLEN-1)) or ((XLEN-1 downto 4 => '0') & interrupt_cause);
          csr_mepc   <= id_pc;
        end if;
      elsif (reduce_or(wb_exception and not du_ie(15 downto 0)) = '1') then
        --Trap
        if (has_n = '1' and st_prv_sgn = PRV_U and reduce_or(wb_exception and csr_medeleg(EXCEPTION_SIZE-1 downto 0)) = '1') then
          csr_uepc   <= wb_pc;
          csr_ucause <= (XLEN-1 downto 4 => '0') & trap_cause;
          csr_utval  <= wb_badaddr;
        elsif (has_s = '1' and st_prv_sgn >= PRV_S and reduce_or(wb_exception and csr_medeleg(EXCEPTION_SIZE-1 downto 0)) = '1') then
          csr_sepc   <= wb_pc;
          csr_scause <= (XLEN-1 downto 4 => '0') & trap_cause;

          if (wb_exception(CAUSE_ILLEGAL_INSTRUCTION) = '1') then
            csr_stval <= wb_instr;
          elsif ( wb_exception(CAUSE_MISALIGNED_INSTRUCTION) = '1' or
                  wb_exception(CAUSE_INSTRUCTION_ACCESS_FAULT) = '1' or
                  wb_exception(CAUSE_INSTRUCTION_PAGE_FAULT) = '1' or
                  wb_exception(CAUSE_MISALIGNED_LOAD) = '1' or
                  wb_exception(CAUSE_LOAD_ACCESS_FAULT) = '1' or
                  wb_exception(CAUSE_LOAD_PAGE_FAULT) = '1' or
                  wb_exception(CAUSE_MISALIGNED_STORE) = '1' or
                  wb_exception(CAUSE_STORE_ACCESS_FAULT) = '1' or
                  wb_exception(CAUSE_STORE_PAGE_FAULT) = '1') then
            csr_stval <= wb_badaddr;
          end if;
        else
--        else if (has_h && st_prv_sgn >= PRV_H && |(wb_exception & csr_medeleg)) begin
--          csr_hepc   <= wb_pc;
--          csr_hcause <= trap_cause;
--
--          if (wb_exception[CAUSE_ILLEGAL_INSTRUCTION]) begin
--            csr_htval <= wb_instr;
--          else if (wb_exception[CAUSE_MISALIGNED_INSTRUCTION] || wb_exception[CAUSE_INSTRUCTION_ACCESS_FAULT] || wb_exception[CAUSE_INSTRUCTION_PAGE_FAULT] ||
--                   wb_exception[CAUSE_MISALIGNED_LOAD       ] || wb_exception[CAUSE_LOAD_ACCESS_FAULT       ] || wb_exception[CAUSE_LOAD_PAGE_FAULT       ] ||
--                   wb_exception[CAUSE_MISALIGNED_STORE      ] || wb_exception[CAUSE_STORE_ACCESS_FAULT      ] || wb_exception[CAUSE_STORE_PAGE_FAULT      ] )
--            csr_htval <= wb_badaddr;
--          end
--        end
          csr_mepc   <= wb_pc;
          csr_mcause <= (XLEN -1 downto 4 => '0') & trap_cause;
          if (wb_exception(CAUSE_ILLEGAL_INSTRUCTION) = '1') then
            csr_mtval <= (XLEN-1 downto ILEN => '0') & wb_instr;
          elsif ( wb_exception(CAUSE_MISALIGNED_INSTRUCTION) = '1' or
                  wb_exception(CAUSE_INSTRUCTION_ACCESS_FAULT) = '1' or
                  wb_exception(CAUSE_INSTRUCTION_PAGE_FAULT) = '1' or
                  wb_exception(CAUSE_MISALIGNED_LOAD) = '1' or
                  wb_exception(CAUSE_LOAD_ACCESS_FAULT) = '1' or
                  wb_exception(CAUSE_LOAD_PAGE_FAULT) = '1' or
                  wb_exception(CAUSE_MISALIGNED_STORE) = '1' or
                  wb_exception(CAUSE_STORE_ACCESS_FAULT) = '1' or
                  wb_exception(CAUSE_STORE_PAGE_FAULT) = '1') then
            csr_mtval <= wb_badaddr;
          end if;
        end if;
      end if;
    end if;
  end process;

  --Physical Memory Protection & Translation registers
  generating_7 : if (XLEN > 64) generate               --RV128
    generating_8 : for idx in 0 to 15 generate
      generating_9 : if (idx < PMP_CNT) generate
        processing_15 : process (clk, rstn)
        begin
          if (rstn = '0') then
            csr_pmpcfg(idx) <= (others => '0');
          elsif (rising_edge(clk)) then
            if ((ex_csr_we = '1' and ex_csr_reg = PMPCFG0 and st_prv_sgn = PRV_M) or (du_we_csr = '1' and du_addr = PMPCFG0)) then
              if (csr_pmpcfg(idx)(7) = '0') then
                csr_pmpcfg(idx) <= csr_wval(idx*8+7 downto idx*8) and PMPCFG_MASK;
              end if;
            end if;
          end if;
        end process;
      elsif (idx >= PMP_CNT) generate
        csr_pmpcfg(idx) <= (others => '0');
      end generate;
    end generate;
  end generate;
    --next idx

  --pmpaddr not defined for RV128 yet
  generating_11 : if (XLEN > 32) generate            --RV64 
    generating_12 : for idx in 0 to 7 generate
      processing_16 : process (clk, rstn)
      begin
        if (rstn = '0') then
          csr_pmpcfg(idx) <= (others => '0');
        elsif (rising_edge(clk)) then
          if ((ex_csr_we = '1' and ex_csr_reg = PMPCFG0 and st_prv_sgn = PRV_M) or (du_we_csr = '1' and du_addr = PMPCFG0)) then
            if (idx < PMP_CNT and csr_pmpcfg(idx)(7) = '0') then
              csr_pmpcfg(idx) <= csr_wval(idx*8+7 downto idx*8) and PMPCFG_MASK;
            end if;
          end if;
        end if;
      end process;
    end generate;
    --next idx

    generating_13 : for idx in 8 to 15 generate
      processing_17 : process (clk, rstn)
      begin
        if (rstn = '0') then
          csr_pmpcfg(idx) <= (others => '0');
        elsif (rising_edge(clk)) then
          if ((ex_csr_we = '1' and ex_csr_reg = PMPCFG2 and st_prv_sgn = PRV_M) or (du_we_csr = '1' and du_addr = PMPCFG2)) then
            if (idx < PMP_CNT and csr_pmpcfg(idx)(7) = '0') then
              csr_pmpcfg(idx) <= csr_wval((idx-8)*8+7 downto (idx-8)*8) and PMPCFG_MASK;
            end if;
          end if;
        end if;
      end process;
    end generate;
    --next idx

    generating_14 : for idx in 0 to 15 generate
      generating_15 : if (idx < PMP_CNT) generate
        generating_16 : if (idx = 15) generate
          processing_18 : process (clk, rstn)
          begin
            if (rstn = '0') then
              csr_pmpaddr(idx) <= (others => '0');
            elsif (rising_edge(clk)) then
              if ((ex_csr_we = '1' and ex_csr_reg = std_logic_vector(unsigned(PMPADDR0)+to_unsigned(idx, 12)) and st_prv_sgn = PRV_M and csr_pmpcfg(idx)(7) = '0') or (du_we_csr = '1' and du_addr = std_logic_vector(unsigned(PMPADDR0)+to_unsigned(idx, 12)))) then
                csr_pmpaddr(idx) <= ((XLEN-1 downto 54 => '0') & csr_wval(53 downto 0));
              end if;
            end if;
          end process;
        elsif (idx /= 15) generate
          processing_19 : process (clk, rstn)
          begin
            if (rstn = '0') then
              csr_pmpaddr(idx) <= (others => '0');
            elsif (rising_edge(clk)) then
              if ((ex_csr_we = '1' and ex_csr_reg = std_logic_vector(unsigned(PMPADDR0)+to_unsigned(idx, 12)) and st_prv_sgn = PRV_M and csr_pmpcfg(idx)(7) = '0' and (csr_pmpcfg(idx+1)(4 downto 3) /= TOR and csr_pmpcfg(idx+1)(7) = '1')) or (du_we_csr = '1' and du_addr = std_logic_vector(unsigned(PMPADDR0)+to_unsigned(idx, 12)))) then
                csr_pmpaddr(idx) <= ((XLEN-1 downto 54 => '0') & csr_wval(53 downto 0));
              end if;
            end if;
          end process;
        end generate;
      elsif (idx >= PMP_CNT) generate
        csr_pmpaddr(idx) <= (others => '0');
      end generate;
    end generate;
  end generate;                        --next idx
  generating_19 : if (XLEN <= 32) generate
    --RV32
    generating_20 : for idx in 0 to 3 generate
      processing_20 : process (clk, rstn)
      begin
        if (rstn = '0') then
          csr_pmpcfg(idx) <= (others => '0');
        elsif (rising_edge(clk)) then
          if ((ex_csr_we = '1' and ex_csr_reg = PMPCFG0 and st_prv_sgn = PRV_M) or (du_we_csr = '1' and du_addr = PMPCFG0)) then
            if (idx < PMP_CNT and csr_pmpcfg(idx)(7) = '0') then
              csr_pmpcfg(idx) <= csr_wval(idx*8+7 downto idx*8) and PMPCFG_MASK;
            end if;
          end if;
        end if;
      end process;
    end generate;
    --next idx

    generating_21 : for idx in 4 to 8 - 1 generate
      processing_21 : process (clk, rstn)
      begin
        if (rstn = '0') then
          csr_pmpcfg(idx) <= (others => '0');
        elsif (rising_edge(clk)) then
          if ((ex_csr_we = '1' and ex_csr_reg = PMPCFG1 and st_prv_sgn = PRV_M) or (du_we_csr = '1' and du_addr = PMPCFG1)) then
            if (idx < PMP_CNT and csr_pmpcfg(idx)(7) = '0') then
              csr_pmpcfg(idx) <= csr_wval((idx-4)*8+7 downto (idx-4)*8) and PMPCFG_MASK;
            end if;
          end if;
        end if;
      end process;
    end generate;
    --next idx

    generating_22 : for idx in 8 to 12 - 1 generate
      processing_22 : process (clk, rstn)
      begin
        if (rstn = '0') then
          csr_pmpcfg(idx) <= (others => '0');
        elsif (rising_edge(clk)) then
          if ((ex_csr_we = '1' and ex_csr_reg = PMPCFG2 and st_prv_sgn = PRV_M) or (du_we_csr = '1' and du_addr = PMPCFG2)) then
            if (idx < PMP_CNT and csr_pmpcfg(idx)(7) = '0') then
              csr_pmpcfg(idx) <= csr_wval((idx-8)*8+7 downto (idx-8)*8) and PMPCFG_MASK;
            end if;
          end if;
        end if;
      end process;
    end generate;
    --next idx

    generating_23 : for idx in 12 to 15 generate
      processing_23 : process (clk, rstn)
      begin
        if (rstn = '0') then
          csr_pmpcfg(idx) <= (others => '0');
        elsif (rising_edge(clk)) then
          if ((ex_csr_we = '1' and ex_csr_reg = PMPCFG3 and st_prv_sgn = PRV_M) or (du_we_csr = '1' and du_addr = PMPCFG3)) then
            if (idx < PMP_CNT and csr_pmpcfg(idx)(7) = '0') then
              csr_pmpcfg(idx) <= csr_wval((idx-12)*8+7 downto (idx-12)*8) and PMPCFG_MASK;
            end if;
          end if;
        end if;
      end process;
    end generate;
    --next idx

    generating_24 : for idx in 0 to 15 generate
      generating_25 : if (idx < PMP_CNT) generate
        generating_26 : if (idx = 15) generate
          processing_24 : process (clk, rstn)
          begin
            if (rstn = '0') then
              csr_pmpaddr(idx) <= (others => '0');
            elsif (rising_edge(clk)) then
              if ((ex_csr_we = '1' and ex_csr_reg = std_logic_vector(unsigned(PMPADDR0)+to_unsigned(idx, 12)) and st_prv_sgn = PRV_M and csr_pmpcfg(idx)(7) = '0') or (du_we_csr = '1' and du_addr = std_logic_vector(unsigned(PMPADDR0)+to_unsigned(idx, 12)))) then
                csr_pmpaddr(idx) <= csr_wval;
              end if;
            end if;
          end process;
        elsif (idx /= 15) generate
          processing_25 : process (clk, rstn)
          begin
            if (rstn = '0') then
              csr_pmpaddr(idx) <= (others => '0');
            elsif (rising_edge(clk)) then
              if ((ex_csr_we = '1' and ex_csr_reg = std_logic_vector(unsigned(PMPADDR0)+to_unsigned(idx, 12)) and st_prv_sgn = PRV_M and csr_pmpcfg(idx)(7) = '0' and (csr_pmpcfg(idx+1)(4 downto 3) /= TOR and csr_pmpcfg(idx+1)(7) = '1')) or (du_we_csr = '1' and du_addr = std_logic_vector(unsigned(PMPADDR0)+to_unsigned(idx, 12)))) then
                csr_pmpaddr(idx) <= csr_wval;
              end if;
            end if;
          end process;
        end generate;
      elsif (idx < PMP_CNT) generate
        csr_pmpaddr(idx) <= (others => '0');
      end generate;
    end generate;
  end generate;
  --next idx

  st_pmpcfg  <= csr_pmpcfg;
  st_pmpaddr <= csr_pmpaddr;

  --//////////////////////////////////////////////////////////////
  --
  -- Supervisor Registers
  --
  generating_29 : if (HAS_SUPER = '1') generate
    --stvec
    processing_26 : process (clk, rstn)
    begin
      if (rstn = '0') then
        csr_stvec <= STVEC_DEFAULT;
      elsif (rising_edge(clk)) then
        if ((ex_csr_we = '1' and ex_csr_reg = STVEC and st_prv_sgn >= PRV_S) or (du_we_csr = '1' and du_addr = STVEC)) then
          csr_stvec <= csr_wval and not X"0000000000000002";
        end if;
      end if;
    end process;

    --scounteren
    processing_27 : process (clk, rstn)
    begin
      if (rstn = '0') then
        csr_scounteren <= (others => '0');
      elsif (rising_edge(clk)) then
        if ((ex_csr_we = '1' and ex_csr_reg = SCOUNTEREN and st_prv_sgn = PRV_M) or (du_we_csr = '1' and du_addr = SCOUNTEREN)) then
          csr_scounteren <= csr_wval and X"0000000000000007";
        end if;
      end if;
    end process;

    --sedeleg
    processing_28 : process (clk, rstn)
    begin
      if (rstn = '0') then
        csr_sedeleg <= (others => '0');
      elsif (rising_edge(clk)) then
        if ((ex_csr_we = '1' and ex_csr_reg = SEDELEG and st_prv_sgn >= PRV_S) or (du_we_csr = '1' and du_addr = SEDELEG)) then
          csr_sedeleg <= csr_wval and (std_logic_vector(to_unsigned(2**CAUSE_UMODE_ECALL, XLEN)) or std_logic_vector(to_unsigned(2**CAUSE_SMODE_ECALL, XLEN)));
        end if;
      end if;
    end process;

    --sscratch
    processing_29 : process (clk, rstn)
    begin
      if (rstn = '0') then
        csr_sscratch <= (others => '0');
      elsif (rising_edge(clk)) then
        if ((ex_csr_we = '1' and ex_csr_reg = SSCRATCH and st_prv_sgn >= PRV_S) or (du_we_csr = '1' and du_addr = SSCRATCH)) then
          csr_sscratch <= csr_wval;
        end if;
      end if;
    end process;

    --satp
    processing_30 : process (clk, rstn)
    begin
      if (rstn = '0') then
        csr_satp <= (others => '0');
      elsif (rising_edge(clk)) then
        if ((ex_csr_we = '1' and ex_csr_reg = SATP and st_prv_sgn >= PRV_S) or (du_we_csr = '1' and du_addr = SATP)) then
          csr_satp <= ex_csr_wval;
        end if;
      end if;
    end process;
  elsif (HAS_SUPER = '0') generate
    csr_stvec      <= (others => '0');
    csr_scounteren <= (others => '0');
    csr_sedeleg    <= (others => '0');
    csr_sscratch   <= (others => '0');
    csr_satp       <= (others => '0');
  end generate;

  st_scounteren <= csr_scounteren;

  --//////////////////////////////////////////////////////////////
  --User Registers
  --
  generating_31 : if (HAS_USER = '1') generate
    --utvec
    processing_31 : process (clk, rstn)
    begin
      if (rstn = '0') then
        csr_utvec <= UTVEC_DEFAULT;
      elsif (rising_edge(clk)) then
        if ((ex_csr_we = '1' and ex_csr_reg = UTVEC) or (du_we_csr = '1' and du_addr = UTVEC)) then
          csr_utvec <= (csr_wval(XLEN-1 downto 2) & "00");
        end if;
      end if;
    end process;

    --uscratch
    processing_32 : process (clk, rstn)
    begin
      if (rstn = '0') then
        csr_uscratch <= (others => '0');
      elsif (rising_edge(clk)) then
        if ((ex_csr_we = '1' and ex_csr_reg = USCRATCH) or (du_we_csr = '1' and du_addr = USCRATCH)) then
          csr_uscratch <= csr_wval;
        end if;
      end if;
    end process;

    --Floating point registers
    generating_32 : if (HAS_FPU = '1') generate
    end generate;
  elsif (HAS_USER = '0') generate
    csr_utvec    <= (others => '0');
    csr_uscratch <= (others => '0');
    csr_fcsr     <= (others => '0');
  end generate;
end RTL;
