-- Converted from riscv_memory_model.sv
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
--              Memory Model                                                  //
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

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;
use std.textio.all;

use work.riscv_mpsoc_pkg.all;

entity riscv_memory_model is
  generic (
    XLEN : integer := 64;
    PLEN : integer := 64;

    BASE : std_logic_vector(PLEN-1 downto 0) := (others => '0');

    MEM_LATENCY : integer := 1;

    LATENCY : integer := 1;
    BURST   : integer := 8;

    INIT_FILE : string := "test.hex"
    );
  port (
    HCLK    : in std_logic;
    HRESETn : in std_logic;

    HTRANS : in  M_1_1;
    HREADY : out std_logic_vector(1 downto 0);
    HRESP  : out std_logic_vector(1 downto 0);

    HADDR  : in  M_1_PLEN;
    HWRITE : in  std_logic_vector(1 downto 0);
    HSIZE  : in  M_1_2;
    HBURST : in  M_1_2;
    HWDATA : in  M_1_XLEN;
    HRDATA : out M_1_XLEN
    );
end riscv_memory_model;

architecture RTL of riscv_memory_model is
  --//////////////////////////////////////////////////////////////
  --
  -- Constants
  --
  constant RADRCNT_MSB : integer := integer(log2(real(BURST)))+integer(log2(real(XLEN/8)))-1;

  --//////////////////////////////////////////////////////////////
  --
  -- Typedefs
  --
  type M_PLEN_XLEN is array (PLEN-1 downto 0) of std_logic_vector(XLEN-1 downto 1);

  type M_1_RADRCNT_MSB is array (1 downto 0) of std_logic_vector(RADRCNT_MSB downto 0);
  type M_1_XLEN8 is array (1 downto 0) of std_logic_vector(XLEN/8 downto 0);
  type M_1_MEM_LATENCY is array (1 downto 0) of std_logic_vector(MEM_LATENCY downto 1);

  type M_7_1 is array (7 downto 0) of std_logic_vector(1 downto 0);
  type M_7_255 is array (7 downto 0) of std_logic_vector(255 downto 0);

  --//////////////////////////////////////////////////////////////
  --
  -- Variables
  --
  signal mem_array : M_PLEN_XLEN;

  signal iaddr : M_1_PLEN;
  signal raddr : M_1_PLEN;
  signal waddr : M_1_PLEN;

  signal radrcnt : M_1_RADRCNT_MSB;

  signal wreq : std_logic_vector(1 downto 0);
  signal dbe  : M_1_XLEN8;

  signal ack_latency : M_1_MEM_LATENCY;

  signal dHTRANS : M_1_1;
  signal dHWRITE : std_logic_vector(1 downto 0);
  signal dHSIZE  : M_1_2;
  signal dHBURST : M_1_2;

  --//////////////////////////////////////////////////////////////
  --
  -- Functions
  --
  function to_stdlogic (
    input : boolean
    ) return std_logic is
  begin
    if input then
      return('1');
    else
      return('0');
    end if;
  end function to_stdlogic;

  --//////////////////////////////////////////////////////////////
  --
  -- Procedures
  --

  --Read Intel HEX
  procedure read_ihex (
    signal m   : in integer;
    signal fd  : in integer;
    signal cnt : in integer;
    signal eof : in integer;

    signal tmp : in std_logic_vector(31 downto 0);

    signal byte_cnt    : in std_logic_vector(7 downto 0);
    signal address     : in M_7_1;
    signal record_type : in std_logic_vector(7 downto 0);
    signal data        : in M_7_255;
    signal checksum    : in std_logic_vector(7 downto 0);
    signal crc         : in std_logic_vector(7 downto 0);

    signal base_addr : in std_logic_vector(PLEN-1 downto 0)
    ) is
  begin



    -- * 1: start code
    -- * 2: byte count  (2 hex digits)
    -- * 3: address     (4 hex digits)
    -- * 4: record type (2 hex digits)
    -- *    00: data
    -- *    01: end of file
    -- *    02: extended segment address
    -- *    03: start segment address
    -- *    04: extended linear address (16lsbs of 32bit address)
    -- *    05: start linear address
    -- * 5: data
    -- * 6: checksum    (2 hex digits)

  end read_ihex;

  --Read HEX generated by RISC-V elf2hex
  procedure read_elf2hex (
    signal mem_array : out M_PLEN_XLEN
    ) is

    file fd : text open read_mode is INIT_FILE;  --open file

    variable m      : integer;
    variable line_n : integer;

    variable fstatus: FILE_OPEN_STATUS;

    variable l : line;

    variable base_addr : std_logic_vector(PLEN-1 downto 0);
    variable data      : std_logic_vector(127 downto 0);

  begin

    line_n    := 0;
    base_addr := BASE;

    file_open(fstatus, fd, INIT_FILE, read_mode);  --open file

    --Read data from file
    while not endfile(fd) loop
      line_n := line_n+1;

      readline(fd, l);
      read(l, data);

      for m in 0 to 128/XLEN - 1 loop
        mem_array(to_integer(unsigned(base_addr))) <= data((m+1)*XLEN-1 downto m*XLEN);

        base_addr := std_logic_vector(unsigned(base_addr) + to_unsigned(XLEN/8, XLEN));
      end loop;
    end loop;

    --close file
    file_close(fd);
  end read_elf2hex;

  --Dump memory
  procedure dump (
    signal mem_array : in M_PLEN_XLEN
    ) is
  begin
  end dump;

