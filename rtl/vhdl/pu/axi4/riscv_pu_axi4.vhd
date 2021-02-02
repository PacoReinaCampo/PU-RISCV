-- Converted from riscv_pu_axi4.sv
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
--              Processing Unit                                               //
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
-- *   Francisco Javier Reina Campo <frareicam@gmail.com>
-- */

use work."riscv_defines.sv".all;


library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity riscv_pu_axi4 is
  port (








  --Number of hardware breakpoints

  --Number of Physical Memory Protection entries



  --in KBytes
  --in Bytes
  --'n'-way set associative


  --in KBytes
  --in Bytes
  --'n'-way set associative










    HRESETn : in std_logic;
    HCLK : in std_logic;

    pma_cfg_i : in std_logic_vector(13 downto 0);
    pma_adr_i : in std_logic_vector(XLEN-1 downto 0);

  --AXI4 instruction
    axi4_ins_aw_id : out std_logic_vector(AXI_ID_WIDTH-1 downto 0);
    axi4_ins_aw_addr : out std_logic_vector(AXI_ADDR_WIDTH-1 downto 0);
    axi4_ins_aw_len : out std_logic_vector(7 downto 0);
    axi4_ins_aw_size : out std_logic_vector(2 downto 0);
    axi4_ins_aw_burst : out std_logic_vector(1 downto 0);
    axi4_ins_aw_lock : out std_logic;
    axi4_ins_aw_cache : out std_logic_vector(3 downto 0);
    axi4_ins_aw_prot : out std_logic_vector(2 downto 0);
    axi4_ins_aw_qos : out std_logic_vector(3 downto 0);
    axi4_ins_aw_region : out std_logic_vector(3 downto 0);
    axi4_ins_aw_user : out std_logic_vector(AXI_USER_WIDTH-1 downto 0);
    axi4_ins_aw_valid : out std_logic;
    axi4_ins_aw_ready : in std_logic;

    axi4_ins_ar_id : out std_logic_vector(AXI_ID_WIDTH-1 downto 0);
    axi4_ins_ar_addr : out std_logic_vector(AXI_ADDR_WIDTH-1 downto 0);
    axi4_ins_ar_len : out std_logic_vector(7 downto 0);
    axi4_ins_ar_size : out std_logic_vector(2 downto 0);
    axi4_ins_ar_burst : out std_logic_vector(1 downto 0);
    axi4_ins_ar_lock : out std_logic;
    axi4_ins_ar_cache : out std_logic_vector(3 downto 0);
    axi4_ins_ar_prot : out std_logic_vector(2 downto 0);
    axi4_ins_ar_qos : out std_logic_vector(3 downto 0);
    axi4_ins_ar_region : out std_logic_vector(3 downto 0);
    axi4_ins_ar_user : out std_logic_vector(AXI_USER_WIDTH-1 downto 0);
    axi4_ins_ar_valid : out std_logic;
    axi4_ins_ar_ready : in std_logic;

    axi4_ins_w_data : out std_logic_vector(AXI_DATA_WIDTH-1 downto 0);
    axi4_ins_w_strb : out std_logic_vector(AXI_STRB_WIDTH-1 downto 0);
    axi4_ins_w_last : out std_logic;
    axi4_ins_w_user : out std_logic_vector(AXI_USER_WIDTH-1 downto 0);
    axi4_ins_w_valid : out std_logic;
    axi4_ins_w_ready : in std_logic;

    axi4_ins_r_id : in std_logic_vector(AXI_ID_WIDTH-1 downto 0);
    axi4_ins_r_data : in std_logic_vector(AXI_DATA_WIDTH-1 downto 0);
    axi4_ins_r_resp : in std_logic_vector(1 downto 0);
    axi4_ins_r_last : in std_logic;
    axi4_ins_r_user : in std_logic_vector(AXI_USER_WIDTH-1 downto 0);
    axi4_ins_r_valid : in std_logic;
    axi4_ins_r_ready : out std_logic;

    axi4_ins_b_id : in std_logic_vector(AXI_ID_WIDTH-1 downto 0);
    axi4_ins_b_resp : in std_logic_vector(1 downto 0);
    axi4_ins_b_user : in std_logic_vector(AXI_USER_WIDTH-1 downto 0);
    axi4_ins_b_valid : in std_logic;
    axi4_ins_b_ready : out std_logic;

  --AXI4 data
    axi4_dat_aw_id : out std_logic_vector(AXI_ID_WIDTH-1 downto 0);
    axi4_dat_aw_addr : out std_logic_vector(AXI_ADDR_WIDTH-1 downto 0);
    axi4_dat_aw_len : out std_logic_vector(7 downto 0);
    axi4_dat_aw_size : out std_logic_vector(2 downto 0);
    axi4_dat_aw_burst : out std_logic_vector(1 downto 0);
    axi4_dat_aw_lock : out std_logic;
    axi4_dat_aw_cache : out std_logic_vector(3 downto 0);
    axi4_dat_aw_prot : out std_logic_vector(2 downto 0);
    axi4_dat_aw_qos : out std_logic_vector(3 downto 0);
    axi4_dat_aw_region : out std_logic_vector(3 downto 0);
    axi4_dat_aw_user : out std_logic_vector(AXI_USER_WIDTH-1 downto 0);
    axi4_dat_aw_valid : out std_logic;
    axi4_dat_aw_ready : in std_logic;

    axi4_dat_ar_id : out std_logic_vector(AXI_ID_WIDTH-1 downto 0);
    axi4_dat_ar_addr : out std_logic_vector(AXI_ADDR_WIDTH-1 downto 0);
    axi4_dat_ar_len : out std_logic_vector(7 downto 0);
    axi4_dat_ar_size : out std_logic_vector(2 downto 0);
    axi4_dat_ar_burst : out std_logic_vector(1 downto 0);
    axi4_dat_ar_lock : out std_logic;
    axi4_dat_ar_cache : out std_logic_vector(3 downto 0);
    axi4_dat_ar_prot : out std_logic_vector(2 downto 0);
    axi4_dat_ar_qos : out std_logic_vector(3 downto 0);
    axi4_dat_ar_region : out std_logic_vector(3 downto 0);
    axi4_dat_ar_user : out std_logic_vector(AXI_USER_WIDTH-1 downto 0);
    axi4_dat_ar_valid : out std_logic;
    axi4_dat_ar_ready : in std_logic;

    axi4_dat_w_data : out std_logic_vector(AXI_DATA_WIDTH-1 downto 0);
    axi4_dat_w_strb : out std_logic_vector(AXI_STRB_WIDTH-1 downto 0);
    axi4_dat_w_last : out std_logic;
    axi4_dat_w_user : out std_logic_vector(AXI_USER_WIDTH-1 downto 0);
    axi4_dat_w_valid : out std_logic;
    axi4_dat_w_ready : in std_logic;

    axi4_dat_r_id : in std_logic_vector(AXI_ID_WIDTH-1 downto 0);
    axi4_dat_r_data : in std_logic_vector(AXI_DATA_WIDTH-1 downto 0);
    axi4_dat_r_resp : in std_logic_vector(1 downto 0);
    axi4_dat_r_last : in std_logic;
    axi4_dat_r_user : in std_logic_vector(AXI_USER_WIDTH-1 downto 0);
    axi4_dat_r_valid : in std_logic;
    axi4_dat_r_ready : out std_logic;

    axi4_dat_b_id : in std_logic_vector(AXI_ID_WIDTH-1 downto 0);
    axi4_dat_b_resp : in std_logic_vector(1 downto 0);
    axi4_dat_b_user : in std_logic_vector(AXI_USER_WIDTH-1 downto 0);
    axi4_dat_b_valid : in std_logic;
    axi4_dat_b_ready : out std_logic;

  --Interrupts
    ext_nmi, ext_tint, ext_sint : in std_logic;
    ext_int : in std_logic_vector(3 downto 0);

  --Debug Interface
    dbg_stall : in std_logic;
    dbg_strb : in std_logic;
    dbg_we : in std_logic;
    dbg_addr : in std_logic_vector(PLEN-1 downto 0);
    dbg_dati : in std_logic_vector(XLEN-1 downto 0);
    dbg_dato : out std_logic_vector(XLEN-1 downto 0);
    dbg_ack : out std_logic 
    dbg_bp : out std_logic
  );
  constant AXI_ID_WIDTH : integer := 10;
  constant AXI_ADDR_WIDTH : integer := 64;
  constant AXI_DATA_WIDTH : integer := 64;
  constant AXI_STRB_WIDTH : integer := 10;
  constant AXI_USER_WIDTH : integer := 10;
  constant AHB_ADDR_WIDTH : integer := 64;
  constant AHB_DATA_WIDTH : integer := 64;
  constant XLEN : integer := 64;
  constant PLEN : integer := 64;
  constant PC_INIT : std_logic_vector(XLEN-1 downto 0) := X"8000_0000";
  constant HAS_USER : integer := 1;
  constant HAS_SUPER : integer := 1;
  constant HAS_HYPER : integer := 1;
  constant HAS_BPU : integer := 1;
  constant HAS_FPU : integer := 1;
  constant HAS_MMU : integer := 1;
  constant HAS_RVM : integer := 1;
  constant HAS_RVA : integer := 1;
  constant HAS_RVC : integer := 1;
  constant IS_RV32E : integer := 0;
  constant MULT_LATENCY : integer := 1;
  constant BREAKPOINTS : integer := 8;
  constant PMA_CNT : integer := 4;
  constant PMP_CNT : integer := 16;
  constant BP_GLOBAL_BITS : integer := 2;
  constant BP_LOCAL_BITS : integer := 10;
  constant BP_LOCAL_BITS_LSB : integer := 2;
  constant ICACHE_SIZE : integer := 64;
  constant ICACHE_BLOCK_SIZE : integer := 64;
  constant ICACHE_WAYS : integer := 2;
  constant ICACHE_REPLACE_ALG : integer := 0;
  constant ITCM_SIZE : integer := 0;
  constant DCACHE_SIZE : integer := 64;
  constant DCACHE_BLOCK_SIZE : integer := 64;
  constant DCACHE_WAYS : integer := 2;
  constant DCACHE_REPLACE_ALG : integer := 0;
  constant DTCM_SIZE : integer := 0;
  constant WRITEBUFFER_SIZE : integer := 8;
  constant TECHNOLOGY : integer := "GENERIC";
  constant MNMIVEC_DEFAULT : std_logic_vector(XLEN-1 downto 0) := PC_INIT-X"004";
  constant MTVEC_DEFAULT : std_logic_vector(XLEN-1 downto 0) := PC_INIT-X"040";
  constant HTVEC_DEFAULT : std_logic_vector(XLEN-1 downto 0) := PC_INIT-X"080";
  constant STVEC_DEFAULT : std_logic_vector(XLEN-1 downto 0) := PC_INIT-X"0C0";
  constant UTVEC_DEFAULT : std_logic_vector(XLEN-1 downto 0) := PC_INIT-X"100";
  constant JEDEC_BANK : integer := 10;
  constant JEDEC_MANUFACTURER_ID : integer := X"6e";
  constant HARTID : integer := 0;
  constant PARCEL_SIZE : integer := 32;
