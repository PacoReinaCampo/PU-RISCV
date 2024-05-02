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
--              Bus Interface Unit                                            --
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

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.peripheral_wb_vhdl_pkg.all;
use work.peripheral_wb_vhdl_pkg.all;
use work.vhdl_pkg.all;

entity pu_riscv_wb2wb is
  generic (
    XLEN : integer := 64;
    PLEN : integer := 64
    );
  port (
    HRESETn : in std_logic;
    HCLK    : in std_logic;

    -- Wishbone Bus
    wb_adr_o : out std_logic_vector(PLEN-1 downto 0);
    wb_dat_o : out std_logic_vector(XLEN-1 downto 0);
    wb_sel_o : out std_logic_vector(3 downto 0);
    wb_we_o  : out std_logic;
    wb_stb_o : out std_logic;
    wb_cyc_o : out std_logic;
    wb_cti_o : out std_logic_vector(2 downto 0);
    wb_bte_o : out std_logic_vector(1 downto 0);
    wb_dat_i : in  std_logic_vector(XLEN-1 downto 0);
    wb_ack_i : in  std_logic;
    wb_err_i : in  std_logic;
    wb_rty_i : in  std_logic_vector(2 downto 0);

    -- BIU Bus (Core ports)
    wb_stb_i     : in  std_logic;      -- strobe
    wb_stb_ack_o : out std_logic;  -- strobe acknowledge; can send new strobe
    wb_d_ack_o   : out std_logic;  -- data acknowledge (send new wb_d_i); for pipelined buses
    wb_adri_i    : in  std_logic_vector(PLEN-1 downto 0);
    wb_adro_o    : out std_logic_vector(PLEN-1 downto 0);
    wb_size_i    : in  std_logic_vector(2 downto 0);  -- transfer size
    wb_type_i    : in  std_logic_vector(2 downto 0);  -- burst type
    wb_prot_i    : in  std_logic_vector(2 downto 0);  -- protection
    wb_lock_i    : in  std_logic;
    wb_we_i      : in  std_logic;
    wb_d_i       : in  std_logic_vector(XLEN-1 downto 0);
    wb_q_o       : out std_logic_vector(XLEN-1 downto 0);
    wb_ack_o     : out std_logic;      -- transfer acknowledge
    wb_err_o     : out std_logic       -- transfer error
    );
end pu_riscv_wb2wb;

