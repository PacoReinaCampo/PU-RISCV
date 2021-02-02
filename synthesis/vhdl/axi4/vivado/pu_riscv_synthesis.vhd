-- Converted from pu_riscv_synthesis.sv
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
--              PU-RISCV                                                      //
--              Synthesis                                                     //
--              AMBA4 AXI-Lite Bus Interface                                  //
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

use work."riscv_defines.sv".all;


library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity pu_riscv_synthesis is
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

  --Interrupts
    ext_nmi : in std_logic;
    ext_tint : in std_logic;
    ext_sint : in std_logic;
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
  constant XLEN : integer := 32;
  constant PLEN : integer := 32;
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
end pu_riscv_synthesis;

architecture RTL of pu_riscv_synthesis is
  component riscv_pu_axi4
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
    ? : std_logic_vector(? downto 0) := ?
  );
  port (
    HRESETn : std_logic_vector(? downto 0);
    HCLK : std_logic_vector(? downto 0);
    pma_cfg_i : std_logic_vector(? downto 0);
    pma_adr_i : std_logic_vector(? downto 0);
    axi4_ins_aw_id : std_logic_vector(? downto 0);
    axi4_ins_aw_addr : std_logic_vector(? downto 0);
    axi4_ins_aw_len : std_logic_vector(? downto 0);
    axi4_ins_aw_size : std_logic_vector(? downto 0);
    axi4_ins_aw_burst : std_logic_vector(? downto 0);
    axi4_ins_aw_lock : std_logic_vector(? downto 0);
    axi4_ins_aw_cache : std_logic_vector(? downto 0);
    axi4_ins_aw_prot : std_logic_vector(? downto 0);
    axi4_ins_aw_qos : std_logic_vector(? downto 0);
    axi4_ins_aw_region : std_logic_vector(? downto 0);
    axi4_ins_aw_user : std_logic_vector(? downto 0);
    axi4_ins_aw_valid : std_logic_vector(? downto 0);
    axi4_ins_aw_ready : std_logic_vector(? downto 0);
    axi4_ins_ar_id : std_logic_vector(? downto 0);
    axi4_ins_ar_addr : std_logic_vector(? downto 0);
    axi4_ins_ar_len : std_logic_vector(? downto 0);
    axi4_ins_ar_size : std_logic_vector(? downto 0);
    axi4_ins_ar_burst : std_logic_vector(? downto 0);
    axi4_ins_ar_lock : std_logic_vector(? downto 0);
    axi4_ins_ar_cache : std_logic_vector(? downto 0);
    axi4_ins_ar_prot : std_logic_vector(? downto 0);
    axi4_ins_ar_qos : std_logic_vector(? downto 0);
    axi4_ins_ar_region : std_logic_vector(? downto 0);
    axi4_ins_ar_user : std_logic_vector(? downto 0);
    axi4_ins_ar_valid : std_logic_vector(? downto 0);
    axi4_ins_ar_ready : std_logic_vector(? downto 0);
    axi4_ins_w_data : std_logic_vector(? downto 0);
    axi4_ins_w_strb : std_logic_vector(? downto 0);
    axi4_ins_w_last : std_logic_vector(? downto 0);
    axi4_ins_w_user : std_logic_vector(? downto 0);
    axi4_ins_w_valid : std_logic_vector(? downto 0);
    axi4_ins_w_ready : std_logic_vector(? downto 0);
    axi4_ins_r_id : std_logic_vector(? downto 0);
    axi4_ins_r_data : std_logic_vector(? downto 0);
    axi4_ins_r_resp : std_logic_vector(? downto 0);
    axi4_ins_r_last : std_logic_vector(? downto 0);
    axi4_ins_r_user : std_logic_vector(? downto 0);
    axi4_ins_r_valid : std_logic_vector(? downto 0);
    axi4_ins_r_ready : std_logic_vector(? downto 0);
    axi4_ins_b_id : std_logic_vector(? downto 0);
    axi4_ins_b_resp : std_logic_vector(? downto 0);
    axi4_ins_b_user : std_logic_vector(? downto 0);
    axi4_ins_b_valid : std_logic_vector(? downto 0);
    axi4_ins_b_ready : std_logic_vector(? downto 0);
    axi4_dat_aw_id : std_logic_vector(? downto 0);
    axi4_dat_aw_addr : std_logic_vector(? downto 0);
    axi4_dat_aw_len : std_logic_vector(? downto 0);
    axi4_dat_aw_size : std_logic_vector(? downto 0);
    axi4_dat_aw_burst : std_logic_vector(? downto 0);
    axi4_dat_aw_lock : std_logic_vector(? downto 0);
    axi4_dat_aw_cache : std_logic_vector(? downto 0);
    axi4_dat_aw_prot : std_logic_vector(? downto 0);
    axi4_dat_aw_qos : std_logic_vector(? downto 0);
    axi4_dat_aw_region : std_logic_vector(? downto 0);
    axi4_dat_aw_user : std_logic_vector(? downto 0);
    axi4_dat_aw_valid : std_logic_vector(? downto 0);
    axi4_dat_aw_ready : std_logic_vector(? downto 0);
    axi4_dat_ar_id : std_logic_vector(? downto 0);
    axi4_dat_ar_addr : std_logic_vector(? downto 0);
    axi4_dat_ar_len : std_logic_vector(? downto 0);
    axi4_dat_ar_size : std_logic_vector(? downto 0);
    axi4_dat_ar_burst : std_logic_vector(? downto 0);
    axi4_dat_ar_lock : std_logic_vector(? downto 0);
    axi4_dat_ar_cache : std_logic_vector(? downto 0);
    axi4_dat_ar_prot : std_logic_vector(? downto 0);
    axi4_dat_ar_qos : std_logic_vector(? downto 0);
    axi4_dat_ar_region : std_logic_vector(? downto 0);
    axi4_dat_ar_user : std_logic_vector(? downto 0);
    axi4_dat_ar_valid : std_logic_vector(? downto 0);
    axi4_dat_ar_ready : std_logic_vector(? downto 0);
    axi4_dat_w_data : std_logic_vector(? downto 0);
    axi4_dat_w_strb : std_logic_vector(? downto 0);
    axi4_dat_w_last : std_logic_vector(? downto 0);
    axi4_dat_w_user : std_logic_vector(? downto 0);
    axi4_dat_w_valid : std_logic_vector(? downto 0);
    axi4_dat_w_ready : std_logic_vector(? downto 0);
    axi4_dat_r_id : std_logic_vector(? downto 0);
    axi4_dat_r_data : std_logic_vector(? downto 0);
    axi4_dat_r_resp : std_logic_vector(? downto 0);
    axi4_dat_r_last : std_logic_vector(? downto 0);
    axi4_dat_r_user : std_logic_vector(? downto 0);
    axi4_dat_r_valid : std_logic_vector(? downto 0);
    axi4_dat_r_ready : std_logic_vector(? downto 0);
    axi4_dat_b_id : std_logic_vector(? downto 0);
    axi4_dat_b_resp : std_logic_vector(? downto 0);
    axi4_dat_b_user : std_logic_vector(? downto 0);
    axi4_dat_b_valid : std_logic_vector(? downto 0);
    axi4_dat_b_ready : std_logic_vector(? downto 0);
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

  component mpsoc_axi4_spram
  generic (
    ? : std_logic_vector(? downto 0) := ?;
    ? : std_logic_vector(? downto 0) := ?;
    ? : std_logic_vector(? downto 0) := ?;
    ? : std_logic_vector(? downto 0) := ?;
    ? : std_logic_vector(? downto 0) := ?
  );
  port (
    clk_i : std_logic_vector(? downto 0);
    rst_ni : std_logic_vector(? downto 0);
    axi_aw_id : std_logic_vector(? downto 0);
    axi_aw_addr : std_logic_vector(? downto 0);
    axi_aw_len : std_logic_vector(? downto 0);
    axi_aw_size : std_logic_vector(? downto 0);
    axi_aw_burst : std_logic_vector(? downto 0);
    axi_aw_lock : std_logic_vector(? downto 0);
    axi_aw_cache : std_logic_vector(? downto 0);
    axi_aw_prot : std_logic_vector(? downto 0);
    axi_aw_qos : std_logic_vector(? downto 0);
    axi_aw_region : std_logic_vector(? downto 0);
    axi_aw_user : std_logic_vector(? downto 0);
    axi_aw_valid : std_logic_vector(? downto 0);
    axi_aw_ready : std_logic_vector(? downto 0);
    axi_ar_id : std_logic_vector(? downto 0);
    axi_ar_addr : std_logic_vector(? downto 0);
    axi_ar_len : std_logic_vector(? downto 0);
    axi_ar_size : std_logic_vector(? downto 0);
    axi_ar_burst : std_logic_vector(? downto 0);
    axi_ar_lock : std_logic_vector(? downto 0);
    axi_ar_cache : std_logic_vector(? downto 0);
    axi_ar_prot : std_logic_vector(? downto 0);
    axi_ar_qos : std_logic_vector(? downto 0);
    axi_ar_region : std_logic_vector(? downto 0);
    axi_ar_user : std_logic_vector(? downto 0);
    axi_ar_valid : std_logic_vector(? downto 0);
    axi_ar_ready : std_logic_vector(? downto 0);
    axi_w_data : std_logic_vector(? downto 0);
    axi_w_strb : std_logic_vector(? downto 0);
    axi_w_last : std_logic_vector(? downto 0);
    axi_w_user : std_logic_vector(? downto 0);
    axi_w_valid : std_logic_vector(? downto 0);
    axi_w_ready : std_logic_vector(? downto 0);
    axi_r_id : std_logic_vector(? downto 0);
    axi_r_data : std_logic_vector(? downto 0);
    axi_r_resp : std_logic_vector(? downto 0);
    axi_r_last : std_logic_vector(? downto 0);
    axi_r_user : std_logic_vector(? downto 0);
    axi_r_valid : std_logic_vector(? downto 0);
    axi_r_ready : std_logic_vector(? downto 0);
    axi_b_id : std_logic_vector(? downto 0);
    axi_b_resp : std_logic_vector(? downto 0);
    axi_b_user : std_logic_vector(? downto 0);
    axi_b_valid : std_logic_vector(? downto 0);
    axi_b_ready : std_logic_vector(? downto 0);
    req_o : std_logic_vector(? downto 0);
    we_o : std_logic_vector(? downto 0);
    addr_o : std_logic_vector(? downto 0);
    be_o : std_logic_vector(? downto 0);
    data_o : std_logic_vector(? downto 0);
    data_i : std_logic_vector(? downto 0)
  );
  end component;

  --////////////////////////////////////////////////////////////////
  --
  -- Variables
  --

  constant HTIF : integer := 0;  -- Host-Interface
  constant TOHOST : std_logic_vector(31 downto 0) := X"80001000";
  constant UART_TX : std_logic_vector(31 downto 0) := X"80001080";

  constant AXI_ID_WIDTH : integer := 10;
  constant AXI_ADDR_WIDTH : integer := 64;
  constant AXI_DATA_WIDTH : integer := 64;
  constant AXI_STRB_WIDTH : integer := 8;
  constant AXI_USER_WIDTH : integer := 10;
  --////////////////////////////////////////////////////////////////
  --
  -- Variables
  --

  --PMA configuration
  signal pma_cfg : std_logic_vector(13 downto 0);
  signal pma_adr : std_logic_vector(PLEN-1 downto 0);

  -- AXI4 Instruction
  signal axi4_ins_aw_id : std_logic_vector(AXI_ID_WIDTH-1 downto 0);
  signal axi4_ins_aw_addr : std_logic_vector(AXI_ADDR_WIDTH-1 downto 0);
  signal axi4_ins_aw_len : std_logic_vector(7 downto 0);
  signal axi4_ins_aw_size : std_logic_vector(2 downto 0);
  signal axi4_ins_aw_burst : std_logic_vector(1 downto 0);
  signal axi4_ins_aw_lock : std_logic;
  signal axi4_ins_aw_cache : std_logic_vector(3 downto 0);
  signal axi4_ins_aw_prot : std_logic_vector(2 downto 0);
  signal axi4_ins_aw_qos : std_logic_vector(3 downto 0);
  signal axi4_ins_aw_region : std_logic_vector(3 downto 0);
  signal axi4_ins_aw_user : std_logic_vector(AXI_USER_WIDTH-1 downto 0);
  signal axi4_ins_aw_valid : std_logic;
  signal axi4_ins_aw_ready : std_logic;

  signal axi4_ins_ar_id : std_logic_vector(AXI_ID_WIDTH-1 downto 0);
  signal axi4_ins_ar_addr : std_logic_vector(AXI_ADDR_WIDTH-1 downto 0);
  signal axi4_ins_ar_len : std_logic_vector(7 downto 0);
  signal axi4_ins_ar_size : std_logic_vector(2 downto 0);
  signal axi4_ins_ar_burst : std_logic_vector(1 downto 0);
  signal axi4_ins_ar_lock : std_logic;
  signal axi4_ins_ar_cache : std_logic_vector(3 downto 0);
  signal axi4_ins_ar_prot : std_logic_vector(2 downto 0);
  signal axi4_ins_ar_qos : std_logic_vector(3 downto 0);
  signal axi4_ins_ar_region : std_logic_vector(3 downto 0);
  signal axi4_ins_ar_user : std_logic_vector(AXI_USER_WIDTH-1 downto 0);
  signal axi4_ins_ar_valid : std_logic;
  signal axi4_ins_ar_ready : std_logic;

  signal axi4_ins_w_data : std_logic_vector(AXI_DATA_WIDTH-1 downto 0);
  signal axi4_ins_w_strb : std_logic_vector(AXI_STRB_WIDTH-1 downto 0);
  signal axi4_ins_w_last : std_logic;
  signal axi4_ins_w_user : std_logic_vector(AXI_USER_WIDTH-1 downto 0);
  signal axi4_ins_w_valid : std_logic;
  signal axi4_ins_w_ready : std_logic;

  signal axi4_ins_r_id : std_logic_vector(AXI_ID_WIDTH-1 downto 0);
  signal axi4_ins_r_data : std_logic_vector(AXI_DATA_WIDTH-1 downto 0);
  signal axi4_ins_r_resp : std_logic_vector(1 downto 0);
  signal axi4_ins_r_last : std_logic;
  signal axi4_ins_r_user : std_logic_vector(AXI_USER_WIDTH-1 downto 0);
  signal axi4_ins_r_valid : std_logic;
  signal axi4_ins_r_ready : std_logic;

  signal axi4_ins_b_id : std_logic_vector(AXI_ID_WIDTH-1 downto 0);
  signal axi4_ins_b_resp : std_logic_vector(1 downto 0);
  signal axi4_ins_b_user : std_logic_vector(AXI_USER_WIDTH-1 downto 0);
  signal axi4_ins_b_valid : std_logic;
  signal axi4_ins_b_ready : std_logic;

  --AXI4 Data
  signal axi4_dat_aw_id : std_logic_vector(AXI_ID_WIDTH-1 downto 0);
  signal axi4_dat_aw_addr : std_logic_vector(AXI_ADDR_WIDTH-1 downto 0);
  signal axi4_dat_aw_len : std_logic_vector(7 downto 0);
  signal axi4_dat_aw_size : std_logic_vector(2 downto 0);
  signal axi4_dat_aw_burst : std_logic_vector(1 downto 0);
  signal axi4_dat_aw_lock : std_logic;
  signal axi4_dat_aw_cache : std_logic_vector(3 downto 0);
  signal axi4_dat_aw_prot : std_logic_vector(2 downto 0);
  signal axi4_dat_aw_qos : std_logic_vector(3 downto 0);
  signal axi4_dat_aw_region : std_logic_vector(3 downto 0);
  signal axi4_dat_aw_user : std_logic_vector(AXI_USER_WIDTH-1 downto 0);
  signal axi4_dat_aw_valid : std_logic;
  signal axi4_dat_aw_ready : std_logic;

  signal axi4_dat_ar_id : std_logic_vector(AXI_ID_WIDTH-1 downto 0);
  signal axi4_dat_ar_addr : std_logic_vector(AXI_ADDR_WIDTH-1 downto 0);
  signal axi4_dat_ar_len : std_logic_vector(7 downto 0);
  signal axi4_dat_ar_size : std_logic_vector(2 downto 0);
  signal axi4_dat_ar_burst : std_logic_vector(1 downto 0);
  signal axi4_dat_ar_lock : std_logic;
  signal axi4_dat_ar_cache : std_logic_vector(3 downto 0);
  signal axi4_dat_ar_prot : std_logic_vector(2 downto 0);
  signal axi4_dat_ar_qos : std_logic_vector(3 downto 0);
  signal axi4_dat_ar_region : std_logic_vector(3 downto 0);
  signal axi4_dat_ar_user : std_logic_vector(AXI_USER_WIDTH-1 downto 0);
  signal axi4_dat_ar_valid : std_logic;
  signal axi4_dat_ar_ready : std_logic;

  signal axi4_dat_w_data : std_logic_vector(AXI_DATA_WIDTH-1 downto 0);
  signal axi4_dat_w_strb : std_logic_vector(AXI_STRB_WIDTH-1 downto 0);
  signal axi4_dat_w_last : std_logic;
  signal axi4_dat_w_user : std_logic_vector(AXI_USER_WIDTH-1 downto 0);
  signal axi4_dat_w_valid : std_logic;
  signal axi4_dat_w_ready : std_logic;

  signal axi4_dat_r_id : std_logic_vector(AXI_ID_WIDTH-1 downto 0);
  signal axi4_dat_r_data : std_logic_vector(AXI_DATA_WIDTH-1 downto 0);
  signal axi4_dat_r_resp : std_logic_vector(1 downto 0);
  signal axi4_dat_r_last : std_logic;
  signal axi4_dat_r_user : std_logic_vector(AXI_USER_WIDTH-1 downto 0);
  signal axi4_dat_r_valid : std_logic;
  signal axi4_dat_r_ready : std_logic;

  signal axi4_dat_b_id : std_logic_vector(AXI_ID_WIDTH-1 downto 0);
  signal axi4_dat_b_resp : std_logic_vector(1 downto 0);
  signal axi4_dat_b_user : std_logic_vector(AXI_USER_WIDTH-1 downto 0);
  signal axi4_dat_b_valid : std_logic;
  signal axi4_dat_b_ready : std_logic;
begin
  --//////////////////////////////////////////////////////////////
  --
  -- Module Body
  --

  --Define PMA regions

  --crt.0 (ROM) region
  pma_adr(0) <= TOHOST srl 2;
  pma_cfg(0) <= (MEM_TYPE_MAIN & "1111_1000" & AMO_TYPE_NONE & TOR);

  --TOHOST region
  pma_adr(1) <= ((TOHOST srl 2) and not X"f") or X"7";
  pma_cfg(1) <= (MEM_TYPE_IO & "0100_0000" & AMO_TYPE_NONE & NAPOT);

  --UART-Tx region
  pma_adr(2) <= UART_TX srl 2;
  pma_cfg(2) <= (MEM_TYPE_IO & "0100_0000" & AMO_TYPE_NONE & NA4);

  --RAM region
  pma_adr(3) <= 1 sll 31;
  pma_cfg(3) <= (MEM_TYPE_MAIN & "1111_0000" & AMO_TYPE_NONE & TOR);

  -- Processing Unit
  dut : riscv_pu_axi4
  generic map (
    XLEN, 
    PLEN, 
    PC_INIT, 
    HAS_USER, 
    HAS_SUPER, 
    HAS_HYPER, 
    HAS_RVA, 
    HAS_RVM, 

    MULT_LATENCY, 

    PMA_CNT, 

    ICACHE_SIZE, 
    ICACHE_WAYS, 
    DCACHE_SIZE, 
    DTCM_SIZE, 

    WRITEBUFFER_SIZE, 

    MTVEC_DEFAULT
  )
  port map (
    HRESETn => HRESETn,
    HCLK => HCLK,

    pma_cfg_i => pma_cfg,
    pma_adr_i => pma_adr,

    --AXI4 instruction
    axi4_ins_aw_id => axi4_ins_aw_id,
    axi4_ins_aw_addr => axi4_ins_aw_addr,
    axi4_ins_aw_len => axi4_ins_aw_len,
    axi4_ins_aw_size => axi4_ins_aw_size,
    axi4_ins_aw_burst => axi4_ins_aw_burst,
    axi4_ins_aw_lock => axi4_ins_aw_lock,
    axi4_ins_aw_cache => axi4_ins_aw_cache,
    axi4_ins_aw_prot => axi4_ins_aw_prot,
    axi4_ins_aw_qos => axi4_ins_aw_qos,
    axi4_ins_aw_region => axi4_ins_aw_region,
    axi4_ins_aw_user => axi4_ins_aw_user,
    axi4_ins_aw_valid => axi4_ins_aw_valid,
    axi4_ins_aw_ready => axi4_ins_aw_ready,
    axi4_ins_ar_id => axi4_ins_ar_id,
    axi4_ins_ar_addr => axi4_ins_ar_addr,
    axi4_ins_ar_len => axi4_ins_ar_len,
    axi4_ins_ar_size => axi4_ins_ar_size,
    axi4_ins_ar_burst => axi4_ins_ar_burst,
    axi4_ins_ar_lock => axi4_ins_ar_lock,
    axi4_ins_ar_cache => axi4_ins_ar_cache,
    axi4_ins_ar_prot => axi4_ins_ar_prot,
    axi4_ins_ar_qos => axi4_ins_ar_qos,
    axi4_ins_ar_region => axi4_ins_ar_region,
    axi4_ins_ar_user => axi4_ins_ar_user,
    axi4_ins_ar_valid => axi4_ins_ar_valid,
    axi4_ins_ar_ready => axi4_ins_ar_ready,
    axi4_ins_w_data => axi4_ins_w_data,
    axi4_ins_w_strb => axi4_ins_w_strb,
    axi4_ins_w_last => axi4_ins_w_last,
    axi4_ins_w_user => axi4_ins_w_user,
    axi4_ins_w_valid => axi4_ins_w_valid,
    axi4_ins_w_ready => axi4_ins_w_ready,
    axi4_ins_r_id => axi4_ins_r_id,
    axi4_ins_r_data => axi4_ins_r_data,
    axi4_ins_r_resp => axi4_ins_r_resp,
    axi4_ins_r_last => axi4_ins_r_last,
    axi4_ins_r_user => axi4_ins_r_user,
    axi4_ins_r_valid => axi4_ins_r_valid,
    axi4_ins_r_ready => axi4_ins_r_ready,
    axi4_ins_b_id => axi4_ins_b_id,
    axi4_ins_b_resp => axi4_ins_b_resp,
    axi4_ins_b_user => axi4_ins_b_user,
    axi4_ins_b_valid => axi4_ins_b_valid,
    axi4_ins_b_ready => axi4_ins_b_ready,

    --AXI4 data
    axi4_dat_aw_id => axi4_dat_aw_id,
    axi4_dat_aw_addr => axi4_dat_aw_addr,
    axi4_dat_aw_len => axi4_dat_aw_len,
    axi4_dat_aw_size => axi4_dat_aw_size,
    axi4_dat_aw_burst => axi4_dat_aw_burst,
    axi4_dat_aw_lock => axi4_dat_aw_lock,
    axi4_dat_aw_cache => axi4_dat_aw_cache,
    axi4_dat_aw_prot => axi4_dat_aw_prot,
    axi4_dat_aw_qos => axi4_dat_aw_qos,
    axi4_dat_aw_region => axi4_dat_aw_region,
    axi4_dat_aw_user => axi4_dat_aw_user,
    axi4_dat_aw_valid => axi4_dat_aw_valid,
    axi4_dat_aw_ready => axi4_dat_aw_ready,
    axi4_dat_ar_id => axi4_dat_ar_id,
    axi4_dat_ar_addr => axi4_dat_ar_addr,
    axi4_dat_ar_len => axi4_dat_ar_len,
    axi4_dat_ar_size => axi4_dat_ar_size,
    axi4_dat_ar_burst => axi4_dat_ar_burst,
    axi4_dat_ar_lock => axi4_dat_ar_lock,
    axi4_dat_ar_cache => axi4_dat_ar_cache,
    axi4_dat_ar_prot => axi4_dat_ar_prot,
    axi4_dat_ar_qos => axi4_dat_ar_qos,
    axi4_dat_ar_region => axi4_dat_ar_region,
    axi4_dat_ar_user => axi4_dat_ar_user,
    axi4_dat_ar_valid => axi4_dat_ar_valid,
    axi4_dat_ar_ready => axi4_dat_ar_ready,
    axi4_dat_w_data => axi4_dat_w_data,
    axi4_dat_w_strb => axi4_dat_w_strb,
    axi4_dat_w_last => axi4_dat_w_last,
    axi4_dat_w_user => axi4_dat_w_user,
    axi4_dat_w_valid => axi4_dat_w_valid,
    axi4_dat_w_ready => axi4_dat_w_ready,
    axi4_dat_r_id => axi4_dat_r_id,
    axi4_dat_r_data => axi4_dat_r_data,
    axi4_dat_r_resp => axi4_dat_r_resp,
    axi4_dat_r_last => axi4_dat_r_last,
    axi4_dat_r_user => axi4_dat_r_user,
    axi4_dat_r_valid => axi4_dat_r_valid,
    axi4_dat_r_ready => axi4_dat_r_ready,
    axi4_dat_b_id => axi4_dat_b_id,
    axi4_dat_b_resp => axi4_dat_b_resp,
    axi4_dat_b_user => axi4_dat_b_user,
    axi4_dat_b_valid => axi4_dat_b_valid,
    axi4_dat_b_ready => axi4_dat_b_ready,
    --Interrupts
    ext_nmi => ext_nmi,
    ext_tint => ext_tint,
    ext_sint => ext_sint,
    ext_int => ext_int,

    --Debug Interface
    dbg_stall => dbg_stall,
    dbg_strb => dbg_strb,
    dbg_we => dbg_we,
    dbg_addr => dbg_addr,
    dbg_dati => dbg_dati,
    dbg_dato => db_dato,
    dbg_ack => dbg_ack,
    dbg_bp => dbg_bp
  );


  --Instruction AXI4
  instruction_axi4 : mpsoc_axi4_spram
  generic map (
    AXI_ID_WIDTH, 
    AXI_ADDR_WIDTH, 
    AXI_DATA_WIDTH, 
    AXI_STRB_WIDTH, 
    AXI_USER_WIDTH
  )
  port map (
    clk_i => HCLK,  -- Clock
    rst_ni => HRESETn,  -- Asynchronous reset active low

    axi_aw_id => axi4_ins_aw_id,
    axi_aw_addr => axi4_ins_aw_addr,
    axi_aw_len => axi4_ins_aw_len,
    axi_aw_size => axi4_ins_aw_size,
    axi_aw_burst => axi4_ins_aw_burst,
    axi_aw_lock => axi4_ins_aw_lock,
    axi_aw_cache => axi4_ins_aw_cache,
    axi_aw_prot => axi4_ins_aw_prot,
    axi_aw_qos => axi4_ins_aw_qos,
    axi_aw_region => axi4_ins_aw_region,
    axi_aw_user => axi4_ins_aw_user,
    axi_aw_valid => axi4_ins_aw_valid,
    axi_aw_ready => axi4_ins_aw_ready,

    axi_ar_id => axi4_ins_ar_id,
    axi_ar_addr => axi4_ins_ar_addr,
    axi_ar_len => axi4_ins_ar_len,
    axi_ar_size => axi4_ins_ar_size,
    axi_ar_burst => axi4_ins_ar_burst,
    axi_ar_lock => axi4_ins_ar_lock,
    axi_ar_cache => axi4_ins_ar_cache,
    axi_ar_prot => axi4_ins_ar_prot,
    axi_ar_qos => axi4_ins_ar_qos,
    axi_ar_region => axi4_ins_ar_region,
    axi_ar_user => axi4_ins_ar_user,
    axi_ar_valid => axi4_ins_ar_valid,
    axi_ar_ready => axi4_ins_ar_ready,

    axi_w_data => axi4_ins_w_data,
    axi_w_strb => axi4_ins_w_strb,
    axi_w_last => axi4_ins_w_last,
    axi_w_user => axi4_ins_w_user,
    axi_w_valid => axi4_ins_w_valid,
    axi_w_ready => axi4_ins_w_ready,

    axi_r_id => axi4_ins_r_id,
    axi_r_data => axi4_ins_r_data,
    axi_r_resp => axi4_ins_r_resp,
    axi_r_last => axi4_ins_r_last,
    axi_r_user => axi4_ins_r_user,
    axi_r_valid => axi4_ins_r_valid,
    axi_r_ready => axi4_ins_r_ready,

    axi_b_id => axi4_ins_b_id,
    axi_b_resp => axi4_ins_b_resp,
    axi_b_user => axi4_ins_b_user,
    axi_b_valid => axi4_ins_b_valid,
    axi_b_ready => axi4_ins_b_ready,

    req_o => open,
    we_o => open,
    addr_o => open,
    be_o => open,
    data_o => open,
    data_i => 0
  );


  --Data AXI4
  data_axi4 : mpsoc_axi4_spram
  generic map (
    AXI_ID_WIDTH, 
    AXI_ADDR_WIDTH, 
    AXI_DATA_WIDTH, 
    AXI_STRB_WIDTH, 
    AXI_USER_WIDTH
  )
  port map (
    clk_i => HCLK,  -- Clock
    rst_ni => HRESETn,  -- Asynchronous reset active low

    axi_aw_id => axi4_dat_aw_id,
    axi_aw_addr => axi4_dat_aw_addr,
    axi_aw_len => axi4_dat_aw_len,
    axi_aw_size => axi4_dat_aw_size,
    axi_aw_burst => axi4_dat_aw_burst,
    axi_aw_lock => axi4_dat_aw_lock,
    axi_aw_cache => axi4_dat_aw_cache,
    axi_aw_prot => axi4_dat_aw_prot,
    axi_aw_qos => axi4_dat_aw_qos,
    axi_aw_region => axi4_dat_aw_region,
    axi_aw_user => axi4_dat_aw_user,
    axi_aw_valid => axi4_dat_aw_valid,
    axi_aw_ready => axi4_dat_aw_ready,

    axi_ar_id => axi4_dat_ar_id,
    axi_ar_addr => axi4_dat_ar_addr,
    axi_ar_len => axi4_dat_ar_len,
    axi_ar_size => axi4_dat_ar_size,
    axi_ar_burst => axi4_dat_ar_burst,
    axi_ar_lock => axi4_dat_ar_lock,
    axi_ar_cache => axi4_dat_ar_cache,
    axi_ar_prot => axi4_dat_ar_prot,
    axi_ar_qos => axi4_dat_ar_qos,
    axi_ar_region => axi4_dat_ar_region,
    axi_ar_user => axi4_dat_ar_user,
    axi_ar_valid => axi4_dat_ar_valid,
    axi_ar_ready => axi4_dat_ar_ready,

    axi_w_data => axi4_dat_w_data,
    axi_w_strb => axi4_dat_w_strb,
    axi_w_last => axi4_dat_w_last,
    axi_w_user => axi4_dat_w_user,
    axi_w_valid => axi4_dat_w_valid,
    axi_w_ready => axi4_dat_w_ready,

    axi_r_id => axi4_dat_r_id,
    axi_r_data => axi4_dat_r_data,
    axi_r_resp => axi4_dat_r_resp,
    axi_r_last => axi4_dat_r_last,
    axi_r_user => axi4_dat_r_user,
    axi_r_valid => axi4_dat_r_valid,
    axi_r_ready => axi4_dat_r_ready,

    axi_b_id => axi4_dat_b_id,
    axi_b_resp => axi4_dat_b_resp,
    axi_b_user => axi4_dat_b_user,
    axi_b_valid => axi4_dat_b_valid,
    axi_b_ready => axi4_dat_b_ready,

    req_o => open,
    we_o => open,
    addr_o => open,
    be_o => open,
    data_o => open,
    data_i => 0
  );
end RTL;