end riscv_pu_axi4;

architecture RTL of riscv_pu_axi4 is
  component riscv_core
  generic (
    ? : std_logic_vector(? downto 0) := ?;
    ? : std_logic_vector(? downto 0) := ?;
    ? : std_logic_vector(? downto 0) := ?;
    ? : std_logic_vector(? downto 0) := ?;
    ? : std_logic_vector(? downto 0) := ?;
    ? : std_logic_vector(? downto 0) := ?;
    ? : std_logic_vector(? downto 0) := ?;
    ? : std_logic_vector(? downto 0) := ?;
    ? : std_logic_vector(? downto 0) := ?;
    ? : std_logic_vector(? downto 0) := ?;
    ? : std_logic_vector(? downto 0) := ?;
    ? : std_logic_vector(? downto 0) := ?;
    ? : std_logic_vector(? downto 0) := ?;
    ? : std_logic_vector(? downto 0) := ?;
    ? : std_logic_vector(? downto 0) := ?;
    ? : std_logic_vector(? downto 0) := ?;
    ? : std_logic_vector(? downto 0) := ?;
    ? : std_logic_vector(? downto 0) := ?;
    ? : std_logic_vector(? downto 0) := ?;
    ? : std_logic_vector(? downto 0) := ?;
    ? : std_logic_vector(? downto 0) := ?;
    ? : std_logic_vector(? downto 0) := ?;
    ? : std_logic_vector(? downto 0) := ?;
    ? : std_logic_vector(? downto 0) := ?;
    ? : std_logic_vector(? downto 0) := ?;
    ? : std_logic_vector(? downto 0) := ?;
    ? : std_logic_vector(? downto 0) := ?;
    ? : std_logic_vector(? downto 0) := ?
  );
  port (
    rstn : std_logic_vector(? downto 0);
    clk : std_logic_vector(? downto 0);
    if_stall_nxt_pc : std_logic_vector(? downto 0);
    if_nxt_pc : std_logic_vector(? downto 0);
    if_stall : std_logic_vector(? downto 0);
    if_flush : std_logic_vector(? downto 0);
    if_parcel : std_logic_vector(? downto 0);
    if_parcel_pc : std_logic_vector(? downto 0);
    if_parcel_valid : std_logic_vector(? downto 0);
    if_parcel_misaligned : std_logic_vector(? downto 0);
    if_parcel_page_fault : std_logic_vector(? downto 0);
    dmem_adr : std_logic_vector(? downto 0);
    dmem_d : std_logic_vector(? downto 0);
    dmem_q : std_logic_vector(? downto 0);
    dmem_we : std_logic_vector(? downto 0);
    dmem_size : std_logic_vector(? downto 0);
    dmem_req : std_logic_vector(? downto 0);
    dmem_ack : std_logic_vector(? downto 0);
    dmem_err : std_logic_vector(? downto 0);
    dmem_misaligned : std_logic_vector(? downto 0);
    dmem_page_fault : std_logic_vector(? downto 0);
    st_prv : std_logic_vector(? downto 0);
    st_pmpcfg : std_logic_vector(? downto 0);
    st_pmpaddr : std_logic_vector(? downto 0);
    bu_cacheflush : std_logic_vector(? downto 0);
    ext_nmi : std_logic_vector(? downto 0);
    ext_tint : std_logic_vector(? downto 0);
    ext_sint : std_logic_vector(? downto 0);
    ext_int : std_logic_vector(? downto 0);
    dbg_stall : std_logic_vector(? downto 0);
    dbg_strb : std_logic_vector(? downto 0);
    dbg_we : std_logic_vector(? downto 0);
    dbg_addr : std_logic_vector(? downto 0);
    dbg_dati : std_logic_vector(? downto 0);
    dbg_dato : std_logic_vector(? downto 0);
    dbg_ack : std_logic_vector(? downto 0);
    dbg_bp : std_logic_vector(? downto 0)
  );
  end component;

  component riscv_imem_ctrl
  generic (
    ? : std_logic_vector(? downto 0) := ?;
    ? : std_logic_vector(? downto 0) := ?;
    ? : std_logic_vector(? downto 0) := ?;
    ? : std_logic_vector(? downto 0) := ?;
    ? : std_logic_vector(? downto 0) := ?;
    ? : std_logic_vector(? downto 0) := ?;
    ? : std_logic_vector(? downto 0) := ?;
    ? : std_logic_vector(? downto 0) := ?;
    ? : std_logic_vector(? downto 0) := ?;
    ? : std_logic_vector(? downto 0) := ?;
    ? : std_logic_vector(? downto 0) := ?;
    ? : std_logic_vector(? downto 0) := ?
  );
  port (
    rst_ni : std_logic_vector(? downto 0);
    clk_i : std_logic_vector(? downto 0);
    pma_cfg_i : std_logic_vector(? downto 0);
    pma_adr_i : std_logic_vector(? downto 0);
    nxt_pc_i : std_logic_vector(? downto 0);
    stall_nxt_pc_o : std_logic_vector(? downto 0);
    stall_i : std_logic_vector(? downto 0);
    flush_i : std_logic_vector(? downto 0);
    parcel_pc_o : std_logic_vector(? downto 0);
    parcel_o : std_logic_vector(? downto 0);
    parcel_valid_o : std_logic_vector(? downto 0);
    err_o : std_logic_vector(? downto 0);
    misaligned_o : std_logic_vector(? downto 0);
    page_fault_o : std_logic_vector(? downto 0);
    cache_flush_i : std_logic_vector(? downto 0);
    dcflush_rdy_i : std_logic_vector(? downto 0);
    st_prv_i : std_logic_vector(? downto 0);
    st_pmpcfg_i : std_logic_vector(? downto 0);
    st_pmpaddr_i : std_logic_vector(? downto 0);
    biu_stb_o : std_logic_vector(? downto 0);
    biu_stb_ack_i : std_logic_vector(? downto 0);
    biu_d_ack_i : std_logic_vector(? downto 0);
    biu_adri_o : std_logic_vector(? downto 0);
    biu_adro_i : std_logic_vector(? downto 0);
    biu_size_o : std_logic_vector(? downto 0);
    biu_type_o : std_logic_vector(? downto 0);
    biu_we_o : std_logic_vector(? downto 0);
    biu_lock_o : std_logic_vector(? downto 0);
    biu_prot_o : std_logic_vector(? downto 0);
    biu_d_o : std_logic_vector(? downto 0);
    biu_q_i : std_logic_vector(? downto 0);
    biu_ack_i : std_logic_vector(? downto 0);
    biu_err_i : std_logic_vector(? downto 0)
  );
  end component;

  component riscv_dmem_ctrl
  generic (
    ? : std_logic_vector(? downto 0) := ?;
    ? : std_logic_vector(? downto 0) := ?;
    ? : std_logic_vector(? downto 0) := ?;
    ? : std_logic_vector(? downto 0) := ?;
    ? : std_logic_vector(? downto 0) := ?;
    ? : std_logic_vector(? downto 0) := ?;
    ? : std_logic_vector(? downto 0) := ?;
    ? : std_logic_vector(? downto 0) := ?;
    ? : std_logic_vector(? downto 0) := ?;
    ? : std_logic_vector(? downto 0) := ?;
    ? : std_logic_vector(? downto 0) := ?
  );
  port (
    rst_ni : std_logic_vector(? downto 0);
    clk_i : std_logic_vector(? downto 0);
    pma_cfg_i : std_logic_vector(? downto 0);
    pma_adr_i : std_logic_vector(? downto 0);
    mem_req_i : std_logic_vector(? downto 0);
    mem_adr_i : std_logic_vector(? downto 0);
    mem_size_i : std_logic_vector(? downto 0);
    mem_lock_i : std_logic_vector(? downto 0);
    mem_we_i : std_logic_vector(? downto 0);
    mem_d_i : std_logic_vector(? downto 0);
    mem_q_o : std_logic_vector(? downto 0);
    mem_ack_o : std_logic_vector(? downto 0);
    mem_err_o : std_logic_vector(? downto 0);
    mem_misaligned_o : std_logic_vector(? downto 0);
    mem_page_fault_o : std_logic_vector(? downto 0);
    cache_flush_i : std_logic_vector(? downto 0);
    dcflush_rdy_o : std_logic_vector(? downto 0);
    st_prv_i : std_logic_vector(? downto 0);
    st_pmpcfg_i : std_logic_vector(? downto 0);
    st_pmpaddr_i : std_logic_vector(? downto 0);
    biu_stb_o : std_logic_vector(? downto 0);
    biu_stb_ack_i : std_logic_vector(? downto 0);
    biu_d_ack_i : std_logic_vector(? downto 0);
    biu_adri_o : std_logic_vector(? downto 0);
    biu_adro_i : std_logic_vector(? downto 0);
    biu_size_o : std_logic_vector(? downto 0);
    biu_type_o : std_logic_vector(? downto 0);
    biu_we_o : std_logic_vector(? downto 0);
    biu_lock_o : std_logic_vector(? downto 0);
    biu_prot_o : std_logic_vector(? downto 0);
    biu_d_o : std_logic_vector(? downto 0);
    biu_q_i : std_logic_vector(? downto 0);
    biu_ack_i : std_logic_vector(? downto 0);
    biu_err_i : std_logic_vector(? downto 0)
  );
  end component;

  component riscv_biu2axi4
  generic (
    ? : std_logic_vector(? downto 0) := ?;
    ? : std_logic_vector(? downto 0) := ?;
    ? : std_logic_vector(? downto 0) := ?;
    ? : std_logic_vector(? downto 0) := ?;
    ? : std_logic_vector(? downto 0) := ?;
    ? : std_logic_vector(? downto 0) := ?;
    ? : std_logic_vector(? downto 0) := ?;
    ? : std_logic_vector(? downto 0) := ?;
    ? : std_logic_vector(? downto 0) := ?
  );
  port (
    HRESETn : std_logic_vector(? downto 0);
    HCLK : std_logic_vector(? downto 0);
    axi4_aw_id : std_logic_vector(? downto 0);
    axi4_aw_addr : std_logic_vector(? downto 0);
    axi4_aw_len : std_logic_vector(? downto 0);
    axi4_aw_size : std_logic_vector(? downto 0);
    axi4_aw_burst : std_logic_vector(? downto 0);
    axi4_aw_lock : std_logic_vector(? downto 0);
    axi4_aw_cache : std_logic_vector(? downto 0);
    axi4_aw_prot : std_logic_vector(? downto 0);
    axi4_aw_qos : std_logic_vector(? downto 0);
    axi4_aw_region : std_logic_vector(? downto 0);
    axi4_aw_user : std_logic_vector(? downto 0);
    axi4_aw_valid : std_logic_vector(? downto 0);
    axi4_aw_ready : std_logic_vector(? downto 0);
    axi4_ar_id : std_logic_vector(? downto 0);
    axi4_ar_addr : std_logic_vector(? downto 0);
    axi4_ar_len : std_logic_vector(? downto 0);
    axi4_ar_size : std_logic_vector(? downto 0);
    axi4_ar_burst : std_logic_vector(? downto 0);
    axi4_ar_lock : std_logic_vector(? downto 0);
    axi4_ar_cache : std_logic_vector(? downto 0);
    axi4_ar_prot : std_logic_vector(? downto 0);
    axi4_ar_qos : std_logic_vector(? downto 0);
    axi4_ar_region : std_logic_vector(? downto 0);
    axi4_ar_user : std_logic_vector(? downto 0);
    axi4_ar_valid : std_logic_vector(? downto 0);
    axi4_ar_ready : std_logic_vector(? downto 0);
    axi4_w_data : std_logic_vector(? downto 0);
    axi4_w_strb : std_logic_vector(? downto 0);
    axi4_w_last : std_logic_vector(? downto 0);
    axi4_w_user : std_logic_vector(? downto 0);
    axi4_w_valid : std_logic_vector(? downto 0);
    axi4_w_ready : std_logic_vector(? downto 0);
    axi4_r_id : std_logic_vector(? downto 0);
    axi4_r_data : std_logic_vector(? downto 0);
    axi4_r_resp : std_logic_vector(? downto 0);
    axi4_r_last : std_logic_vector(? downto 0);
    axi4_r_user : std_logic_vector(? downto 0);
    axi4_r_valid : std_logic_vector(? downto 0);
    axi4_r_ready : std_logic_vector(? downto 0);
    axi4_b_id : std_logic_vector(? downto 0);
    axi4_b_resp : std_logic_vector(? downto 0);
    axi4_b_user : std_logic_vector(? downto 0);
    axi4_b_valid : std_logic_vector(? downto 0);
    axi4_b_ready : std_logic_vector(? downto 0);
    biu_stb_i : std_logic_vector(? downto 0);
    biu_stb_ack_o : std_logic_vector(? downto 0);
    biu_d_ack_o : std_logic_vector(? downto 0);
    biu_adri_i : std_logic_vector(? downto 0);
    biu_adro_o : std_logic_vector(? downto 0);
    biu_size_i : std_logic_vector(? downto 0);
    biu_type_i : std_logic_vector(? downto 0);
    biu_prot_i : std_logic_vector(? downto 0);
    biu_lock_i : std_logic_vector(? downto 0);
    biu_we_i : std_logic_vector(? downto 0);
    biu_d_i : std_logic_vector(? downto 0);
    biu_q_o : std_logic_vector(? downto 0);
    biu_ack_o : std_logic_vector(? downto 0);
    biu_err_o : std_logic_vector(? downto 0)
  );
  end component;



  --//////////////////////////////////////////////////////////////
  --
  -- Variables
  --
  signal if_stall_nxt_pc : std_logic;
  signal if_nxt_pc : std_logic_vector(XLEN-1 downto 0);
  signal if_stall, if_flush : std_logic;
  signal if_parcel : std_logic_vector(PARCEL_SIZE-1 downto 0);
  signal if_parcel_pc : std_logic_vector(XLEN-1 downto 0);
  signal if_parcel_valid : std_logic_vector(PARCEL_SIZE/16-1 downto 0);
  signal if_parcel_misaligned : std_logic;
  signal if_parcel_page_fault : std_logic;

  signal dmem_req : std_logic;
  signal dmem_adr : std_logic_vector(XLEN-1 downto 0);
  signal dmem_size : std_logic_vector(2 downto 0);
  signal dmem_we : std_logic;
  signal dmem_d, dmem_q : std_logic_vector(XLEN-1 downto 0);
  signal dmem_ack, dmem_err : std_logic;
  signal dmem_misaligned : std_logic;
  signal dmem_page_fault : std_logic;

  signal st_prv : std_logic_vector(1 downto 0);
  signal st_pmpcfg : std_logic_vector(7 downto 0);
  signal st_pmpaddr : std_logic_vector(XLEN-1 downto 0);

  signal cacheflush, dcflush_rdy : std_logic;

  --Instruction Memory BIU connections
  signal ibiu_stb : std_logic;
  signal ibiu_stb_ack : std_logic;
  signal ibiu_d_ack : std_logic;
  signal ibiu_adri, ibiu_adro : std_logic_vector(PLEN-1 downto 0);
  signal ibiu_size : std_logic_vector(2 downto 0);
  signal ibiu_type : std_logic_vector(2 downto 0);
  signal ibiu_we : std_logic;
  signal ibiu_lock : std_logic;
  signal ibiu_prot : std_logic_vector(2 downto 0);
  signal ibiu_d : std_logic_vector(XLEN-1 downto 0);
  signal ibiu_q : std_logic_vector(XLEN-1 downto 0);
  signal ibiu_ack, ibiu_err : std_logic;
  --Data Memory BIU connections
  signal dbiu_stb : std_logic;
  signal dbiu_stb_ack : std_logic;
  signal dbiu_d_ack : std_logic;
  signal dbiu_adri, dbiu_adro : std_logic_vector(PLEN-1 downto 0);
  signal dbiu_size : std_logic_vector(2 downto 0);
  signal dbiu_type : std_logic_vector(2 downto 0);
  signal dbiu_we : std_logic;
  signal dbiu_lock : std_logic;
  signal dbiu_prot : std_logic_vector(2 downto 0);
  signal dbiu_d : std_logic_vector(XLEN-1 downto 0);
  signal dbiu_q : std_logic_vector(XLEN-1 downto 0);
  signal dbiu_ack, dbiu_err : std_logic;

