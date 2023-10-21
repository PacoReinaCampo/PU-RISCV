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
--              Memory Model                                                  --
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
--

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

use work.riscv_defines.all;

entity pu_riscv_memory_model_wb is
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
end pu_riscv_memory_model_wb;

architecture rtl of pu_riscv_memory_model_wb is
  ------------------------------------------------------------------------------
  -- Constants
  ------------------------------------------------------------------------------
  constant RADRCNT_MSB : integer := integer(log2(real(BURST)))+integer(log2(real(XLEN/8)))-1;

  ------------------------------------------------------------------------------
  -- Variables
  ------------------------------------------------------------------------------
  signal mem_array : std_logic_matrix(PLEN-1 downto 1)(XLEN-1 downto 1);

  signal iaddr : std_logic_matrix(1 downto 0)(PLEN-1 downto 0);
  signal raddr : std_logic_matrix(1 downto 0)(PLEN-1 downto 0);
  signal waddr : std_logic_matrix(1 downto 0)(PLEN-1 downto 0);

  signal radrcnt : std_logic_matrix(1 downto 0)(RADRCNT_MSB downto 0);

  signal wreq : std_logic_vector(1 downto 0);
  signal dbe  : std_logic_matrix(1 downto 0)(XLEN/8-1 downto 0);

  signal ack_latency : std_logic_matrix(1 downto 0)(MEM_LATENCY downto 1);

  signal dHTRANS : std_logic_matrix(1 downto 0)(1 downto 0);
  signal dHWRITE : std_logic_vector(1 downto 0);
  signal dHSIZE  : std_logic_matrix(1 downto 0)(2 downto 0);
  signal dHBURST : std_logic_matrix(1 downto 0)(2 downto 0);

begin
  ------------------------------------------------------------------------------
  -- Module body
  ------------------------------------------------------------------------------
  generating_0 : for u in 0 to 1 generate

    -- Generate ACK

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

    -- Write Section

    -- delay control signals
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

    -- Read Section
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
end rtl;
