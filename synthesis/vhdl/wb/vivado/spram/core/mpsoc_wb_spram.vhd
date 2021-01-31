-- Converted from mpsoc_wb_spram.v
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
--              Single Port RAM                                               //
--              Wishbone Bus Interface                                        //
--                                                                            //
--//////////////////////////////////////////////////////////////////////////////

-- Copyright (c) 2018-2019 by the author(s)
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
-- *   Olof Kindgren <olof.kindgren@gmail.com>
-- *   Paco Reina Campo <pacoreinacampo@queenfield.tech>
-- */

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

use work.mpsoc_spram_wb_pkg.all;

entity mpsoc_wb_spram is
  generic (
    --Memory parameters
    DEPTH   : integer := 256;
    MEMFILE : string  := "";
    --Wishbone parameters
    DW : integer := 32;
    AW : integer := integer(log2(real(DEPTH)))
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
end mpsoc_wb_spram;

architecture RTL of mpsoc_wb_spram is
  component mpsoc_wb_ram_generic
    generic (
      DEPTH   : integer := 256;
      MEMFILE : string  := "";

      AW : integer := integer(log2(real(DEPTH)));
      DW : integer := 32
      );
    port (
      clk   : in  std_logic;
      we    : in  std_logic_vector(3 downto 0);
      din   : in  std_logic_vector(DW-1 downto 0);
      waddr : in  std_logic_vector(AW-1 downto 0);
      raddr : in  std_logic_vector(AW-1 downto 0);
      dout  : out std_logic_vector(DW-1 downto 0)
      );
  end component;

  --////////////////////////////////////////////////////////////////
  --
  -- Constants
  --
  constant CLASSIC_CYCLE : std_logic := '0';
  constant BURST_CYCLE   : std_logic := '1';

  constant READ  : std_logic := '0';
  constant WRITE : std_logic := '1';

  constant CTI_CLASSIC      : std_logic_vector(2 downto 0) := "000";
  constant CTI_CONST_BURST  : std_logic_vector(2 downto 0) := "001";
  constant CTI_INC_BURST    : std_logic_vector(2 downto 0) := "010";
  constant CTI_END_OF_BURST : std_logic_vector(2 downto 0) := "111";

  constant BTE_LINEAR  : std_logic_vector(1 downto 0) := "00";
  constant BTE_WRAP_4  : std_logic_vector(1 downto 0) := "01";
  constant BTE_WRAP_8  : std_logic_vector(1 downto 0) := "10";
  constant BTE_WRAP_16 : std_logic_vector(1 downto 0) := "11";

  --////////////////////////////////////////////////////////////////
  --
  -- Functions
  --
  function get_cycle_type (
    cti : std_logic_vector(2 downto 0)
    ) return std_logic is

    variable get_cycle_type_return : std_logic;
  begin
    if (cti = CTI_CLASSIC) then
      get_cycle_type_return := CLASSIC_CYCLE;
    else
      get_cycle_type_return := BURST_CYCLE;
    end if;
    return get_cycle_type_return;
  end get_cycle_type;

  function wb_is_last (
    cti : std_logic_vector(2 downto 0)
    ) return std_logic is

    variable wb_is_last_return : std_logic;
  begin
    case ((cti)) is
      when CTI_CLASSIC =>
        wb_is_last_return := '1';
      when CTI_CONST_BURST =>
        wb_is_last_return := '0';
      when CTI_INC_BURST =>
        wb_is_last_return := '0';
      when CTI_END_OF_BURST =>
        wb_is_last_return := '1';
      when others =>
        null;
    end case;
    return wb_is_last_return;
  end wb_is_last;

  function wb_next_adr (
    adr_i : std_logic_vector(AW-1 downto 0);
    cti_i : std_logic_vector(2 downto 0);
    bte_i : std_logic_vector(1 downto 0)

    ) return std_logic_vector is

    variable adr : std_logic_vector(AW-1 downto 0);

    variable shift : integer;

    variable wb_next_adr_return : std_logic_vector (AW-1 downto 0);
  begin
    if (DW = 64) then
      shift := 3;
    elsif (DW = 32) then
      shift := 2;
    elsif (DW = 16) then
      shift := 1;
    else
      shift := 0;
    end if;
    adr := std_logic_vector(unsigned(adr_i) srl shift);
    if (cti_i = CTI_INC_BURST) then
      case ((bte_i)) is
        when BTE_LINEAR =>
          adr := std_logic_vector(unsigned(adr)+to_unsigned(1, AW));
        when BTE_WRAP_4 =>
          adr := adr(AW-1 downto 2) & std_logic_vector(unsigned(adr(1 downto 0))+"01");
        when BTE_WRAP_8 =>
          adr := adr(AW-1 downto 3) & std_logic_vector(unsigned(adr(2 downto 0))+"001");
        when BTE_WRAP_16 =>
          adr := adr(AW-1 downto 4) & std_logic_vector(unsigned(adr(3 downto 0))+"0001");
        when others =>
          null;
      end case;
    end if;
    -- case (burst_type_i)
    wb_next_adr_return := std_logic_vector(unsigned(adr) sll shift);
    return wb_next_adr_return;
  end wb_next_adr;

--////////////////////////////////////////////////////////////////
--
-- Variables
--
  signal adr_r     : std_logic_vector(AW-1 downto 0);
  signal next_adr  : std_logic_vector(AW-1 downto 0);
  signal valid     : std_logic;
  signal valid_r   : std_logic;
  signal is_last_r : std_logic;
  signal new_cycle : std_logic;
  signal adr       : std_logic_vector(AW-1 downto 0);
  signal ram_we    : std_logic;

  signal wb_ack : std_logic;

  signal we_i : std_logic_vector(3 downto 0);

begin
  --////////////////////////////////////////////////////////////////
  --
  -- Module Body
  --
  valid <= wb_cyc_i and wb_stb_i;

  processing_0 : process (wb_clk_i)
  begin
    if (rising_edge(wb_clk_i)) then
      is_last_r <= wb_is_last(wb_cti_i);
    end if;
  end process;

  new_cycle <= (valid and not valid_r) or is_last_r;

  next_adr <= wb_next_adr(adr_r, wb_cti_i, wb_bte_i);

  adr <= wb_adr_i when new_cycle = '1' else next_adr;

  processing_1 : process (wb_clk_i)
  begin
    if (rising_edge(wb_clk_i)) then
      adr_r   <= adr;
      valid_r <= valid;
      --Ack generation
      wb_ack  <= valid and (not (to_stdlogic(wb_cti_i = "000") or to_stdlogic(wb_cti_i = "111")) or not wb_ack);
      if (wb_rst_i = '1') then
        adr_r   <= (others => '0');
        valid_r <= '0';
        wb_ack  <= '0';
      end if;
    end if;
  end process;

  ram_we <= wb_we_i and valid and wb_ack;

  wb_ack_o <= wb_ack;

  --TODO:ck for burst address errors
  wb_err_o <= '0';

  ram0 : mpsoc_wb_ram_generic
    generic map (
      DEPTH   => DEPTH/4,
      MEMFILE => MEMFILE,

      AW => integer(log2(real(DEPTH/4))),
      DW => DW
      )
    port map (
      clk   => wb_clk_i,
      we    => we_i,
      din   => wb_dat_i,
      waddr => adr_r(AW-1 downto 2),
      raddr => adr(AW-1 downto 2),
      dout  => wb_dat_o
      );

  we_i <= (ram_we & ram_we & ram_we & ram_we) and wb_sel_i;
end RTL;
