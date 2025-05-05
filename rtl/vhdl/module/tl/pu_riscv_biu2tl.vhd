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
--              AMBA4 AHB-Lite Bus Interface                                  --
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
--   Francisco Javier Reina Campo <pacoreinacampo@queenfield.tech>

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.peripheral_tl_vhdl_pkg.all;
use work.peripheral_biu_vhdl_pkg.all;
use work.vhdl_pkg.all;

entity pu_riscv_biu2tl is
  generic (
    XLEN           : integer := 64;
    PLEN           : integer := 64;
    AXI_ID_WIDTH   : integer := 10;
    AXI_ADDR_WIDTH : integer := 64;
    AXI_DATA_WIDTH : integer := 64;
    AXI_STRB_WIDTH : integer := 10;
    AXI_USER_WIDTH : integer := 10;
    AHB_ADDR_WIDTH : integer := 64;
    AHB_DATA_WIDTH : integer := 64
    );
  port (
    HRESETn : in std_logic;
    HCLK    : in std_logic;

    -- AXI4 instruction
    tl_aw_id     : out std_logic_vector(AXI_ID_WIDTH-1 downto 0);
    tl_aw_addr   : out std_logic_vector(AXI_ADDR_WIDTH-1 downto 0);
    tl_aw_len    : out std_logic_vector(7 downto 0);
    tl_aw_size   : out std_logic_vector(2 downto 0);
    tl_aw_burst  : out std_logic_vector(1 downto 0);
    tl_aw_lock   : out std_logic;
    tl_aw_cache  : out std_logic_vector(3 downto 0);
    tl_aw_prot   : out std_logic_vector(2 downto 0);
    tl_aw_qos    : out std_logic_vector(3 downto 0);
    tl_aw_region : out std_logic_vector(3 downto 0);
    tl_aw_user   : out std_logic_vector(AXI_USER_WIDTH-1 downto 0);
    tl_aw_valid  : out std_logic;
    tl_aw_ready  : in  std_logic;

    tl_ar_id     : out std_logic_vector(AXI_ID_WIDTH-1 downto 0);
    tl_ar_addr   : out std_logic_vector(AXI_ADDR_WIDTH-1 downto 0);
    tl_ar_len    : out std_logic_vector(7 downto 0);
    tl_ar_size   : out std_logic_vector(2 downto 0);
    tl_ar_burst  : out std_logic_vector(1 downto 0);
    tl_ar_lock   : out std_logic;
    tl_ar_cache  : out std_logic_vector(3 downto 0);
    tl_ar_prot   : out std_logic_vector(2 downto 0);
    tl_ar_qos    : out std_logic_vector(3 downto 0);
    tl_ar_region : out std_logic_vector(3 downto 0);
    tl_ar_user   : out std_logic_vector(AXI_USER_WIDTH-1 downto 0);
    tl_ar_valid  : out std_logic;
    tl_ar_ready  : in  std_logic;

    tl_w_data  : out std_logic_vector(AXI_DATA_WIDTH-1 downto 0);
    tl_w_strb  : out std_logic_vector(AXI_STRB_WIDTH-1 downto 0);
    tl_w_last  : out std_logic;
    tl_w_user  : out std_logic_vector(AXI_USER_WIDTH-1 downto 0);
    tl_w_valid : out std_logic;
    tl_w_ready : in  std_logic;

    tl_r_id    : in  std_logic_vector(AXI_ID_WIDTH-1 downto 0);
    tl_r_data  : in  std_logic_vector(AXI_DATA_WIDTH-1 downto 0);
    tl_r_resp  : in  std_logic_vector(1 downto 0);
    tl_r_last  : in  std_logic;
    tl_r_user  : in  std_logic_vector(AXI_USER_WIDTH-1 downto 0);
    tl_r_valid : in  std_logic;
    tl_r_ready : out std_logic;

    tl_b_id    : in  std_logic_vector(AXI_ID_WIDTH-1 downto 0);
    tl_b_resp  : in  std_logic_vector(1 downto 0);
    tl_b_user  : in  std_logic_vector(AXI_USER_WIDTH-1 downto 0);
    tl_b_valid : in  std_logic;
    tl_b_ready : out std_logic;

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
    biu_ack_o     : out std_logic       -- transfer acknowledge
    biu_err_o     : out std_logic       -- transfer error
    );
