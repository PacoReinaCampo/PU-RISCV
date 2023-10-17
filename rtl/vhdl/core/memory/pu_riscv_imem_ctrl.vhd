-- Converted from rtl/verilog/core/memory/pu_riscv_imem_ctrl.sv
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
--              Core - Instruction Memory Access Block                        --
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
use ieee.math_real.all;

use work.pu_riscv_vhdl_pkg.all;
use work.peripheral_biu_vhdl_pkg.all;
use work.vhdl_pkg.all;

entity pu_riscv_imem_ctrl is
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

    --Configuration
    pma_cfg_i : std_logic_matrix(PMA_CNT-1 downto 0)(13 downto 0);
    pma_adr_i : std_logic_matrix(PMA_CNT-1 downto 0)(PLEN-1 downto 0);

    --CPU side
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

    --BIU ports
    biu_stb_o     : out std_logic;
    biu_stb_ack_i : in  std_logic;
    biu_d_ack_i   : in  std_logic;
    biu_adri_o    : out std_logic_vector(PLEN-1 downto 0);
    biu_adro_i    : in  std_logic_vector(PLEN-1 downto 0);
    biu_size_o    : out std_logic_vector(2 downto 0);
    biu_type_o    : out std_logic_vector(2 downto 0);
    biu_we_o      : out std_logic;
    biu_lock_o    : out std_logic;
    biu_prot_o    : out std_logic_vector(2 downto 0);
    biu_d_o       : out std_logic_vector(XLEN-1 downto 0);
    biu_q_i       : in  std_logic_vector(XLEN-1 downto 0);
    biu_ack_i     : in  std_logic;
    biu_err_i     : in  std_logic
    );
end pu_riscv_imem_ctrl;

