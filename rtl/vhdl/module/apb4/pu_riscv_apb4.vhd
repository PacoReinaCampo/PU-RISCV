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
--              Processing Unit                                               --
--              Wishbone Bus Interface                                        --
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

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.pu_riscv_vhdl_pkg.all;
use work.vhdl_pkg.all;

entity pu_riscv_apb4 is
  generic (
    XLEN : integer := 64;
    PLEN : integer := 64;

    HAS_USER  : std_logic := '1';
    HAS_SUPER : std_logic := '1';
    HAS_HYPER : std_logic := '1';
    HAS_BPU   : std_logic := '1';
    HAS_FPU   : std_logic := '1';
    HAS_MMU   : std_logic := '1';
    HAS_RVM   : std_logic := '1';
    HAS_RVA   : std_logic := '1';
    HAS_RVC   : std_logic := '1';
    IS_RV32E  : std_logic := '1';

    MULT_LATENCY : std_logic := '1';

    BREAKPOINTS : integer := 8;         -- Number of hardware breakpoints

    PMA_CNT : integer := 4;
    PMP_CNT : integer := 16;  -- Number of Physical Memory Protection entries

    BP_GLOBAL_BITS    : integer := 2;
    BP_LOCAL_BITS     : integer := 10;
    BP_LOCAL_BITS_LSB : integer := 2;

    ICACHE_SIZE        : integer := 64;  -- in KBytes
    ICACHE_BLOCK_SIZE  : integer := 64;  -- in Bytes
    ICACHE_WAYS        : integer := 2;   -- 'n'-way set associative
    ICACHE_REPLACE_ALG : integer := 0;
    ITCM_SIZE          : integer := 0;

    DCACHE_SIZE        : integer := 64;  -- in KBytes
    DCACHE_BLOCK_SIZE  : integer := 64;  -- in Bytes
    DCACHE_WAYS        : integer := 2;   -- 'n'-way set associative
    DCACHE_REPLACE_ALG : integer := 0;
    DTCM_SIZE          : integer := 0;
    WRITEBUFFER_SIZE   : integer := 8;

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
    -- AHB interfaces
    HRESETn : in std_logic;
    HCLK    : in std_logic;

    pma_cfg_i : std_logic_matrix(PMA_CNT-1 downto 0)(13 downto 0);
    pma_adr_i : std_logic_matrix(PMA_CNT-1 downto 0)(PLEN-1 downto 0);

    ins_HSEL      : out std_logic;
    ins_HADDR     : out std_logic_vector(PLEN-1 downto 0);
    ins_HWDATA    : out std_logic_vector(XLEN-1 downto 0);
    ins_HRDATA    : in  std_logic_vector(XLEN-1 downto 0);
    ins_HWRITE    : out std_logic;
    ins_HSIZE     : out std_logic_vector(2 downto 0);
    ins_HBURST    : out std_logic_vector(2 downto 0);
    ins_HPROT     : out std_logic_vector(3 downto 0);
    ins_HTRANS    : out std_logic_vector(1 downto 0);
    ins_HMASTLOCK : out std_logic;
    ins_HREADY    : in  std_logic;
    ins_HRESP     : in  std_logic;

    dat_HSEL      : out std_logic;
    dat_HADDR     : out std_logic_vector(PLEN-1 downto 0);
    dat_HWDATA    : out std_logic_vector(XLEN-1 downto 0);
    dat_HRDATA    : in  std_logic_vector(XLEN-1 downto 0);
    dat_HWRITE    : out std_logic;
    dat_HSIZE     : out std_logic_vector(2 downto 0);
    dat_HBURST    : out std_logic_vector(2 downto 0);
    dat_HPROT     : out std_logic_vector(3 downto 0);
    dat_HTRANS    : out std_logic_vector(1 downto 0);
    dat_HMASTLOCK : out std_logic;
    dat_HREADY    : in  std_logic;
    dat_HRESP     : in  std_logic;

    -- Interrupts
    ext_nmi  : in std_logic;
    ext_tint : in std_logic;
    ext_sint : in std_logic;
    ext_int  : in std_logic_vector(3 downto 0);

    -- Debug Interface
    dbg_stall : in  std_logic;
    dbg_strb  : in  std_logic;
    dbg_we    : in  std_logic;
    dbg_addr  : in  std_logic_vector(PLEN-1 downto 0);
    dbg_dati  : in  std_logic_vector(XLEN-1 downto 0);
    dbg_dato  : out std_logic_vector(XLEN-1 downto 0);
    dbg_ack   : out std_logic;
    dbg_bp    : out std_logic
    );
