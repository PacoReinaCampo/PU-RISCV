-- Converted from pu_riscv_synthesis.sv
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
--              PU-RISCV                                                      --
--              Synthesis                                                     --
--              AMBA4 AXI-Lite Bus Interface                                  --
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

use work.riscv_defines.all;

entity pu_riscv_synthesis is
  generic (
    AXI_ID_WIDTH   : integer := 10;
    AXI_ADDR_WIDTH : integer := 64;
    AXI_DATA_WIDTH : integer := 64;
    AXI_STRB_WIDTH : integer := 10;
    AXI_USER_WIDTH : integer := 10;

    AHB_ADDR_WIDTH : integer := 64;
    AHB_DATA_WIDTH : integer := 64;

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

    BREAKPOINTS : integer := 8;  --Number of hardware breakpoints

    PMA_CNT : integer := 4;
    PMP_CNT : integer := 16;  --Number of Physical Memory Protection entries

    BP_GLOBAL_BITS    : integer := 2;
    BP_LOCAL_BITS     : integer := 10;
    BP_LOCAL_BITS_LSB : integer := 2;

    ICACHE_SIZE        : integer := 64;  --in KBytes
    ICACHE_BLOCK_SIZE  : integer := 64;  --in Bytes
    ICACHE_WAYS        : integer := 2;   --'n'-way set associative
    ICACHE_REPLACE_ALG : integer := 0;
    ITCM_SIZE          : integer := 0;

    DCACHE_SIZE        : integer := 64;  --in KBytes
    DCACHE_BLOCK_SIZE  : integer := 64;  --in Bytes
    DCACHE_WAYS        : integer := 2;   --'n'-way set associative
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

    JEDEC_BANK : integer := 10;

    JEDEC_MANUFACTURER_ID : std_logic_vector(7 downto 0) := X"6E";

    HARTID : integer := 0;

    PARCEL_SIZE : integer := 64
    );
  port (
    HRESETn : in std_logic;
    HCLK    : in std_logic;

    --Interrupts
    ext_nmi  : in std_logic;
    ext_tint : in std_logic;
    ext_sint : in std_logic;
    ext_int  : in std_logic_vector(3 downto 0);

    --Debug Interface
    dbg_stall : in  std_logic;
    dbg_strb  : in  std_logic;
    dbg_we    : in  std_logic;
    dbg_addr  : in  std_logic_vector(31 downto 0);
    dbg_dati  : in  std_logic_vector(31 downto 0);
    dbg_dato  : out std_logic_vector(31 downto 0);
    dbg_ack   : out std_logic;
    dbg_bp    : out std_logic
    );
end pu_riscv_synthesis;