architecture rtl of pu_riscv_imem_ctrl is
  component pu_riscv_membuf
    generic (
      DEPTH : integer := 2;
      DBITS : integer := 32
      );
    port (
      rst_ni : in std_logic;
      clk_i  : in std_logic;

      clr_i : in std_logic;             --clear pending requests
      ena_i : in std_logic;

      --CPU side
      req_i : in std_logic;
      d_i   : in std_logic_vector(DBITS-1 downto 0);

      --Memory system side
      req_o : out std_logic;
      ack_i : in  std_logic;
      q_o   : out std_logic_vector(DBITS-1 downto 0);

      empty_o : out std_logic;
      full_o  : out std_logic
      );
  end component;

  component pu_riscv_memmisaligned
    generic (
      XLEN    : integer   := 64;
      HAS_RVC : std_logic := '1'
      );
    port (
      clk_i : in std_logic;

      --CPU side
      instruction_i : in std_logic;
      req_i         : in std_logic;
      adr_i         : in std_logic_vector(XLEN-1 downto 0);
      size_i        : in std_logic_vector(2 downto 0);

      --To memory subsystem
      misaligned_o : out std_logic
      );
  end component;

  component pu_riscv_mmu
    generic (
      XLEN : integer := 64;
      PLEN : integer := 64
      );
    port (
      rst_ni : in std_logic;
      clk_i  : in std_logic;
      clr_i  : in std_logic;            --clear pending request

      --Mode
      --input  logic [XLEN-1:0] st_satp;

      --CPU side
      vreq_i  : in std_logic;                          --Request from CPU
      vadr_i  : in std_logic_vector(XLEN-1 downto 0);  --Virtual Memory Address
      vsize_i : in std_logic_vector(2 downto 0);
      vlock_i : in std_logic;
      vprot_i : in std_logic_vector(2 downto 0);
      vwe_i   : in std_logic;
      vd_i    : in std_logic_vector(XLEN-1 downto 0);

      --Memory system side
      preq_o  : out std_logic;
      padr_o  : out std_logic_vector(PLEN-1 downto 0);  --Physical Memory Address
      psize_o : out std_logic_vector(2 downto 0);
      plock_o : out std_logic;
      pprot_o : out std_logic_vector(2 downto 0);
      pwe_o   : out std_logic;
      pd_o    : out std_logic_vector(XLEN-1 downto 0);
      pq_i    : in  std_logic_vector(XLEN-1 downto 0);
      pack_i  : in  std_logic;

      --Exception
      page_fault_o : out std_logic
      );
  end component;

  component pu_riscv_pmachk
    generic (
      XLEN    : integer := 64;
      PLEN    : integer := 64;
      PMA_CNT : integer := 4
      );
    port (
      --PMA  configuration
      pma_cfg_i : std_logic_matrix(PMA_CNT-1 downto 0)(13 downto 0);
      pma_adr_i : std_logic_matrix(PMA_CNT-1 downto 0)(PLEN-1 downto 0);

      --Memory Access
      instruction_i : in std_logic;     --This is an instruction access
      req_i         : in std_logic;     --Memory access requested
      adr_i         : in std_logic_vector(PLEN-1 downto 0);  --Physical Memory address (i.e. after translation)
      size_i        : in std_logic_vector(2 downto 0);       --Transfer size
      lock_i        : in std_logic;     --AMO : TODO: specify AMO type
      we_i          : in std_logic;

      misaligned_i : in std_logic;      --Misaligned access

      --Output
      pma_o             : out std_logic_vector(13 downto 0);
      exception_o       : out std_logic;
      misaligned_o      : out std_logic;
      is_cache_access_o : out std_logic;
      is_ext_access_o   : out std_logic;
      is_tcm_access_o   : out std_logic
      );
  end component;

  component pu_riscv_pmpchk
    generic (
      XLEN    : integer := 64;
      PLEN    : integer := 64;
      PMP_CNT : integer := 16
      );
    port (
      --From State
      st_pmpcfg_i  : in std_logic_matrix(PMP_CNT-1 downto 0)(7 downto 0);
      st_pmpaddr_i : in std_logic_matrix(PMP_CNT-1 downto 0)(PLEN-1 downto 0);
      st_prv_i     : in std_logic_vector(1 downto 0);

      --Memory Access
      instruction_i : in std_logic;     --This is an instruction access
      req_i         : in std_logic;     --Memory access requested
      adr_i         : in std_logic_vector(PLEN-1 downto 0);  --Physical Memory address (i.e. after translation)
      size_i        : in std_logic_vector(2 downto 0);       --Transfer size
      we_i          : in std_logic;     --Read/Write enable

      --Output
      exception_o : out std_logic
      );
  end component;

  component pu_riscv_icache_core
    generic (
      XLEN : integer := 64;
      PLEN : integer := 64;

      ICACHE_SIZE        : integer := 64;
      ICACHE_BLOCK_SIZE  : integer := 64;
      ICACHE_WAYS        : integer := 2;
      ICACHE_REPLACE_ALG : integer := 0;

      TECHNOLOGY : string := "GENERIC"
      );
    port (
      rst_ni : in std_logic;
      clk_i  : in std_logic;
      clr_i  : in std_logic;            --clear any pending request

      --CPU side
      mem_vreq_i : in  std_logic;
      mem_preq_i : in  std_logic;
      mem_vadr_i : in  std_logic_vector(XLEN-1 downto 0);
      mem_padr_i : in  std_logic_vector(PLEN-1 downto 0);
      mem_size_i : in  std_logic_vector(2 downto 0);
      mem_lock_i : in  std_logic;
      mem_prot_i : in  std_logic_vector(2 downto 0);
      mem_q_o    : out std_logic_vector(PARCEL_SIZE-1 downto 0);
      mem_ack_o  : out std_logic;
      mem_err_o  : out std_logic;
      flush_i    : in  std_logic;
      flushrdy_i : in  std_logic;

      --To BIU
      biu_stb_o     : out std_logic;    --access request
      biu_stb_ack_i : in  std_logic;    --access acknowledge
      biu_d_ack_i   : in  std_logic;    --BIU needs new data (biu_d_o)
      biu_adri_o    : out std_logic_vector(PLEN-1 downto 0);  --access start address
      biu_adro_i    : in  std_logic_vector(PLEN-1 downto 0);
      biu_size_o    : out std_logic_vector(2 downto 0);       --transfer size
      biu_type_o    : out std_logic_vector(2 downto 0);       --burst type
      biu_lock_o    : out std_logic;    --locked transfer
      biu_prot_o    : out std_logic_vector(2 downto 0);       --protection bits
      biu_we_o      : out std_logic;    --write enable
      biu_d_o       : out std_logic_vector(XLEN-1 downto 0);  --write data
      biu_q_i       : in  std_logic_vector(XLEN-1 downto 0);  --read data
      biu_ack_i     : in  std_logic;    --transfer acknowledge
      biu_err_i     : in  std_logic     --transfer error
      );
  end component;

  component pu_riscv_dext
    generic (
      XLEN  : integer := 64;
      PLEN  : integer := 64;            --Physical address bus size
      DEPTH : integer := 2              --number of instructions in flight
      );
    port (
      rst_ni : in std_logic;
      clk_i  : in std_logic;
      clr_i  : in std_logic;

      --CPU side
      mem_req_i     : in  std_logic;
      mem_adr_i     : in  std_logic_vector(XLEN-1 downto 0);
      mem_size_i    : in  std_logic_vector(2 downto 0);
      mem_type_i    : in  std_logic_vector(2 downto 0);
      mem_lock_i    : in  std_logic;
      mem_prot_i    : in  std_logic_vector(2 downto 0);
      mem_we_i      : in  std_logic;
      mem_d_i       : in  std_logic_vector(XLEN-1 downto 0);
      mem_adr_ack_o : out std_logic;    --acknowledge address phase
      mem_adr_o     : out std_logic_vector(PLEN-1 downto 0);
      mem_q_o       : out std_logic_vector(XLEN-1 downto 0);
      mem_ack_o     : out std_logic;    --acknowledge data transfer
      mem_err_o     : out std_logic;    --data transfer error

      --To BIU
      biu_stb_o     : out std_logic;
      biu_stb_ack_i : in  std_logic;
      biu_adri_o    : out std_logic_vector(PLEN-1 downto 0);
      biu_adro_i    : in  std_logic_vector(PLEN-1 downto 0);
      biu_size_o    : out std_logic_vector(2 downto 0);  --transfer size
      biu_type_o    : out std_logic_vector(2 downto 0);  --burst type
      biu_lock_o    : out std_logic;
      biu_prot_o    : out std_logic_vector(2 downto 0);
      biu_we_o      : out std_logic;
      biu_d_o       : out std_logic_vector(XLEN-1 downto 0);
      biu_q_i       : in  std_logic_vector(XLEN-1 downto 0);
      biu_ack_i     : in  std_logic;    --data acknowledge, 1 per data
      biu_err_i     : in  std_logic     --data error
      );
  end component;

  component pu_riscv_ram_queue
    generic (
      DEPTH                  : integer := 8;
      DBITS                  : integer := 64;
      ALMOST_FULL_THRESHOLD  : integer := 4;
      ALMOST_EMPTY_THRESHOLD : integer := 0
      );
    port (
      rst_ni : in std_logic;            --asynchronous, active low reset
      clk_i  : in std_logic;            --rising edge triggered clock

      clr_i : in std_logic;  --clear all queue entries (synchronous reset)
      ena_i : in std_logic;             --clock enable

      --Queue Write
      we_i : in std_logic;                           --Queue write enable
      d_i  : in std_logic_vector(DBITS-1 downto 0);  --Queue write data

      --Queue Read
      re_i : in  std_logic;                           --Queue read enable
      q_o  : out std_logic_vector(DBITS-1 downto 0);  --Queue read data

      --Status signals
      empty_o        : out std_logic;   --Queue is empty
      full_o         : out std_logic;   --Queue is full
      almost_empty_o : out std_logic;   --Programmable almost empty
      almost_full_o  : out std_logic    --Programmable almost full
      );
  end component;

  component pu_riscv_mux
    generic (
      XLEN  : integer := 64;
      PLEN  : integer := 64;
      PORTS : integer := 2
      );
    port (
      rst_ni : in std_logic;
      clk_i  : in std_logic;

      --Input Ports
      biu_req_i     : in  std_logic_vector(PORTS-1 downto 0);  --access request
      biu_req_ack_o : out std_logic_vector(PORTS-1 downto 0);  --biu access acknowledge
      biu_d_ack_o   : out std_logic_vector(PORTS-1 downto 0);  --biu early data acknowledge
      biu_adri_i    : in  std_logic_matrix(PORTS-1 downto 0)(PLEN-1 downto 0);  --access start address
      biu_adro_o    : out std_logic_matrix(PORTS-1 downto 0)(PLEN-1 downto 0);  --biu response address
      biu_size_i    : in  std_logic_matrix(PORTS-1 downto 0)(2 downto 0);  --access data size
      biu_type_i    : in  std_logic_matrix(PORTS-1 downto 0)(2 downto 0);  --access burst type
      biu_lock_i    : in  std_logic_vector(PORTS-1 downto 0);  --access locked access
      biu_prot_i    : in  std_logic_matrix(PORTS-1 downto 0)(2 downto 0);  --access protection
      biu_we_i      : in  std_logic_vector(PORTS-1 downto 0);  --access write enable
      biu_d_i       : in  std_logic_matrix(PORTS-1 downto 0)(XLEN-1 downto 0);  --access write data
      biu_q_o       : out std_logic_matrix(PORTS-1 downto 0)(XLEN-1 downto 0);  --access read data
      biu_ack_o     : out std_logic_vector(PORTS-1 downto 0);  --access acknowledge
      biu_err_o     : out std_logic_vector(PORTS-1 downto 0);  --access error

      --Output (to BIU)
      biu_req_o     : out std_logic;    --BIU access request
      biu_req_ack_i : in  std_logic;    --BIU ackowledge
      biu_d_ack_i   : in  std_logic;    --BIU early data acknowledge
      biu_adri_o    : out std_logic_vector(PLEN-1 downto 0);  --address into BIU
      biu_adro_i    : in  std_logic_vector(PLEN-1 downto 0);  --address from BIU
      biu_size_o    : out std_logic_vector(2 downto 0);       --transfer size
      biu_type_o    : out std_logic_vector(2 downto 0);       --burst type
      biu_lock_o    : out std_logic;
      biu_prot_o    : out std_logic_vector(2 downto 0);
      biu_we_o      : out std_logic;
      biu_d_o       : out std_logic_vector(XLEN-1 downto 0);  --data into BIU
      biu_q_i       : in  std_logic_vector(XLEN-1 downto 0);  --data from BIU
      biu_ack_i     : in  std_logic;    --data acknowledge, 1 per data
      biu_err_i     : in  std_logic     --data error
      );
  end component;

  ------------------------------------------------------------------------------
  -- Constants
  ------------------------------------------------------------------------------
  constant TID_SIZE : integer := 3;

  constant MUX_PORTS : integer := 2;

  constant EXT       : integer := 0;
  constant CACHE     : integer := 1;
  constant TCM       : integer := 2;
  constant SEL_EXT   : integer := 2**EXT;
  constant SEL_CACHE : integer := 2**CACHE;
  constant SEL_TCM   : integer := 2**TCM;

  ------------------------------------------------------------------------------
  -- Variables
  ------------------------------------------------------------------------------

  --Buffered memory request signals
  --Virtual memory access signals
  signal buf_req     : std_logic;
  signal buf_ack     : std_logic;
  signal buf_adr     : std_logic_vector(XLEN-1 downto 0);
  signal buf_adr_dly : std_logic_vector(XLEN-1 downto 0);
  signal buf_size    : std_logic_vector(2 downto 0);
  signal buf_lock    : std_logic;
  signal buf_prot    : std_logic_vector(2 downto 0);

  signal nxt_pc_queue_req   : std_logic;
  signal nxt_pc_queue_empty : std_logic;
  signal nxt_pc_queue_full  : std_logic;

  --Misalignment check
  signal misaligned : std_logic;

  --MMU signals
  --Physical memory access signals
  signal preq       : std_logic;
  signal padr       : std_logic_vector(PLEN-1 downto 0);
  signal psize      : std_logic_vector(2 downto 0);
  signal plock      : std_logic;
  signal pprot      : std_logic_vector(2 downto 0);
  signal page_fault : std_logic;

  --from PMA check
  signal pma_exception   : std_logic;
  signal pma_misaligned  : std_logic;
  signal is_cache_access : std_logic;
  signal is_ext_access   : std_logic;
  signal ext_access_req  : std_logic;
  signal is_tcm_access   : std_logic;

  --from PMP check
  signal pmp_exception : std_logic;

  --From Cache Controller Core
  signal cache_q   : std_logic_vector(PARCEL_SIZE-1 downto 0);
  signal cache_ack : std_logic;
  signal cache_err : std_logic;

  --From TCM
  signal tcm_q   : std_logic_vector(XLEN-1 downto 0);
  signal tcm_ack : std_logic;

  --From IO
  signal ext_vadr       : std_logic_vector(XLEN-1 downto 0);
  signal ext_q          : std_logic_vector(XLEN-1 downto 0);
  signal ext_access_ack : std_logic;    --address transfer acknowledge
  signal ext_ack        : std_logic;    --data transfer acknowledge
  signal ext_err        : std_logic;

  --BIU ports
  signal biu_stb     : std_logic_vector(MUX_PORTS-1 downto 0);
  signal biu_stb_ack : std_logic_vector(MUX_PORTS-1 downto 0);
  signal biu_d_ack   : std_logic_vector(MUX_PORTS-1 downto 0);
  signal biu_adro    : std_logic_matrix(MUX_PORTS-1 downto 0)(PLEN-1 downto 0);
  signal biu_adri    : std_logic_matrix(MUX_PORTS-1 downto 0)(PLEN-1 downto 0);
  signal biu_size    : std_logic_matrix(MUX_PORTS-1 downto 0)(2 downto 0);
  signal biu_type    : std_logic_matrix(MUX_PORTS-1 downto 0)(2 downto 0);
  signal biu_we      : std_logic_vector(MUX_PORTS-1 downto 0);
  signal biu_lock    : std_logic_vector(MUX_PORTS-1 downto 0);
  signal biu_prot    : std_logic_matrix(MUX_PORTS-1 downto 0)(2 downto 0);
  signal biu_d       : std_logic_matrix(MUX_PORTS-1 downto 0)(XLEN-1 downto 0);
  signal biu_q       : std_logic_matrix(MUX_PORTS-1 downto 0)(XLEN-1 downto 0);
  signal biu_ack     : std_logic_vector(MUX_PORTS-1 downto 0);
  signal biu_err     : std_logic_vector(MUX_PORTS-1 downto 0);

  --to CPU
  signal parcel_valid : std_logic_vector(PARCEL_SIZE/16-1 downto 0);

  signal parcel_queue_d_pc         : std_logic_vector(XLEN-1 downto 0);
  signal parcel_queue_d_parcel     : std_logic_vector(PARCEL_SIZE-1 downto 0);
  signal parcel_queue_d_valid      : std_logic_vector(PARCEL_SIZE/16-1 downto 0);
  signal parcel_queue_d_misaligned : std_logic;
  signal parcel_queue_d_page_fault : std_logic;
  signal parcel_queue_d_error      : std_logic;

  signal parcel_queue_q_pc         : std_logic_vector(XLEN-1 downto 0);
  signal parcel_queue_q_parcel     : std_logic_vector(PARCEL_SIZE-1 downto 0);
  signal parcel_queue_q_valid      : std_logic_vector(PARCEL_SIZE/16-1 downto 0);
  signal parcel_queue_q_misaligned : std_logic;
  signal parcel_queue_q_page_fault : std_logic;
  signal parcel_queue_q_error      : std_logic;

  signal parcel_queue_d : std_logic_vector(XLEN+PARCEL_SIZE*(1+1/16)+3-1 downto 0);
  signal parcel_queue_q : std_logic_vector(XLEN+PARCEL_SIZE*(1+1/16)+3-1 downto 0);

  signal parcel_queue_empty : std_logic;
  signal parcel_queue_full  : std_logic;

  signal stall_nxt_pc_not : std_logic;

  signal re_i_queue : std_logic;