end pu_riscv_apb4;

architecture rtl of pu_riscv_apb4 is
  component pu_riscv_core
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
      rstn : in std_logic;              -- Reset
      clk  : in std_logic;              -- Clock

      -- Instruction Memory Access bus
      if_stall_nxt_pc      : in  std_logic;
      if_nxt_pc            : out std_logic_vector(XLEN-1 downto 0);
      if_stall             : out std_logic;
      if_flush             : out std_logic;
      if_parcel            : in  std_logic_vector(PARCEL_SIZE-1 downto 0);
      if_parcel_pc         : in  std_logic_vector(XLEN-1 downto 0);
      if_parcel_valid      : in  std_logic_vector(PARCEL_SIZE/16-1 downto 0);
      if_parcel_misaligned : in  std_logic;
      if_parcel_page_fault : in  std_logic;

      -- Data Memory Access bus
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

      -- cpu state
      st_prv     : out std_logic_vector(1 downto 0);
      st_pmpcfg  : out std_logic_matrix(PMP_CNT-1 downto 0)(7 downto 0);
      st_pmpaddr : out std_logic_matrix(PMP_CNT-1 downto 0)(PLEN-1 downto 0);

      bu_cacheflush : out std_logic;

      -- Interrupts
      ext_nmi  : in std_logic;
      ext_tint : in std_logic;
      ext_sint : in std_logic;
      ext_int  : in std_logic_vector(3 downto 0);

      -- Debug Interface
      dbg_stall : in  std_logic;
      dbg_strb  : in  std_logic;
      dbg_we    : in  std_logic;
      dbg_addr  : in  std_logic_vector(PLEN-1 downto 0);
      dbg_dati  : in  std_logic_vector(XLEN-1 downto 0);
      dbg_dato  : out std_logic_vector(XLEN-1 downto 0);
      dbg_ack   : out std_logic;
      dbg_bp    : out std_logic
      );
  end component;

  component pu_riscv_imem_ctrl
    generic (
      XLEN : integer := 64;
      PLEN : integer := 64;

      PARCEL_SIZE : integer := 64;

      HAS_RVC : std_logic := '1';

      PMA_CNT : integer := 4;
      PMP_CNT : integer := 16;

      ICACHE_SIZE        : integer := 64;
      ICACHE_BLOCK_SIZE  : integer := 64;
      ICACHE_WAYS        : integer := 2;
      ICACHE_REPLACE_ALG : integer := 2;
      ITCM_SIZE          : integer := 0;

      TECHNOLOGY : string := "GENERIC"
      );
    port (
      rst_ni : in std_logic;
      clk_i  : in std_logic;

      -- Configuration
      pma_cfg_i : std_logic_matrix(PMA_CNT-1 downto 0)(13 downto 0);
      pma_adr_i : std_logic_matrix(PMA_CNT-1 downto 0)(PLEN-1 downto 0);

      -- CPU side
      nxt_pc_i       : in  std_logic_vector(XLEN-1 downto 0);
      stall_nxt_pc_o : out std_logic;
      stall_i        : in  std_logic;
      flush_i        : in  std_logic;
      parcel_pc_o    : out std_logic_vector(XLEN-1 downto 0);
      parcel_o       : out std_logic_vector(PARCEL_SIZE-1 downto 0);
      parcel_valid_o : out std_logic_vector(PARCEL_SIZE/16-1 downto 0);
      err_o          : out std_logic;
      misaligned_o   : out std_logic;
      page_fault_o   : out std_logic;
      cache_flush_i  : in  std_logic;
      dcflush_rdy_i  : in  std_logic;

      st_pmpcfg_i  : in std_logic_matrix(PMP_CNT-1 downto 0)(7 downto 0);
      st_pmpaddr_i : in std_logic_matrix(PMP_CNT-1 downto 0)(PLEN-1 downto 0);
      st_prv_i     : in std_logic_vector(1 downto 0);

      -- BIU ports
      apb4_stb_o     : out std_logic;
      apb4_stb_ack_i : in  std_logic;
      apb4_d_ack_i   : in  std_logic;
      apb4_adri_o    : out std_logic_vector(PLEN-1 downto 0);
      apb4_adro_i    : in  std_logic_vector(PLEN-1 downto 0);
      apb4_size_o    : out std_logic_vector(2 downto 0);
      apb4_type_o    : out std_logic_vector(2 downto 0);
      apb4_we_o      : out std_logic;
      apb4_lock_o    : out std_logic;
      apb4_prot_o    : out std_logic_vector(2 downto 0);
      apb4_d_o       : out std_logic_vector(XLEN-1 downto 0);
      apb4_q_i       : in  std_logic_vector(XLEN-1 downto 0);
      apb4_ack_i     : in  std_logic;
      apb4_err_i     : in  std_logic
      );
  end component;

  component pu_riscv_dmem_ctrl
    generic (
      XLEN : integer := 64;
      PLEN : integer := 64;

      HAS_RVC : std_logic := '1';

      PMA_CNT : integer := 4;
      PMP_CNT : integer := 16;

      DCACHE_SIZE        : integer := 64;
      DCACHE_BLOCK_SIZE  : integer := 64;
      DCACHE_WAYS        : integer := 2;
      DCACHE_REPLACE_ALG : integer := 2;
      DTCM_SIZE          : integer := 0;

      TECHNOLOGY : string := "GENERIC"
      );
    port (
      rst_ni : in std_logic;
      clk_i  : in std_logic;

      -- Configuration
      pma_cfg_i : std_logic_matrix(PMA_CNT-1 downto 0)(13 downto 0);
      pma_adr_i : std_logic_matrix(PMA_CNT-1 downto 0)(PLEN-1 downto 0);

      -- CPU side
      mem_req_i        : in  std_logic;
      mem_adr_i        : in  std_logic_vector(XLEN-1 downto 0);
      mem_size_i       : in  std_logic_vector(2 downto 0);
      mem_lock_i       : in  std_logic;
      mem_we_i         : in  std_logic;
      mem_d_i          : in  std_logic_vector(XLEN-1 downto 0);
      mem_q_o          : out std_logic_vector(XLEN-1 downto 0);
      mem_ack_o        : out std_logic;
      mem_err_o        : out std_logic;
      mem_misaligned_o : out std_logic;
      mem_page_fault_o : out std_logic;
      cache_flush_i    : in  std_logic;
      dcflush_rdy_o    : out std_logic;

      st_pmpcfg_i  : in std_logic_matrix(PMP_CNT-1 downto 0)(7 downto 0);
      st_pmpaddr_i : in std_logic_matrix(PMP_CNT-1 downto 0)(PLEN-1 downto 0);
      st_prv_i     : in std_logic_vector(1 downto 0);

      -- BIU ports
      apb4_stb_o     : out std_logic;
      apb4_stb_ack_i : in  std_logic;
      apb4_d_ack_i   : in  std_logic;
      apb4_adri_o    : out std_logic_vector(PLEN-1 downto 0);
      apb4_adro_i    : in  std_logic_vector(PLEN-1 downto 0);
      apb4_size_o    : out std_logic_vector(2 downto 0);
      apb4_type_o    : out std_logic_vector(2 downto 0);
      apb4_we_o      : out std_logic;
      apb4_lock_o    : out std_logic;
      apb4_prot_o    : out std_logic_vector(2 downto 0);
      apb4_d_o       : out std_logic_vector(XLEN-1 downto 0);
      apb4_q_i       : in  std_logic_vector(XLEN-1 downto 0);
      apb4_ack_i     : in  std_logic;
      apb4_err_i     : in  std_logic
      );
  end component;

  component pu_riscv_apb42apb4
    generic (
      XLEN : integer := 64;
      PLEN : integer := 64
      );
    port (
      HRESETn : in std_logic;
      HCLK    : in std_logic;

      -- AHB4 Lite Bus
      HSEL      : out std_logic;
      HADDR     : out std_logic_vector(PLEN-1 downto 0);
      HRDATA    : in  std_logic_vector(XLEN-1 downto 0);
      HWDATA    : out std_logic_vector(XLEN-1 downto 0);
      HWRITE    : out std_logic;
      HSIZE     : out std_logic_vector(2 downto 0);
      HBURST    : out std_logic_vector(2 downto 0);
      HPROT     : out std_logic_vector(3 downto 0);
      HTRANS    : out std_logic_vector(1 downto 0);
      HMASTLOCK : out std_logic;
      HREADY    : in  std_logic;
      HRESP     : in  std_logic;

      -- BIU Bus (Core ports)
      apb4_stb_i     : in  std_logic;    -- strobe
      apb4_stb_ack_o : out std_logic;  -- strobe acknowledge; can send new strobe
      apb4_d_ack_o   : out std_logic;  -- data acknowledge (send new apb4_d_i); for pipelined buses
      apb4_adri_i    : in  std_logic_vector(PLEN-1 downto 0);
      apb4_adro_o    : out std_logic_vector(PLEN-1 downto 0);
      apb4_size_i    : in  std_logic_vector(2 downto 0);  -- transfer size
      apb4_type_i    : in  std_logic_vector(2 downto 0);  -- burst type
      apb4_prot_i    : in  std_logic_vector(2 downto 0);  -- protection
      apb4_lock_i    : in  std_logic;
      apb4_we_i      : in  std_logic;
      apb4_d_i       : in  std_logic_vector(XLEN-1 downto 0);
      apb4_q_o       : out std_logic_vector(XLEN-1 downto 0);
      apb4_ack_o     : out std_logic;    -- transfer acknowledge
      apb4_err_o     : out std_logic     -- transfer error
      );
  end component;

  ------------------------------------------------------------------------------
  -- Variables
  ------------------------------------------------------------------------------
  signal if_stall_nxt_pc      : std_logic;
  signal if_nxt_pc            : std_logic_vector(XLEN-1 downto 0);
  signal if_stall, if_flush   : std_logic;
  signal if_parcel            : std_logic_vector(PARCEL_SIZE-1 downto 0);
  signal if_parcel_pc         : std_logic_vector(XLEN-1 downto 0);
  signal if_parcel_valid      : std_logic_vector(PARCEL_SIZE/16-1 downto 0);
  signal if_parcel_misaligned : std_logic;
  signal if_parcel_page_fault : std_logic;

  signal dmem_req           : std_logic;
  signal dmem_adr           : std_logic_vector(XLEN-1 downto 0);
  signal dmem_size          : std_logic_vector(2 downto 0);
  signal dmem_we            : std_logic;
  signal dmem_d, dmem_q     : std_logic_vector(XLEN-1 downto 0);
  signal dmem_ack, dmem_err : std_logic;
  signal dmem_misaligned    : std_logic;
  signal dmem_page_fault    : std_logic;

  signal st_prv     : std_logic_vector(1 downto 0);
  signal st_pmpcfg  : std_logic_matrix(PMP_CNT-1 downto 0)(7 downto 0);
  signal st_pmpaddr : std_logic_matrix(PMP_CNT-1 downto 0)(PLEN-1 downto 0);

  signal cacheflush  : std_logic;
  signal dcflush_rdy : std_logic;

  -- Instruction Memory BIU connections
  signal iapb4_stb             : std_logic;
  signal iapb4_stb_ack         : std_logic;
  signal iapb4_d_ack           : std_logic;
  signal iapb4_adri, iapb4_adro : std_logic_vector(PLEN-1 downto 0);
  signal iapb4_size            : std_logic_vector(2 downto 0);
  signal iapb4_type            : std_logic_vector(2 downto 0);
  signal iapb4_we              : std_logic;
  signal iapb4_lock            : std_logic;
  signal iapb4_prot            : std_logic_vector(2 downto 0);
  signal iapb4_d               : std_logic_vector(XLEN-1 downto 0);
  signal iapb4_q               : std_logic_vector(XLEN-1 downto 0);
  signal iapb4_ack, iapb4_err   : std_logic;

  -- Data Memory BIU connections
  signal dapb4_stb             : std_logic;
  signal dapb4_stb_ack         : std_logic;
  signal dapb4_d_ack           : std_logic;
  signal dapb4_adri, dapb4_adro : std_logic_vector(PLEN-1 downto 0);
  signal dapb4_size            : std_logic_vector(2 downto 0);
  signal dapb4_type            : std_logic_vector(2 downto 0);
  signal dapb4_we              : std_logic;
  signal dapb4_lock            : std_logic;
  signal dapb4_prot            : std_logic_vector(2 downto 0);
  signal dapb4_d               : std_logic_vector(XLEN-1 downto 0);
  signal dapb4_q               : std_logic_vector(XLEN-1 downto 0);
  signal dapb4_ack, dapb4_err   : std_logic;

  signal mem_lock_i : std_logic;

