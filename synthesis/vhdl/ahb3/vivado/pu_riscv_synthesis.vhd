-- Converted from pu_riscv_synthesis.sv
-- by verilog2vhdl - QueenField

--------------------------------------------------------------------------------
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
--              AMBA3 AHB-Lite Bus Interface                                  //
--                                                                            //
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

use work.peripheral_ahb3_pkg.all;
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
  component riscv_pu_ahb3
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
      --AHB interfaces
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

  component mpsoc_ahb3_spram
    generic (
      MEM_SIZE          : integer := 256;  --Memory in Bytes
      MEM_DEPTH         : integer := 256;  --Memory depth
      PLEN              : integer := 64;
      XLEN              : integer := 64;
      TECHNOLOGY        : string  := "GENERIC";
      REGISTERED_OUTPUT : string  := "NO"
    );
    port (
      HRESETn : in std_logic;
      HCLK    : in std_logic;

      --AHB Slave Interfaces (receive data from AHB Masters)
      --AHB Masters connect to these ports
      HSEL      : in  std_logic;
      HADDR     : in  std_logic_vector(PLEN-1 downto 0);
      HWDATA    : in  std_logic_vector(XLEN-1 downto 0);
      HRDATA    : out std_logic_vector(XLEN-1 downto 0);
      HWRITE    : in  std_logic;
      HSIZE     : in  std_logic_vector(2 downto 0);
      HBURST    : in  std_logic_vector(2 downto 0);
      HPROT     : in  std_logic_vector(3 downto 0);
      HTRANS    : in  std_logic_vector(1 downto 0);
      HMASTLOCK : in  std_logic;
      HREADYOUT : out std_logic;
      HREADY    : in  std_logic;
      HRESP     : out std_logic
    );
  end component;

  ------------------------------------------------------------------------------
  --
  -- Constants
  --

  constant HTIF    : integer                       := 0;  -- Host-Interface
  constant TOHOST  : std_logic_vector(31 downto 0) := X"80001000";
  constant UART_TX : std_logic_vector(31 downto 0) := X"80001080";

  ------------------------------------------------------------------------------
  --
  -- Variables
  --

  --PMA configuration
  signal pma_cfg : std_logic_matrix(PMA_CNT-1 downto 0)(13 downto 0);
  signal pma_adr : std_logic_matrix(PMA_CNT-1 downto 0)(PLEN-1 downto 0);

  --AHB3 instruction
  signal ins_HSEL      : std_logic;
  signal ins_HADDR     : std_logic_vector(PLEN-1 downto 0);
  signal ins_HWDATA    : std_logic_vector(XLEN-1 downto 0);
  signal ins_HRDATA    : std_logic_vector(XLEN-1 downto 0);
  signal ins_HWRITE    : std_logic;
  signal ins_HSIZE     : std_logic_vector(2 downto 0);
  signal ins_HBURST    : std_logic_vector(2 downto 0);
  signal ins_HPROT     : std_logic_vector(3 downto 0);
  signal ins_HTRANS    : std_logic_vector(1 downto 0);
  signal ins_HMASTLOCK : std_logic;
  signal ins_HREADY    : std_logic;
  signal ins_HRESP     : std_logic;

  --AHB3 data
  signal dat_HSEL      : std_logic;
  signal dat_HADDR     : std_logic_vector(PLEN-1 downto 0);
  signal dat_HWDATA    : std_logic_vector(XLEN-1 downto 0);
  signal dat_HRDATA    : std_logic_vector(XLEN-1 downto 0);
  signal dat_HWRITE    : std_logic;
  signal dat_HSIZE     : std_logic_vector(2 downto 0);
  signal dat_HBURST    : std_logic_vector(2 downto 0);
  signal dat_HPROT     : std_logic_vector(3 downto 0);
  signal dat_HTRANS    : std_logic_vector(1 downto 0);
  signal dat_HMASTLOCK : std_logic;
  signal dat_HREADY    : std_logic;
  signal dat_HRESP     : std_logic;

  --Debug Interface
  signal dbg_dato_s : std_logic_vector(XLEN-1 downto 0);

begin
  --/////////////////////////////////////////////////////////////
  --
  -- Module Body
  --

  --Define PMA regions
  pma_adr <= (others => (others => '0'));
  pma_cfg <= (others => (others => '0'));

  --Debug Interface
  dbg_dato_s <= X"00000000" & dbg_dato;

  -- Processing Unit
  dut : riscv_pu_ahb3
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

      --AHB3 instruction
      ins_HSEL      => ins_HSEL,
      ins_HADDR     => ins_HADDR,
      ins_HWDATA    => ins_HWDATA,
      ins_HRDATA    => ins_HRDATA,
      ins_HWRITE    => ins_HWRITE,
      ins_HSIZE     => ins_HSIZE,
      ins_HBURST    => ins_HBURST,
      ins_HPROT     => ins_HPROT,
      ins_HTRANS    => ins_HTRANS,
      ins_HMASTLOCK => ins_HMASTLOCK,
      ins_HREADY    => ins_HREADY,
      ins_HRESP     => ins_HRESP,

      --AHB3 data
      dat_HSEL      => dat_HSEL,
      dat_HADDR     => dat_HADDR,
      dat_HWDATA    => dat_HWDATA,
      dat_HRDATA    => dat_HRDATA,
      dat_HWRITE    => dat_HWRITE,
      dat_HSIZE     => dat_HSIZE,
      dat_HBURST    => dat_HBURST,
      dat_HPROT     => dat_HPROT,
      dat_HTRANS    => dat_HTRANS,
      dat_HMASTLOCK => dat_HMASTLOCK,
      dat_HREADY    => dat_HREADY,
      dat_HRESP     => dat_HRESP,

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

  --Instruction AHB3
  instruction_ahb3 : mpsoc_ahb3_spram
    generic map (
      MEM_SIZE          => 256,
      MEM_DEPTH         => 256,
      PLEN              => PLEN,
      XLEN              => XLEN,
      TECHNOLOGY        => TECHNOLOGY,
      REGISTERED_OUTPUT => "NO"
    )
    port map (
      HRESETn => HRESETn,
      HCLK    => HCLK,

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
      HREADYOUT => open,
      HREADY    => ins_HREADY,
      HRESP     => ins_HRESP
    );

  --Data AHB3
  data_ahb3 : mpsoc_ahb3_spram
    generic map (
      MEM_SIZE          => 256,
      MEM_DEPTH         => 256,
      PLEN              => PLEN,
      XLEN              => XLEN,
      TECHNOLOGY        => TECHNOLOGY,
      REGISTERED_OUTPUT => "NO"
    )
    port map (
      HRESETn => HRESETn,
      HCLK    => HCLK,

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
      HREADYOUT => open,
      HREADY    => dat_HREADY,
      HRESP     => dat_HRESP
    );
end RTL;
