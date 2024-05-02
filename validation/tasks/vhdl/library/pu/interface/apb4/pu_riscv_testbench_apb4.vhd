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
--              TestBench                                                     --
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

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

use work.pu_riscv_vhdl_pkg.all;
use work.vhdl_pkg.all;

entity pu_riscv_testbench_apb4 is
end pu_riscv_testbench_apb4;

architecture rtl of pu_riscv_testbench_apb4 is
  ------------------------------------------------------------------------------
  -- Constants
  ------------------------------------------------------------------------------
  constant MULLAT : integer := MULT_LATENCY;

  -- core parameters
  constant XLEN : integer := 64;
  constant PLEN : integer := 64;

  constant HAS_USER  : std_logic := '1';
  constant HAS_SUPER : std_logic := '1';
  constant HAS_HYPER : std_logic := '1';
  constant HAS_BPU   : std_logic := '1';
  constant HAS_FPU   : std_logic := '1';
  constant HAS_MMU   : std_logic := '1';
  constant HAS_RVM   : std_logic := '1';
  constant HAS_RVA   : std_logic := '1';
  constant HAS_RVC   : std_logic := '1';
  constant IS_RV32E  : std_logic := '1';

  constant MULT_LATENCY : std_logic := '1';

  constant BREAKPOINTS : integer := 8;  -- Number of hardware breakpoints

  constant PMA_CNT : integer := 4;
  constant PMP_CNT : integer := 16;  -- Number of Physical Memory Protection entries

  constant BP_GLOBAL_BITS    : integer := 2;
  constant BP_LOCAL_BITS     : integer := 10;
  constant BP_LOCAL_BITS_LSB : integer := 2;

  constant ICACHE_SIZE        : integer := 64;  -- in KBytes
  constant ICACHE_BLOCK_SIZE  : integer := 64;  -- in Bytes
  constant ICACHE_WAYS        : integer := 2;   -- 'n'-way set associative
  constant ICACHE_REPLACE_ALG : integer := 0;
  constant ITCM_SIZE          : integer := 0;

  constant DCACHE_SIZE        : integer := 64;  -- in KBytes
  constant DCACHE_BLOCK_SIZE  : integer := 64;  -- in Bytes
  constant DCACHE_WAYS        : integer := 2;   -- 'n'-way set associative
  constant DCACHE_REPLACE_ALG : integer := 0;
  constant DTCM_SIZE          : integer := 0;
  constant WRITEBUFFER_SIZE   : integer := 8;

  constant TECHNOLOGY : string := "GENERIC";

  constant PC_INIT : std_logic_vector(63 downto 0) := X"0000000080000000";

  constant MNMIVEC_DEFAULT : std_logic_vector(63 downto 0) := X"0000000000000004";
  constant MTVEC_DEFAULT   : std_logic_vector(63 downto 0) := X"0000000000000040";
  constant HTVEC_DEFAULT   : std_logic_vector(63 downto 0) := X"0000000000000080";
  constant STVEC_DEFAULT   : std_logic_vector(63 downto 0) := X"00000000000000C0";
  constant UTVEC_DEFAULT   : std_logic_vector(63 downto 0) := X"0000000000000100";

  constant JEDEC_BANK : integer := 10;

  constant JEDEC_MANUFACTURER_ID : std_logic_vector(7 downto 0) := X"6E";

  constant HARTID : integer := 0;

  constant PARCEL_SIZE : integer := 64;

  -- Host-interface
  constant HTIF : std_logic := '0';

  constant TOHOST  : std_logic_vector(63 downto 0) := X"0000000080001000";
  constant UART_TX : std_logic_vector(63 downto 0) := X"0000000080001080";

  constant BASE : std_logic_vector(PLEN-1 downto 0) := (others => '0');

  constant MEM_LATENCY : integer := 1;

  constant LATENCY : integer := 1;
  constant BURST   : integer := 8;

  -- mpsoc parameters
  constant X : integer := 1;
  constant Y : integer := 1;
  constant Z : integer := 1;

  constant NODES : integer := X*Y*Z;

  ------------------------------------------------------------------------------
  -- Components
  ------------------------------------------------------------------------------
  component pu_riscv_apb4
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

      BREAKPOINTS : integer := 8;       -- Number of hardware breakpoints

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

      -- AHB3 instruction
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

      -- AHB3 data
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
  end component;

  component pu_riscv_dbg_bfm
    generic (
      XLEN : integer := 64;
      PLEN : integer := 64
    );
    port (
      rstn : in std_logic;
      clk  : in std_logic;

      cpu_bp_i : in std_logic;

      cpu_stall_o : out std_logic;
      cpu_stb_o   : out std_logic;
      cpu_we_o    : out std_logic;
      cpu_adr_o   : out std_logic_vector(PLEN-1 downto 0);
      cpu_dat_o   : out std_logic_vector(XLEN-1 downto 0);
      cpu_dat_i   : in  std_logic_vector(XLEN-1 downto 0);
      cpu_ack_i   : in  std_logic
    );
  end component;

  component pu_riscv_memory_model_apb4
    generic (
      XLEN : integer := 64;
      PLEN : integer := 64;

      BASE : std_logic_vector(PLEN-1 downto 0) := (others => '0');

      MEM_LATENCY : integer := 1;

      LATENCY : integer := 1;
      BURST   : integer := 8;

      HEX_FILE : string := "test.hex",
      MEM_FILE : string := "test.mem",
    );
    port (
      HCLK    : in std_logic;
      HRESETn : in std_logic;

      HTRANS : in  std_logic_matrix(1 downto 0)(1 downto 0);
      HREADY : out std_logic_vector(1 downto 0);
      HRESP  : out std_logic_vector(1 downto 0);

      HADDR  : in  std_logic_matrix(1 downto 0)(PLEN-1 downto 0);
      HWRITE : in  std_logic_vector(1 downto 0);
      HSIZE  : in  std_logic_matrix(1 downto 0)(2 downto 0);
      HBURST : in  std_logic_matrix(1 downto 0)(2 downto 0);
      HWDATA : in  std_logic_matrix(1 downto 0)(XLEN-1 downto 0);
      HRDATA : out std_logic_matrix(1 downto 0)(XLEN-1 downto 0)
    );
  end component;

  -- HTIF Interface
  component pu_riscv_htif
    generic (
      XLEN : integer := 32
    );
    port (
      rstn : in std_logic;
      clk  : in std_logic;

      host_csr_req      : out std_logic;
      host_csr_ack      : in  std_logic;
      host_csr_we       : out std_logic;
      host_csr_tohost   : in  std_logic_vector(XLEN-1 downto 0);
      host_csr_fromhost : out std_logic_vector(XLEN-1 downto 0)
    );
  end component;

  -- MMIO Interface
  component pu_riscv_mmio_if_apb4
    generic (
      XLEN : integer := 32;
      PLEN : integer := 32;

      TOHOST  : std_logic_vector(63 downto 0) := X"0000000080001000";
      UART_TX : std_logic_vector(63 downto 0) := X"0000000080001080"
    );
    port (
      HRESETn : in std_logic;
      HCLK    : in std_logic;

      HTRANS : in  std_logic_vector(1 downto 0);
      HADDR  : in  std_logic_vector(HADDR_SIZE-1 downto 0);
      HWRITE : in  std_logic;
      HSIZE  : in  std_logic_vector(2 downto 0);
      HBURST : in  std_logic_vector(2 downto 0);
      HWDATA : in  std_logic_vector(HDATA_SIZE-1 downto 0);
      HRDATA : out std_logic_vector(HDATA_SIZE-1 downto 0);

      HREADYOUT : out std_logic;
      HRESP     : out std_logic
    );
  end component;

  ------------------------------------------------------------------------------
  -- Variables
  ------------------------------------------------------------------------------
  signal HCLK    : std_logic;
  signal HRESETn : std_logic;

  -- PMA configuration
  signal pma_cfg : std_logic_matrix(PMA_CNT-1 downto 0)(13 downto 0);
  signal pma_adr : std_logic_matrix(PMA_CNT-1 downto 0)(PLEN-1 downto 0);

  -- Instruction interface
  signal ins_HSEL      : std_logic;
  signal ins_HADDR     : std_logic_vector(PLEN-1 downto 0);
  signal ins_HRDATA    : std_logic_vector(XLEN-1 downto 0);
  signal ins_HWDATA    : std_logic_vector(XLEN-1 downto 0);
  signal ins_HWRITE    : std_logic;
  signal ins_HSIZE     : std_logic_vector(2 downto 0);
  signal ins_HBURST    : std_logic_vector(2 downto 0);
  signal ins_HPROT     : std_logic_vector(3 downto 0);
  signal ins_HTRANS    : std_logic_vector(1 downto 0);
  signal ins_HMASTLOCK : std_logic;
  signal ins_HREADY    : std_logic;
  signal ins_HRESP     : std_logic;

  -- Data interface
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

  -- Debug Interface
  signal dbg_bp    : std_logic;
  signal dbg_stall : std_logic;
  signal dbg_strb  : std_logic;
  signal dbg_ack   : std_logic;
  signal dbg_we    : std_logic;
  signal dbg_addr  : std_logic_vector(PLEN-1 downto 0);
  signal dbg_dati  : std_logic_vector(XLEN-1 downto 0);
  signal dbg_dato  : std_logic_vector(XLEN-1 downto 0);

  -- Host Interface
  signal host_csr_req      : std_logic;
  signal host_csr_ack      : std_logic;
  signal host_csr_we       : std_logic;
  signal host_csr_tohost   : std_logic_vector(XLEN-1 downto 0);
  signal host_csr_fromhost : std_logic_vector(XLEN-1 downto 0);

  -- Unified memory interface
  signal mem_htrans : std_logic_matrix(1 downto 0)(1 downto 0);
  signal mem_hburst : std_logic_matrix(1 downto 0)(2 downto 0);
  signal mem_hready : std_logic_vector(1 downto 0);
  signal mem_hresp  : std_logic_vector(1 downto 0);
  signal mem_haddr  : std_logic_matrix(1 downto 0)(PLEN-1 downto 0);
  signal mem_hwdata : std_logic_matrix(1 downto 0)(XLEN-1 downto 0);
  signal mem_hrdata : std_logic_matrix(1 downto 0)(XLEN-1 downto 0);
  signal mem_hsize  : std_logic_matrix(1 downto 0)(2 downto 0);
  signal mem_hwrite : std_logic_vector(1 downto 0);

  signal mem_array : std_logic_matrix(PLEN-1 downto 1)(XLEN-1 downto 1);

  ------------------------------------------------------------------------------
  -- Procedures
  ------------------------------------------------------------------------------

  -- Stall CPU
  procedure stall (
    signal clk : in std_logic;

    signal stall_cpu : out std_logic
    ) is
  begin
    wait until rising_edge(clk);
    stall_cpu <= '1';
  end stall;

  -- Unstall CPU
  procedure unstall (
    signal clk : in std_logic;

    signal stall_cpu : out std_logic
    ) is
  begin
    wait until rising_edge(clk);
    stall_cpu <= '0';
  end unstall;

  -- Write to CPU (via DBG interface)
  procedure write (
    constant DATA : in std_logic_vector(XLEN-1 downto 0);
    constant ADDR : in std_logic_vector(PLEN-1 downto 0);

    signal clk : in std_logic;

    signal cpu_ack_i : in std_logic;

    signal cpu_stb_o : out std_logic;
    signal cpu_we_o  : out std_logic;
    signal cpu_dat_o : out std_logic_vector(XLEN-1 downto 0);
    signal cpu_adr_o : out std_logic_vector(PLEN-1 downto 0)
    ) is
  begin

    -- setup DBG bus
    wait until rising_edge(clk);
    cpu_stb_o <= '1';
    cpu_we_o  <= '1';
    cpu_dat_o <= DATA;
    cpu_adr_o <= ADDR;

    -- wait for ack
    while (cpu_ack_i = '0') loop
      wait until rising_edge(clk);
    end loop;

    -- clear DBG bus
    cpu_stb_o <= '0';
    cpu_we_o  <= '0';
  end write;

  -- Read Intel HEX
  procedure read_ihex (
    signal mem_array : out std_logic_matrix(PLEN-1 downto 1)(XLEN-1 downto 1)
    ) is

    file fd : text open read_mode is HEX_FILE;  -- open file

    variable m      : integer;
    variable line_n : integer;

    variable fstatus : file_open_status;

    variable l : line;

    variable cnt : integer;
    variable eof : std_logic;

    variable tmp : std_logic_vector(31 downto 0);

    variable byte_cnt    : std_logic_vector(7 downto 0);
    variable address     : std_logic_matrix(1 downto 0)(7 downto 0);
    variable record_type : std_logic_vector(7 downto 0);
    variable data        : std_logic_matrix(255 downto 0)(7 downto 0);
    variable checksum    : std_logic_vector(7 downto 0);
    variable crc         : std_logic_vector(7 downto 0);

    variable base_addr : std_logic_vector(PLEN-1 downto 0);

  begin

    -- 1: start code
    -- 2: byte count  (2 hex digits)
    -- 3: address     (4 hex digits)
    -- 4: record type (2 hex digits)
    --    00: data
    --    01: end of file
    --    02: extended segment address
    --    03: start segment address
    --    04: extended linear address (16lsbs of 32bit address)
    --    05: start linear address
    -- 5: data
    -- 6: checksum    (2 hex digits)

    file_open(fstatus, fd, HEX_FILE, read_mode);  -- open file

    -- if (fd < X"80000000") then
    report "ERROR  : Skip reading file %s. Reason file not found" & HEX_FILE;
    -- end if;

    eof := '0';

    while (eof = '0') loop
      -- if ((null)(fd, ":%2h%4h%2h", byte_cnt, address, record_type) /= 3) then
      report "ERROR  : Read error while processing " & HEX_FILE;
      -- end if;

      -- initial CRC value
      crc := std_logic_vector(unsigned(byte_cnt)+unsigned(address(1))+unsigned(address(0))+unsigned(record_type));

      for m in 0 to to_integer(unsigned(byte_cnt)) - 1 loop
        -- if ((null)(fd, "%2h", data(m)) /= 1) then
        report "ERROR  : Read error while processing " & HEX_FILE;
        -- end if;

        -- update CRC
        crc := std_logic_vector(unsigned(crc)+unsigned(data(m)));
      end loop;

      -- if ((null)(fd, "%2h", checksum) /= 1) then
      report "ERROR  : Read error while processing " & HEX_FILE;
      -- end if;

      if (unsigned(checksum)+unsigned(crc) = X"ff") then
        report "ERROR  : CRC error while processing " & HEX_FILE;
      end if;

      case (record_type) is
        when X"00" =>
          for m in 0 to to_integer(unsigned(byte_cnt)) - 1 loop
          -- mem_array((base_addr+address+m) and not (XLEN/8-1))(((base_addr+address+m) mod (XLEN/8))*8+8) <= data(m);
          end loop;
        when X"01" =>
          eof := '1';
        when X"02" =>
        -- base_addr := std_logic_vector(unsigned(data(0) & data(1)) sll 4);
        when X"03" =>
          report "INFO   : Ignored record type %0d while processing " & to_string(record_type) & HEX_FILE;
        when X"04" =>
        -- base_addr := std_logic_vector(unsigned(data(0) & data(1)) sll 16);
        when X"05" =>
          base_addr := data(0) & data(1) & data(2) & data(3) & data(4) & data(5) & data(6) & data(7);
        when others =>
          report "ERROR  : Unknown record type while processing " & HEX_FILE;
      end case;
    end loop;

    -- close file
    file_close(fd);
  end read_ihex;

  -- Read HEX generated by RISC-V elf2hex
  procedure read_elf2hex (
    signal mem_array : out std_logic_matrix(PLEN-1 downto 1)(XLEN-1 downto 1)
    ) is

    file fd : text open read_mode is HEX_FILE;  -- open file

    variable m      : integer;
    variable line_n : integer;

    variable fstatus : file_open_status;

    variable l : line;

    variable base_addr : std_logic_vector(PLEN-1 downto 0);
    variable data      : std_logic_vector(127 downto 0);

  begin

    line_n    := 0;
    base_addr := BASE;

    file_open(fstatus, fd, HEX_FILE, read_mode);  -- open file

    -- Read data from file
    while not endfile(fd) loop
      line_n := line_n+1;

      readline(fd, l);
      read(l, data);

      for m in 0 to 128/XLEN - 1 loop
        mem_array(to_integer(unsigned(base_addr))) <= data((m+1)*XLEN-1 downto m*XLEN);

        base_addr := std_logic_vector(unsigned(base_addr) + to_unsigned(XLEN/8, XLEN));
      end loop;
    end loop;

    -- close file
    file_close(fd);
  end read_elf2hex;

  -- Read Memory
  procedure read_memory (
    signal mem_array : in std_logic_matrix(PLEN-1 downto 1)(XLEN-1 downto 1)
    ) is
  begin
  end dump;