architecture rtl of pu_riscv_wb2wb is
  ------------------------------------------------------------------------------
  -- Functions
  ------------------------------------------------------------------------------
  function wb_size2hsize (
    size : std_logic_vector(2 downto 0)
    ) return std_logic_vector is
    variable wb_size2hsize_return : std_logic_vector (2 downto 0);
  begin
    case ((size)) is
      when "000" =>
        wb_size2hsize_return := HSIZE_BYTE;
      when "001" =>
        wb_size2hsize_return := HSIZE_HWORD;
      when "010" =>
        wb_size2hsize_return := HSIZE_WORD;
      when "011" =>
        wb_size2hsize_return := HSIZE_DWORD;
      when others =>
        -- OOPSS
        wb_size2hsize_return := "XXX";
    end case;
    return wb_size2hsize_return;
  end wb_size2hsize;

  -- convert burst type to counter length (actually length -1)
  function wb_type2cnt (
    wb_type : std_logic_vector(2 downto 0)
    ) return std_logic_vector is
    variable wb_type2cnt_return : std_logic_vector (3 downto 0);
  begin
    case ((wb_type)) is
      when SINGLE =>
        wb_type2cnt_return := "0000";
      when INCR =>
        wb_type2cnt_return := "0000";
      when WRAP4 =>
        wb_type2cnt_return := "0011";
      when INCR4 =>
        wb_type2cnt_return := "0011";
      when WRAP8 =>
        wb_type2cnt_return := "0111";
      when INCR8 =>
        wb_type2cnt_return := "0111";
      when WRAP16 =>
        wb_type2cnt_return := "1111";
      when INCR16 =>
        wb_type2cnt_return := "1111";
      when others =>
        -- OOPS
        wb_type2cnt_return := "XXXX";
    end case;
    return wb_type2cnt_return;
  end wb_type2cnt;

  -- convert burst type to counter length (actually length -1)
  function wb_type2hburst (
    wb_type : std_logic_vector(2 downto 0)
    ) return std_logic_vector is
    variable wb_type2hburst_return : std_logic_vector (2 downto 0);
  begin
    case ((wb_type)) is
      when SINGLE =>
        wb_type2hburst_return := HBURST_SINGLE;
      when INCR =>
        wb_type2hburst_return := HBURST_INCR;
      when WRAP4 =>
        wb_type2hburst_return := HBURST_WRAP4;
      when INCR4 =>
        wb_type2hburst_return := HBURST_INCR4;
      when WRAP8 =>
        wb_type2hburst_return := HBURST_WRAP8;
      when INCR8 =>
        wb_type2hburst_return := HBURST_INCR8;
      when WRAP16 =>
        wb_type2hburst_return := HBURST_WRAP16;
      when INCR16 =>
        wb_type2hburst_return := HBURST_INCR16;
      when others =>
        -- OOPS
        wb_type2hburst_return := "XXX";
    end case;
    return wb_type2hburst_return;
  end wb_type2hburst;

  -- convert burst type to counter length (actually length -1)
  function wb_prot2hprot (
    wb_prot : std_logic_vector(2 downto 0)
    ) return std_logic_vector is
    variable wb_prot2hprot_return     : std_logic_vector (3 downto 0);
    variable wb_prot2hprot_privileged : std_logic_vector (3 downto 0);
    variable wb_prot2hprot_cacheable  : std_logic_vector (3 downto 0);
  begin
    if ((wb_prot and PROT_DATA) = "111") then
      wb_prot2hprot_return := HPROT_DATA;
    else
      wb_prot2hprot_return := HPROT_OPCODE;
    end if;

    if ((wb_prot and PROT_PRIVILEGED) = "111") then
      wb_prot2hprot_privileged := HPROT_PRIVILEGED;
    else
      wb_prot2hprot_privileged := HPROT_USER;
    end if;

    wb_prot2hprot_return := wb_prot2hprot_return or wb_prot2hprot_privileged;

    if ((wb_prot and PROT_CACHEABLE) = "111") then
      wb_prot2hprot_cacheable := HPROT_CACHEABLE;
    else
      wb_prot2hprot_cacheable := HPROT_NON_CACHEABLE;
    end if;

    wb_prot2hprot_return := wb_prot2hprot_return or wb_prot2hprot_cacheable;

    return wb_prot2hprot_return;
  end wb_prot2hprot;

  -- convert burst type to counter length (actually length -1)
  function nxt_addr (
    addr   : std_logic_vector(PLEN-1 downto 0);  -- current address
    hburst : std_logic_vector(2 downto 0)        -- AHB HBURST
    ) return std_logic_vector is
    variable nxt_addr_return : std_logic_vector (PLEN-1 downto 0);
  begin
    -- next linear address
    if (XLEN = 32) then
      nxt_addr_return := std_logic_vector(unsigned(addr)+to_unsigned(4, PLEN)) and not std_logic_vector(to_unsigned(3, PLEN));
    else
      nxt_addr_return := std_logic_vector(unsigned(addr)+to_unsigned(8, PLEN)) and not std_logic_vector(to_unsigned(7, PLEN));
    end if;
    -- wrap?
    case (hburst) is
      when HBURST_WRAP4 =>
        if (XLEN = 32) then
          nxt_addr_return := (addr(PLEN-1 downto 4) & nxt_addr_return(3 downto 0));
        else
          nxt_addr_return := (addr(PLEN-1 downto 5) & nxt_addr_return(4 downto 0));
        end if;
      when HBURST_WRAP8 =>
        if (XLEN = 32) then
          nxt_addr_return := (addr(PLEN-1 downto 5) & nxt_addr_return(4 downto 0));
        else
          nxt_addr_return := (addr(PLEN-1 downto 6) & nxt_addr_return(5 downto 0));
        end if;
      when HBURST_WRAP16 =>
        if (XLEN = 32) then
          nxt_addr_return := (addr(PLEN-1 downto 6) & nxt_addr_return(5 downto 0));
        else
          nxt_addr_return := (addr(PLEN-1 downto 7) & nxt_addr_return(6 downto 0));
        end if;
      when others =>
        null;
    end case;
    return nxt_addr_return;
  end nxt_addr;

  ------------------------------------------------------------------------------
  -- Variables
  ------------------------------------------------------------------------------
  signal burst_cnt  : std_logic_vector(3 downto 0);
  signal data_ena   : std_logic;
  signal data_ena_d : std_logic;
  signal wb_di_dly : std_logic_vector(XLEN-1 downto 0);

  signal wb_err : std_logic;

