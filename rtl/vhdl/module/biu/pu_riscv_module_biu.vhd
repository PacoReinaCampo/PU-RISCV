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

use work.peripheral_biu_vhdl_pkg.all;
use work.vhdl_pkg.all;

entity pu_riscv_module_biu is
  generic (
    XLEN : integer := 64;
    PLEN : integer := 64
    );
  port (
    HRESETn : in std_logic;
    HCLK    : in std_logic;

    -- AHB4 Lite Bus
    HSEL      : out std_logic;
    HADDR     : out std_logic_vector(PLEN-1 downto 0);
    HRDATA    : in  std_logic_vector(XLEN-1 downto 0);
    HWDATA    : out std_logic_vector(XLEN-1 downto 0);
    HWRITE    : out std_logic;
    HSIZE     : out std_logic_vector(2 downto 0);
    HBURST    : out std_logic_vector(2 downto 0);
    HPROT     : out std_logic_vector(3 downto 0);
    HTRANS    : out std_logic_vector(1 downto 0);
    HMASTLOCK : out std_logic;
    HREADY    : in  std_logic;
    HRESP     : in  std_logic;

    -- BIU Bus (Core ports)
    biu_stb_i     : in  std_logic;      -- strobe
    biu_stb_ack_o : out std_logic;  -- strobe acknowledge; can send new strobe
    biu_d_ack_o   : out std_logic;  -- data acknowledge (send new biu_d_i); for pipelined buses
    biu_adri_i    : in  std_logic_vector(PLEN-1 downto 0);
    biu_adro_o    : out std_logic_vector(PLEN-1 downto 0);
    biu_size_i    : in  std_logic_vector(2 downto 0);  -- transfer size
    biu_type_i    : in  std_logic_vector(2 downto 0);  -- burst type
    biu_prot_i    : in  std_logic_vector(2 downto 0);  -- protection
    biu_lock_i    : in  std_logic;
    biu_we_i      : in  std_logic;
    biu_d_i       : in  std_logic_vector(XLEN-1 downto 0);
    biu_q_o       : out std_logic_vector(XLEN-1 downto 0);
    biu_ack_o     : out std_logic;      -- transfer acknowledge
    biu_err_o     : out std_logic       -- transfer error
    );
end pu_riscv_module_biu;

architecture rtl of pu_riscv_module_biu is
  ------------------------------------------------------------------------------
  -- Functions
  ------------------------------------------------------------------------------
  function biu_size2hsize (
    size : std_logic_vector(2 downto 0)
    ) return std_logic_vector is
    variable biu_size2hsize_return : std_logic_vector (2 downto 0);
  begin
    case ((size)) is
      when "000" =>
        biu_size2hsize_return := HSIZE_BYTE;
      when "001" =>
        biu_size2hsize_return := HSIZE_HWORD;
      when "010" =>
        biu_size2hsize_return := HSIZE_WORD;
      when "011" =>
        biu_size2hsize_return := HSIZE_DWORD;
      when others =>
        -- OOPSS
        biu_size2hsize_return := "XXX";
    end case;
    return biu_size2hsize_return;
  end biu_size2hsize;

  -- convert burst type to counter length (actually length -1)
  function biu_type2cnt (
    biu_type : std_logic_vector(2 downto 0)
    ) return std_logic_vector is
    variable biu_type2cnt_return : std_logic_vector (3 downto 0);
  begin
    case ((biu_type)) is
      when SINGLE =>
        biu_type2cnt_return := "0000";
      when INCR =>
        biu_type2cnt_return := "0000";
      when WRAP4 =>
        biu_type2cnt_return := "0011";
      when INCR4 =>
        biu_type2cnt_return := "0011";
      when WRAP8 =>
        biu_type2cnt_return := "0111";
      when INCR8 =>
        biu_type2cnt_return := "0111";
      when WRAP16 =>
        biu_type2cnt_return := "1111";
      when INCR16 =>
        biu_type2cnt_return := "1111";
      when others =>
        -- OOPS
        biu_type2cnt_return := "XXXX";
    end case;
    return biu_type2cnt_return;
  end biu_type2cnt;

  -- convert burst type to counter length (actually length -1)
  function biu_type2hburst (
    biu_type : std_logic_vector(2 downto 0)
    ) return std_logic_vector is
    variable biu_type2hburst_return : std_logic_vector (2 downto 0);
  begin
    case ((biu_type)) is
      when SINGLE =>
        biu_type2hburst_return := HBURST_SINGLE;
      when INCR =>
        biu_type2hburst_return := HBURST_INCR;
      when WRAP4 =>
        biu_type2hburst_return := HBURST_WRAP4;
      when INCR4 =>
        biu_type2hburst_return := HBURST_INCR4;
      when WRAP8 =>
        biu_type2hburst_return := HBURST_WRAP8;
      when INCR8 =>
        biu_type2hburst_return := HBURST_INCR8;
      when WRAP16 =>
        biu_type2hburst_return := HBURST_WRAP16;
      when INCR16 =>
        biu_type2hburst_return := HBURST_INCR16;
      when others =>
        -- OOPS
        biu_type2hburst_return := "XXX";
    end case;
    return biu_type2hburst_return;
  end biu_type2hburst;

  -- convert burst type to counter length (actually length -1)
  function biu_prot2hprot (
    biu_prot : std_logic_vector(2 downto 0)
    ) return std_logic_vector is
    variable biu_prot2hprot_return     : std_logic_vector (3 downto 0);
    variable biu_prot2hprot_privileged : std_logic_vector (3 downto 0);
    variable biu_prot2hprot_cacheable  : std_logic_vector (3 downto 0);
  begin
    if ((biu_prot and PROT_DATA) = "111") then
      biu_prot2hprot_return := HPROT_DATA;
    else
      biu_prot2hprot_return := HPROT_OPCODE;
    end if;

    if ((biu_prot and PROT_PRIVILEGED) = "111") then
      biu_prot2hprot_privileged := HPROT_PRIVILEGED;
    else
      biu_prot2hprot_privileged := HPROT_USER;
    end if;

    biu_prot2hprot_return := biu_prot2hprot_return or biu_prot2hprot_privileged;

    if ((biu_prot and PROT_CACHEABLE) = "111") then
      biu_prot2hprot_cacheable := HPROT_CACHEABLE;
    else
      biu_prot2hprot_cacheable := HPROT_NON_CACHEABLE;
    end if;

    biu_prot2hprot_return := biu_prot2hprot_return or biu_prot2hprot_cacheable;

    return biu_prot2hprot_return;
  end biu_prot2hprot;

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
  signal biu_di_dly : std_logic_vector(XLEN-1 downto 0);

  signal biu_err : std_logic;


  signal HADDR_O  : std_logic_vector(PLEN-1 downto 0);
  signal HBURST_O : std_logic_vector(2 downto 0);