end pu_riscv_biu2tl;

architecture rtl of pu_riscv_biu2tl is
  component riscv_ahb2axi
    generic (
      ? : std_logic_vector(? downto 0) := ?;
      ? : std_logic_vector(? downto 0) := ?;
      ? : std_logic_vector(? downto 0) := ?;
      ? : std_logic_vector(? downto 0) := ?;
      ? : std_logic_vector(? downto 0) := ?;
      ? : std_logic_vector(? downto 0) := ?
      );
    port (
      clk            : std_logic_vector(? downto 0);
      rst_l          : std_logic_vector(? downto 0);
      scan_mode      : std_logic_vector(? downto 0);
      bus_clk_en     : std_logic_vector(? downto 0);
      tl_aw_id     : std_logic_vector(? downto 0);
      tl_aw_addr   : std_logic_vector(? downto 0);
      tl_aw_len    : std_logic_vector(? downto 0);
      tl_aw_size   : std_logic_vector(? downto 0);
      tl_aw_burst  : std_logic_vector(? downto 0);
      tl_aw_lock   : std_logic_vector(? downto 0);
      tl_aw_cache  : std_logic_vector(? downto 0);
      tl_aw_prot   : std_logic_vector(? downto 0);
      tl_aw_qos    : std_logic_vector(? downto 0);
      tl_aw_region : std_logic_vector(? downto 0);
      tl_aw_user   : std_logic_vector(? downto 0);
      tl_aw_valid  : std_logic_vector(? downto 0);
      tl_aw_ready  : std_logic_vector(? downto 0);
      tl_ar_id     : std_logic_vector(? downto 0);
      tl_ar_addr   : std_logic_vector(? downto 0);
      tl_ar_len    : std_logic_vector(? downto 0);
      tl_ar_size   : std_logic_vector(? downto 0);
      tl_ar_burst  : std_logic_vector(? downto 0);
      tl_ar_lock   : std_logic_vector(? downto 0);
      tl_ar_cache  : std_logic_vector(? downto 0);
      tl_ar_prot   : std_logic_vector(? downto 0);
      tl_ar_qos    : std_logic_vector(? downto 0);
      tl_ar_region : std_logic_vector(? downto 0);
      tl_ar_user   : std_logic_vector(? downto 0);
      tl_ar_valid  : std_logic_vector(? downto 0);
      tl_ar_ready  : std_logic_vector(? downto 0);
      tl_w_data    : std_logic_vector(? downto 0);
      tl_w_strb    : std_logic_vector(? downto 0);
      tl_w_last    : std_logic_vector(? downto 0);
      tl_w_user    : std_logic_vector(? downto 0);
      tl_w_valid   : std_logic_vector(? downto 0);
      tl_w_ready   : std_logic_vector(? downto 0);
      tl_r_id      : std_logic_vector(? downto 0);
      tl_r_data    : std_logic_vector(? downto 0);
      tl_r_resp    : std_logic_vector(? downto 0);
      tl_r_last    : std_logic_vector(? downto 0);
      tl_r_user    : std_logic_vector(? downto 0);
      tl_r_valid   : std_logic_vector(? downto 0);
      tl_r_ready   : std_logic_vector(? downto 0);
      tl_b_id      : std_logic_vector(? downto 0);
      tl_b_resp    : std_logic_vector(? downto 0);
      tl_b_user    : std_logic_vector(? downto 0);
      tl_b_valid   : std_logic_vector(? downto 0);
      tl_b_ready   : std_logic_vector(? downto 0);
      tl_hsel      : std_logic_vector(? downto 0);
      tl_haddr     : std_logic_vector(? downto 0);
      tl_hwdata    : std_logic_vector(? downto 0);
      tl_hrdata    : std_logic_vector(? downto 0);
      tl_hwrite    : std_logic_vector(? downto 0);
      tl_hsize     : std_logic_vector(? downto 0);
      tl_hburst    : std_logic_vector(? downto 0);
      tl_hprot     : std_logic_vector(? downto 0);
      tl_htrans    : std_logic_vector(? downto 0);
      tl_hmastlock : std_logic_vector(? downto 0);
      tl_hreadyin  : std_logic_vector(? downto 0);
      tl_hreadyout : std_logic_vector(? downto 0);
      tl_hresp     : std_logic_vector(? downto 0)
      );
  end component;



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
        biu_size2hsize_return <= HSIZE_BYTE;
      when "001" =>
        biu_size2hsize_return <= HSIZE_HWORD;
      when "010" =>
        biu_size2hsize_return <= HSIZE_WORD;
      when "011" =>
        biu_size2hsize_return <= HSIZE_DWORD;
      when others =>
        -- OOPSS
        biu_size2hsize_return <= X"x";
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
        biu_type2cnt_return <= 0;
      when INCR =>
        biu_type2cnt_return <= 0;
      when WRAP4 =>
        biu_type2cnt_return <= 3;
      when INCR4 =>
        biu_type2cnt_return <= 3;
      when WRAP8 =>
        biu_type2cnt_return <= 7;
      when INCR8 =>
        biu_type2cnt_return <= 7;
      when WRAP16 =>
        biu_type2cnt_return <= 15;
      when INCR16 =>
        biu_type2cnt_return <= 15;
      when others =>
        -- OOPS
        biu_type2cnt_return <= X"x";
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
        biu_type2hburst_return <= HBURST_SINGLE;
      when INCR =>
        biu_type2hburst_return <= HBURST_INCR;
      when WRAP4 =>
        biu_type2hburst_return <= HBURST_WRAP4;
      when INCR4 =>
        biu_type2hburst_return <= HBURST_INCR4;
      when WRAP8 =>
        biu_type2hburst_return <= HBURST_WRAP8;
      when INCR8 =>
        biu_type2hburst_return <= HBURST_INCR8;
      when WRAP16 =>
        biu_type2hburst_return <= HBURST_WRAP16;
      when INCR16 =>
        biu_type2hburst_return <= HBURST_INCR16;
      when others =>
        -- OOPS
        biu_type2hburst_return <= X"x";
    end case;
    return biu_type2hburst_return;
  end biu_type2hburst;



  -- convert burst type to counter length (actually length -1)
  function biu_prot2hprot (
    biu_prot : std_logic_vector(2 downto 0)

    ) return std_logic_vector is
    variable biu_prot2hprot_return : std_logic_vector (3 downto 0);
  begin
    biu_prot2hprot_return <= HPROT_DATA
                             when biu_prot and PROT_DATA else HPROT_OPCODE;
    biu_prot2hprot_return <= biu_prot2hprot_return or (HPROT_PRIVILEGED
                                                       when biu_prot and PROT_PRIVILEGED else HPROT_USER);
    biu_prot2hprot_return <= biu_prot2hprot_return or (HPROT_CACHEABLE
                                                       when biu_prot and PROT_CACHEABLE else HPROT_NON_CACHEABLE);
    return biu_prot2hprot_return;
  end biu_prot2hprot;



  -- convert burst type to counter length (actually length -1)
  function nxt_addr (
    addr   : std_logic_vector(PLEN-1 downto 0);  -- current address
    hburst : std_logic_vector(2 downto 0)        -- AHB hburst

    ) return std_logic_vector is
    variable nxt_addr_return : std_logic_vector (PLEN-1 downto 0);
  begin
    -- next linear address
    if (XLEN = 32) then
      nxt_addr_return <= (addr+X"4") and not X"3";
    else

      nxt_addr_return <= (addr+X"8") and not X"7";
    end if;
    -- wrap?
    case ((hburst)) is
      when HBURST_WRAP4 =>
        nxt_addr_return <= (addr(PLEN-1 downto 4) & nxt_addr_return(3 downto 0))
                           when (XLEN = 32) else (addr(PLEN-1 downto 5) & nxt_addr_return(4 downto 0));
      when HBURST_WRAP8 =>
        nxt_addr_return <= (addr(PLEN-1 downto 5) & nxt_addr_return(4 downto 0))
                           when (XLEN = 32) else (addr(PLEN-1 downto 6) & nxt_addr_return(5 downto 0));
      when HBURST_WRAP16 =>
        nxt_addr_return <= (addr(PLEN-1 downto 6) & nxt_addr_return(5 downto 0))
                           when (XLEN = 32) else (addr(PLEN-1 downto 7) & nxt_addr_return(6 downto 0));
      when others =>
        null;
    end case;
    return nxt_addr_return;
  end nxt_addr;



  ------------------------------------------------------------------------------
  -- Variables
  ------------------------------------------------------------------------------

  signal burst_cnt            : std_logic_vector(3 downto 0);
  signal data_ena, data_ena_d : std_logic;
  signal biu_di_dly           : std_logic_vector(XLEN-1 downto 0);

  signal hsel      : std_logic;
  signal haddr     : std_logic_vector(PLEN-1 downto 0);
  signal hrdata    : std_logic_vector(XLEN-1 downto 0);
  signal hwdata    : std_logic_vector(XLEN-1 downto 0);
  signal hwrite    : std_logic;
  signal hsize     : std_logic_vector(2 downto 0);
  signal hburst    : std_logic_vector(2 downto 0);
  signal hprot     : std_logic_vector(3 downto 0);
  signal htrans    : std_logic_vector(1 downto 0);
  signal hmastlock : std_logic;
  signal hready    : std_logic;
  signal hresp     : std_logic;

