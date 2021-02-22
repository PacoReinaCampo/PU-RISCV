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
--              Wishbone Bus Interface                                        //
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
use ieee.math_real.all;

use work.peripheral_wb_pkg.all;
use work.vhdl_pkg.all;

entity pu_riscv_synthesis is
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

architecture RTL of pu_riscv_synthesis is
  component riscv_pu_wb
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

      JEDEC_BANK : integer := 10;

      JEDEC_MANUFACTURER_ID : std_logic_vector(7 downto 0) := X"6E";

      HARTID : integer := 0;

      PARCEL_SIZE : integer := 64
    );
    port (
      HRESETn : in std_logic;
      HCLK    : in std_logic;

      pma_cfg_i : std_logic_matrix(PMA_CNT-1 downto 0)(13 downto 0);
      pma_adr_i : std_logic_matrix(PMA_CNT-1 downto 0)(PLEN-1 downto 0);

      --WB interfaces
      wb_ins_adr_o : out std_logic_vector(PLEN-1 downto 0);
      wb_ins_dat_o : out std_logic_vector(XLEN-1 downto 0);
      wb_ins_sel_o : out std_logic_vector(3 downto 0);
      wb_ins_we_o  : out std_logic;
      wb_ins_cyc_o : out std_logic;
      wb_ins_stb_o : out std_logic;
      wb_ins_cti_o : out std_logic_vector(2 downto 0);
      wb_ins_bte_o : out std_logic_vector(1 downto 0);
      wb_ins_dat_i : in  std_logic_vector(XLEN-1 downto 0);
      wb_ins_ack_i : in  std_logic;
      wb_ins_err_i : in  std_logic;
      wb_ins_rty_i : in  std_logic_vector(2 downto 0);

      wb_dat_adr_o : out std_logic_vector(PLEN-1 downto 0);
      wb_dat_dat_o : out std_logic_vector(XLEN-1 downto 0);
      wb_dat_sel_o : out std_logic_vector(3 downto 0);
      wb_dat_we_o  : out std_logic;
      wb_dat_stb_o : out std_logic;
      wb_dat_cyc_o : out std_logic;
      wb_dat_cti_o : out std_logic_vector(2 downto 0);
      wb_dat_bte_o : out std_logic_vector(1 downto 0);
      wb_dat_dat_i : in  std_logic_vector(XLEN-1 downto 0);
      wb_dat_ack_i : in  std_logic;
      wb_dat_err_i : in  std_logic;
      wb_dat_rty_i : in  std_logic_vector(2 downto 0);

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
  end component;

  component mpsoc_wb_spram
    generic (
      --Memory parameters
      DEPTH   : integer := 256;
      MEMFILE : string  := "";

      --Wishbone parameters
      DW : integer := 32;
      AW : integer := integer(log2(real(256)))
      );
    port (
      wb_clk_i : in std_logic;
      wb_rst_i : in std_logic;

      wb_adr_i : in std_logic_vector(AW-1 downto 0);
      wb_dat_i : in std_logic_vector(DW-1 downto 0);
      wb_sel_i : in std_logic_vector(3 downto 0);
      wb_we_i  : in std_logic;
      wb_bte_i : in std_logic_vector(1 downto 0);
      wb_cti_i : in std_logic_vector(2 downto 0);
      wb_cyc_i : in std_logic;
      wb_stb_i : in std_logic;

      wb_ack_o : out std_logic;
      wb_err_o : out std_logic;
      wb_dat_o : out std_logic_vector(DW-1 downto 0)
      );
  end component;

  --////////////////////////////////////////////////////////////////
  --
  -- Constants
  --

  constant HTIF    : integer                       := 0;  -- Host-Interface
  constant TOHOST  : std_logic_vector(31 downto 0) := X"80001000";
  constant UART_TX : std_logic_vector(31 downto 0) := X"80001080";

  --////////////////////////////////////////////////////////////////
  --
  -- Variables
  --

  --PMA configuration
  signal pma_cfg : std_logic_matrix(PMA_CNT-1 downto 0)(13 downto 0);
  signal pma_adr : std_logic_matrix(PMA_CNT-1 downto 0)(PLEN-1 downto 0);

  --WB Instruction
  signal wb_ins_adr_o : std_logic_vector(PLEN-1 downto 0);
  signal wb_ins_dat_o : std_logic_vector(XLEN-1 downto 0);
  signal wb_ins_sel_o : std_logic_vector(3 downto 0);
  signal wb_ins_we_o  : std_logic;
  signal wb_ins_cyc_o : std_logic;
  signal wb_ins_stb_o : std_logic;
  signal wb_ins_cti_o : std_logic_vector(2 downto 0);
  signal wb_ins_bte_o : std_logic_vector(1 downto 0);
  signal wb_ins_dat_i : std_logic_vector(XLEN-1 downto 0);
  signal wb_ins_ack_i : std_logic;
  signal wb_ins_err_i : std_logic;
  signal wb_ins_rty_i : std_logic_vector(2 downto 0);

  --WB Data
  signal wb_dat_adr_o : std_logic_vector(PLEN-1 downto 0);
  signal wb_dat_dat_o : std_logic_vector(XLEN-1 downto 0);
  signal wb_dat_sel_o : std_logic_vector(3 downto 0);
  signal wb_dat_we_o  : std_logic;
  signal wb_dat_stb_o : std_logic;
  signal wb_dat_cyc_o : std_logic;
  signal wb_dat_cti_o : std_logic_vector(2 downto 0);
  signal wb_dat_bte_o : std_logic_vector(1 downto 0);
  signal wb_dat_dat_i : std_logic_vector(XLEN-1 downto 0);
  signal wb_dat_ack_i : std_logic;
  signal wb_dat_err_i : std_logic;
  signal wb_dat_rty_i : std_logic_vector(2 downto 0);

  --Debug Interface
  signal dbg_dato_s : std_logic_vector(XLEN-1 downto 0);

begin
  --//////////////////////////////////////////////////////////////
  --
  -- Module Body
  --

  --Define PMA regions
  pma_adr <= (others => (others => '0'));
  pma_cfg <= (others => (others => '0'));

  --Debug Interface
  dbg_dato_s <= X"00000000" & dbg_dato;

  -- Processing Unit
  dut : riscv_pu_wb
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

      --WB instruction
      wb_ins_adr_o => wb_ins_adr_o,
      wb_ins_dat_o => wb_ins_dat_o,
      wb_ins_sel_o => wb_ins_sel_o,
      wb_ins_we_o  => wb_ins_we_o,
      wb_ins_cyc_o => wb_ins_cyc_o,
      wb_ins_stb_o => wb_ins_stb_o,
      wb_ins_cti_o => wb_ins_cti_o,
      wb_ins_bte_o => wb_ins_bte_o,
      wb_ins_dat_i => wb_ins_dat_i,
      wb_ins_ack_i => wb_ins_ack_i,
      wb_ins_err_i => wb_ins_err_i,
      wb_ins_rty_i => wb_ins_rty_i,

      --WB data
      wb_dat_adr_o => wb_dat_adr_o,
      wb_dat_dat_o => wb_dat_dat_o,
      wb_dat_sel_o => wb_dat_sel_o,
      wb_dat_we_o  => wb_dat_we_o,
      wb_dat_cyc_o => wb_dat_cyc_o,
      wb_dat_stb_o => wb_dat_stb_o,
      wb_dat_cti_o => wb_dat_cti_o,
      wb_dat_bte_o => wb_dat_bte_o,
      wb_dat_dat_i => wb_dat_dat_i,
      wb_dat_ack_i => wb_dat_ack_i,
      wb_dat_err_i => wb_dat_err_i,
      wb_dat_rty_i => wb_dat_rty_i,
 
      --Interrupts
      ext_nmi       => ext_nmi,
      ext_tint      => ext_tint,
      ext_sint      => ext_sint,
      ext_int       => ext_int,

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

  --Instruction wb
  instruction_wb : mpsoc_wb_spram
    generic map (
      DEPTH   => 256,
      MEMFILE => "",
      AW      => PLEN,
      DW      => XLEN
    )
    port map (
      wb_clk_i => HCLK,
      wb_rst_i => HRESETn,

      wb_adr_i => wb_ins_adr_o,
      wb_dat_i => wb_ins_dat_o,
      wb_sel_i => wb_ins_sel_o,
      wb_we_i  => wb_ins_we_o,
      wb_bte_i => wb_ins_bte_o,
      wb_cti_i => wb_ins_cti_o,
      wb_cyc_i => wb_ins_cyc_o,
      wb_stb_i => wb_ins_stb_o,
      wb_ack_o => wb_ins_ack_i,
      wb_err_o => wb_ins_err_i,
      wb_dat_o => wb_ins_dat_i
    );

  --Data wb
  data_wb : mpsoc_wb_spram
    generic map (
      DEPTH   => 256,
      MEMFILE => "",
      AW      => PLEN,
      DW      => XLEN
    )
    port map (
      wb_clk_i => HCLK,
      wb_rst_i => HRESETn,

      wb_adr_i => wb_dat_adr_o,
      wb_dat_i => wb_dat_dat_o,
      wb_sel_i => wb_dat_sel_o,
      wb_we_i  => wb_dat_we_o,
      wb_bte_i => wb_dat_bte_o,
      wb_cti_i => wb_dat_cti_o,
      wb_cyc_i => wb_dat_cyc_o,
      wb_stb_i => wb_dat_stb_o,
      wb_ack_o => wb_dat_ack_i,
      wb_err_o => wb_dat_err_i,
      wb_dat_o => wb_dat_dat_i
    );
end RTL;