begin
  ------------------------------------------------------------------------------
  -- Module Body
  ------------------------------------------------------------------------------

  -- State Machine
  processing_0 : process (HCLK, HRESETn)
  begin
    if (HRESETn = '0') then
      data_ena  <= '0';
      biu_err   <= '0';
      burst_cnt <= (others => '0');

      HSEL      <= '0';
      HADDR_O   <= (others => '0');
      HWRITE    <= '0';
      HSIZE     <= (others => '0');     -- don't care
      HBURST_O  <= (others => '0');     -- don't care
      HPROT     <= HPROT_DATA or HPROT_PRIVILEGED or HPROT_NON_BUFFERABLE or HPROT_NON_CACHEABLE;
      HTRANS    <= HTRANS_IDLE;
      HMASTLOCK <= '0';
    elsif (rising_edge(HCLK) or falling_edge(HRESETn)) then
      -- strobe/ack signals
      biu_err <= '0';

      if (HREADY = '1') then
        if (reduce_nor(burst_cnt) = '1') then  -- burst complete
          if (biu_stb_i = '1' and biu_err = '0') then
            data_ena  <= '1';
            burst_cnt <= biu_type2cnt(biu_type_i);

            HSEL      <= '1';
            HTRANS    <= HTRANS_NONSEQ;  -- start of burst
            HADDR_O   <= biu_adri_i;
            HWRITE    <= biu_we_i;
            HSIZE     <= biu_size2hsize(biu_size_i);
            HBURST_O  <= biu_type2hburst(biu_type_i);
            HPROT     <= biu_prot2hprot(biu_prot_i);
            HMASTLOCK <= biu_lock_i;
          else
            data_ena  <= '0';
            HSEL      <= '0';
            HTRANS    <= HTRANS_IDLE;    -- no new transfer
            HMASTLOCK <= biu_lock_i;
          end if;
        else                             -- continue burst
          data_ena  <= '1';
          burst_cnt <= std_logic_vector(unsigned(burst_cnt)-to_unsigned(1, 4));

          HTRANS  <= HTRANS_SEQ;                   -- continue burst
          HADDR_O <= nxt_addr(HADDR_O, HBURST_O);  -- next address
        end if;
      -- error response
      elsif (HRESP = HRESP_ERROR) then
        burst_cnt <= (others => '0');              -- burst done (interrupted)

        HSEL   <= '0';
        HTRANS <= HTRANS_IDLE;

        data_ena <= '0';
        biu_err  <= '1';
      end if;
    end if;
  end process;

  HBURST <= HBURST_O;
  HADDR  <= HADDR_O;

  biu_err_o <= biu_err;

  -- Data section
  processing_1 : process (HCLK)
  begin
    if (rising_edge(HCLK)) then
      if (HREADY = '1') then
        biu_di_dly <= biu_d_i;
      end if;
    end if;
  end process;

  processing_2 : process (HCLK)
  begin
    if (rising_edge(HCLK)) then
      if (HREADY = '1') then
        HWDATA     <= biu_di_dly;
        biu_adro_o <= HADDR_O;
      end if;
    end if;
  end process;

  processing_3 : process (HCLK, HRESETn)
  begin
    if (HRESETn = '0') then
      data_ena_d <= '0';
    elsif (rising_edge(HCLK) or falling_edge(HRESETn)) then
      if (HREADY = '1') then
        data_ena_d <= data_ena;
      end if;
    end if;
  end process;

  biu_q_o       <= HRDATA;
  biu_ack_o     <= HREADY and data_ena_d;
  biu_d_ack_o   <= HREADY and data_ena;
  biu_stb_ack_o <= HREADY and reduce_nor(burst_cnt) and biu_stb_i and not biu_err;
end rtl;
