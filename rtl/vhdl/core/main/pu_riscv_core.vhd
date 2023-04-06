-- Converted from rtl/verilog/core/pu_riscv_core.sv
-- by verilog2vhdl - QueenField

--------------------------------------------------------------------------------
--                                            __ _      _     _               --
--                                           / _(_)    | |   | |              --
--                __ _ _   _  ___  ___ _ __ | |_ _  ___| | __| |              --
--               / _` | | | |/ _ \/ _ \ '_ \|  _| |/ _ \ |/ _` |              --
--              | (_| | |_| |  __/  __/ | | | | | |  __/ | (_| |              --
--               \__, |\__,_|\___|\___|_| |_|_| |_|\___|_|\__,_|              --
--                  | |                                                       --
--                  |_|                                                       --
--                                                                            --
--                                                                            --
--              MPSoC-RISCV CPU                                               --
--              Core - Core                                                   --
--              AMBA3 AHB-Lite Bus Interface                                  --
--                                                                            --
--------------------------------------------------------------------------------

-- Copyright (c) 2017-2018 by the author(s)
--
-- Permission is hereby granted, free of charge, to any person obtaining a copy
-- of this software and associated documentation files (the "Software"), to deal
-- in the Software without restriction, including without limitation the rights
-- to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
-- copies of the Software, and to permit persons to whom the Software is
-- furnished to do so, subject to the following conditions:
--
-- The above copyright notice and this permission notice shall be included in
-- all copies or substantial portions of the Software.
--
-- THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
-- IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
-- FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
-- AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
-- LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
-- OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
-- THE SOFTWARE.
--
--------------------------------------------------------------------------------
-- Author(s):
--   Paco Reina Campo <pacoreinacampo@queenfield.tech>
--

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.pu_riscv_pkg.all;
use work.vhdl_pkg.all;

entity pu_riscv_core is
  generic (
    XLEN           : integer   := 64;
    PLEN           : integer   := 64;
    ILEN           : integer   := 64;
    EXCEPTION_SIZE : integer   := 16;
    HAS_USER       : std_logic := '1';
    HAS_SUPER      : std_logic := '1';
    HAS_HYPER      : std_logic := '1';
    HAS_BPU        : std_logic := '1';
    HAS_FPU        : std_logic := '1';
    HAS_MMU        : std_logic := '1';
    HAS_RVA        : std_logic := '1';
    HAS_RVM        : std_logic := '1';
    HAS_RVC        : std_logic := '1';
    IS_RV32E       : std_logic := '1';

    MULT_LATENCY : std_logic := '1';

    BREAKPOINTS : integer := 8;

    PMA_CNT : integer := 4;
    PMP_CNT : integer := 16;

    BP_GLOBAL_BITS    : integer := 2;
    BP_LOCAL_BITS     : integer := 10;
    BP_LOCAL_BITS_LSB : integer := 2;

    DU_ADDR_SIZE    : integer := 12;
    MAX_BREAKPOINTS : integer := 8;

    TECHNOLOGY : string := "GENERIC";

    PC_INIT : std_logic_vector(63 downto 0) := X"0000000080000000";

    MNMIVEC_DEFAULT : std_logic_vector(63 downto 0) := X"0000000000000004";
    MTVEC_DEFAULT   : std_logic_vector(63 downto 0) := X"0000000000000040";
    HTVEC_DEFAULT   : std_logic_vector(63 downto 0) := X"0000000000000080";
    STVEC_DEFAULT   : std_logic_vector(63 downto 0) := X"00000000000000C0";
    UTVEC_DEFAULT   : std_logic_vector(63 downto 0) := X"0000000000000100";

    JEDEC_BANK            : integer                      := 10;
    JEDEC_MANUFACTURER_ID : std_logic_vector(7 downto 0) := X"6E";

    HARTID : integer := 0;

    PARCEL_SIZE : integer := 64
  );
  port (
    rstn : in std_logic;                --Reset
    clk  : in std_logic;                --Clock

    --Instruction Memory Access bus
    if_stall_nxt_pc      : in  std_logic;
    if_nxt_pc            : out std_logic_vector(XLEN-1 downto 0);
    if_stall             : out std_logic;
    if_flush             : out std_logic;
    if_parcel            : in  std_logic_vector(PARCEL_SIZE-1 downto 0);
    if_parcel_pc         : in  std_logic_vector(XLEN-1 downto 0);
    if_parcel_valid      : in  std_logic_vector(PARCEL_SIZE/16-1 downto 0);
    if_parcel_misaligned : in  std_logic;
    if_parcel_page_fault : in  std_logic;

    --Data Memory Access bus
    dmem_adr        : out std_logic_vector(XLEN-1 downto 0);
    dmem_d          : out std_logic_vector(XLEN-1 downto 0);
    dmem_q          : in  std_logic_vector(XLEN-1 downto 0);
    dmem_we         : out std_logic;
    dmem_size       : out std_logic_vector(2 downto 0);
    dmem_req        : out std_logic;
    dmem_ack        : in  std_logic;
    dmem_err        : in  std_logic;
    dmem_misaligned : in  std_logic;
    dmem_page_fault : in  std_logic;

    --cpu state
    st_prv     : out std_logic_vector(1 downto 0);
    st_pmpcfg  : out std_logic_matrix(PMP_CNT-1 downto 0)(7 downto 0);
    st_pmpaddr : out std_logic_matrix(PMP_CNT-1 downto 0)(PLEN-1 downto 0);

    bu_cacheflush : out std_logic;

    --Interrupts
    ext_nmi  : in std_logic;
    ext_tint : in std_logic;
    ext_sint : in std_logic;
    ext_int  : in std_logic_vector(3 downto 0);

    --Debug Interface
    dbg_stall : in  std_logic;
    dbg_strb  : in  std_logic;
    dbg_we    : in  std_logic;
    dbg_addr  : in  std_logic_vector(PLEN-1 downto 0);
    dbg_dati  : in  std_logic_vector(XLEN-1 downto 0);
    dbg_dato  : out std_logic_vector(XLEN-1 downto 0);
    dbg_ack   : out std_logic;
    dbg_bp    : out std_logic
  );
end pu_riscv_core;

architecture rtl of pu_riscv_core is
  component pu_riscv_if
    generic (
      XLEN           : integer := 64;
      ILEN           : integer := 64;
      PARCEL_SIZE    : integer := 64;
      EXCEPTION_SIZE : integer := 16;

      PC_INIT : std_logic_vector(63 downto 0) := X"0000000080000000"
    );
    port (
      rstn     : in std_logic;          --Reset
      clk      : in std_logic;          --Clock
      id_stall : in std_logic;

      if_stall_nxt_pc      : in std_logic;
      if_parcel            : in std_logic_vector(PARCEL_SIZE-1 downto 0);
      if_parcel_pc         : in std_logic_vector(XLEN-1 downto 0);
      if_parcel_valid      : in std_logic_vector(PARCEL_SIZE/16-1 downto 0);
      if_parcel_misaligned : in std_logic;
      if_parcel_page_fault : in std_logic;

      if_instr     : out std_logic_vector(ILEN-1 downto 0);  --Instruction out
      if_bubble    : out std_logic;  --Insert bubble in the pipe (NOP instruction)
      if_exception : out std_logic_vector(EXCEPTION_SIZE-1 downto 0);  --Exceptions


      bp_bp_predict : in  std_logic_vector(1 downto 0);  --Branch Prediction bits
      if_bp_predict : out std_logic_vector(1 downto 0);  --push down the pipe

      bu_flush : in std_logic;          --flush pipe & load new program counter
      st_flush : in std_logic;
      du_flush : in std_logic;          --flush pipe after debug exit

      bu_nxt_pc : in std_logic_vector(XLEN-1 downto 0);  --Branch Unit Next Program Counter
      st_nxt_pc : in std_logic_vector(XLEN-1 downto 0);  --State Next Program Counter

      if_nxt_pc : out std_logic_vector(XLEN-1 downto 0);  --next Program Counter
      if_stall  : out std_logic;  --stall instruction fetch BIU (cache/bus-interface)
      if_flush  : out std_logic;  --flush instruction fetch BIU (cache/bus-interface)
      if_pc     : out std_logic_vector(XLEN-1 downto 0)   --Program Counter
    );
  end component;

  component pu_riscv_id
    generic (
      XLEN           : integer := 64;
      ILEN           : integer := 64;
      EXCEPTION_SIZE : integer := 16
    );
    port (
      rstn : in std_logic;
      clk  : in std_logic;

      id_stall : out std_logic;
      ex_stall : in  std_logic;
      du_stall : in  std_logic;

      bu_flush : in std_logic;
      st_flush : in std_logic;
      du_flush : in std_logic;

      bu_nxt_pc : in std_logic_vector(XLEN-1 downto 0);
      st_nxt_pc : in std_logic_vector(XLEN-1 downto 0);

      --Program counter
      if_pc         : in  std_logic_vector(XLEN-1 downto 0);
      id_pc         : out std_logic_vector(XLEN-1 downto 0);
      if_bp_predict : in  std_logic_vector(1 downto 0);
      id_bp_predict : out std_logic_vector(1 downto 0);

      --Instruction
      if_instr   : in  std_logic_vector(ILEN-1 downto 0);
      if_bubble  : in  std_logic;
      id_instr   : out std_logic_vector(ILEN-1 downto 0);
      id_bubble  : out std_logic;
      ex_instr   : in  std_logic_vector(ILEN-1 downto 0);
      ex_bubble  : in  std_logic;
      mem_instr  : in  std_logic_vector(ILEN-1 downto 0);
      mem_bubble : in  std_logic;
      wb_instr   : in  std_logic_vector(ILEN-1 downto 0);
      wb_bubble  : in  std_logic;

      --Exceptions
      if_exception  : in  std_logic_vector(EXCEPTION_SIZE-1 downto 0);
      ex_exception  : in  std_logic_vector(EXCEPTION_SIZE-1 downto 0);
      mem_exception : in  std_logic_vector(EXCEPTION_SIZE-1 downto 0);
      wb_exception  : in  std_logic_vector(EXCEPTION_SIZE-1 downto 0);
      id_exception  : out std_logic_vector(EXCEPTION_SIZE-1 downto 0);

      --From State
      st_prv        : in std_logic_vector(1 downto 0);
      st_xlen       : in std_logic_vector(1 downto 0);
      st_tvm        : in std_logic;
      st_tw         : in std_logic;
      st_tsr        : in std_logic;
      st_mcounteren : in std_logic_vector(XLEN-1 downto 0);
      st_scounteren : in std_logic_vector(XLEN-1 downto 0);

      --To RF
      id_src1 : out std_logic_vector(4 downto 0);
      id_src2 : out std_logic_vector(4 downto 0);

      --To execution units
      id_opA : out std_logic_vector(XLEN-1 downto 0);
      id_opB : out std_logic_vector(XLEN-1 downto 0);

      id_userf_opA  : out std_logic;
      id_userf_opB  : out std_logic;
      id_bypex_opA  : out std_logic;
      id_bypex_opB  : out std_logic;
      id_bypmem_opA : out std_logic;
      id_bypmem_opB : out std_logic;
      id_bypwb_opA  : out std_logic;
      id_bypwb_opB  : out std_logic;

      --from MEM/WB
      mem_r : in std_logic_vector(XLEN-1 downto 0);
      wb_r  : in std_logic_vector(XLEN-1 downto 0)
    );
  end component;

  component pu_riscv_execution
    generic (
      XLEN           : integer   := 64;
      ILEN           : integer   := 64;
      EXCEPTION_SIZE : integer   := 16;
      BP_GLOBAL_BITS : integer   := 2;
      HAS_RVC        : std_logic := '1';
      HAS_RVA        : std_logic := '1';
      HAS_RVM        : std_logic := '1';
      MULT_LATENCY   : std_logic := '1';

      PC_INIT : std_logic_vector(63 downto 0) := X"0000000080000000"
    );
    port (
      rstn : in std_logic;
      clk  : in std_logic;

      wb_stall : in  std_logic;
      ex_stall : out std_logic;

      --Program counter
      id_pc         : in  std_logic_vector(XLEN-1 downto 0);
      ex_pc         : out std_logic_vector(XLEN-1 downto 0);
      bu_nxt_pc     : out std_logic_vector(XLEN-1 downto 0);
      bu_flush      : out std_logic;
      bu_cacheflush : out std_logic;
      id_bp_predict : in  std_logic_vector(1 downto 0);
      bu_bp_predict : out std_logic_vector(1 downto 0);
      bu_bp_history : out std_logic_vector(BP_GLOBAL_BITS-1 downto 0);
      bu_bp_btaken  : out std_logic;
      bu_bp_update  : out std_logic;

      --Instruction
      id_bubble : in  std_logic;
      id_instr  : in  std_logic_vector(ILEN-1 downto 0);
      ex_bubble : out std_logic;
      ex_instr  : out std_logic_vector(ILEN-1 downto 0);

      id_exception  : in  std_logic_vector(EXCEPTION_SIZE-1 downto 0);
      mem_exception : in  std_logic_vector(EXCEPTION_SIZE-1 downto 0);
      wb_exception  : in  std_logic_vector(EXCEPTION_SIZE-1 downto 0);
      ex_exception  : out std_logic_vector(EXCEPTION_SIZE-1 downto 0);

      --from ID
      id_userf_opA  : in std_logic;
      id_userf_opB  : in std_logic;
      id_bypex_opA  : in std_logic;
      id_bypex_opB  : in std_logic;
      id_bypmem_opA : in std_logic;
      id_bypmem_opB : in std_logic;
      id_bypwb_opA  : in std_logic;
      id_bypwb_opB  : in std_logic;
      id_opA        : in std_logic_vector(XLEN-1 downto 0);
      id_opB        : in std_logic_vector(XLEN-1 downto 0);

      --from RF
      rf_srcv1 : in std_logic_vector(XLEN-1 downto 0);
      rf_srcv2 : in std_logic_vector(XLEN-1 downto 0);

      --to MEM
      ex_r : out std_logic_vector(XLEN-1 downto 0);

      --Bypasses
      mem_r : in std_logic_vector(XLEN-1 downto 0);
      wb_r  : in std_logic_vector(XLEN-1 downto 0);

      --To State
      ex_csr_reg  : out std_logic_vector(11 downto 0);
      ex_csr_wval : out std_logic_vector(XLEN-1 downto 0);
      ex_csr_we   : out std_logic;

      --From State
      st_prv      : in std_logic_vector(1 downto 0);
      st_xlen     : in std_logic_vector(1 downto 0);
      st_flush    : in std_logic;
      st_csr_rval : in std_logic_vector(XLEN-1 downto 0);

      --To DCACHE/Memory
      dmem_adr        : out std_logic_vector(XLEN-1 downto 0);
      dmem_d          : out std_logic_vector(XLEN-1 downto 0);
      dmem_req        : out std_logic;
      dmem_we         : out std_logic;
      dmem_size       : out std_logic_vector(2 downto 0);
      dmem_ack        : in  std_logic;
      dmem_q          : in  std_logic_vector(XLEN-1 downto 0);
      dmem_misaligned : in  std_logic;
      dmem_page_fault : in  std_logic;

      --Debug Unit
      du_stall     : in std_logic;
      du_stall_dly : in std_logic;
      du_flush     : in std_logic;
      du_we_pc     : in std_logic;
      du_dato      : in std_logic_vector(XLEN-1 downto 0);
      du_ie        : in std_logic_vector(31 downto 0)
    );
  end component;

  component pu_riscv_memory
    generic (
      XLEN : integer := 64;
      ILEN : integer := 64;

      EXCEPTION_SIZE : integer := 16;

      PC_INIT : std_logic_vector(63 downto 0) := X"0000000080000000"
    );
    port (
      rstn : in std_logic;
      clk  : in std_logic;

      wb_stall : in std_logic;

      --Program counter
      ex_pc  : in  std_logic_vector(XLEN-1 downto 0);
      mem_pc : out std_logic_vector(XLEN-1 downto 0);

      --Instruction
      ex_bubble  : in  std_logic;
      ex_instr   : in  std_logic_vector(ILEN-1 downto 0);
      mem_bubble : out std_logic;
      mem_instr  : out std_logic_vector(ILEN-1 downto 0);

      ex_exception  : in  std_logic_vector(EXCEPTION_SIZE-1 downto 0);
      wb_exception  : in  std_logic_vector(EXCEPTION_SIZE-1 downto 0);
      mem_exception : out std_logic_vector(EXCEPTION_SIZE-1 downto 0);

      --From EX
      ex_r     : in std_logic_vector(XLEN-1 downto 0);
      dmem_adr : in std_logic_vector(XLEN-1 downto 0);

      --To WB
      mem_r      : out std_logic_vector(XLEN-1 downto 0);
      mem_memadr : out std_logic_vector(XLEN-1 downto 0)
    );
  end component;

  component pu_riscv_wb
    generic (
      XLEN : integer := 64;
      ILEN : integer := 64;

      EXCEPTION_SIZE : integer := 16;

      PC_INIT : std_logic_vector(63 downto 0) := X"0000000080000000"
    );
    port (
      rst_ni : in std_logic;            --Reset
      clk_i  : in std_logic;            --Clock

      wb_stall_o : out std_logic;       --Stall on memory-wait

      mem_pc_i : in  std_logic_vector(XLEN-1 downto 0);
      wb_pc_o  : out std_logic_vector(XLEN-1 downto 0);

      mem_instr_i  : in  std_logic_vector(ILEN-1 downto 0);
      mem_bubble_i : in  std_logic;
      wb_instr_o   : out std_logic_vector(ILEN-1 downto 0);
      wb_bubble_o  : out std_logic;

      mem_exception_i : in  std_logic_vector(EXCEPTION_SIZE-1 downto 0);
      wb_exception_o  : out std_logic_vector(EXCEPTION_SIZE-1 downto 0);
      wb_badaddr_o    : out std_logic_vector(XLEN-1 downto 0);

      mem_r_i      : in std_logic_vector(XLEN-1 downto 0);
      mem_memadr_i : in std_logic_vector(XLEN-1 downto 0);

      --From Memory System
      dmem_ack_i        : in std_logic;
      dmem_err_i        : in std_logic;
      dmem_q_i          : in std_logic_vector(XLEN-1 downto 0);
      dmem_misaligned_i : in std_logic;
      dmem_page_fault_i : in std_logic;

      --To Register File
      wb_dst_o : out std_logic_vector(4 downto 0);
      wb_r_o   : out std_logic_vector(XLEN-1 downto 0);
      wb_we_o  : out std_logic
    );
  end component;

  component pu_riscv_state
    generic (
      XLEN           : integer := 64;
      FLEN           : integer := 64;
      ILEN           : integer := 64;
      EXCEPTION_SIZE : integer := 16;

      IS_RV32E : std_logic := '0';
      HAS_RVN  : std_logic := '1';
      HAS_RVC  : std_logic := '1';
      HAS_FPU  : std_logic := '1';
      HAS_MMU  : std_logic := '1';
      HAS_RVM  : std_logic := '1';
      HAS_RVA  : std_logic := '1';
      HAS_RVB  : std_logic := '1';
      HAS_RVT  : std_logic := '1';
      HAS_RVP  : std_logic := '1';
      HAS_EXT  : std_logic := '1';

      HAS_USER  : std_logic := '1';
      HAS_SUPER : std_logic := '1';
      HAS_HYPER : std_logic := '1';

      PC_INIT : std_logic_vector(63 downto 0) := X"0000000080000000";

      MNMIVEC_DEFAULT : std_logic_vector(63 downto 0) := X"0000000000000004";
      MTVEC_DEFAULT   : std_logic_vector(63 downto 0) := X"0000000000000040";
      HTVEC_DEFAULT   : std_logic_vector(63 downto 0) := X"0000000000000080";
      STVEC_DEFAULT   : std_logic_vector(63 downto 0) := X"00000000000000C0";
      UTVEC_DEFAULT   : std_logic_vector(63 downto 0) := X"0000000000000100";

      JEDEC_BANK            : integer                      := 10;
      JEDEC_MANUFACTURER_ID : std_logic_vector(7 downto 0) := X"6E";

      PMP_CNT : integer := 16;
      HARTID  : integer := 0
    );
    port (
      rstn : in std_logic;
      clk  : in std_logic;

      id_pc     : in std_logic_vector(XLEN-1 downto 0);
      id_bubble : in std_logic;
      id_instr  : in std_logic_vector(ILEN-1 downto 0);
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
      st_tvm        : out std_logic;    --trap on satp access or SFENCE.VMA
      st_tw         : out std_logic;    --trap on WFI (after time >=0)
      st_tsr        : out std_logic;    --trap SRET
      st_mcounteren : out std_logic_vector(XLEN-1 downto 0);
      st_scounteren : out std_logic_vector(XLEN-1 downto 0);
      st_pmpcfg     : out std_logic_matrix(PMP_CNT-1 downto 0)(7 downto 0);
      st_pmpaddr    : out std_logic_matrix(PMP_CNT-1 downto 0)(PLEN-1 downto 0);


      --interrupts (3=M-mode, 0=U-mode)
      ext_int  : in std_logic_vector(3 downto 0);  --external interrupt (per privilege mode; determined by PIC)
      ext_tint : in std_logic;          --machine timer interrupt
      ext_sint : in std_logic;          --machine software interrupt (for ipi)
      ext_nmi  : in std_logic;          --non-maskable interrupt

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
  end component;

  component pu_riscv_rf
    generic (
      XLEN    : integer := 64;
      AR_BITS : integer := 5;
      RDPORTS : integer := 2;
      WRPORTS : integer := 1
    );
    port (
      rstn : in std_logic;
      clk  : in std_logic;

      --Register File read
      rf_src1  : in  std_logic_matrix(RDPORTS-1 downto 0)(AR_BITS-1 downto 0);
      rf_src2  : in  std_logic_matrix(RDPORTS-1 downto 0)(AR_BITS-1 downto 0);
      rf_srcv1 : out std_logic_matrix(RDPORTS-1 downto 0)(XLEN-1 downto 0);
      rf_srcv2 : out std_logic_matrix(RDPORTS-1 downto 0)(XLEN-1 downto 0);

      --Register File write
      rf_dst  : in std_logic_matrix(WRPORTS-1 downto 0)(AR_BITS-1 downto 0);
      rf_dstv : in std_logic_matrix(WRPORTS-1 downto 0)(XLEN-1 downto 0);
      rf_we   : in std_logic_vector(WRPORTS-1 downto 0);

      --Debug Interface
      du_stall   : in  std_logic;
      du_we_rf   : in  std_logic;
      du_dato    : in  std_logic_vector(XLEN-1 downto 0);  --output from debug unit
      du_dati_rf : out std_logic_vector(XLEN-1 downto 0);
      du_addr    : in  std_logic_vector(11 downto 0)
    );
  end component;

  component pu_riscv_bp
    generic (
      XLEN : integer := 64;

      HAS_BPU : std_logic := '1';

      BP_GLOBAL_BITS    : integer := 2;
      BP_LOCAL_BITS     : integer := 10;
      BP_LOCAL_BITS_LSB : integer := 2;

      TECHNOLOGY : string := "GENERIC";

      AVOID_X : std_logic := '0';

      PC_INIT : std_logic_vector(63 downto 0) := X"0000000080000000"
    );
    port (
      rst_ni : in std_logic;
      clk_i  : in std_logic;

      --Read side
      id_stall_i      : in  std_logic;
      if_parcel_pc_i  : in  std_logic_vector(XLEN-1 downto 0);
      bp_bp_predict_o : out std_logic_vector(1 downto 0);

      --Write side
      ex_pc_i         : in std_logic_vector(XLEN-1 downto 0);
      bu_bp_history_i : in std_logic_vector(BP_GLOBAL_BITS-1 downto 0);  --branch history
      bu_bp_predict_i : in std_logic_vector(1 downto 0);  --prediction bits for branch
      bu_bp_btaken_i  : in std_logic;
      bu_bp_update_i  : in std_logic
    );
  end component;

  component pu_riscv_du
    generic (
      XLEN : integer := 64;
      PLEN : integer := 64;
      ILEN : integer := 64;

      EXCEPTION_SIZE : integer := 16;

      DU_ADDR_SIZE    : integer := 12;
      MAX_BREAKPOINTS : integer := 8;

      BREAKPOINTS : integer := 3
    );
    port (
      rstn : in std_logic;
      clk  : in std_logic;

      --Debug Port interface
      dbg_stall : in  std_logic;
      dbg_strb  : in  std_logic;
      dbg_we    : in  std_logic;
      dbg_addr  : in  std_logic_vector(PLEN-1 downto 0);
      dbg_dati  : in  std_logic_vector(XLEN-1 downto 0);
      dbg_dato  : out std_logic_vector(XLEN-1 downto 0);
      dbg_ack   : out std_logic;
      dbg_bp    : out std_logic;

      --CPU signals
      du_stall     : out std_logic;
      du_stall_dly : out std_logic;
      du_flush     : out std_logic;
      du_we_rf     : out std_logic;
      du_we_frf    : out std_logic;
      du_we_csr    : out std_logic;
      du_we_pc     : out std_logic;
      du_addr      : out std_logic_vector(DU_ADDR_SIZE-1 downto 0);
      du_dato      : out std_logic_vector(XLEN-1 downto 0);
      du_ie        : out std_logic_vector(31 downto 0);
      du_dati_rf   : in  std_logic_vector(XLEN-1 downto 0);
      du_dati_frf  : in  std_logic_vector(XLEN-1 downto 0);
      st_csr_rval  : in  std_logic_vector(XLEN-1 downto 0);
      if_pc        : in  std_logic_vector(XLEN-1 downto 0);
      id_pc        : in  std_logic_vector(XLEN-1 downto 0);
      ex_pc        : in  std_logic_vector(XLEN-1 downto 0);
      bu_nxt_pc    : in  std_logic_vector(XLEN-1 downto 0);
      bu_flush     : in  std_logic;
      st_flush     : in  std_logic;

      if_instr      : in std_logic_vector(ILEN-1 downto 0);
      mem_instr     : in std_logic_vector(ILEN-1 downto 0);
      if_bubble     : in std_logic;
      mem_bubble    : in std_logic;
      mem_exception : in std_logic_vector(EXCEPTION_SIZE-1 downto 0);
      mem_memadr    : in std_logic_vector(XLEN-1 downto 0);
      dmem_ack      : in std_logic;
      ex_stall      : in std_logic;

      --From state
      du_exceptions : in std_logic_vector(31 downto 0)
    );
  end component;

  ------------------------------------------------------------------------------
  -- Variables
  ------------------------------------------------------------------------------
  signal bu_nxt_pc : std_logic_vector(XLEN-1 downto 0);
  signal st_nxt_pc : std_logic_vector(XLEN-1 downto 0);
  signal if_pc     : std_logic_vector(XLEN-1 downto 0);
  signal id_pc     : std_logic_vector(XLEN-1 downto 0);
  signal ex_pc     : std_logic_vector(XLEN-1 downto 0);
  signal mem_pc    : std_logic_vector(XLEN-1 downto 0);
  signal wb_pc     : std_logic_vector(XLEN-1 downto 0);

  signal if_instr  : std_logic_vector(ILEN-1 downto 0);
  signal id_instr  : std_logic_vector(ILEN-1 downto 0);
  signal ex_instr  : std_logic_vector(ILEN-1 downto 0);
  signal mem_instr : std_logic_vector(ILEN-1 downto 0);
  signal wb_instr  : std_logic_vector(ILEN-1 downto 0);

  signal if_bubble  : std_logic;
  signal id_bubble  : std_logic;
  signal ex_bubble  : std_logic;
  signal mem_bubble : std_logic;
  signal wb_bubble  : std_logic;

  signal bu_flush : std_logic;
  signal st_flush : std_logic;
  signal du_flush : std_logic;

  signal id_stall     : std_logic;
  signal ex_stall     : std_logic;
  signal wb_stall     : std_logic;
  signal du_stall     : std_logic;
  signal du_stall_dly : std_logic;

  --Branch Prediction
  signal bp_bp_predict : std_logic_vector(1 downto 0);
  signal if_bp_predict : std_logic_vector(1 downto 0);
  signal id_bp_predict : std_logic_vector(1 downto 0);
  signal bu_bp_predict : std_logic_vector(1 downto 0);

  signal bu_bp_history : std_logic_vector(BP_GLOBAL_BITS-1 downto 0);
  signal bu_bp_btaken  : std_logic;
  signal bu_bp_update  : std_logic;

  --Exceptions
  signal if_exception  : std_logic_vector(EXCEPTION_SIZE-1 downto 0);
  signal id_exception  : std_logic_vector(EXCEPTION_SIZE-1 downto 0);
  signal ex_exception  : std_logic_vector(EXCEPTION_SIZE-1 downto 0);
  signal mem_exception : std_logic_vector(EXCEPTION_SIZE-1 downto 0);
  signal wb_exception  : std_logic_vector(EXCEPTION_SIZE-1 downto 0);

  --RF access
  constant RDPORTS : integer := 1;
  constant WRPORTS : integer := 1;
  constant AR_BITS : integer := 5;

  signal id_srcv2 : std_logic_vector(XLEN-1 downto 0);
  signal rf_src1  : std_logic_matrix(RDPORTS-1 downto 0)(AR_BITS-1 downto 0);
  signal rf_src2  : std_logic_matrix(RDPORTS-1 downto 0)(AR_BITS-1 downto 0);
  signal rf_dst   : std_logic_matrix(WRPORTS-1 downto 0)(AR_BITS-1 downto 0);
  signal rf_srcv1 : std_logic_matrix(RDPORTS-1 downto 0)(XLEN-1 downto 0);
  signal rf_srcv2 : std_logic_matrix(RDPORTS-1 downto 0)(XLEN-1 downto 0);
  signal rf_dstv  : std_logic_matrix(WRPORTS-1 downto 0)(XLEN-1 downto 0);
  signal rf_we    : std_logic_vector(WRPORTS-1 downto 0);

  --ALU signals
  signal id_opA     : std_logic_vector(XLEN-1 downto 0);
  signal id_opB     : std_logic_vector(XLEN-1 downto 0);
  signal ex_r       : std_logic_vector(XLEN-1 downto 0);
  signal ex_memadr  : std_logic_vector(XLEN-1 downto 0);
  signal mem_r      : std_logic_vector(XLEN-1 downto 0);
  signal mem_memadr : std_logic_vector(XLEN-1 downto 0);

  signal id_userf_opA  : std_logic;
  signal id_userf_opB  : std_logic;
  signal id_bypex_opA  : std_logic;
  signal id_bypex_opB  : std_logic;
  signal id_bypmem_opA : std_logic;
  signal id_bypmem_opB : std_logic;
  signal id_bypwb_opA  : std_logic;
  signal id_bypwb_opB  : std_logic;

  --CPU state
  signal st_xlen       : std_logic_vector(1 downto 0);
  signal st_tvm        : std_logic;
  signal st_tw         : std_logic;
  signal st_tsr        : std_logic;
  signal st_mcounteren : std_logic_vector(XLEN-1 downto 0);
  signal st_scounteren : std_logic_vector(XLEN-1 downto 0);
  signal st_interrupt  : std_logic;
  signal ex_csr_reg    : std_logic_vector(11 downto 0);
  signal ex_csr_wval   : std_logic_vector(XLEN-1 downto 0);
  signal st_csr_rval   : std_logic_vector(XLEN-1 downto 0);
  signal ex_csr_we     : std_logic;

  --Write back
  signal wb_dst     : std_logic_vector(4 downto 0);
  signal wb_r       : std_logic_vector(XLEN-1 downto 0);
  signal wb_we      : std_logic;
  signal wb_badaddr : std_logic_vector(XLEN-1 downto 0);

  --Debug
  signal du_we_rf      : std_logic;
  signal du_we_frf     : std_logic;
  signal du_we_csr     : std_logic;
  signal du_we_pc      : std_logic;
  signal du_addr       : std_logic_vector(DU_ADDR_SIZE-1 downto 0);
  signal du_dato       : std_logic_vector(XLEN-1 downto 0);
  signal du_dati_rf    : std_logic_vector(XLEN-1 downto 0);
  signal du_dati_frf   : std_logic_vector(XLEN-1 downto 0);
  signal du_dati_csr   : std_logic_vector(XLEN-1 downto 0);
  signal du_ie         : std_logic_vector(31 downto 0);
  signal du_exceptions : std_logic_vector(31 downto 0);

  signal dmem_adr_sgn : std_logic_vector(XLEN-1 downto 0);
  signal st_prv_sgn   : std_logic_vector(1 downto 0);

begin
  ------------------------------------------------------------------------------
  -- Module Body
  ------------------------------------------------------------------------------

  --  * Instruction Fetch
  --  *
  --  * Calculate next Program Counter
  --  * Fetch next instruction

  if_unit : pu_riscv_if
    generic map (
      XLEN           => XLEN,
      ILEN           => ILEN,
      PARCEL_SIZE    => PARCEL_SIZE,
      EXCEPTION_SIZE => EXCEPTION_SIZE,

      PC_INIT => PC_INIT
      )
    port map (
      rstn                 => rstn,
      clk                  => clk,
      id_stall             => id_stall,
      if_stall_nxt_pc      => if_stall_nxt_pc,
      if_parcel            => if_parcel,
      if_parcel_pc         => if_parcel_pc,
      if_parcel_valid      => if_parcel_valid,
      if_parcel_misaligned => if_parcel_misaligned,
      if_parcel_page_fault => if_parcel_page_fault,
      if_instr             => if_instr,
      if_bubble            => if_bubble,
      if_exception         => if_exception,
      bp_bp_predict        => bp_bp_predict,
      if_bp_predict        => if_bp_predict,
      bu_flush             => bu_flush,
      st_flush             => st_flush,
      du_flush             => du_flush,
      bu_nxt_pc            => bu_nxt_pc,
      st_nxt_pc            => st_nxt_pc,
      if_nxt_pc            => if_nxt_pc,
      if_stall             => if_stall,
      if_flush             => if_flush,
      if_pc                => if_pc
    );

  --  * Instruction Decoder
  --  *
  --  * Data from RF/ROB is available here

  id_unit : pu_riscv_id
    generic map (
      XLEN           => XLEN,
      ILEN           => ILEN,
      EXCEPTION_SIZE => EXCEPTION_SIZE
      )
    port map (
      rstn          => rstn,
      clk           => clk,
      id_stall      => id_stall,
      ex_stall      => ex_stall,
      du_stall      => du_stall,
      bu_flush      => bu_flush,
      st_flush      => st_flush,
      du_flush      => du_flush,
      bu_nxt_pc     => bu_nxt_pc,
      st_nxt_pc     => st_nxt_pc,
      if_pc         => if_pc,
      id_pc         => id_pc,
      if_bp_predict => if_bp_predict,
      id_bp_predict => id_bp_predict,
      if_instr      => if_instr,
      if_bubble     => if_bubble,
      id_instr      => id_instr,
      id_bubble     => id_bubble,
      ex_instr      => ex_instr,
      ex_bubble     => ex_bubble,
      mem_instr     => mem_instr,
      mem_bubble    => mem_bubble,
      wb_instr      => wb_instr,
      wb_bubble     => wb_bubble,
      if_exception  => if_exception,
      ex_exception  => ex_exception,
      mem_exception => mem_exception,
      wb_exception  => wb_exception,
      id_exception  => id_exception,
      st_prv        => st_prv_sgn,
      st_xlen       => st_xlen,
      st_tvm        => st_tvm,
      st_tw         => st_tw,
      st_tsr        => st_tsr,
      st_mcounteren => st_mcounteren,
      st_scounteren => st_scounteren,

      id_src1 => rf_src1(0),
      id_src2 => rf_src2(0),

      id_opA        => id_opA,
      id_opB        => id_opB,
      id_userf_opA  => id_userf_opA,
      id_userf_opB  => id_userf_opB,
      id_bypex_opA  => id_bypex_opA,
      id_bypex_opB  => id_bypex_opB,
      id_bypmem_opA => id_bypmem_opA,
      id_bypmem_opB => id_bypmem_opB,
      id_bypwb_opA  => id_bypwb_opA,
      id_bypwb_opB  => id_bypwb_opB,
      mem_r         => mem_r,
      wb_r          => wb_r
    );

  --Execution units
  execution_unit : pu_riscv_execution
    generic map (
      XLEN           => XLEN,
      ILEN           => ILEN,
      EXCEPTION_SIZE => EXCEPTION_SIZE,
      BP_GLOBAL_BITS => BP_GLOBAL_BITS,
      HAS_RVC        => HAS_RVC,
      HAS_RVA        => HAS_RVA,
      HAS_RVM        => HAS_RVM,
      MULT_LATENCY   => MULT_LATENCY,

      PC_INIT => PC_INIT
      )
    port map (
      rstn          => rstn,
      clk           => clk,
      wb_stall      => wb_stall,
      ex_stall      => ex_stall,
      id_pc         => id_pc,
      ex_pc         => ex_pc,
      bu_nxt_pc     => bu_nxt_pc,
      bu_flush      => bu_flush,
      bu_cacheflush => bu_cacheflush,
      id_bp_predict => id_bp_predict,
      bu_bp_predict => bu_bp_predict,
      bu_bp_history => bu_bp_history,
      bu_bp_btaken  => bu_bp_btaken,
      bu_bp_update  => bu_bp_update,
      id_bubble     => id_bubble,
      id_instr      => id_instr,
      ex_bubble     => ex_bubble,
      ex_instr      => ex_instr,
      id_exception  => id_exception,
      mem_exception => mem_exception,
      wb_exception  => wb_exception,
      ex_exception  => ex_exception,
      id_userf_opA  => id_userf_opA,
      id_userf_opB  => id_userf_opB,
      id_bypex_opA  => id_bypex_opA,
      id_bypex_opB  => id_bypex_opB,
      id_bypmem_opA => id_bypmem_opA,
      id_bypmem_opB => id_bypmem_opB,
      id_bypwb_opA  => id_bypwb_opA,
      id_bypwb_opB  => id_bypwb_opB,
      id_opA        => id_opA,
      id_opB        => id_opB,

      rf_srcv1 => rf_srcv1(0),
      rf_srcv2 => rf_srcv2(0),

      ex_r            => ex_r,
      mem_r           => mem_r,
      wb_r            => wb_r,
      ex_csr_reg      => ex_csr_reg,
      ex_csr_wval     => ex_csr_wval,
      ex_csr_we       => ex_csr_we,
      st_prv          => st_prv_sgn,
      st_xlen         => st_xlen,
      st_flush        => st_flush,
      st_csr_rval     => st_csr_rval,
      dmem_adr        => dmem_adr_sgn,
      dmem_d          => dmem_d,
      dmem_req        => dmem_req,
      dmem_we         => dmem_we,
      dmem_size       => dmem_size,
      dmem_ack        => dmem_ack,
      dmem_q          => dmem_q,
      dmem_misaligned => dmem_misaligned,
      dmem_page_fault => dmem_page_fault,
      du_stall        => du_stall,
      du_stall_dly    => du_stall_dly,
      du_flush        => du_flush,
      du_we_pc        => du_we_pc,
      du_dato         => du_dato,
      du_ie           => du_ie
    );

  --Memory access
  memory_unit : pu_riscv_memory
    generic map (
      XLEN => XLEN,
      ILEN => ILEN,

      EXCEPTION_SIZE => EXCEPTION_SIZE,

      PC_INIT => PC_INIT
      )
    port map (
      rstn          => rstn,
      clk           => clk,
      wb_stall      => wb_stall,
      ex_pc         => ex_pc,
      mem_pc        => mem_pc,
      ex_bubble     => ex_bubble,
      ex_instr      => ex_instr,
      mem_bubble    => mem_bubble,
      mem_instr     => mem_instr,
      ex_exception  => ex_exception,
      wb_exception  => wb_exception,
      mem_exception => mem_exception,
      ex_r          => ex_r,
      dmem_adr      => dmem_adr_sgn,
      mem_r         => mem_r,
      mem_memadr    => mem_memadr
    );

  dmem_adr <= dmem_adr_sgn;

  --Memory acknowledge + Write Back unit
  wb_unit : pu_riscv_wb
    generic map (
      XLEN => XLEN,
      ILEN => ILEN,

      EXCEPTION_SIZE => EXCEPTION_SIZE,

      PC_INIT => PC_INIT
      )
    port map (
      rst_ni            => rstn,
      clk_i             => clk,
      mem_pc_i          => mem_pc,
      mem_instr_i       => mem_instr,
      mem_bubble_i      => mem_bubble,
      mem_r_i           => mem_r,
      mem_exception_i   => mem_exception,
      mem_memadr_i      => mem_memadr,
      wb_pc_o           => wb_pc,
      wb_stall_o        => wb_stall,
      wb_instr_o        => wb_instr,
      wb_bubble_o       => wb_bubble,
      wb_exception_o    => wb_exception,
      wb_badaddr_o      => wb_badaddr,
      dmem_ack_i        => dmem_ack,
      dmem_err_i        => dmem_err,
      dmem_q_i          => dmem_q,
      dmem_misaligned_i => dmem_misaligned,
      dmem_page_fault_i => dmem_page_fault,
      wb_dst_o          => wb_dst,
      wb_r_o            => wb_r,
      wb_we_o           => wb_we
    );

  rf_dst (0)  <= wb_dst;
  rf_dstv (0) <= wb_r;
  rf_we (0)   <= wb_we;

  --Thread state
  cpu_state : pu_riscv_state
    generic map (
      XLEN           => XLEN,
      FLEN           => 64,
      ILEN           => ILEN,
      EXCEPTION_SIZE => EXCEPTION_SIZE,

      IS_RV32E => IS_RV32E,
      HAS_RVN  => HAS_RVN,
      HAS_RVC  => HAS_RVC,
      HAS_FPU  => HAS_FPU,
      HAS_MMU  => HAS_MMU,
      HAS_RVM  => HAS_RVM,
      HAS_RVA  => HAS_RVA,
      HAS_RVB  => HAS_RVB,
      HAS_RVT  => HAS_RVT,
      HAS_RVP  => HAS_RVP,
      HAS_EXT  => HAS_EXT,

      HAS_USER  => HAS_USER,
      HAS_SUPER => HAS_SUPER,
      HAS_HYPER => HAS_HYPER,

      PC_INIT => PC_INIT,

      MNMIVEC_DEFAULT => MNMIVEC_DEFAULT,
      MTVEC_DEFAULT   => MTVEC_DEFAULT,
      HTVEC_DEFAULT   => HTVEC_DEFAULT,
      STVEC_DEFAULT   => STVEC_DEFAULT,
      UTVEC_DEFAULT   => UTVEC_DEFAULT,

      JEDEC_BANK            => JEDEC_BANK,
      JEDEC_MANUFACTURER_ID => JEDEC_MANUFACTURER_ID,

      PMP_CNT => PMP_CNT,
      HARTID  => HARTID
      )
    port map (
      rstn => rstn,
      clk  => clk,

      id_pc     => id_pc,
      id_bubble => id_bubble,
      id_instr  => id_instr,
      id_stall  => id_stall,

      bu_flush  => bu_flush,
      bu_nxt_pc => bu_nxt_pc,
      st_flush  => st_flush,
      st_nxt_pc => st_nxt_pc,

      wb_pc        => wb_pc,
      wb_bubble    => wb_bubble,
      wb_instr     => wb_instr,
      wb_exception => wb_exception,
      wb_badaddr   => wb_badaddr,

      st_interrupt  => st_interrupt,
      st_prv        => st_prv_sgn,
      st_xlen       => st_xlen,
      st_tvm        => st_tvm,
      st_tw         => st_tw,
      st_tsr        => st_tsr,
      st_mcounteren => st_mcounteren,
      st_scounteren => st_scounteren,
      st_pmpcfg     => st_pmpcfg,
      st_pmpaddr    => st_pmpaddr,

      ext_int  => ext_int,
      ext_tint => ext_tint,
      ext_sint => ext_sint,
      ext_nmi  => ext_nmi,

      ex_csr_reg  => ex_csr_reg,
      ex_csr_we   => ex_csr_we,
      ex_csr_wval => ex_csr_wval,
      st_csr_rval => st_csr_rval,

      du_stall  => du_stall,
      du_flush  => du_flush,
      du_we_csr => du_we_csr,
      du_dato   => du_dato,

      du_addr       => du_addr,
      du_ie         => du_ie,
      du_exceptions => du_exceptions
    );

  --Integer Register File
  rf_unit : pu_riscv_rf
    generic map (
      XLEN    => XLEN,
      AR_BITS => AR_BITS,
      RDPORTS => RDPORTS,
      WRPORTS => WRPORTS
      )
    port map (
      rstn       => rstn,
      clk        => clk,
      rf_src1    => rf_src1,
      rf_src2    => rf_src2,
      rf_srcv1   => rf_srcv1,
      rf_srcv2   => rf_srcv2,
      rf_dst     => rf_dst,
      rf_dstv    => rf_dstv,
      rf_we      => rf_we,
      du_stall   => du_stall,
      du_we_rf   => du_we_rf,
      du_dato    => du_dato,
      du_dati_rf => du_dati_rf,
      du_addr    => du_addr
    );

  --Branch Prediction Unit

  --Get Branch Prediction for Next Program Counter
  generating_0 : if (HAS_BPU = '0') generate
    bp_bp_predict <= "00";
  elsif (HAS_BPU /= '0') generate
    bp_unit : pu_riscv_bp
      generic map (
        XLEN => XLEN,

        HAS_BPU => HAS_BPU,

        BP_GLOBAL_BITS    => BP_GLOBAL_BITS,
        BP_LOCAL_BITS     => BP_LOCAL_BITS,
        BP_LOCAL_BITS_LSB => BP_LOCAL_BITS_LSB,

        TECHNOLOGY => TECHNOLOGY,

        AVOID_X => '0',

        PC_INIT => PC_INIT
        )
      port map (
        rst_ni => rstn,
        clk_i  => clk,

        id_stall_i      => id_stall,
        if_parcel_pc_i  => if_parcel_pc,
        bp_bp_predict_o => bp_bp_predict,

        ex_pc_i         => ex_pc,
        bu_bp_history_i => bu_bp_history,
        bu_bp_predict_i => bu_bp_predict,  --prediction bits for branch
        bu_bp_btaken_i  => bu_bp_btaken,
        bu_bp_update_i  => bu_bp_update
      );
  end generate;

  --Debug Unit
  du_unit : pu_riscv_du
    generic map (
      XLEN => XLEN,
      PLEN => PLEN,
      ILEN => ILEN,

      EXCEPTION_SIZE => EXCEPTION_SIZE,

      DU_ADDR_SIZE    => DU_ADDR_SIZE,
      MAX_BREAKPOINTS => MAX_BREAKPOINTS,

      BREAKPOINTS => BREAKPOINTS
      )
    port map (
      rstn          => rstn,
      clk           => clk,
      dbg_stall     => dbg_stall,
      dbg_strb      => dbg_strb,
      dbg_we        => dbg_we,
      dbg_addr      => dbg_addr,
      dbg_dati      => dbg_dati,
      dbg_dato      => dbg_dato,
      dbg_ack       => dbg_ack,
      dbg_bp        => dbg_bp,
      du_stall      => du_stall,
      du_stall_dly  => du_stall_dly,
      du_flush      => du_flush,
      du_we_rf      => du_we_rf,
      du_we_frf     => du_we_frf,
      du_we_csr     => du_we_csr,
      du_we_pc      => du_we_pc,
      du_addr       => du_addr,
      du_dato       => du_dato,
      du_ie         => du_ie,
      du_dati_rf    => du_dati_rf,
      du_dati_frf   => du_dati_frf,
      st_csr_rval   => st_csr_rval,
      if_pc         => if_pc,
      id_pc         => id_pc,
      ex_pc         => ex_pc,
      bu_nxt_pc     => bu_nxt_pc,
      bu_flush      => bu_flush,
      st_flush      => st_flush,
      if_instr      => if_instr,
      mem_instr     => mem_instr,
      if_bubble     => if_bubble,
      mem_bubble    => mem_bubble,
      mem_exception => mem_exception,
      mem_memadr    => mem_memadr,
      dmem_ack      => dmem_ack,
      ex_stall      => ex_stall,
      du_exceptions => du_exceptions
    );

  st_prv <= st_prv_sgn;
end rtl;