begin
  ------------------------------------------------------------------------------
  -- Module Body
  ------------------------------------------------------------------------------

  parcel_queue_d <= (parcel_queue_d_pc(XLEN-5 downto 0) & parcel_queue_d_parcel & parcel_queue_d_valid & parcel_queue_d_misaligned & parcel_queue_d_page_fault & parcel_queue_d_error);

  parcel_queue_q_parcel     <= parcel_queue_q(XLEN+PARCEL_SIZE/16+2 downto PARCEL_SIZE/16+3);
  parcel_queue_q_valid      <= parcel_queue_q(PARCEL_SIZE/16+2 downto 3);
  parcel_queue_q_misaligned <= parcel_queue_q(2);
  parcel_queue_q_page_fault <= parcel_queue_q(1);
  parcel_queue_q_error      <= parcel_queue_q(0);

--  // For debugging
--  int fd;
--  initial fd = $fopen("memtrace.dat");
--
--  logic [XLEN-1:0] adr_dly, d_dly;
--  logic            we_dly;
--  int n = 0;
--
--  always @(posedge clk_i) begin
--    if (buf_req) begin
--      adr_dly <= buf_adr;
--    end
--
--    else if (mem_ack_o) begin
--      n++;
--      if (we_dly) $fdisplay (fd, "%0d, [%0x] <= %x", n, adr_dly, d_dly);
--      else        $fdisplay (fd, "%0d, [%0x] == %x", n, adr_dly, mem_q_o);
--    end
--  end

  --Hookup Access Buffer
  nxt_pc_queue_inst : pu_riscv_membuf
    generic map (
      DEPTH => 2,
      DBITS => XLEN
      )
    port map (
      rst_ni => rst_ni,
      clk_i  => clk_i,

      clr_i => flush_i,
      ena_i => '1',

      req_i => stall_nxt_pc_not,
      d_i   => nxt_pc_i,

      req_o => buf_req,
      q_o   => buf_adr,
      ack_i => buf_ack,

      empty_o => open,
      full_o  => nxt_pc_queue_full
      );

  --stall nxt_pc when queues full, or when DCACHE is flushing
  stall_nxt_pc_o <= nxt_pc_queue_full or parcel_queue_full or not dcflush_rdy_i;

  stall_nxt_pc_not <= not (nxt_pc_queue_full or parcel_queue_full or not dcflush_rdy_i);

  buf_ack  <= ext_access_ack or cache_ack or tcm_ack;
  buf_size <= WORD;
  buf_lock <= '0';
  buf_prot <= PROT_USER
              when ((PROT_DATA = "001") or (st_prv_i = PRV_U)) else PROT_PRIVILEGED;

  --Hookup misalignment check
  misaligned_inst : pu_riscv_memmisaligned
    generic map (
      XLEN    => XLEN,
      HAS_RVC => HAS_RVC
      )
    port map (
      clk_i         => clk_i,
      instruction_i => '1',             --instruction access
      req_i         => buf_req,
      adr_i         => buf_adr,
      size_i        => buf_size,
      misaligned_o  => misaligned
      );

  -- Hookup MMU
  mmu_inst : pu_riscv_mmu
    generic map (
      XLEN => XLEN,
      PLEN => PLEN
      )
    port map (
      rst_ni => rst_ni,
      clk_i  => clk_i,
      clr_i  => flush_i,

      vreq_i  => buf_req,
      vadr_i  => buf_adr,
      vsize_i => buf_size,
      vlock_i => buf_lock,
      vprot_i => buf_prot,
      vwe_i   => '0',                   --instructions only read
      vd_i    => (others => '0'),       --no write data

      preq_o  => preq,
      padr_o  => padr,
      psize_o => psize,
      plock_o => plock,
      pprot_o => pprot,
      pwe_o   => open,
      pd_o    => open,
      pq_i    => (others => '0'),
      pack_i  => '0',

      page_fault_o => page_fault
      );

  --Hookup Physical Memory Atrributes Unit
  pmachk_inst : pu_riscv_pmachk
    generic map (
      XLEN    => XLEN,
      PLEN    => PLEN,
      PMA_CNT => PMA_CNT
      )
    port map (
      --Configuration
      pma_cfg_i => pma_cfg_i,
      pma_adr_i => pma_adr_i,

      --misaligned
      misaligned_i => misaligned,

      --Memory Access
      instruction_i => '1',             --Instruction access
      req_i         => preq,
      adr_i         => padr,
      size_i        => psize,
      lock_i        => plock,
      we_i          => '0',

      --Output
      pma_o             => open,
      exception_o       => pma_exception,
      misaligned_o      => pma_misaligned,
      is_cache_access_o => is_cache_access,
      is_ext_access_o   => is_ext_access,
      is_tcm_access_o   => is_tcm_access
      );

  --Hookup Physical Memory Protection Unit
  pmpchk_inst : pu_riscv_pmpchk
    generic map (
      XLEN    => XLEN,
      PLEN    => PLEN,
      PMP_CNT => PMP_CNT
      )
    port map (
      st_pmpcfg_i  => st_pmpcfg_i,
      st_pmpaddr_i => st_pmpaddr_i,
      st_prv_i     => st_prv_i,

      instruction_i => '1',             --Instruction access
      req_i         => preq,            --Memory access request
      adr_i         => padr,  --Physical Memory address (i.e. after translation)
      size_i        => psize,           --Transfer size
      we_i          => '0',             --Read/Write enable

      exception_o => pmp_exception
      );

  --Hookup Cache, TCM, external-interface
  generating_0 : if (ICACHE_SIZE > 0) generate
    --Instantiate Data Cache Core
    icache_inst : pu_riscv_icache_core
      generic map (
        XLEN => XLEN,
        PLEN => PLEN,

        ICACHE_SIZE        => ICACHE_SIZE,
        ICACHE_BLOCK_SIZE  => ICACHE_BLOCK_SIZE,
        ICACHE_WAYS        => ICACHE_WAYS,
        ICACHE_REPLACE_ALG => ICACHE_REPLACE_ALG,

        TECHNOLOGY => TECHNOLOGY
        )
      port map (
        --common signals
        rst_ni => rst_ni,
        clk_i  => clk_i,
        clr_i  => flush_i,

        --from MMU/PMA
        mem_vreq_i => buf_req,
        mem_preq_i => is_cache_access,
        mem_vadr_i => buf_adr,
        mem_padr_i => padr,
        mem_size_i => buf_size,
        mem_lock_i => buf_lock,
        mem_prot_i => buf_prot,
        mem_q_o    => cache_q,
        mem_ack_o  => cache_ack,
        mem_err_o  => cache_err,
        flush_i    => cache_flush_i,
        flushrdy_i => '1',              --handled by stall_nxt_pc

        --To BIU
        biu_stb_o     => biu_stb (CACHE),
        biu_stb_ack_i => biu_stb_ack (CACHE),
        biu_d_ack_i   => biu_d_ack (CACHE),
        biu_adri_o    => biu_adri (CACHE),
        biu_adro_i    => biu_adro (CACHE),
        biu_size_o    => biu_size (CACHE),
        biu_type_o    => biu_type (CACHE),
        biu_lock_o    => biu_lock (CACHE),
        biu_prot_o    => biu_prot (CACHE),
        biu_we_o      => biu_we (CACHE),
        biu_d_o       => biu_d (CACHE),
        biu_q_i       => biu_q (CACHE),
        biu_ack_i     => biu_ack (CACHE),
        biu_err_i     => biu_err (CACHE)
        );
  elsif (ICACHE_SIZE <= 0) generate     --No cache
    cache_q   <= (others => '0');
    cache_ack <= '0';
    cache_err <= '0';
  end generate;

  --Instantiate TCM block
  generating_2 : if (ITCM_SIZE <= 0) generate  --No TCM
    tcm_q   <= (others => '0');
    tcm_ack <= '0';
  end generate;

  --Instantiate EXT block
  generating_3 : if (ICACHE_SIZE > 0) generate
    generating_4 : if (ITCM_SIZE > 0) generate
      ext_access_req <= is_ext_access;
    elsif (ITCM_SIZE <= 0) generate
      ext_access_req <= is_ext_access or is_tcm_access;
    end generate generating_4;
  elsif (ITCM_SIZE > 0) generate
    ext_access_req <= is_ext_access or is_cache_access;
  elsif (ICACHE_SIZE <= 0 and ITCM_SIZE <= 0) generate
    ext_access_req <= is_ext_access or is_cache_access or is_tcm_access;
  end generate generating_3;

  dext_inst : pu_riscv_dext
    generic map (
      XLEN  => XLEN,
      PLEN  => PLEN,                    --Physical address bus size
      DEPTH => 2                        --number of instructions in flight
      )
    port map (
      rst_ni => rst_ni,
      clk_i  => clk_i,
      clr_i  => flush_i,

      mem_req_i     => ext_access_req,
      mem_adr_i     => padr,
      mem_size_i    => psize,
      mem_type_i    => SINGLE,
      mem_lock_i    => plock,
      mem_prot_i    => pprot,
      mem_we_i      => '0',
      mem_d_i       => (others => '0'),
      mem_adr_ack_o => ext_access_ack,
      mem_adr_o     => open,
      mem_q_o       => ext_q,
      mem_ack_o     => ext_ack,
      mem_err_o     => ext_err,

      biu_stb_o     => biu_stb (EXT),
      biu_stb_ack_i => biu_stb_ack (EXT),
      biu_adri_o    => biu_adri (EXT),
      biu_adro_i    => biu_adro (EXT),
      biu_size_o    => biu_size (EXT),
      biu_type_o    => biu_type (EXT),
      biu_lock_o    => biu_lock (EXT),
      biu_prot_o    => biu_prot (EXT),
      biu_we_o      => biu_we (EXT),
      biu_d_o       => biu_d (EXT),
      biu_q_i       => biu_q (EXT),
      biu_ack_i     => biu_ack (EXT),
      biu_err_i     => biu_err (EXT)
      );

  --store virtual addresses for external access
  ext_vadr_queue_inst : pu_riscv_ram_queue
    generic map (
      DEPTH                  => 8,
      DBITS                  => XLEN,
      ALMOST_FULL_THRESHOLD  => 4,
      ALMOST_EMPTY_THRESHOLD => 0
      )
    port map (
      rst_ni => rst_ni,
      clk_i  => clk_i,

      clr_i => flush_i,
      ena_i => '1',

      we_i => ext_access_req,
      d_i  => buf_adr_dly,

      re_i => ext_ack,
      q_o  => ext_vadr,

      almost_empty_o => open,
      almost_full_o  => open,
      empty_o        => open,
      full_o         => open
      );
  --stall access requests when full (AXI bus ...)

  --Hookup BIU mux
  pu_riscv_mux_inst : pu_riscv_mux
    generic map (
      XLEN  => XLEN,
      PLEN  => PLEN,
      PORTS => MUX_PORTS
      )
    port map (
      rst_ni => rst_ni,
      clk_i  => clk_i,

      biu_req_i     => biu_stb,         --access request
      biu_req_ack_o => biu_stb_ack,     --access request acknowledge
      biu_d_ack_o   => biu_d_ack,
      biu_adri_i    => biu_adri,        --access start address
      biu_adro_o    => biu_adro,        --transfer addresss
      biu_size_i    => biu_size,        --access data size
      biu_type_i    => biu_type,        --access burst type
      biu_lock_i    => biu_lock,        --access locked access
      biu_prot_i    => biu_prot,        --access protection bits
      biu_we_i      => biu_we,          --access write enable
      biu_d_i       => biu_d,           --access write data
      biu_q_o       => biu_q,           --access read data
      biu_ack_o     => biu_ack,         --transfer acknowledge
      biu_err_o     => biu_err,         --transfer error

      biu_req_o     => biu_stb_o,
      biu_req_ack_i => biu_stb_ack_i,
      biu_d_ack_i   => biu_d_ack_i,
      biu_adri_o    => biu_adri_o,
      biu_adro_i    => biu_adro_i,
      biu_size_o    => biu_size_o,
      biu_type_o    => biu_type_o,
      biu_lock_o    => biu_lock_o,
      biu_prot_o    => biu_prot_o,
      biu_we_o      => biu_we_o,
      biu_d_o       => biu_d_o,
      biu_q_i       => biu_q_i,
      biu_ack_i     => biu_ack_i,
      biu_err_i     => biu_err_i
      );

  --Results back to CPU
  parcel_valid <= (ext_ack or cache_ack or tcm_ack) &
                  (ext_ack or cache_ack or tcm_ack) &
                  (ext_ack or cache_ack or tcm_ack) &
                  (ext_ack or cache_ack or tcm_ack);

  --Instruction Queue
  processing_0 : process (clk_i)
  begin
    if (rising_edge(clk_i)) then
      if (buf_req = '1') then
        buf_adr_dly <= buf_adr;
      end if;
    end if;
  end process;

  parcel_queue_d_pc <= ext_vadr
                       when ext_ack = '1' else buf_adr_dly;

  processing_1 : process (cache_ack, cache_q, ext_ack, ext_q, parcel_queue_d_pc, tcm_ack, tcm_q)
    variable state : std_logic_vector(2 downto 0);
  begin
    case (state) is
      when "001" =>
        parcel_queue_d_parcel <= tcm_q;
      when "010" =>
        parcel_queue_d_parcel <= cache_q;
      when others =>
        parcel_queue_d_parcel <= std_logic_vector(unsigned(ext_q) srl (16*to_integer(unsigned(parcel_queue_d_pc(integer(log2(real(XLEN/16)))+1 downto integer(log2(real(XLEN/16))))))));
    end case;
    state := ext_ack & cache_ack & tcm_ack;
  end process;

  parcel_queue_d_valid      <= parcel_valid;
  parcel_queue_d_misaligned <= pma_misaligned;
  parcel_queue_d_page_fault <= page_fault;
  parcel_queue_d_error      <= ext_err or cache_err or pma_exception or pmp_exception;

  --Instruction queue
  --Add some extra words for inflight instructions
  parcel_queue_inst : pu_riscv_ram_queue
    generic map (
      DEPTH                  => 4+4,
      DBITS                  => XLEN+PARCEL_SIZE*(1+1/16)+3,
      ALMOST_FULL_THRESHOLD  => 4,
      ALMOST_EMPTY_THRESHOLD => 0
      )
    port map (
      rst_ni => rst_ni,
      clk_i  => clk_i,

      clr_i => flush_i,
      ena_i => '1',

      we_i => reduce_or(parcel_valid),
      d_i  => parcel_queue_d,

      re_i => re_i_queue,
      q_o  => parcel_queue_q,

      almost_empty_o => open,
      almost_full_o  => parcel_queue_full,
      empty_o        => parcel_queue_empty,
      full_o         => open
      );

  re_i_queue <= not parcel_queue_empty and not stall_i;

  --CPU signals
  parcel_pc_o    <= parcel_queue_q_pc;
  parcel_o       <= parcel_queue_q_parcel;
  parcel_valid_o <= parcel_queue_q_valid and not (PARCEL_SIZE/16-1 downto 0 => parcel_queue_empty);
  misaligned_o   <= parcel_queue_q_misaligned;
  page_fault_o   <= parcel_queue_q_page_fault;
  err_o          <= parcel_queue_q_error;
end rtl;