begin
  ------------------------------------------------------------------------------
  -- Module Body
  ------------------------------------------------------------------------------

  -- State Machine
  processing_0 : process (HCLK, HRESETn)
  begin
    if (not HRESETn) then
      data_ena  <= '0';
      biu_err_o <= '0';
      burst_cnt <= X"0";

      hsel      <= '0';
      haddr     <= X"0";
      hwrite    <= '0';
      hsize     <= X"0";                -- don't care
      hburst    <= X"0";                -- don't care
      hprot     <= HPROT_DATA or HPROT_PRIVILEGED or HPROT_NON_BUFFERABLE or HPROT_NON_CACHEABLE;
      htrans    <= HTRANS_IDLE;
      hmastlock <= '0';
    elsif (rising_edge(HCLK)) then
      -- strobe/ack signals
      biu_err_o <= '0';

      if (hready) then
        if (nor burst_cnt) then         -- burst complete
          if (biu_stb_i and not biu_err_o) then
            data_ena  <= '1';
            burst_cnt <= (null)(biu_type_i);

            hsel      <= '1';
            htrans    <= HTRANS_NONSEQ;  -- start of burst
            haddr     <= biu_adri_i;
            hwrite    <= biu_we_i;
            hsize     <= (null)(biu_size_i);
            hburst    <= (null)(biu_type_i);
            hprot     <= (null)(biu_prot_i);
            hmastlock <= biu_lock_i;
          else

            data_ena  <= '0';
            hsel      <= '0';
            htrans    <= HTRANS_IDLE;   -- no new transfer
            hmastlock <= biu_lock_i;
          end if;
        else                            -- continue burst
          data_ena  <= '1';
          burst_cnt <= burst_cnt-1;

          htrans <= HTRANS_SEQ;             -- continue burst
          haddr  <= (null)(haddr, hburst);  -- next address
        end if;
      -- error response
      elsif (hresp = HRESP_ERROR) then
        burst_cnt <= X"0";                  -- burst done (interrupted)

        hsel   <= '0';
        htrans <= HTRANS_IDLE;

        data_ena  <= '0';
        biu_err_o <= '1';
      end if;
    end if;
  end process;


  -- Data section
  processing_1 : process (HCLK)
  begin
    if (rising_edge(HCLK)) then
      if (hready) then
        biu_di_dly <= biu_d_i;
      end if;
    end if;
  end process;


  processing_2 : process (HCLK)
  begin
    if (rising_edge(HCLK)) then
      if (hready) then
        hwdata     <= biu_di_dly;
        biu_adro_o <= haddr;
      end if;
    end if;
  end process;


  processing_3 : process (HCLK, HRESETn)
  begin
    if (not HRESETn) then
      data_ena_d <= '0';
    elsif (rising_edge(HCLK)) then
      if (hready) then
        data_ena_d <= data_ena;
      end if;
    end if;
  end process;


  biu_q_o       <= hrdata;
  biu_ack_o     <= hready and data_ena_d;
  biu_d_ack_o   <= hready and data_ena;
  biu_stb_ack_o <= hready and nor burst_cnt and biu_stb_i and not biu_err_o;

  ahb2axi : riscv_ahb2axi
    generic map (
      AXI_ID_WIDTH,
      AXI_ADDR_WIDTH,
      AXI_DATA_WIDTH,
      AXI_STRB_WIDTH,

      AHB_ADDR_WIDTH,
      AHB_DATA_WIDTH
      )
    port map (
      clk   => HCLK,
      rst_l => HRESETn,

      scan_mode  => '1',
      bus_clk_en => '1',

      -- AXI4 signals
      tl_aw_id     => tl_aw_id,
      tl_aw_addr   => tl_aw_addr,
      tl_aw_len    => tl_aw_len,
      tl_aw_size   => tl_aw_size,
      tl_aw_burst  => tl_aw_burst,
      tl_aw_lock   => tl_aw_lock,
      tl_aw_cache  => tl_aw_cache,
      tl_aw_prot   => tl_aw_prot,
      tl_aw_qos    => tl_aw_qos,
      tl_aw_region => tl_aw_region,
      tl_aw_user   => tl_aw_user,
      tl_aw_valid  => tl_aw_valid,
      tl_aw_ready  => tl_aw_ready,
      tl_ar_id     => tl_ar_id,
      tl_ar_addr   => tl_ar_addr,
      tl_ar_len    => tl_ar_len,
      tl_ar_size   => tl_ar_size,
      tl_ar_burst  => tl_ar_burst,
      tl_ar_lock   => tl_ar_lock,
      tl_ar_cache  => tl_ar_cache,
      tl_ar_prot   => tl_ar_prot,
      tl_ar_qos    => tl_ar_qos,
      tl_ar_region => tl_ar_region,
      tl_ar_user   => tl_ar_user,
      tl_ar_valid  => tl_ar_valid,
      tl_ar_ready  => tl_ar_ready,
      tl_w_data    => tl_w_data,
      tl_w_strb    => tl_w_strb,
      tl_w_last    => tl_w_last,
      tl_w_user    => tl_w_user,
      tl_w_valid   => tl_w_valid,
      tl_w_ready   => tl_w_ready,
      tl_r_id      => tl_r_id,
      tl_r_data    => tl_r_data,
      tl_r_resp    => tl_r_resp,
      tl_r_last    => tl_r_last,
      tl_r_user    => tl_r_user,
      tl_r_valid   => tl_r_valid,
      tl_r_ready   => tl_r_ready,
      tl_b_id      => tl_b_id,
      tl_b_resp    => tl_b_resp,
      tl_b_user    => tl_b_user,
      tl_b_valid   => tl_b_valid,
      tl_b_ready   => tl_b_ready,

      -- AHB4 signals
      tl_hsel      => hsel,
      tl_haddr     => haddr,
      tl_hwdata    => hwdata,
      tl_hrdata    => hrdata,
      tl_hwrite    => hwrite,
      tl_hsize     => hsize,
      tl_hburst    => hburst,
      tl_hprot     => hprot,
      tl_htrans    => htrans,
      tl_hmastlock => hmastlock,
      tl_hreadyin  => hreadyin,
      tl_hreadyout => hreadyout,
      tl_hresp     => hresp
      );
end rtl;