begin
  --//////////////////////////////////////////////////////////////
  --
  -- Module Body
  --

  --Instantiate RISC-V core
  core : riscv_core
  generic map (
    XLEN, 
    PLEN, 
    HAS_USER, 
    HAS_SUPER, 
    HAS_HYPER, 
    HAS_BPU, 
    HAS_FPU, 
    HAS_MMU, 
    HAS_RVM, 
    HAS_RVA, 
    HAS_RVC, 
    IS_RV32E, 

    MULT_LATENCY, 

    BREAKPOINTS, 
    PMP_CNT, 

    BP_GLOBAL_BITS, 
    BP_LOCAL_BITS, 

    TECHNOLOGY, 

    MNMIVEC_DEFAULT, 
    MTVEC_DEFAULT, 
    HTVEC_DEFAULT, 
    STVEC_DEFAULT, 
    UTVEC_DEFAULT, 

    JEDEC_BANK, 
    JEDEC_MANUFACTURER_ID, 

    HARTID, 

    PC_INIT, 
    PARCEL_SIZE
  )
  port map (
    rstn => HRESETn,
    clk => HCLK,

    if_stall_nxt_pc => if_stall_nxt_pc,
    if_nxt_pc => if_nxt_pc,
    if_stall => if_stall,
    if_flush => if_flush,
    if_parcel => if_parcel,
    if_parcel_pc => if_parcel_pc,
    if_parcel_valid => if_parcel_valid,
    if_parcel_misaligned => if_parcel_misaligned,
    if_parcel_page_fault => if_parcel_page_fault,
    dmem_adr => dmem_adr,
    dmem_d => dmem_d,
    dmem_q => dmem_q,
    dmem_we => dmem_we,
    dmem_size => dmem_size,
    dmem_req => dmem_req,
    dmem_ack => dmem_ack,
    dmem_err => dmem_err,
    dmem_misaligned => dmem_misaligned,
    dmem_page_fault => dmem_page_fault,
    st_prv => st_prv,
    st_pmpcfg => st_pmpcfg,
    st_pmpaddr => st_pmpaddr,

    bu_cacheflush => cacheflush,

    ext_nmi => ext_nmi,
    ext_tint => ext_tint,
    ext_sint => ext_sint,
    ext_int => ext_int,
    dbg_stall => dbg_stall,
    dbg_strb => dbg_strb,
    dbg_we => dbg_we,
    dbg_addr => dbg_addr,
    dbg_dati => dbg_dati,
    dbg_dato => dbg_dato,
    dbg_ack => dbg_ack,
    dbg_bp => dbg_bp
  );


  --Instantiate bus interfaces and optional caches

  --Instruction Memory Access Block
  imem_ctrl : riscv_imem_ctrl
  generic map (
    XLEN, 
    PLEN, 

    PARCEL_SIZE, 

    HAS_RVC, 

    PMA_CNT, 
    PMP_CNT, 

    ICACHE_SIZE, 
    ICACHE_BLOCK_SIZE, 
    ICACHE_WAYS, 
    ICACHE_REPLACE_ALG, 
    ITCM_SIZE, 

    TECHNOLOGY
  )
  port map (
    rst_ni => HRESETn,
    clk_i => HCLK,

    pma_cfg_i => pma_cfg_i,
    pma_adr_i => pma_adr_i,

    nxt_pc_i => if_nxt_pc,
    stall_nxt_pc_o => if_stall_nxt_pc,
    stall_i => if_stall,
    flush_i => if_flush,
    parcel_pc_o => if_parcel_pc,
    parcel_o => if_parcel,
    parcel_valid_o => if_parcel_valid,
    err_o => open,
    misaligned_o => if_parcel_misaligned,
    page_fault_o => if_parcel_page_fault,

    cache_flush_i => cacheflush,
    dcflush_rdy_i => dcflush_rdy,

    st_prv_i => st_prv,
    st_pmpcfg_i => st_pmpcfg,
    st_pmpaddr_i => st_pmpaddr,

    biu_stb_o => ibiu_stb,
    biu_stb_ack_i => ibiu_stb_ack,
    biu_d_ack_i => ibiu_d_ack,
    biu_adri_o => ibiu_adri,
    biu_adro_i => ibiu_adro,
    biu_size_o => ibiu_size,
    biu_type_o => ibiu_type,
    biu_we_o => ibiu_we,
    biu_lock_o => ibiu_lock,
    biu_prot_o => ibiu_prot,
    biu_d_o => ibiu_d,
    biu_q_i => ibiu_q,
    biu_ack_i => ibiu_ack,
    biu_err_i => ibiu_err
  );


  --Data Memory Access Block
  dmem_ctrl : riscv_dmem_ctrl
  generic map (
    XLEN, 
    PLEN, 

    HAS_RVC, 

    PMA_CNT, 
    PMP_CNT, 

    DCACHE_SIZE, 
    DCACHE_BLOCK_SIZE, 
    DCACHE_WAYS, 
    DCACHE_REPLACE_ALG, 
    DTCM_SIZE, 

    TECHNOLOGY
  )
  port map (
    rst_ni => HRESETn,
    clk_i => HCLK,

    pma_cfg_i => pma_cfg_i,
    pma_adr_i => pma_adr_i,

    mem_req_i => dmem_req,
    mem_adr_i => dmem_adr,
    mem_size_i => dmem_size,
    mem_lock_i => open,
    mem_we_i => dmem_we,
    mem_d_i => dmem_d,
    mem_q_o => dmem_q,
    mem_ack_o => dmem_ack,
    mem_err_o => dmem_err,
    mem_misaligned_o => dmem_misaligned,
    mem_page_fault_o => dmem_page_fault,

    cache_flush_i => cacheflush,
    dcflush_rdy_o => dcflush_rdy,

    st_prv_i => st_prv,
    st_pmpcfg_i => st_pmpcfg,
    st_pmpaddr_i => st_pmpaddr,

    biu_stb_o => dbiu_stb,
    biu_stb_ack_i => dbiu_stb_ack,
    biu_d_ack_i => dbiu_d_ack,
    biu_adri_o => dbiu_adri,
    biu_adro_i => dbiu_adro,
    biu_size_o => dbiu_size,
    biu_type_o => dbiu_type,
    biu_we_o => dbiu_we,
    biu_lock_o => dbiu_lock,
    biu_prot_o => dbiu_prot,
    biu_d_o => dbiu_d,
    biu_q_i => dbiu_q,
    biu_ack_i => dbiu_ack,
    biu_err_i => dbiu_err
  );


  --Instantiate BIU
  ibiu : riscv_biu2axi4
  generic map (
    XLEN, 
    PLEN, 

    AXI_ID_WIDTH, 
    AXI_ADDR_WIDTH, 
    AXI_DATA_WIDTH, 
    AXI_STRB_WIDTH, 
    AXI_USER_WIDTH, 

    AHB_ADDR_WIDTH, 
    AHB_DATA_WIDTH
  )
  port map (
    HRESETn => HRESETn,
    HCLK => HCLK,

    --AXI4 instruction
    axi4_aw_id => axi4_ins_aw_id,
    axi4_aw_addr => axi4_ins_aw_addr,
    axi4_aw_len => axi4_ins_aw_len,
    axi4_aw_size => axi4_ins_aw_size,
    axi4_aw_burst => axi4_ins_aw_burst,
    axi4_aw_lock => axi4_ins_aw_lock,
    axi4_aw_cache => axi4_ins_aw_cache,
    axi4_aw_prot => axi4_ins_aw_prot,
    axi4_aw_qos => axi4_ins_aw_qos,
    axi4_aw_region => axi4_ins_aw_region,
    axi4_aw_user => axi4_ins_aw_user,
    axi4_aw_valid => axi4_ins_aw_valid,
    axi4_aw_ready => axi4_ins_aw_ready,
    axi4_ar_id => axi4_ins_ar_id,
    axi4_ar_addr => axi4_ins_ar_addr,
    axi4_ar_len => axi4_ins_ar_len,
    axi4_ar_size => axi4_ins_ar_size,
    axi4_ar_burst => axi4_ins_ar_burst,
    axi4_ar_lock => axi4_ins_ar_lock,
    axi4_ar_cache => axi4_ins_ar_cache,
    axi4_ar_prot => axi4_ins_ar_prot,
    axi4_ar_qos => axi4_ins_ar_qos,
    axi4_ar_region => axi4_ins_ar_region,
    axi4_ar_user => axi4_ins_ar_user,
    axi4_ar_valid => axi4_ins_ar_valid,
    axi4_ar_ready => axi4_ins_ar_ready,
    axi4_w_data => axi4_ins_w_data,
    axi4_w_strb => axi4_ins_w_strb,
    axi4_w_last => axi4_ins_w_last,
    axi4_w_user => axi4_ins_w_user,
    axi4_w_valid => axi4_ins_w_valid,
    axi4_w_ready => axi4_ins_w_ready,
    axi4_r_id => axi4_ins_r_id,
    axi4_r_data => axi4_ins_r_data,
    axi4_r_resp => axi4_ins_r_resp,
    axi4_r_last => axi4_ins_r_last,
    axi4_r_user => axi4_ins_r_user,
    axi4_r_valid => axi4_ins_r_valid,
    axi4_r_ready => axi4_ins_r_ready,
    axi4_b_id => axi4_ins_b_id,
    axi4_b_resp => axi4_ins_b_resp,
    axi4_b_user => axi4_ins_b_user,
    axi4_b_valid => axi4_ins_b_valid,
    axi4_b_ready => axi4_ins_b_ready,

    biu_stb_i => ibiu_stb,
    biu_stb_ack_o => ibiu_stb_ack,
    biu_d_ack_o => ibiu_d_ack,
    biu_adri_i => ibiu_adri,
    biu_adro_o => ibiu_adro,
    biu_size_i => ibiu_size,
    biu_type_i => ibiu_type,
    biu_prot_i => ibiu_prot,
    biu_lock_i => ibiu_lock,
    biu_we_i => ibiu_we,
    biu_d_i => ibiu_d,
    biu_q_o => ibiu_q,
    biu_ack_o => ibiu_ack,
    biu_err_o => ibiu_err
  );


  dbiu : riscv_biu2axi4
  generic map (
    XLEN, 
    PLEN, 

    AXI_ID_WIDTH, 
    AXI_ADDR_WIDTH, 
    AXI_DATA_WIDTH, 
    AXI_STRB_WIDTH, 
    AXI_USER_WIDTH, 

    AHB_ADDR_WIDTH, 
    AHB_DATA_WIDTH
  )
  port map (
    HRESETn => HRESETn,
    HCLK => HCLK,
    --AXI4 data
    axi4_aw_id => axi4_dat_aw_id,
    axi4_aw_addr => axi4_dat_aw_addr,
    axi4_aw_len => axi4_dat_aw_len,
    axi4_aw_size => axi4_dat_aw_size,
    axi4_aw_burst => axi4_dat_aw_burst,
    axi4_aw_lock => axi4_dat_aw_lock,
    axi4_aw_cache => axi4_dat_aw_cache,
    axi4_aw_prot => axi4_dat_aw_prot,
    axi4_aw_qos => axi4_dat_aw_qos,
    axi4_aw_region => axi4_dat_aw_region,
    axi4_aw_user => axi4_dat_aw_user,
    axi4_aw_valid => axi4_dat_aw_valid,
    axi4_aw_ready => axi4_dat_aw_ready,
    axi4_ar_id => axi4_dat_ar_id,
    axi4_ar_addr => axi4_dat_ar_addr,
    axi4_ar_len => axi4_dat_ar_len,
    axi4_ar_size => axi4_dat_ar_size,
    axi4_ar_burst => axi4_dat_ar_burst,
    axi4_ar_lock => axi4_dat_ar_lock,
    axi4_ar_cache => axi4_dat_ar_cache,
    axi4_ar_prot => axi4_dat_ar_prot,
    axi4_ar_qos => axi4_dat_ar_qos,
    axi4_ar_region => axi4_dat_ar_region,
    axi4_ar_user => axi4_dat_ar_user,
    axi4_ar_valid => axi4_dat_ar_valid,
    axi4_ar_ready => axi4_dat_ar_ready,
    axi4_w_data => axi4_dat_w_data,
    axi4_w_strb => axi4_dat_w_strb,
    axi4_w_last => axi4_dat_w_last,
    axi4_w_user => axi4_dat_w_user,
    axi4_w_valid => axi4_dat_w_valid,
    axi4_w_ready => axi4_dat_w_ready,
    axi4_r_id => axi4_dat_r_id,
    axi4_r_data => axi4_dat_r_data,
    axi4_r_resp => axi4_dat_r_resp,
    axi4_r_last => axi4_dat_r_last,
    axi4_r_user => axi4_dat_r_user,
    axi4_r_valid => axi4_dat_r_valid,
    axi4_r_ready => axi4_dat_r_ready,
    axi4_b_id => axi4_dat_b_id,
    axi4_b_resp => axi4_dat_b_resp,
    axi4_b_user => axi4_dat_b_user,
    axi4_b_valid => axi4_dat_b_valid,
    axi4_b_ready => axi4_dat_b_ready,

    biu_stb_i => dbiu_stb,
    biu_stb_ack_o => dbiu_stb_ack,
    biu_d_ack_o => dbiu_d_ack,
    biu_adri_i => dbiu_adri,
    biu_adro_o => dbiu_adro,
    biu_size_i => dbiu_size,
    biu_type_i => dbiu_type,
    biu_prot_i => dbiu_prot,
    biu_lock_i => dbiu_lock,
    biu_we_i => dbiu_we,
    biu_d_i => dbiu_d,
    biu_q_o => dbiu_q,
    biu_ack_o => dbiu_ack,
    biu_err_o => dbiu_err
  );
end RTL;