begin
  ------------------------------------------------------------------------------
  -- Module Body
  ------------------------------------------------------------------------------

  -- Instantiate RISC-V core
  core : pu_riscv_core
    generic map (
      XLEN           => XLEN,
      PLEN           => PLEN,
      ILEN           => ILEN,
      EXCEPTION_SIZE => EXCEPTION_SIZE,
      HAS_USER       => HAS_USER,
      HAS_SUPER      => HAS_SUPER,
      HAS_HYPER      => HAS_HYPER,
      HAS_BPU        => HAS_BPU,
      HAS_FPU        => HAS_FPU,
      HAS_MMU        => HAS_MMU,
      HAS_RVA        => HAS_RVA,
      HAS_RVM        => HAS_RVM,
      HAS_RVC        => HAS_RVC,
      IS_RV32E       => IS_RV32E,

      MULT_LATENCY => MULT_LATENCY,

      BREAKPOINTS => BREAKPOINTS,

      PMA_CNT => PMA_CNT,
      PMP_CNT => PMP_CNT,

      BP_GLOBAL_BITS    => BP_GLOBAL_BITS,
      BP_LOCAL_BITS     => BP_LOCAL_BITS,
      BP_LOCAL_BITS_LSB => BP_LOCAL_BITS_LSB,

      DU_ADDR_SIZE    => DU_ADDR_SIZE,
      MAX_BREAKPOINTS => MAX_BREAKPOINTS,

      TECHNOLOGY => TECHNOLOGY,

      PC_INIT => PC_INIT,

      MNMIVEC_DEFAULT => MNMIVEC_DEFAULT,
      MTVEC_DEFAULT   => MTVEC_DEFAULT,
      HTVEC_DEFAULT   => HTVEC_DEFAULT,
      STVEC_DEFAULT   => STVEC_DEFAULT,
      UTVEC_DEFAULT   => UTVEC_DEFAULT,

      JEDEC_BANK            => JEDEC_BANK,
      JEDEC_MANUFACTURER_ID => JEDEC_MANUFACTURER_ID,

      HARTID => HARTID,

      PARCEL_SIZE => PARCEL_SIZE
      )
    port map (
      rstn => HRESETn,
      clk  => HCLK,

      if_stall_nxt_pc      => if_stall_nxt_pc,
      if_nxt_pc            => if_nxt_pc,
      if_stall             => if_stall,
      if_flush             => if_flush,
      if_parcel            => if_parcel,
      if_parcel_pc         => if_parcel_pc,
      if_parcel_valid      => if_parcel_valid,
      if_parcel_misaligned => if_parcel_misaligned,
      if_parcel_page_fault => if_parcel_page_fault,
      dmem_adr             => dmem_adr,
      dmem_d               => dmem_d,
      dmem_q               => dmem_q,
      dmem_we              => dmem_we,
      dmem_size            => dmem_size,
      dmem_req             => dmem_req,
      dmem_ack             => dmem_ack,
      dmem_err             => dmem_err,
      dmem_misaligned      => dmem_misaligned,
      dmem_page_fault      => dmem_page_fault,
      st_prv               => st_prv,
      st_pmpcfg            => st_pmpcfg,
      st_pmpaddr           => st_pmpaddr,

      bu_cacheflush => cacheflush,

      ext_nmi   => ext_nmi,
      ext_tint  => ext_tint,
      ext_sint  => ext_sint,
      ext_int   => ext_int,
      dbg_stall => dbg_stall,
      dbg_strb  => dbg_strb,
      dbg_we    => dbg_we,
      dbg_addr  => dbg_addr,
      dbg_dati  => dbg_dati,
      dbg_dato  => dbg_dato,
      dbg_ack   => dbg_ack,
      dbg_bp    => dbg_bp
      );

  -- Instantiate bus interfaces and optional caches

  -- Instruction Memory Access Block
  imem_ctrl : pu_riscv_imem_ctrl
    generic map (
      XLEN => XLEN,
      PLEN => PLEN,

      PARCEL_SIZE => PARCEL_SIZE,

      HAS_RVC => HAS_RVC,

      PMA_CNT => PMA_CNT,
      PMP_CNT => PMP_CNT,

      ICACHE_SIZE        => ICACHE_SIZE,
      ICACHE_BLOCK_SIZE  => ICACHE_BLOCK_SIZE,
      ICACHE_WAYS        => ICACHE_WAYS,
      ICACHE_REPLACE_ALG => ICACHE_REPLACE_ALG,
      ITCM_SIZE          => ITCM_SIZE,

      TECHNOLOGY => TECHNOLOGY
      )
    port map (
      rst_ni => HRESETn,
      clk_i  => HCLK,

      pma_cfg_i => pma_cfg_i,
      pma_adr_i => pma_adr_i,

      nxt_pc_i       => if_nxt_pc,
      stall_nxt_pc_o => if_stall_nxt_pc,
      stall_i        => if_stall,
      flush_i        => if_flush,
      parcel_pc_o    => if_parcel_pc,
      parcel_o       => if_parcel,
      parcel_valid_o => if_parcel_valid,
      err_o          => open,
      misaligned_o   => if_parcel_misaligned,
      page_fault_o   => if_parcel_page_fault,

      cache_flush_i => cacheflush,
      dcflush_rdy_i => dcflush_rdy,

      st_prv_i     => st_prv,
      st_pmpcfg_i  => st_pmpcfg,
      st_pmpaddr_i => st_pmpaddr,

      apb4_stb_o     => iapb4_stb,
      apb4_stb_ack_i => iapb4_stb_ack,
      apb4_d_ack_i   => iapb4_d_ack,
      apb4_adri_o    => iapb4_adri,
      apb4_adro_i    => iapb4_adro,
      apb4_size_o    => iapb4_size,
      apb4_type_o    => iapb4_type,
      apb4_we_o      => iapb4_we,
      apb4_lock_o    => iapb4_lock,
      apb4_prot_o    => iapb4_prot,
      apb4_d_o       => iapb4_d,
      apb4_q_i       => iapb4_q,
      apb4_ack_i     => iapb4_ack,
      apb4_err_i     => iapb4_err
      );

  -- Data Memory Access Block
  dmem_ctrl : pu_riscv_dmem_ctrl
    generic map (
      XLEN => XLEN,
      PLEN => PLEN,

      HAS_RVC => HAS_RVC,

      PMA_CNT => PMA_CNT,
      PMP_CNT => PMP_CNT,

      DCACHE_SIZE        => DCACHE_SIZE,
      DCACHE_BLOCK_SIZE  => DCACHE_BLOCK_SIZE,
      DCACHE_WAYS        => DCACHE_WAYS,
      DCACHE_REPLACE_ALG => DCACHE_REPLACE_ALG,
      DTCM_SIZE          => DTCM_SIZE,

      TECHNOLOGY => TECHNOLOGY
      )
    port map (
      rst_ni => HRESETn,
      clk_i  => HCLK,

      pma_cfg_i => pma_cfg_i,
      pma_adr_i => pma_adr_i,

      mem_req_i        => dmem_req,
      mem_adr_i        => dmem_adr,
      mem_size_i       => dmem_size,
      mem_lock_i       => mem_lock_i,
      mem_we_i         => dmem_we,
      mem_d_i          => dmem_d,
      mem_q_o          => dmem_q,
      mem_ack_o        => dmem_ack,
      mem_err_o        => dmem_err,
      mem_misaligned_o => dmem_misaligned,
      mem_page_fault_o => dmem_page_fault,

      cache_flush_i => cacheflush,
      dcflush_rdy_o => dcflush_rdy,

      st_prv_i     => st_prv,
      st_pmpcfg_i  => st_pmpcfg,
      st_pmpaddr_i => st_pmpaddr,

      apb4_stb_o     => dapb4_stb,
      apb4_stb_ack_i => dapb4_stb_ack,
      apb4_d_ack_i   => dapb4_d_ack,
      apb4_adri_o    => dapb4_adri,
      apb4_adro_i    => dapb4_adro,
      apb4_size_o    => dapb4_size,
      apb4_type_o    => dapb4_type,
      apb4_we_o      => dapb4_we,
      apb4_lock_o    => dapb4_lock,
      apb4_prot_o    => dapb4_prot,
      apb4_d_o       => dapb4_d,
      apb4_q_i       => dapb4_q,
      apb4_ack_i     => dapb4_ack,
      apb4_err_i     => dapb4_err
      );

  -- Instantiate BIU
  iapb4 : pu_riscv_apb42apb4
    generic map (
      XLEN => XLEN,
      PLEN => PLEN
      )
    port map (
      HRESETn   => HRESETn,
      HCLK      => HCLK,
      HSEL      => ins_HSEL,
      HADDR     => ins_HADDR,
      HWDATA    => ins_HWDATA,
      HRDATA    => ins_HRDATA,
      HWRITE    => ins_HWRITE,
      HSIZE     => ins_HSIZE,
      HBURST    => ins_HBURST,
      HPROT     => ins_HPROT,
      HTRANS    => ins_HTRANS,
      HMASTLOCK => ins_HMASTLOCK,
      HREADY    => ins_HREADY,
      HRESP     => ins_HRESP,

      apb4_stb_i     => iapb4_stb,
      apb4_stb_ack_o => iapb4_stb_ack,
      apb4_d_ack_o   => iapb4_d_ack,
      apb4_adri_i    => iapb4_adri,
      apb4_adro_o    => iapb4_adro,
      apb4_size_i    => iapb4_size,
      apb4_type_i    => iapb4_type,
      apb4_prot_i    => iapb4_prot,
      apb4_lock_i    => iapb4_lock,
      apb4_we_i      => iapb4_we,
      apb4_d_i       => iapb4_d,
      apb4_q_o       => iapb4_q,
      apb4_ack_o     => iapb4_ack,
      apb4_err_o     => iapb4_err
      );

  dapb4 : pu_riscv_apb42apb4
    generic map (
      XLEN => XLEN,
      PLEN => PLEN
      )
    port map (
      HRESETn   => HRESETn,
      HCLK      => HCLK,
      HSEL      => dat_HSEL,
      HADDR     => dat_HADDR,
      HWDATA    => dat_HWDATA,
      HRDATA    => dat_HRDATA,
      HWRITE    => dat_HWRITE,
      HSIZE     => dat_HSIZE,
      HBURST    => dat_HBURST,
      HPROT     => dat_HPROT,
      HTRANS    => dat_HTRANS,
      HMASTLOCK => dat_HMASTLOCK,
      HREADY    => dat_HREADY,
      HRESP     => dat_HRESP,

      apb4_stb_i     => dapb4_stb,
      apb4_stb_ack_o => dapb4_stb_ack,
      apb4_d_ack_o   => dapb4_d_ack,
      apb4_adri_i    => dapb4_adri,
      apb4_adro_o    => dapb4_adro,
      apb4_size_i    => dapb4_size,
      apb4_type_i    => dapb4_type,
      apb4_prot_i    => dapb4_prot,
      apb4_lock_i    => dapb4_lock,
      apb4_we_i      => dapb4_we,
      apb4_d_i       => dapb4_d,
      apb4_q_o       => dapb4_q,
      apb4_ack_o     => dapb4_ack,
      apb4_err_o     => dapb4_err
      );
end rtl;