begin
  ------------------------------------------------------------------------------
  -- Module Body
  ------------------------------------------------------------------------------

  -- State Machine
  processing_0 : process (HCLK, HRESETn)
  begin
    if (HRESETn = '0') then
      data_ena  <= '0';
      wb_err   <= '0';
      burst_cnt <= (others => '0');

      wb_stb_o <= '0';
      wb_adr_o <= (others => '0');
      wb_we_o  <= '0';
      wb_cti_o <= (others => '0');      -- don't care
      wb_sel_o <= HPROT_DATA or HPROT_PRIVILEGED or HPROT_NON_BUFFERABLE or HPROT_NON_CACHEABLE;
      wb_bte_o <= HTRANS_IDLE;
      wb_cyc_o <= '0';
    elsif (rising_edge(HCLK) or falling_edge(HRESETn)) then
      -- strobe/ack signals
      wb_err <= '0';

      if (wb_ack_i = '1') then
        if (reduce_nor(burst_cnt) = '1') then  -- burst complete
          if (wb_stb_i = '1' and wb_err = '0') then
            data_ena  <= '1';
            burst_cnt <= wb_type2cnt(wb_type_i);

            wb_stb_o <= '1';
            wb_bte_o <= HTRANS_NONSEQ;  -- start of burst
            wb_adr_o <= wb_adri_i;
            wb_we_o  <= wb_we_i;
            wb_cti_o <= wb_type2hburst(wb_type_i);
            wb_sel_o <= wb_prot2hprot(wb_prot_i);
            wb_cyc_o <= wb_lock_i;
          else
            data_ena <= '0';
            wb_stb_o <= '0';
            wb_bte_o <= HTRANS_IDLE;    -- no new transfer
            wb_cyc_o <= wb_lock_i;
          end if;
        else                            -- continue burst
          data_ena  <= '1';
          burst_cnt <= std_logic_vector(unsigned(burst_cnt)-to_unsigned(1, 4));

          wb_bte_o <= HTRANS_SEQ;                    -- continue burst
          wb_adr_o <= nxt_addr(wb_adr_o, wb_cti_o);  -- next address
        end if;
      -- error response
      elsif (wb_err_i = HRESP_ERROR) then
        burst_cnt <= (others => '0');                -- burst done (interrupted)

        wb_stb_o <= '0';
        wb_bte_o <= HTRANS_IDLE;

        data_ena <= '0';
        wb_err  <= '1';
      end if;
    end if;
  end process;

  wb_err_o <= wb_err;

  -- Data section
  processing_1 : process (HCLK)
  begin
    if (rising_edge(HCLK)) then
      if (wb_ack_i = '1') then
        wb_di_dly <= wb_d_i;
      end if;
    end if;
  end process;

  processing_2 : process (HCLK)
  begin
    if (rising_edge(HCLK)) then
      if (wb_ack_i = '1') then
        wb_dat_o   <= wb_di_dly;
        wb_adro_o <= wb_adr_o;
      end if;
    end if;
  end process;

  processing_3 : process (HCLK, HRESETn)
  begin
    if (HRESETn = '0') then
      data_ena_d <= '0';
    elsif (rising_edge(HCLK) or falling_edge(HRESETn)) then
      if (wb_ack_i = '1') then
        data_ena_d <= data_ena;
      end if;
    end if;
  end process;

  wb_q_o       <= wb_dat_i;
  wb_ack_o     <= wb_ack_i and data_ena_d;
  wb_d_ack_o   <= wb_ack_i and data_ena;
  wb_stb_ack_o <= wb_ack_i and reduce_nor(burst_cnt) and wb_stb_i and not wb_err;
end rtl;