begin
  ------------------------------------------------------------------------------
  -- Module Body
  ------------------------------------------------------------------------------

  -- Define PMA regions

  -- crt.0 (ROM) region
  pma_adr(0) <= TOHOST srl 2;
  pma_cfg(0) <= (MEM_TYPE_MAIN & "11111000" & AMO_TYPE_NONE & TOR);

  -- TOHOST region
  pma_adr(1) <= ((TOHOST srl 2) and not X"000000000000000f") or X"0000000000000007";
  pma_cfg(1) <= (MEM_TYPE_IO & "01000000" & AMO_TYPE_NONE & NAPOT);

  -- UART-Tx region
  pma_adr(2) <= UART_TX srl 2;
  pma_cfg(2) <= (MEM_TYPE_IO & "01000000" & AMO_TYPE_NONE & NA4);

  -- RAM region
  pma_adr(3) <= X"0000000000000001" sll 63;
  pma_cfg(3) <= (MEM_TYPE_MAIN & "11110000" & AMO_TYPE_NONE & TOR);

  -- Hookup Device Under Test
  dut : pu_riscv_apb4
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
      ICACHE_WAYS        => ICACHE_WAYS,
      ICACHE_REPLACE_ALG => ICACHE_REPLACE_ALG,
      ITCM_SIZE          => ITCM_SIZE,

      DCACHE_SIZE        => DCACHE_SIZE,
      DCACHE_BLOCK_SIZE  => DCACHE_BLOCK_SIZE,
      DCACHE_WAYS        => DCACHE_WAYS,
      DCACHE_REPLACE_ALG => DCACHE_REPLACE_ALG,
      DTCM_SIZE          => DTCM_SIZE,
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

      -- Interrupts
      ext_nmi  => '0',
      ext_tint => '0',
      ext_sint => '0',
      ext_int  => X"0",

      -- Debug Interface
      dbg_stall => dbg_stall,
      dbg_strb  => dbg_strb,
      dbg_we    => dbg_we,
      dbg_addr  => dbg_addr,
      dbg_dati  => dbg_dati,
      dbg_dato  => dbg_dato,
      dbg_ack   => dbg_ack,
      dbg_bp    => dbg_bp
    );

  -- Hookup Debug Unit
  dbg_ctrl : pu_riscv_dbg_bfm
    generic map (
      XLEN => XLEN,
      PLEN => PLEN
      )
    port map (
      rstn => HRESETn,
      clk  => HCLK,

      cpu_bp_i    => dbg_bp,
      cpu_stall_o => dbg_stall,
      cpu_stb_o   => dbg_strb,
      cpu_we_o    => dbg_we,
      cpu_adr_o   => dbg_addr,
      cpu_dat_o   => dbg_dati,
      cpu_dat_i   => dbg_dato,
      cpu_ack_i   => dbg_ack
    );

  -- bus <-> memory model connections
  mem_htrans(0) <= ins_HTRANS;
  mem_hburst(0) <= ins_HBURST;
  mem_haddr(0)  <= ins_HADDR;
  mem_hwrite(0) <= ins_HWRITE;
  mem_hsize(0)  <= (others => '0');
  mem_hwdata(0) <= (others => '0');
  ins_HRDATA    <= mem_hrdata(0);
  ins_HREADY    <= mem_hready(0);
  ins_HRESP     <= mem_hresp(0);

  mem_htrans(1) <= dat_HTRANS;
  mem_hburst(1) <= dat_HBURST;
  mem_haddr(1)  <= dat_HADDR;
  mem_hwrite(1) <= dat_HWRITE;
  mem_hsize(1)  <= dat_HSIZE;
  mem_hwdata(1) <= dat_HWDATA;
  dat_HRDATA    <= mem_hrdata(1);
  dat_HREADY    <= mem_hready(1);
  dat_HRESP     <= mem_hresp(1);

  -- hookup memory model
  memory_model : pu_riscv_memory_model_apb4
    generic map (
      XLEN => XLEN,
      PLEN => PLEN,

      BASE => BASE,

      MEM_LATENCY => MEM_LATENCY,

      LATENCY => LATENCY,
      BURST   => BURST,

      HEX_FILE => HEX_FILE,
      MEM_FILE => MEM_FILE
      )
    port map (
      HRESETn => HRESETn,
      HCLK    => HCLK,
      HTRANS  => mem_htrans,
      HREADY  => mem_hready,
      HRESP   => mem_hresp,
      HADDR   => mem_haddr,
      HWRITE  => mem_hwrite,
      HSIZE   => mem_hsize,
      HBURST  => mem_hburst,
      HWDATA  => mem_hwdata,
      HRDATA  => mem_hrdata
    );

  -- Front-End Server
  generating_0 : if (HTIF = '1') generate
    -- Old HTIF interface
    htif_frontend : pu_riscv_htif
      generic map (
        XLEN => XLEN
        )
      port map (
        rstn => HRESETn,
        clk  => HCLK,

        host_csr_req      => host_csr_req,
        host_csr_ack      => host_csr_ack,
        host_csr_we       => host_csr_we,
        host_csr_tohost   => host_csr_tohost,
        host_csr_fromhost => host_csr_fromhost
      );
  elsif (HTIF = '0') generate
    mmio_if : pu_riscv_mmio_if_apb4
      generic map (
        XLEN    => XLEN,
        PLEN    => PLEN,
        TOHOST  => TOHOST,
        UART_TX => UART_TX
        )
      port map (
        HRESETn   => HRESETn,
        HCLK      => HCLK,
        HTRANS    => dat_HTRANS,
        HWRITE    => dat_HWRITE,
        HSIZE     => dat_HSIZE,
        HBURST    => dat_HBURST,
        HADDR     => dat_HADDR,
        HWDATA    => dat_HWDATA,
        HRDATA    => open,
        HREADYOUT => open,
        HRESP     => open
      );
  end generate;

  -- Generate clock
  -- always #1 HCLK = ~HCLK;

  processing_0 : process
  begin
    report "\n";
    report "                                                                                                         ";
    report "                                                                                                         ";
    report "                                                              ***                     ***          **    ";
    report "                                                            ** ***    *                ***          **   ";
    report "                                                           **   ***  ***                **          **   ";
    report "                                                           **         *                 **          **   ";
    report "    ****    **   ****                                      **                           **          **   ";
    report "   * ***  *  **    ***  *    ***       ***    ***  ****    ******   ***        ***      **      *** **   ";
    report "  *   ****   **     ****    * ***     * ***    **** **** * *****     ***      * ***     **     ********* ";
    report " **    **    **      **    *   ***   *   ***    **   ****  **         **     *   ***    **    **   ****  ";
    report " **    **    **      **   **    *** **    ***   **    **   **         **    **    ***   **    **    **   ";
    report " **    **    **      **   ********  ********    **    **   **         **    ********    **    **    **   ";
    report " **    **    **      **   *******   *******     **    **   **         **    *******     **    **    **   ";
    report " **    **    **      **   **        **          **    **   **         **    **          **    **    **   ";
    report "  *******     ******* **  ****    * ****    *   **    **   **         **    ****    *   **    **    **   ";
    report "   ******      *****   **  *******   *******    ***   ***  **         *** *  *******    *** *  *****     ";
    report "       **                   *****     *****      ***   ***  **         ***    *****      ***    ***      ";
    report "       **                                                                                                ";
    report "       **                                                                                                ";
    report "        **                                                                                               ";
    report "- RISC-V Regression TestBench -------------------------------------------------------------------------- -";
    report "  XLEN | PRIV | MMU | FPU | RVA | RVM | MULLAT";

    report "------------------------------------------------------------------------------ ";
    report "  CORES | NODES | X | Y | Z | CORES_PER_TILE | CORES_PER_MISD | CORES_PER_SIMD";
    report "    1   | " & integer'image(NODES) & " | " & integer'image(X) & " | " & integer'image(Y) & " | " & integer'image(Z) & " |";
    report "------------------------------------------------------------------------------ ";
    report "  Test   = " & HEX_FILE;
    report "  ICache = %0dkB" & integer'image(ICACHE_SIZE);
    report "  DCache = %0dkB" & integer'image(DCACHE_SIZE);
    report "------------------------------------------------------------------------------ ";

    wait;
  end process;

  processing_1 : process
  begin
    read_ihex (
      mem_array => mem_array
    );

    HCLK    <= '0';
    HRESETn <= '1';

    for repeat in 1 to 5 loop
      wait until falling_edge(HCLK);
    end loop;

    HRESETn <= '0';

    for repeat in 1 to 5 loop
      wait until falling_edge(HCLK);
    end loop;

    HRESETn <= '1';

    wait for 112 ns;

    -- stall CPU
    stall (
      clk       => HCLK,
      stall_cpu => dbg_stall
    );

    -- Enable BREAKPOINT to call external debugger
    -- write(X"0000000000000004", X"00000000000000008");

    -- Enable Single Stepping
    write (
      clk => HCLK,

      cpu_ack_i => dbg_ack,

      data => X"0000000000000000",
      addr => X"0000000000000001",

      cpu_stb_o => dbg_strb,
      cpu_we_o  => dbg_we,
      cpu_dat_o => dbg_dato,
      cpu_adr_o => dbg_addr
    );

    -- single step through 10 instructions
    for repeat in 1 to 100 loop
      while (dbg_stall = '0') loop
        wait until rising_edge(HCLK);
      end loop;

      for repeat in 1 to 15 loop
        wait until rising_edge(HCLK);
      end loop;

      -- clear single-step-hit
      write (
        clk => HCLK,

        cpu_ack_i => dbg_ack,

        data => X"0000000000000001",
        addr => X"0000000000000000",

        cpu_stb_o => dbg_strb,
        cpu_we_o  => dbg_we,
        cpu_dat_o => dbg_dato,
        cpu_adr_o => dbg_addr
      );

      unstall (
        clk       => HCLK,
        stall_cpu => dbg_stall
      );
    end loop;

    -- last time ...
    wait until rising_edge(HCLK);

    while (dbg_stall = '0') loop
      wait until rising_edge(HCLK);
    end loop;

    -- disable Single Stepping
    write (
      clk => HCLK,

      cpu_ack_i => dbg_ack,

      data => X"0000000000000000",
      addr => X"0000000000000000",

      cpu_stb_o => dbg_strb,
      cpu_we_o  => dbg_we,
      cpu_dat_o => dbg_dato,
      cpu_adr_o => dbg_addr
    );

    write (
      clk => HCLK,

      cpu_ack_i => dbg_ack,

      data => X"0000000000000001",
      addr => X"0000000000000000",

      cpu_stb_o => dbg_strb,
      cpu_we_o  => dbg_we,
      cpu_dat_o => dbg_dato,
      cpu_adr_o => dbg_addr
    );

    unstall (
      clk       => HCLK,
      stall_cpu => dbg_stall
    );
  end process;
end rtl;
