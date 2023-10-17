-- Converted from rtl/verilog/core/memory/pu_riscv_mmu.sv
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
--              Core - Memory Management Unit                                 --
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

entity pu_riscv_mmu is
  generic (
    XLEN : integer := 64;
    PLEN : integer := 64
    );
  port (
    rst_ni : in std_logic;
    clk_i  : in std_logic;
    clr_i  : in std_logic;              --clear pending request

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
end pu_riscv_mmu;

architecture rtl of pu_riscv_mmu is
begin
  ------------------------------------------------------------------------------
  -- Module Body
  ------------------------------------------------------------------------------
  processing_0 : process (clk_i)
  begin
    if (rising_edge(clk_i)) then
      if (vreq_i = '1') then            --TODO: actual translation
        padr_o <= vadr_i;
      end if;
    end if;
  end process;

  --Insert state machine here
  processing_1 : process (clk_i)
  begin
    if (rising_edge(clk_i)) then
      if (clr_i = '1') then
        preq_o <= '0';
      else
        preq_o <= vreq_i;
      end if;
    end if;
  end process;

  processing_2 : process (clk_i)
  begin
    if (rising_edge(clk_i)) then
      psize_o <= vsize_i;
      plock_o <= vlock_i;
      pprot_o <= vprot_i;
      pwe_o   <= vwe_i;
    end if;
  end process;

  --MMU does not write data
  processing_3 : process (clk_i)
  begin
    if (rising_edge(clk_i)) then
      pd_o <= vd_i;
    end if;
  end process;

  --No page fault yet
  page_fault_o <= '0';
end rtl;