begin
  --//////////////////////////////////////////////////////////////
  --
  -- Module body
  --
  generating_0 : for u in 0 to 1 generate

    --Generate ACK

    generating_1 : if (MEM_LATENCY > 0) generate
      processing_0 : process (HCLK, HRESETn)
      begin
        if (HRESETn = '0') then
          ack_latency(u) <= (others => '1');
        elsif (rising_edge(HCLK)) then
          if (HREADY(u) = '1') then
            if (HTRANS(u) = HTRANS_IDLE) then
              ack_latency(u) <= (others => '1');
            elsif (HTRANS(u) = HTRANS_NONSEQ) then
              ack_latency(u) <= (others => '0');
            end if;
          else
            ack_latency(u) <= (ack_latency(u) & '1');
          end if;
        end if;
      end process;
      HREADY(u) <= ack_latency(u)(MEM_LATENCY);
    elsif (MEM_LATENCY <= 0) generate
      HREADY(u) <= '1';
    end generate;

    HRESP(u) <= HRESP_OKAY;

    --Write Section

    --delay control signals
    processing_1 : process (HCLK)
    begin
      if (rising_edge(HCLK)) then
        if (HREADY(u) = '1') then
          dHTRANS(u) <= HTRANS(u);
          dHWRITE(u) <= HWRITE(u);
          dHSIZE(u)  <= HSIZE(u);
          dHBURST(u) <= HBURST(u);
        end if;
      end if;
    end process;

    processing_2 : process (HCLK)
    begin
      if (rising_edge(HCLK)) then
        if (HREADY(u) = '1' and HTRANS(u) /= HTRANS_BUSY) then
          waddr(u) <= HADDR(u) and ((XLEN-1 downto 0 => '1') sll integer(log2(real(XLEN/8))));
          case (HSIZE(u)) is
            when HSIZE_BYTE =>
              dbe(u) <= X"01" sll to_integer(unsigned(HADDR(u)(integer(log2(real(XLEN/8)))-1 downto 0)));
            when HSIZE_HWORD =>
              dbe(u) <= X"03" sll to_integer(unsigned(HADDR(u)(integer(log2(real(XLEN/8)))-1 downto 0)));
            when HSIZE_WORD =>
              dbe(u) <= X"0f" sll to_integer(unsigned(HADDR(u)(integer(log2(real(XLEN/8)))-1 downto 0)));
            when HSIZE_DWORD =>
              dbe(u) <= X"ff" sll to_integer(unsigned(HADDR(u)(integer(log2(real(XLEN/8)))-1 downto 0)));
            when others =>
              null;
          end case;
        end if;
      end if;
    end process;

    processing_3 : process (HCLK)
    begin
      if (rising_edge(HCLK)) then
        if (HREADY(u) = '1') then
          wreq(u) <= to_stdlogic(HTRANS(u) /= HTRANS_IDLE) and to_stdlogic(HTRANS(u) /= HTRANS_BUSY) and HWRITE(u);
        end if;
      end if;
    end process;

    processing_4 : process (HCLK)
    begin
      if (rising_edge(HCLK)) then
        if (HREADY(u) = '1' and wreq(u) = '1') then
          for m in 0 to XLEN/8 - 1 loop
            if (dbe(u)(m) = '1') then
              mem_array(to_integer(unsigned(waddr(u))))((m+1)*8-1 downto m*8) <= HWDATA(u)((m+1)*8-1 downto m*8);
            end if;
          end loop;
        end if;
      end if;
    end process;

    --Read Section
    iaddr(u) <= HADDR(u) and ((XLEN-1 downto 0 => '1') sll integer(log2(real(XLEN/8))));

    processing_5 : process (HCLK)
    begin
      if (rising_edge(HCLK)) then
        if (HREADY(u) = '1' and (HTRANS(u) /= HTRANS_IDLE) and (HTRANS(u) /= HTRANS_BUSY) and HWRITE(u) = '0') then
          if (iaddr(u) = waddr(u) and wreq(u) = '1') then
            for n in 0 to XLEN/8 - 1 loop
              if (dbe(u) = X"ff") then
                HRDATA(u)((n+1)*8-1 downto n*8) <= HWDATA(u)((n+1)*8-1 downto n*8);
              else
                HRDATA(u)((n+1)*8-1 downto n*8) <= mem_array(to_integer(unsigned(iaddr(u))))((n+1)*8-1 downto n*8);
              end if;
            end loop;
          else
            HRDATA(u) <= mem_array(to_integer(unsigned(iaddr(u))));
          end if;
        end if;
      end if;
    end process;
  end generate;
end RTL;