architecture rtl of pu_riscv_synthesis is
  component riscv_pu_axi4
    generic (
      AXI_ID_WIDTH   : integer := 10;
      AXI_ADDR_WIDTH : integer := 64;
      AXI_DATA_WIDTH : integer := 64;
      AXI_STRB_WIDTH : integer := 10;
      AXI_USER_WIDTH : integer := 10;

      AHB_ADDR_WIDTH : integer := 64;
      AHB_DATA_WIDTH : integer := 64;

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

      BREAKPOINTS : integer := 8;       --Number of hardware breakpoints

      PMA_CNT : integer := 4;
      PMP_CNT : integer := 16;  --Number of Physical Memory Protection entries

      BP_GLOBAL_BITS    : integer := 2;
      BP_LOCAL_BITS     : integer := 10;
      BP_LOCAL_BITS_LSB : integer := 2;

      ICACHE_SIZE        : integer := 64;  --in KBytes
      ICACHE_BLOCK_SIZE  : integer := 64;  --in Bytes
      ICACHE_WAYS        : integer := 2;   --'n'-way set associative
      ICACHE_REPLACE_ALG : integer := 0;
      ITCM_SIZE          : integer := 0;

      DCACHE_SIZE        : integer := 64;  --in KBytes
      DCACHE_BLOCK_SIZE  : integer := 64;  --in Bytes
      DCACHE_WAYS        : integer := 2;   --'n'-way set associative
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
      HRESETn : in std_logic;
      HCLK    : in std_logic;

      pma_cfg_i : in std_logic_matrix(PMA_CNT-1 downto 0)(13 downto 0);
      pma_adr_i : in std_logic_matrix(PMA_CNT-1 downto 0)(XLEN-1 downto 0);

      --AXI4 instruction
      axi4_ins_aw_id     : out std_logic_vector(AXI_ID_WIDTH-1 downto 0);
      axi4_ins_aw_addr   : out std_logic_vector(AXI_ADDR_WIDTH-1 downto 0);
      axi4_ins_aw_len    : out std_logic_vector(7 downto 0);
      axi4_ins_aw_size   : out std_logic_vector(2 downto 0);
      axi4_ins_aw_burst  : out std_logic_vector(1 downto 0);
      axi4_ins_aw_lock   : out std_logic;
      axi4_ins_aw_cache  : out std_logic_vector(3 downto 0);
      axi4_ins_aw_prot   : out std_logic_vector(2 downto 0);
      axi4_ins_aw_qos    : out std_logic_vector(3 downto 0);
      axi4_ins_aw_region : out std_logic_vector(3 downto 0);
      axi4_ins_aw_user   : out std_logic_vector(AXI_USER_WIDTH-1 downto 0);
      axi4_ins_aw_valid  : out std_logic;
      axi4_ins_aw_ready  : in  std_logic;

      axi4_ins_ar_id     : out std_logic_vector(AXI_ID_WIDTH-1 downto 0);
      axi4_ins_ar_addr   : out std_logic_vector(AXI_ADDR_WIDTH-1 downto 0);
      axi4_ins_ar_len    : out std_logic_vector(7 downto 0);
      axi4_ins_ar_size   : out std_logic_vector(2 downto 0);
      axi4_ins_ar_burst  : out std_logic_vector(1 downto 0);
      axi4_ins_ar_lock   : out std_logic;
      axi4_ins_ar_cache  : out std_logic_vector(3 downto 0);
      axi4_ins_ar_prot   : out std_logic_vector(2 downto 0);
      axi4_ins_ar_qos    : out std_logic_vector(3 downto 0);
      axi4_ins_ar_region : out std_logic_vector(3 downto 0);
      axi4_ins_ar_user   : out std_logic_vector(AXI_USER_WIDTH-1 downto 0);
      axi4_ins_ar_valid  : out std_logic;
      axi4_ins_ar_ready  : in  std_logic;

      axi4_ins_w_data  : out std_logic_vector(AXI_DATA_WIDTH-1 downto 0);
      axi4_ins_w_strb  : out std_logic_vector(AXI_STRB_WIDTH-1 downto 0);
      axi4_ins_w_last  : out std_logic;
      axi4_ins_w_user  : out std_logic_vector(AXI_USER_WIDTH-1 downto 0);
      axi4_ins_w_valid : out std_logic;
      axi4_ins_w_ready : in  std_logic;

      axi4_ins_r_id    : in  std_logic_vector(AXI_ID_WIDTH-1 downto 0);
      axi4_ins_r_data  : in  std_logic_vector(AXI_DATA_WIDTH-1 downto 0);
      axi4_ins_r_resp  : in  std_logic_vector(1 downto 0);
      axi4_ins_r_last  : in  std_logic;
      axi4_ins_r_user  : in  std_logic_vector(AXI_USER_WIDTH-1 downto 0);
      axi4_ins_r_valid : in  std_logic;
      axi4_ins_r_ready : out std_logic;

      axi4_ins_b_id    : in  std_logic_vector(AXI_ID_WIDTH-1 downto 0);
      axi4_ins_b_resp  : in  std_logic_vector(1 downto 0);
      axi4_ins_b_user  : in  std_logic_vector(AXI_USER_WIDTH-1 downto 0);
      axi4_ins_b_valid : in  std_logic;
      axi4_ins_b_ready : out std_logic;

      --AXI4 data
      axi4_dat_aw_id     : out std_logic_vector(AXI_ID_WIDTH-1 downto 0);
      axi4_dat_aw_addr   : out std_logic_vector(AXI_ADDR_WIDTH-1 downto 0);
      axi4_dat_aw_len    : out std_logic_vector(7 downto 0);
      axi4_dat_aw_size   : out std_logic_vector(2 downto 0);
      axi4_dat_aw_burst  : out std_logic_vector(1 downto 0);
      axi4_dat_aw_lock   : out std_logic;
      axi4_dat_aw_cache  : out std_logic_vector(3 downto 0);
      axi4_dat_aw_prot   : out std_logic_vector(2 downto 0);
      axi4_dat_aw_qos    : out std_logic_vector(3 downto 0);
      axi4_dat_aw_region : out std_logic_vector(3 downto 0);
      axi4_dat_aw_user   : out std_logic_vector(AXI_USER_WIDTH-1 downto 0);
      axi4_dat_aw_valid  : out std_logic;
      axi4_dat_aw_ready  : in  std_logic;

      axi4_dat_ar_id     : out std_logic_vector(AXI_ID_WIDTH-1 downto 0);
      axi4_dat_ar_addr   : out std_logic_vector(AXI_ADDR_WIDTH-1 downto 0);
      axi4_dat_ar_len    : out std_logic_vector(7 downto 0);
      axi4_dat_ar_size   : out std_logic_vector(2 downto 0);
      axi4_dat_ar_burst  : out std_logic_vector(1 downto 0);
      axi4_dat_ar_lock   : out std_logic;
      axi4_dat_ar_cache  : out std_logic_vector(3 downto 0);
      axi4_dat_ar_prot   : out std_logic_vector(2 downto 0);
      axi4_dat_ar_qos    : out std_logic_vector(3 downto 0);
      axi4_dat_ar_region : out std_logic_vector(3 downto 0);
      axi4_dat_ar_user   : out std_logic_vector(AXI_USER_WIDTH-1 downto 0);
      axi4_dat_ar_valid  : out std_logic;
      axi4_dat_ar_ready  : in  std_logic;

      axi4_dat_w_data  : out std_logic_vector(AXI_DATA_WIDTH-1 downto 0);
      axi4_dat_w_strb  : out std_logic_vector(AXI_STRB_WIDTH-1 downto 0);
      axi4_dat_w_last  : out std_logic;
      axi4_dat_w_user  : out std_logic_vector(AXI_USER_WIDTH-1 downto 0);
      axi4_dat_w_valid : out std_logic;
      axi4_dat_w_ready : in  std_logic;

      axi4_dat_r_id    : in  std_logic_vector(AXI_ID_WIDTH-1 downto 0);
      axi4_dat_r_data  : in  std_logic_vector(AXI_DATA_WIDTH-1 downto 0);
      axi4_dat_r_resp  : in  std_logic_vector(1 downto 0);
      axi4_dat_r_last  : in  std_logic;
      axi4_dat_r_user  : in  std_logic_vector(AXI_USER_WIDTH-1 downto 0);
      axi4_dat_r_valid : in  std_logic;
      axi4_dat_r_ready : out std_logic;

      axi4_dat_b_id    : in  std_logic_vector(AXI_ID_WIDTH-1 downto 0);
      axi4_dat_b_resp  : in  std_logic_vector(1 downto 0);
      axi4_dat_b_user  : in  std_logic_vector(AXI_USER_WIDTH-1 downto 0);
      axi4_dat_b_valid : in  std_logic;
      axi4_dat_b_ready : out std_logic;

      --Interrupts
      ext_nmi, ext_tint, ext_sint : in std_logic;
      ext_int                     : in std_logic_vector(3 downto 0);

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
  end component;

  component mpsoc_axi4_spram
    generic (
      AXI_ID_WIDTH   : integer := 10;
      AXI_ADDR_WIDTH : integer := 64;
      AXI_DATA_WIDTH : integer := 64;
      AXI_STRB_WIDTH : integer := 8;
      AXI_USER_WIDTH : integer := 10
      );
    port (
      clk_i  : in std_logic;            -- Clock
      rst_ni : in std_logic;            -- Asynchronous reset active low

      axi_aw_id     : in  std_logic_vector(AXI_ID_WIDTH-1 downto 0);
      axi_aw_addr   : in  std_logic_vector(AXI_ADDR_WIDTH-1 downto 0);
      axi_aw_len    : in  std_logic_vector(7 downto 0);
      axi_aw_size   : in  std_logic_vector(2 downto 0);
      axi_aw_burst  : in  std_logic_vector(1 downto 0);
      axi_aw_lock   : in  std_logic;
      axi_aw_cache  : in  std_logic_vector(3 downto 0);
      axi_aw_prot   : in  std_logic_vector(2 downto 0);
      axi_aw_qos    : in  std_logic_vector(3 downto 0);
      axi_aw_region : in  std_logic_vector(3 downto 0);
      axi_aw_user   : in  std_logic_vector(AXI_USER_WIDTH-1 downto 0);
      axi_aw_valid  : in  std_logic;
      axi_aw_ready  : out std_logic;

      axi_ar_id     : in  std_logic_vector(AXI_ID_WIDTH-1 downto 0);
      axi_ar_addr   : in  std_logic_vector(AXI_ADDR_WIDTH-1 downto 0);
      axi_ar_len    : in  std_logic_vector(7 downto 0);
      axi_ar_size   : in  std_logic_vector(2 downto 0);
      axi_ar_burst  : in  std_logic_vector(1 downto 0);
      axi_ar_lock   : in  std_logic;
      axi_ar_cache  : in  std_logic_vector(3 downto 0);
      axi_ar_prot   : in  std_logic_vector(2 downto 0);
      axi_ar_qos    : in  std_logic_vector(3 downto 0);
      axi_ar_region : in  std_logic_vector(3 downto 0);
      axi_ar_user   : in  std_logic_vector(AXI_USER_WIDTH-1 downto 0);
      axi_ar_valid  : in  std_logic;
      axi_ar_ready  : out std_logic;

      axi_w_data  : in  std_logic_vector(AXI_DATA_WIDTH-1 downto 0);
      axi_w_strb  : in  std_logic_vector(AXI_STRB_WIDTH-1 downto 0);
      axi_w_last  : in  std_logic;
      axi_w_user  : in  std_logic_vector(AXI_USER_WIDTH-1 downto 0);
      axi_w_valid : in  std_logic;
      axi_w_ready : out std_logic;

      axi_r_id    : out std_logic_vector(AXI_ID_WIDTH-1 downto 0);
      axi_r_data  : out std_logic_vector(AXI_DATA_WIDTH-1 downto 0);
      axi_r_resp  : out std_logic_vector(1 downto 0);
      axi_r_last  : out std_logic;
      axi_r_user  : out std_logic_vector(AXI_USER_WIDTH-1 downto 0);
      axi_r_valid : out std_logic;
      axi_r_ready : in  std_logic;

      axi_b_id    : out std_logic_vector(AXI_ID_WIDTH-1 downto 0);
      axi_b_resp  : out std_logic_vector(1 downto 0);
      axi_b_user  : out std_logic_vector(AXI_USER_WIDTH-1 downto 0);
      axi_b_valid : out std_logic;
      axi_b_ready : in  std_logic;

      req_o  : out std_logic;
      we_o   : out std_logic;
      addr_o : out std_logic_vector(AXI_ADDR_WIDTH-1 downto 0);
      be_o   : out std_logic_vector(AXI_DATA_WIDTH/8-1 downto 0);
      data_o : out std_logic_vector(AXI_DATA_WIDTH-1 downto 0);
      data_i : in  std_logic_vector(AXI_DATA_WIDTH-1 downto 0)
      );
  end component;

  ------------------------------------------------------------------------------
  -- Module Body
  ------------------------------------------------------------------------------

  --PMA configuration
  signal pma_cfg : std_logic_matrix(PMA_CNT-1 downto 0)(13 downto 0);
  signal pma_adr : std_logic_matrix(PMA_CNT-1 downto 0)(PLEN-1 downto 0);

  -- AXI4 Instruction
  signal axi4_ins_aw_id     : std_logic_vector(AXI_ID_WIDTH-1 downto 0);
  signal axi4_ins_aw_addr   : std_logic_vector(AXI_ADDR_WIDTH-1 downto 0);
  signal axi4_ins_aw_len    : std_logic_vector(7 downto 0);
  signal axi4_ins_aw_size   : std_logic_vector(2 downto 0);
  signal axi4_ins_aw_burst  : std_logic_vector(1 downto 0);
  signal axi4_ins_aw_lock   : std_logic;
  signal axi4_ins_aw_cache  : std_logic_vector(3 downto 0);
  signal axi4_ins_aw_prot   : std_logic_vector(2 downto 0);
  signal axi4_ins_aw_qos    : std_logic_vector(3 downto 0);
  signal axi4_ins_aw_region : std_logic_vector(3 downto 0);
  signal axi4_ins_aw_user   : std_logic_vector(AXI_USER_WIDTH-1 downto 0);
  signal axi4_ins_aw_valid  : std_logic;
  signal axi4_ins_aw_ready  : std_logic;

  signal axi4_ins_ar_id     : std_logic_vector(AXI_ID_WIDTH-1 downto 0);
  signal axi4_ins_ar_addr   : std_logic_vector(AXI_ADDR_WIDTH-1 downto 0);
  signal axi4_ins_ar_len    : std_logic_vector(7 downto 0);
  signal axi4_ins_ar_size   : std_logic_vector(2 downto 0);
  signal axi4_ins_ar_burst  : std_logic_vector(1 downto 0);
  signal axi4_ins_ar_lock   : std_logic;
  signal axi4_ins_ar_cache  : std_logic_vector(3 downto 0);
  signal axi4_ins_ar_prot   : std_logic_vector(2 downto 0);
  signal axi4_ins_ar_qos    : std_logic_vector(3 downto 0);
  signal axi4_ins_ar_region : std_logic_vector(3 downto 0);
  signal axi4_ins_ar_user   : std_logic_vector(AXI_USER_WIDTH-1 downto 0);
  signal axi4_ins_ar_valid  : std_logic;
  signal axi4_ins_ar_ready  : std_logic;

  signal axi4_ins_w_data  : std_logic_vector(AXI_DATA_WIDTH-1 downto 0);
  signal axi4_ins_w_strb  : std_logic_vector(AXI_STRB_WIDTH-1 downto 0);
  signal axi4_ins_w_last  : std_logic;
  signal axi4_ins_w_user  : std_logic_vector(AXI_USER_WIDTH-1 downto 0);
  signal axi4_ins_w_valid : std_logic;
  signal axi4_ins_w_ready : std_logic;

  signal axi4_ins_r_id    : std_logic_vector(AXI_ID_WIDTH-1 downto 0);
  signal axi4_ins_r_data  : std_logic_vector(AXI_DATA_WIDTH-1 downto 0);
  signal axi4_ins_r_resp  : std_logic_vector(1 downto 0);
  signal axi4_ins_r_last  : std_logic;
  signal axi4_ins_r_user  : std_logic_vector(AXI_USER_WIDTH-1 downto 0);
  signal axi4_ins_r_valid : std_logic;
  signal axi4_ins_r_ready : std_logic;

  signal axi4_ins_b_id    : std_logic_vector(AXI_ID_WIDTH-1 downto 0);
  signal axi4_ins_b_resp  : std_logic_vector(1 downto 0);
  signal axi4_ins_b_user  : std_logic_vector(AXI_USER_WIDTH-1 downto 0);
  signal axi4_ins_b_valid : std_logic;
  signal axi4_ins_b_ready : std_logic;

  --AXI4 Data
  signal axi4_dat_aw_id     : std_logic_vector(AXI_ID_WIDTH-1 downto 0);
  signal axi4_dat_aw_addr   : std_logic_vector(AXI_ADDR_WIDTH-1 downto 0);
  signal axi4_dat_aw_len    : std_logic_vector(7 downto 0);
  signal axi4_dat_aw_size   : std_logic_vector(2 downto 0);
  signal axi4_dat_aw_burst  : std_logic_vector(1 downto 0);
  signal axi4_dat_aw_lock   : std_logic;
  signal axi4_dat_aw_cache  : std_logic_vector(3 downto 0);
  signal axi4_dat_aw_prot   : std_logic_vector(2 downto 0);
  signal axi4_dat_aw_qos    : std_logic_vector(3 downto 0);
  signal axi4_dat_aw_region : std_logic_vector(3 downto 0);
  signal axi4_dat_aw_user   : std_logic_vector(AXI_USER_WIDTH-1 downto 0);
  signal axi4_dat_aw_valid  : std_logic;
  signal axi4_dat_aw_ready  : std_logic;

  signal axi4_dat_ar_id     : std_logic_vector(AXI_ID_WIDTH-1 downto 0);
  signal axi4_dat_ar_addr   : std_logic_vector(AXI_ADDR_WIDTH-1 downto 0);
  signal axi4_dat_ar_len    : std_logic_vector(7 downto 0);
  signal axi4_dat_ar_size   : std_logic_vector(2 downto 0);
  signal axi4_dat_ar_burst  : std_logic_vector(1 downto 0);
  signal axi4_dat_ar_lock   : std_logic;
  signal axi4_dat_ar_cache  : std_logic_vector(3 downto 0);
  signal axi4_dat_ar_prot   : std_logic_vector(2 downto 0);
  signal axi4_dat_ar_qos    : std_logic_vector(3 downto 0);
  signal axi4_dat_ar_region : std_logic_vector(3 downto 0);
  signal axi4_dat_ar_user   : std_logic_vector(AXI_USER_WIDTH-1 downto 0);
  signal axi4_dat_ar_valid  : std_logic;
  signal axi4_dat_ar_ready  : std_logic;

  signal axi4_dat_w_data  : std_logic_vector(AXI_DATA_WIDTH-1 downto 0);
  signal axi4_dat_w_strb  : std_logic_vector(AXI_STRB_WIDTH-1 downto 0);
  signal axi4_dat_w_last  : std_logic;
  signal axi4_dat_w_user  : std_logic_vector(AXI_USER_WIDTH-1 downto 0);
  signal axi4_dat_w_valid : std_logic;
  signal axi4_dat_w_ready : std_logic;

  signal axi4_dat_r_id    : std_logic_vector(AXI_ID_WIDTH-1 downto 0);
  signal axi4_dat_r_data  : std_logic_vector(AXI_DATA_WIDTH-1 downto 0);
  signal axi4_dat_r_resp  : std_logic_vector(1 downto 0);
  signal axi4_dat_r_last  : std_logic;
  signal axi4_dat_r_user  : std_logic_vector(AXI_USER_WIDTH-1 downto 0);
  signal axi4_dat_r_valid : std_logic;
  signal axi4_dat_r_ready : std_logic;

  signal axi4_dat_b_id    : std_logic_vector(AXI_ID_WIDTH-1 downto 0);
  signal axi4_dat_b_resp  : std_logic_vector(1 downto 0);
  signal axi4_dat_b_user  : std_logic_vector(AXI_USER_WIDTH-1 downto 0);
  signal axi4_dat_b_valid : std_logic;
  signal axi4_dat_b_ready : std_logic;

  --Debug Interface
  signal dbg_dato_s : std_logic_vector(XLEN-1 downto 0);

begin

  --/////////////////////////////////////////////////////////////
  --
  -- Module Body
  ------------------------------------------------------------------------------

  --Define PMA regions
  pma_adr <= (others => (others => '0'));
  pma_cfg <= (others => (others => '0'));

  --Debug Interface
  dbg_dato_s <= X"00000000" & dbg_dato;

  -- Processing Unit
  dut : riscv_pu_axi4
    generic map (
      XLEN => XLEN,
      PLEN => PLEN,

      HAS_USER  => HAS_USER,
      HAS_SUPER => HAS_SUPER,
      HAS_HYPER => HAS_HYPER,
      HAS_BPU   => HAS_BPU,
      HAS_FPU   => HAS_FPU,
      HAS_MMU   => HAS_MMU,
      HAS_RVM   => HAS_RVM,
      HAS_RVA   => HAS_RVA,
      HAS_RVC   => HAS_RVC,
      IS_RV32E  => IS_RV32E,

      MULT_LATENCY => MULT_LATENCY,

      BREAKPOINTS => BREAKPOINTS,

      PMA_CNT => PMA_CNT,
      PMP_CNT => PMP_CNT,

      BP_GLOBAL_BITS    => BP_GLOBAL_BITS,
      BP_LOCAL_BITS     => BP_LOCAL_BITS,
      BP_LOCAL_BITS_LSB => BP_LOCAL_BITS_LSB,

      ICACHE_SIZE        => ICACHE_SIZE,
      ICACHE_BLOCK_SIZE  => ICACHE_BLOCK_SIZE,
      ICACHE_WAYS        => 1,
      ICACHE_REPLACE_ALG => ICACHE_REPLACE_ALG,
      ITCM_SIZE          => ITCM_SIZE,

      DCACHE_SIZE        => DCACHE_SIZE,
      DCACHE_BLOCK_SIZE  => DCACHE_BLOCK_SIZE,
      DCACHE_WAYS        => DCACHE_WAYS,
      DCACHE_REPLACE_ALG => DCACHE_REPLACE_ALG,
      DTCM_SIZE          => 0,
      WRITEBUFFER_SIZE   => WRITEBUFFER_SIZE,

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
      HRESETn => HRESETn,
      HCLK    => HCLK,

      pma_cfg_i => pma_cfg,
      pma_adr_i => pma_adr,

      --AXI4 instruction
      axi4_ins_aw_id     => axi4_ins_aw_id,
      axi4_ins_aw_addr   => axi4_ins_aw_addr,
      axi4_ins_aw_len    => axi4_ins_aw_len,
      axi4_ins_aw_size   => axi4_ins_aw_size,
      axi4_ins_aw_burst  => axi4_ins_aw_burst,
      axi4_ins_aw_lock   => axi4_ins_aw_lock,
      axi4_ins_aw_cache  => axi4_ins_aw_cache,
      axi4_ins_aw_prot   => axi4_ins_aw_prot,
      axi4_ins_aw_qos    => axi4_ins_aw_qos,
      axi4_ins_aw_region => axi4_ins_aw_region,
      axi4_ins_aw_user   => axi4_ins_aw_user,
      axi4_ins_aw_valid  => axi4_ins_aw_valid,
      axi4_ins_aw_ready  => axi4_ins_aw_ready,
      axi4_ins_ar_id     => axi4_ins_ar_id,
      axi4_ins_ar_addr   => axi4_ins_ar_addr,
      axi4_ins_ar_len    => axi4_ins_ar_len,
      axi4_ins_ar_size   => axi4_ins_ar_size,
      axi4_ins_ar_burst  => axi4_ins_ar_burst,
      axi4_ins_ar_lock   => axi4_ins_ar_lock,
      axi4_ins_ar_cache  => axi4_ins_ar_cache,
      axi4_ins_ar_prot   => axi4_ins_ar_prot,
      axi4_ins_ar_qos    => axi4_ins_ar_qos,
      axi4_ins_ar_region => axi4_ins_ar_region,
      axi4_ins_ar_user   => axi4_ins_ar_user,
      axi4_ins_ar_valid  => axi4_ins_ar_valid,
      axi4_ins_ar_ready  => axi4_ins_ar_ready,
      axi4_ins_w_data    => axi4_ins_w_data,
      axi4_ins_w_strb    => axi4_ins_w_strb,
      axi4_ins_w_last    => axi4_ins_w_last,
      axi4_ins_w_user    => axi4_ins_w_user,
      axi4_ins_w_valid   => axi4_ins_w_valid,
      axi4_ins_w_ready   => axi4_ins_w_ready,
      axi4_ins_r_id      => axi4_ins_r_id,
      axi4_ins_r_data    => axi4_ins_r_data,
      axi4_ins_r_resp    => axi4_ins_r_resp,
      axi4_ins_r_last    => axi4_ins_r_last,
      axi4_ins_r_user    => axi4_ins_r_user,
      axi4_ins_r_valid   => axi4_ins_r_valid,
      axi4_ins_r_ready   => axi4_ins_r_ready,
      axi4_ins_b_id      => axi4_ins_b_id,
      axi4_ins_b_resp    => axi4_ins_b_resp,
      axi4_ins_b_user    => axi4_ins_b_user,
      axi4_ins_b_valid   => axi4_ins_b_valid,
      axi4_ins_b_ready   => axi4_ins_b_ready,

      --AXI4 data
      axi4_dat_aw_id     => axi4_dat_aw_id,
      axi4_dat_aw_addr   => axi4_dat_aw_addr,
      axi4_dat_aw_len    => axi4_dat_aw_len,
      axi4_dat_aw_size   => axi4_dat_aw_size,
      axi4_dat_aw_burst  => axi4_dat_aw_burst,
      axi4_dat_aw_lock   => axi4_dat_aw_lock,
      axi4_dat_aw_cache  => axi4_dat_aw_cache,
      axi4_dat_aw_prot   => axi4_dat_aw_prot,
      axi4_dat_aw_qos    => axi4_dat_aw_qos,
      axi4_dat_aw_region => axi4_dat_aw_region,
      axi4_dat_aw_user   => axi4_dat_aw_user,
      axi4_dat_aw_valid  => axi4_dat_aw_valid,
      axi4_dat_aw_ready  => axi4_dat_aw_ready,
      axi4_dat_ar_id     => axi4_dat_ar_id,
      axi4_dat_ar_addr   => axi4_dat_ar_addr,
      axi4_dat_ar_len    => axi4_dat_ar_len,
      axi4_dat_ar_size   => axi4_dat_ar_size,
      axi4_dat_ar_burst  => axi4_dat_ar_burst,
      axi4_dat_ar_lock   => axi4_dat_ar_lock,
      axi4_dat_ar_cache  => axi4_dat_ar_cache,
      axi4_dat_ar_prot   => axi4_dat_ar_prot,
      axi4_dat_ar_qos    => axi4_dat_ar_qos,
      axi4_dat_ar_region => axi4_dat_ar_region,
      axi4_dat_ar_user   => axi4_dat_ar_user,
      axi4_dat_ar_valid  => axi4_dat_ar_valid,
      axi4_dat_ar_ready  => axi4_dat_ar_ready,
      axi4_dat_w_data    => axi4_dat_w_data,
      axi4_dat_w_strb    => axi4_dat_w_strb,
      axi4_dat_w_last    => axi4_dat_w_last,
      axi4_dat_w_user    => axi4_dat_w_user,
      axi4_dat_w_valid   => axi4_dat_w_valid,
      axi4_dat_w_ready   => axi4_dat_w_ready,
      axi4_dat_r_id      => axi4_dat_r_id,
      axi4_dat_r_data    => axi4_dat_r_data,
      axi4_dat_r_resp    => axi4_dat_r_resp,
      axi4_dat_r_last    => axi4_dat_r_last,
      axi4_dat_r_user    => axi4_dat_r_user,
      axi4_dat_r_valid   => axi4_dat_r_valid,
      axi4_dat_r_ready   => axi4_dat_r_ready,
      axi4_dat_b_id      => axi4_dat_b_id,
      axi4_dat_b_resp    => axi4_dat_b_resp,
      axi4_dat_b_user    => axi4_dat_b_user,
      axi4_dat_b_valid   => axi4_dat_b_valid,
      axi4_dat_b_ready   => axi4_dat_b_ready,

      --Interrupts
      ext_nmi  => ext_nmi,
      ext_tint => ext_tint,
      ext_sint => ext_sint,
      ext_int  => ext_int,

      --Debug Interface
      dbg_stall => dbg_stall,
      dbg_strb  => dbg_strb,
      dbg_we    => dbg_we,
      dbg_addr  => X"00000000" & dbg_addr,
      dbg_dati  => X"00000000" & dbg_dati,
      dbg_dato  => dbg_dato_s,
      dbg_ack   => dbg_ack,
      dbg_bp    => dbg_bp
      );

  --Instruction AXI4
  instruction_axi4 : mpsoc_axi4_spram
    generic map (
      AXI_ID_WIDTH   => AXI_ID_WIDTH,
      AXI_ADDR_WIDTH => AXI_ADDR_WIDTH,
      AXI_DATA_WIDTH => AXI_DATA_WIDTH,
      AXI_STRB_WIDTH => AXI_STRB_WIDTH,
      AXI_USER_WIDTH => AXI_USER_WIDTH
      )
    port map (
      clk_i  => HCLK,                   -- Clock
      rst_ni => HRESETn,                -- Asynchronous reset active low

      axi_aw_id     => axi4_ins_aw_id,
      axi_aw_addr   => axi4_ins_aw_addr,
      axi_aw_len    => axi4_ins_aw_len,
      axi_aw_size   => axi4_ins_aw_size,
      axi_aw_burst  => axi4_ins_aw_burst,
      axi_aw_lock   => axi4_ins_aw_lock,
      axi_aw_cache  => axi4_ins_aw_cache,
      axi_aw_prot   => axi4_ins_aw_prot,
      axi_aw_qos    => axi4_ins_aw_qos,
      axi_aw_region => axi4_ins_aw_region,
      axi_aw_user   => axi4_ins_aw_user,
      axi_aw_valid  => axi4_ins_aw_valid,
      axi_aw_ready  => axi4_ins_aw_ready,

      axi_ar_id     => axi4_ins_ar_id,
      axi_ar_addr   => axi4_ins_ar_addr,
      axi_ar_len    => axi4_ins_ar_len,
      axi_ar_size   => axi4_ins_ar_size,
      axi_ar_burst  => axi4_ins_ar_burst,
      axi_ar_lock   => axi4_ins_ar_lock,
      axi_ar_cache  => axi4_ins_ar_cache,
      axi_ar_prot   => axi4_ins_ar_prot,
      axi_ar_qos    => axi4_ins_ar_qos,
      axi_ar_region => axi4_ins_ar_region,
      axi_ar_user   => axi4_ins_ar_user,
      axi_ar_valid  => axi4_ins_ar_valid,
      axi_ar_ready  => axi4_ins_ar_ready,

      axi_w_data  => axi4_ins_w_data,
      axi_w_strb  => axi4_ins_w_strb,
      axi_w_last  => axi4_ins_w_last,
      axi_w_user  => axi4_ins_w_user,
      axi_w_valid => axi4_ins_w_valid,
      axi_w_ready => axi4_ins_w_ready,

      axi_r_id    => axi4_ins_r_id,
      axi_r_data  => axi4_ins_r_data,
      axi_r_resp  => axi4_ins_r_resp,
      axi_r_last  => axi4_ins_r_last,
      axi_r_user  => axi4_ins_r_user,
      axi_r_valid => axi4_ins_r_valid,
      axi_r_ready => axi4_ins_r_ready,

      axi_b_id    => axi4_ins_b_id,
      axi_b_resp  => axi4_ins_b_resp,
      axi_b_user  => axi4_ins_b_user,
      axi_b_valid => axi4_ins_b_valid,
      axi_b_ready => axi4_ins_b_ready,

      req_o  => open,
      we_o   => open,
      addr_o => open,
      be_o   => open,
      data_o => open,
      data_i => (others => '0')
      );

  --Data AXI4
  data_axi4 : mpsoc_axi4_spram
    generic map (
      AXI_ID_WIDTH   => AXI_ID_WIDTH,
      AXI_ADDR_WIDTH => AXI_ADDR_WIDTH,
      AXI_DATA_WIDTH => AXI_DATA_WIDTH,
      AXI_STRB_WIDTH => AXI_STRB_WIDTH,
      AXI_USER_WIDTH => AXI_USER_WIDTH
      )
    port map (
      clk_i  => HCLK,                   -- Clock
      rst_ni => HRESETn,                -- Asynchronous reset active low

      axi_aw_id     => axi4_dat_aw_id,
      axi_aw_addr   => axi4_dat_aw_addr,
      axi_aw_len    => axi4_dat_aw_len,
      axi_aw_size   => axi4_dat_aw_size,
      axi_aw_burst  => axi4_dat_aw_burst,
      axi_aw_lock   => axi4_dat_aw_lock,
      axi_aw_cache  => axi4_dat_aw_cache,
      axi_aw_prot   => axi4_dat_aw_prot,
      axi_aw_qos    => axi4_dat_aw_qos,
      axi_aw_region => axi4_dat_aw_region,
      axi_aw_user   => axi4_dat_aw_user,
      axi_aw_valid  => axi4_dat_aw_valid,
      axi_aw_ready  => axi4_dat_aw_ready,

      axi_ar_id     => axi4_dat_ar_id,
      axi_ar_addr   => axi4_dat_ar_addr,
      axi_ar_len    => axi4_dat_ar_len,
      axi_ar_size   => axi4_dat_ar_size,
      axi_ar_burst  => axi4_dat_ar_burst,
      axi_ar_lock   => axi4_dat_ar_lock,
      axi_ar_cache  => axi4_dat_ar_cache,
      axi_ar_prot   => axi4_dat_ar_prot,
      axi_ar_qos    => axi4_dat_ar_qos,
      axi_ar_region => axi4_dat_ar_region,
      axi_ar_user   => axi4_dat_ar_user,
      axi_ar_valid  => axi4_dat_ar_valid,
      axi_ar_ready  => axi4_dat_ar_ready,

      axi_w_data  => axi4_dat_w_data,
      axi_w_strb  => axi4_dat_w_strb,
      axi_w_last  => axi4_dat_w_last,
      axi_w_user  => axi4_dat_w_user,
      axi_w_valid => axi4_dat_w_valid,
      axi_w_ready => axi4_dat_w_ready,

      axi_r_id    => axi4_dat_r_id,
      axi_r_data  => axi4_dat_r_data,
      axi_r_resp  => axi4_dat_r_resp,
      axi_r_last  => axi4_dat_r_last,
      axi_r_user  => axi4_dat_r_user,
      axi_r_valid => axi4_dat_r_valid,
      axi_r_ready => axi4_dat_r_ready,

      axi_b_id    => axi4_dat_b_id,
      axi_b_resp  => axi4_dat_b_resp,
      axi_b_user  => axi4_dat_b_user,
      axi_b_valid => axi4_dat_b_valid,
      axi_b_ready => axi4_dat_b_ready,

      req_o  => open,
      we_o   => open,
      addr_o => open,
      be_o   => open,
      data_o => open,
      data_i => (others => '0')
      );
end rtl;
