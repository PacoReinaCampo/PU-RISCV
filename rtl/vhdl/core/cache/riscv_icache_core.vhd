-- Converted from rtl/verilog/core/cache/riscv_icache_core.sv
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
--              MPSoC-RISCV CPU                                               //
--              Core - Instruction Cache (Write Back)                         //
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

use work.peripheral_biu_pkg.all;
use work.vhdl_pkg.all;

entity riscv_icache_core is
  generic (
    XLEN : integer := 64;
    PLEN : integer := 64;

    PARCEL_SIZE : integer := 64;

    ICACHE_SIZE        : integer := 64;
    ICACHE_BLOCK_SIZE  : integer := 64;
    ICACHE_WAYS        : integer := 2;
    ICACHE_REPLACE_ALG : integer := 0;

    TECHNOLOGY : string := "GENERIC"
  );
  port (
    rst_ni : in std_logic;
    clk_i  : in std_logic;
    clr_i  : in std_logic;  --clear any pending request

    --CPU side
    mem_vreq_i : in  std_logic;
    mem_preq_i : in  std_logic;
    mem_vadr_i : in  std_logic_vector(XLEN-1 downto 0);
    mem_padr_i : in  std_logic_vector(PLEN-1 downto 0);
    mem_size_i : in  std_logic_vector(2 downto 0);
    mem_lock_i : in  std_logic;
    mem_prot_i : in  std_logic_vector(2 downto 0);
    mem_q_o    : out std_logic_vector(PARCEL_SIZE-1 downto 0);
    mem_ack_o  : out std_logic;
    mem_err_o  : out std_logic;
    flush_i    : in  std_logic;
    flushrdy_i : in  std_logic;

    --To BIU
    biu_stb_o     : out std_logic;  --access request
    biu_stb_ack_i : in  std_logic;  --access acknowledge
    biu_d_ack_i   : in  std_logic;  --BIU needs new data (biu_d_o)
    biu_adri_o    : out std_logic_vector(PLEN-1 downto 0);  --access start address
    biu_adro_i    : in  std_logic_vector(PLEN-1 downto 0);
    biu_size_o    : out std_logic_vector(2 downto 0);  --transfer size
    biu_type_o    : out std_logic_vector(2 downto 0);  --burst type
    biu_lock_o    : out std_logic;  --locked transfer
    biu_prot_o    : out std_logic_vector(2 downto 0);  --protection bits
    biu_we_o      : out std_logic;  --write enable
    biu_d_o       : out std_logic_vector(XLEN-1 downto 0);  --write data
    biu_q_i       : in  std_logic_vector(XLEN-1 downto 0);  --read data
    biu_ack_i     : in  std_logic;  --transfer acknowledge
    biu_err_i     : in  std_logic  --transfer error
  );
end riscv_icache_core;

architecture rtl of riscv_icache_core is
  component riscv_ram_1rw
    generic (
      ABITS      : integer := 10;
      DBITS      : integer := 32;
      TECHNOLOGY : string := "GENERIC"
    );
    port (
      rst_ni : in std_logic;
      clk_i  : in std_logic;

      addr_i : in  std_logic_vector(ABITS-1 downto 0);
      we_i   : in  std_logic;
      be_i   : in  std_logic_vector((DBITS+7)/8-1 downto 0);
      din_i  : in  std_logic_vector(DBITS-1 downto 0);
      dout_o : out std_logic_vector(DBITS-1 downto 0)
    );
  end component;

  ------------------------------------------------------------------------------
  -- Constants
  ------------------------------------------------------------------------------

  ------------------------------------------------------------------
  -- Cache
  ------------------------------------------------------------------
  constant PAGE_SIZE    : integer := 4*1024;  --4KB pages
  constant MAX_IDX_BITS : integer := integer(log2(real(PAGE_SIZE)))-integer(log2(real(ICACHE_BLOCK_SIZE)));  --Maximum IDX_BITS

  constant SETS         : integer := (ICACHE_SIZE*1024)/ICACHE_BLOCK_SIZE/ICACHE_WAYS;  --Number of sets TODO:SETS=1 doesn't work
  constant BLK_OFF_BITS : integer := integer(log2(real(ICACHE_BLOCK_SIZE)));  --Number of BlockOffset bits
  constant IDX_BITS     : integer := integer(log2(real(SETS)));  --Number of Index-bits
  constant TAG_BITS     : integer := XLEN-IDX_BITS-BLK_OFF_BITS;  --Number of TAG-bits
  constant BLK_BITS     : integer := 8*ICACHE_BLOCK_SIZE;  --Total number of bits in a Block
  constant BURST_SIZE   : integer := BLK_BITS/XLEN;  --Number of transfers to load 1 Block
  constant BURST_BITS   : integer := integer(log2(real(BURST_SIZE)));
  constant BURST_OFF    : integer := XLEN/8;
  constant BURST_LSB    : integer := integer(log2(real(BURST_OFF)));

  --BLOCK decoding
  constant DAT_OFF_BITS    : integer := integer(log2(real(BLK_BITS/XLEN)));  --Offset in block
  constant PARCEL_OFF_BITS : integer := integer(log2(real(XLEN/PARCEL_SIZE)));

  ------------------------------------------------------------------------------
  -- Constants
  ------------------------------------------------------------------------------
  constant ARMED        : std_logic_vector(2 downto 0) := "000";
  constant FLUSH        : std_logic_vector(2 downto 0) := "001";
  constant WAIT4BIUCMD0 : std_logic_vector(2 downto 0) := "010";
  constant RECOVER      : std_logic_vector(2 downto 0) := "100";

  constant IDLE     : std_logic_vector(1 downto 0) := "00";
  constant WAIT4BIU : std_logic_vector(1 downto 0) := "01";
  constant BURST    : std_logic_vector(1 downto 0) := "10";

  constant NOP       : std_logic_vector(1 downto 0) := "00";
  constant WRITE_WAY : std_logic_vector(1 downto 0) := "01";
  constant READ_WAY  : std_logic_vector(1 downto 0) := "10";

  ------------------------------------------------------------------------------
  -- Functions
  ------------------------------------------------------------------------------
  function size2be (
    size : std_logic_vector(2 downto 0);
    adr  : std_logic_vector(XLEN-1 downto 0)
    ) return std_logic_vector is
    variable adr_lsbs       : std_logic_vector(integer(log2(real(XLEN/8)))-1 downto 0);
    variable size2be_return : std_logic_vector (XLEN/8-1 downto 0);
  begin
    adr_lsbs := adr(integer(log2(real(XLEN/8)))-1 downto 0);

    case (size) is
      when BYTE =>
        size2be_return := std_logic_vector(to_unsigned(1, XLEN/8) sll to_integer(unsigned(adr_lsbs)));
      when HWORD =>
        size2be_return := std_logic_vector(to_unsigned(3, XLEN/8) sll to_integer(unsigned(adr_lsbs)));
      when WORD =>
        size2be_return := std_logic_vector(to_unsigned(15, XLEN/8) sll to_integer(unsigned(adr_lsbs)));
      when DWORD =>
        size2be_return := std_logic_vector(to_unsigned(255, XLEN/8) sll to_integer(unsigned(adr_lsbs)));
      when others =>
        null;
    end case;

    return size2be_return;
  end size2be;

  ------------------------------------------------------------------------------
  -- Variables
  ------------------------------------------------------------------------------

  --Memory Interface State Machine Section
  signal mem_vreq_dly : std_logic;
  signal mem_preq_dly : std_logic;
  signal mem_vadr_dly : std_logic_vector(XLEN-1 downto 0);
  signal mem_padr_dly : std_logic_vector(PLEN-1 downto 0);
  signal mem_be       : std_logic_vector(XLEN/8-1 downto 0);
  signal mem_be_dly   : std_logic_vector(XLEN/8-1 downto 0);

  signal core_tag      : std_logic_vector(TAG_BITS-1 downto 0);
  signal core_tag_hold : std_logic_vector(TAG_BITS-1 downto 0);

  signal hold_flush : std_logic;  --stretch flush_i until FSM is ready to serve

  signal memfsm_state : std_logic_vector(2 downto 0);

  --Cache Section
  signal tag_idx      : std_logic_vector(IDX_BITS-1 downto 0);
  signal tag_idx_dly  : std_logic_vector(IDX_BITS-1 downto 0);  --delayed version for writing valid/dirty
  signal tag_idx_hold : std_logic_vector(IDX_BITS-1 downto 0);  --stretched version for writing TAG during fill
  signal vadr_idx     : std_logic_vector(IDX_BITS-1 downto 0);  --index bits extracted from vadr_i
  signal vadr_dly_idx : std_logic_vector(IDX_BITS-1 downto 0);  --index bits extracted from vadr_dly
  signal padr_idx     : std_logic_vector(IDX_BITS-1 downto 0);
  signal padr_dly_idx : std_logic_vector(IDX_BITS-1 downto 0);

  signal tag_we : std_logic_vector(ICACHE_WAYS-1 downto 0);

  signal tag_in_valid : std_logic_vector(ICACHE_WAYS-1 downto 0);
  signal tag_in_tag   : std_logic_matrix(ICACHE_WAYS-1 downto 0)(TAG_BITS-1 downto 0);

  signal tag_out_valid : std_logic_vector(ICACHE_WAYS-1 downto 0);
  signal tag_out_tag   : std_logic_matrix(ICACHE_WAYS-1 downto 0)(TAG_BITS-1 downto 0);

  signal tag_byp_idx : std_logic_matrix(ICACHE_WAYS-1 downto 0)(IDX_BITS-1 downto 0);
  signal tag_byp_tag : std_logic_matrix(ICACHE_WAYS-1 downto 0)(TAG_BITS-1 downto 0);
  signal tag_valid   : std_logic_matrix(ICACHE_WAYS-1 downto 0)(SETS-1 downto 0);

  signal dat_idx     : std_logic_vector(IDX_BITS-1 downto 0);
  signal dat_idx_dly : std_logic_vector(IDX_BITS-1 downto 0);
  signal dat_we      : std_logic_vector(ICACHE_WAYS-1 downto 0);
  signal dat_be      : std_logic_vector(BLK_BITS/8-1 downto 0);
  signal dat_in      : std_logic_vector(BLK_BITS-1 downto 0);
  signal dat_out     : std_logic_matrix(ICACHE_WAYS-1 downto 0)(BLK_BITS-1 downto 0);

  signal way_q_mux   : std_logic_matrix(ICACHE_WAYS-1 downto 0)(BLK_BITS-1 downto 0);
  signal way_hit     : std_logic_vector(ICACHE_WAYS-1 downto 0);
  signal way_compare : std_logic_matrix(ICACHE_WAYS-1 downto 0)(TAG_BITS-1 downto 0);

  signal dat_offset    : std_logic_vector(DAT_OFF_BITS-1 downto 0);
  signal parcel_offset : std_logic_vector(PARCEL_OFF_BITS downto 0);

  signal cache_hit : std_logic;
  signal cache_q   : std_logic_vector(XLEN-1 downto 0);

  signal way_random           : std_logic_vector(19 downto 0);
  signal fill_way_select      : std_logic_vector(ICACHE_WAYS-1 downto 0);
  signal fill_way_select_hold : std_logic_vector(ICACHE_WAYS-1 downto 0);

  signal biu_adro_eq_cache_adr_dly : std_logic;
  signal flushing                  : std_logic;
  signal filling                   : std_logic;
  signal flush_idx                 : std_logic_vector(IDX_BITS-1 downto 0);

  --Bus Interface State Machine Section
  signal biufsm_state : std_logic_vector(1 downto 0);

  signal biucmd : std_logic_vector(1 downto 0);

  signal biufsm_ack           : std_logic;
  signal biufsm_err           : std_logic;
  signal biufsm_ack_write_way : std_logic;  --BIU FSM should generate biufsm_ack on WRITE_WAY
  signal biu_buffer           : std_logic_vector(BLK_BITS-1 downto 0);
  signal biu_buffer_valid     : std_logic_vector(BURST_SIZE-1 downto 0);
  signal in_biubuffer         : std_logic;

  signal biu_adri_hold : std_logic_vector(PLEN-1 downto 0);
  signal biu_d_hold    : std_logic_vector(XLEN-1 downto 0);

  signal cache_biu : std_logic_vector(BLK_BITS-1 downto 0);

  signal burst_cnt : std_logic_vector(BURST_BITS-1 downto 0);

  --CPU side
  signal mem_ack : std_logic;

  --To BIU
  signal biu_adri : std_logic_vector(PLEN-1 downto 0);  --access start address
  signal biu_d    : std_logic_vector(XLEN-1 downto 0);  --write data

begin
  ------------------------------------------------------------------------------
  -- Module Body
  ------------------------------------------------------------------------------

  ------------------------------------------------------------------
  -- Memory Interface State Machine
  ------------------------------------------------------------------

  --generate cache_* signals
  mem_be <= size2be(mem_size_i, mem_vadr_i);

  --generate delayed mem_* signals
  processing_0 : process (clk_i, rst_ni)
  begin
    if (rst_ni = '0') then
      mem_vreq_dly <= '0';
    elsif (rising_edge(clk_i)) then
      if (clr_i = '1') then
        mem_vreq_dly <= '0';
      else
        mem_vreq_dly <= mem_vreq_i or (mem_vreq_dly and not mem_ack);
      end if;
    end if;
  end process;

  processing_1 : process (clk_i, rst_ni)
  begin
    if (rst_ni = '0') then
      mem_preq_dly <= '0';
    elsif (rising_edge(clk_i)) then
      if (clr_i = '1') then
        mem_preq_dly <= '0';
      else
        mem_preq_dly <= (mem_preq_i or mem_preq_dly) and not mem_ack;
      end if;
    end if;
  end process;

  --register memory signals
  processing_2 : process (clk_i)
  begin
    if (rising_edge(clk_i)) then
      if (mem_vreq_i = '1') then
        mem_vadr_dly <= mem_vadr_i;
        mem_be_dly   <= mem_be;
      end if;
    end if;
  end process;

  processing_3 : process (clk_i)
  begin
    if (rising_edge(clk_i)) then
      if (mem_preq_i = '1') then
        mem_padr_dly <= mem_padr_i;
      end if;
    end if;
  end process;

  --extract index bits from virtual address(es)
  vadr_idx     <= mem_vadr_i(BLK_OFF_BITS+IDX_BITS-1 downto BLK_OFF_BITS);
  vadr_dly_idx <= mem_vadr_dly(BLK_OFF_BITS+IDX_BITS-1 downto BLK_OFF_BITS);
  padr_idx     <= mem_padr_i(BLK_OFF_BITS+IDX_BITS-1 downto BLK_OFF_BITS);
  padr_dly_idx <= mem_padr_dly(BLK_OFF_BITS+IDX_BITS-1 downto BLK_OFF_BITS);

  --extract core_tag from physical address
  core_tag <= mem_padr_i(XLEN-1 downto XLEN-TAG_BITS);

  --hold core_tag during filling. Prevents new mem_req (during fill) to mess up the 'tag' value
  processing_4 : process (clk_i)
  begin
    if (rising_edge(clk_i)) then
      if (filling = '0') then
        core_tag_hold <= core_tag;
      end if;
    end if;
  end process;

  --hold flush until ready to service it
  processing_5 : process (clk_i, rst_ni)
  begin
    if (rst_ni = '0') then
      hold_flush <= '0';
    elsif (rising_edge(clk_i)) then
      hold_flush <= not flushing and (flush_i or hold_flush);
    end if;
  end process;

  --State Machine
  processing_6 : process (clk_i, rst_ni)
  begin
    if (rst_ni = '0') then
      memfsm_state <= ARMED;
      flushing     <= '0';
      filling      <= '0';
      biucmd       <= NOP;
    elsif (rising_edge(clk_i)) then
      case ((memfsm_state)) is
        when ARMED =>
          if (flush_i = '1' or hold_flush = '1') then
            memfsm_state <= FLUSH;
            flushing     <= '1';
          elsif (mem_vreq_dly = '1' and cache_hit = '0' and (mem_preq_i or mem_preq_dly) = '1') then  --it takes 1 cycle to read TAG
            --Load way
            memfsm_state <= WAIT4BIUCMD0;
            biucmd       <= READ_WAY;
            filling      <= '1';
          else
            biucmd <= NOP;
          end if;
        when FLUSH =>
          if (flushrdy_i = '1') then
            memfsm_state <= RECOVER;  --allow to read new tag_idx
            flushing     <= '0';
          end if;
        when WAIT4BIUCMD0 =>
          if (biufsm_err = '1') then
            if (vadr_idx /= tag_idx_hold) then
              memfsm_state <= RECOVER;
            else
              memfsm_state <= ARMED;
            end if;
            biucmd  <= NOP;
            filling <= '0';
          elsif (biufsm_ack = '1') then
            if (vadr_idx /= tag_idx_hold) then
              memfsm_state <= RECOVER;
            else
              memfsm_state <= ARMED;
            end if;
            biucmd  <= NOP;
            filling <= '0';
          end if;
        when RECOVER =>
          --Allow DATA memory read after writing/filling
          memfsm_state <= ARMED;
          biucmd       <= NOP;
          filling      <= '0';
        when others =>
          null;
      end case;
    end if;
  end process;

  --address check, used in a few places
  biu_adro_eq_cache_adr_dly <= to_stdlogic(biu_adro_i(PLEN-1 downto BURST_LSB) = mem_padr_i(PLEN-1 downto BURST_LSB));

  --signal downstream that data is ready
  processing_7 : process (memfsm_state, biu_ack_i, biu_adro_eq_cache_adr_dly, cache_hit, mem_preq_dly, mem_preq_i, mem_vreq_dly)
  begin
    case (memfsm_state) is
      when ARMED =>
        mem_ack <= mem_vreq_dly and (mem_preq_i or mem_preq_dly) and cache_hit;
      when WAIT4BIUCMD0 =>
        mem_ack <= mem_vreq_dly and (mem_preq_i or mem_preq_dly) and biu_ack_i and biu_adro_eq_cache_adr_dly;
      when others =>
        mem_ack <= '0';
    end case;
  end process;

  mem_ack_o <= mem_ack;

  --signal downstream the BIU reported an error
  mem_err_o <= biu_err_i;

  --Assign mem_q
  --biu_q_i and cache_q are XLEN size. If PARCEL_SIZE is smaller, adjust
  parcel_offset <= mem_vadr_dly(1+PARCEL_OFF_BITS downto 1);  --[1 +: PARCEL_OFF_BITS] errors out

  processing_8 : process (memfsm_state, biu_q_i, cache_q, parcel_offset)
  begin
    case (memfsm_state) is
      when WAIT4BIUCMD0 =>
        mem_q_o <= std_logic_vector(unsigned(biu_q_i) srl (to_integer(unsigned(parcel_offset))*16));
      when others =>
        mem_q_o <= std_logic_vector(unsigned(cache_q) srl (to_integer(unsigned(parcel_offset))*16));
    end case;
  end process;

  ------------------------------------------------------------------
  -- End Memory Interface State Machine
  ------------------------------------------------------------------

  ------------------------------------------------------------------
  -- TAG and Data memory
  ------------------------------------------------------------------

  --TAG
  generating_0 : for way in 0 to ICACHE_WAYS - 1 generate
    --TAG is stored in RAM
    tag_ram : riscv_ram_1rw
      generic map (
        ABITS      => IDX_BITS,
        DBITS      => TAG_BITS,
        TECHNOLOGY => TECHNOLOGY
      )
      port map (
        rst_ni => rst_ni,
        clk_i  => clk_i,
        addr_i => tag_idx,
        we_i   => tag_we(way),
        be_i   => (others => '1'),
        din_i  => tag_in_tag(way),
        dout_o => tag_out_tag(way)
      );

    --tag-register for bypass (RAW hazard)
    processing_9 : process (clk_i)
    begin
      if (rising_edge(clk_i)) then
        if (tag_we(way) = '1') then
          tag_byp_tag(way) <= tag_in_tag(way);
          tag_byp_idx(way) <= tag_idx;
        end if;
      end if;
    end process;

    --Valid is stored in DFF
    processing_10 : process (clk_i, rst_ni)
    begin
      if (rst_ni = '0') then
        tag_valid(way) <= (others => '0');
      elsif (rising_edge(clk_i)) then
        if (flush_i = '1') then
          tag_valid(way) <= (others => '0');
        elsif (tag_we(way) = '1') then
          tag_valid(way)(to_integer(unsigned(tag_idx))) <= tag_in_valid(way);
        end if;
      end if;
    end process;

    tag_out_valid(way) <= tag_valid(way)(to_integer(unsigned(tag_idx_dly)));

    --compare way-tag to TAG
    way_hit(way) <= tag_out_valid(way) and to_stdlogic(core_tag = way_compare(way));

    way_compare(way) <= tag_byp_tag(way)
                     when (tag_idx_dly = tag_byp_idx(way)) else tag_out_tag(way);
  end generate;

  -- Generate 'hit'
  cache_hit <= reduce_or(way_hit);  -- & mem_vreq_dly;

  --DATA
  generating_1 : for way in 0 to ICACHE_WAYS - 1 generate
    data_ram : riscv_ram_1rw
      generic map (
        ABITS      =>IDX_BITS,
        DBITS      =>BLK_BITS,
        TECHNOLOGY => TECHNOLOGY
      )
      port map (
        rst_ni => rst_ni,
        clk_i  => clk_i,
        addr_i => dat_idx,
        we_i   => dat_we(way),
        be_i   => dat_be,
        din_i  => dat_in,
        dout_o => dat_out(way)
      );

    --assign way_q; Build MUX (AND/OR) structure
    generating_2 : if (way = 0) generate
      way_q_mux(way) <= dat_out(way) and (BLK_BITS-1 downto 0 => way_hit(way));
    end generate generating_2;
    generating_3 : if (way /= 0) generate
      way_q_mux(way) <= (dat_out(way) and (BLK_BITS-1 downto 0 => way_hit(way))) or way_q_mux(way-1);
    end generate generating_3;
  end generate generating_1;

--get requested data (XLEN-size) from way_q_mux(BLK_BITS-size)
  --in_biubuffer <= to_stdlogic(biu_adri_hold(PLEN-1 downto BLK_OFF_BITS) = (mem_padr_dly(PLEN-1 downto BLK_OFF_BITS) and std_logic_vector(unsigned(biu_buffer_valid(PLEN+BLK_OFF_BITS-1 downto 0)) srl to_integer(unsigned(dat_offset)))))
                  --when mem_preq_dly = '1' else to_stdlogic(biu_adri_hold(PLEN-1 downto BLK_OFF_BITS) = (mem_padr_i(PLEN-1 downto BLK_OFF_BITS) and std_logic_vector(unsigned(biu_buffer_valid(PLEN+BLK_OFF_BITS-1 downto 0)) srl to_integer(unsigned(dat_offset)))));

  cache_biu <= biu_buffer
               when in_biubuffer = '1' else way_q_mux(ICACHE_WAYS-1);
  cache_q <= std_logic_vector((unsigned(cache_biu(XLEN-1 downto 0))) srl (to_integer(unsigned(dat_offset)*XLEN)));

  ------------------------------------------------------------------
  -- END TAG and Data memory
  ------------------------------------------------------------------

  ------------------------------------------------------------------
  -- TAG and Data memory control signals
  ------------------------------------------------------------------

  --Random generator for RANDOM replacement algorithm
  processing_11 : process (clk_i, rst_ni)
  begin
    if (rst_ni = '0') then
      way_random <= (others => '0');
    elsif (rising_edge(clk_i)) then
      if (filling = '0') then
        way_random <= way_random(19 downto 1) & (way_random(19) xnor way_random(16));
      end if;
    end if;
  end process;

  --select which way to fill
  fill_way_select <= std_logic_vector(to_unsigned(1, ICACHE_WAYS))
                     when (ICACHE_WAYS = 1) else std_logic_vector(to_unsigned(2**to_integer(unsigned(way_random(integer(log2(real(ICACHE_WAYS)))-1 downto 0))), ICACHE_WAYS));

  --FILL / WRITE_WAYS use fill_way_select 1 cycle later
  --processing_12 : process (clk_i)
  --begin
    --if (rising_edge(clk_i)) then
      --case (memfsm_state) is
        --when ARMED =>
          --fill_way_select_hold <= fill_way_select;
        --when others =>
          --null;
      --end case;
    --end if;
  --end process;

  --TAG Index
  processing_13 : process (flush_idx, mem_vreq_dly, memfsm_state, tag_idx_hold, vadr_dly_idx, vadr_idx)
  begin
    case (memfsm_state) is
      --TAG write
      when WAIT4BIUCMD0 =>
        tag_idx <= tag_idx_hold;
      --TAG read
      when FLUSH =>
        tag_idx <= flush_idx;
      when RECOVER =>
        --pending access
        --new access
        if (mem_vreq_dly = '1') then
          tag_idx <= vadr_dly_idx;
        else
          tag_idx <= vadr_idx;
        end if;
      when others =>
        --current access
        tag_idx <= vadr_idx;
    end case;
  end process;

  --registered version, for tag_valid
  processing_14 : process (clk_i)
  begin
    if (rising_edge(clk_i)) then
      tag_idx_dly <= tag_idx;
    end if;
  end process;

  --hold tag-idx; prevent new mem_vreq_i from messing up tag during filling
  processing_15 : process (clk_i)
  begin
    if (rising_edge(clk_i)) then
      case (memfsm_state) is
        when ARMED =>
          if (mem_vreq_dly = '1' and cache_hit = '0') then
            tag_idx_hold <= vadr_dly_idx;
          end if;
        when RECOVER =>
          --pending access
          --current access
          if (mem_vreq_dly = '1') then
            tag_idx_hold <= vadr_dly_idx;
          else
            tag_idx_hold <= vadr_idx;
          end if;
        when others =>
          null;
      end case;
    end if;
  end process;

  --TAG Write Enable
  --Update tag during flushing    (clear valid bits)
  generating_3 : for way in 0 to ICACHE_WAYS - 1 generate
    processing_16 : process(memfsm_state, filling, fill_way_select_hold, biufsm_ack)
    begin
      case (memfsm_state) is
        when others =>
          tag_we(way) <= filling and fill_way_select_hold(way) and biufsm_ack;
      end case;
    end process;
  end generate;

  --TAG Write Data
  generating_4 : for way in 0 to ICACHE_WAYS - 1 generate
    --clear valid tag during flushing and cache-coherency checks
    tag_in_valid(way) <= not flushing;

    tag_in_tag(way) <= core_tag_hold;
  end generate;

  --Shift amount for data
  dat_offset <= mem_vadr_dly(BLK_OFF_BITS+DAT_OFF_BITS-1 downto BLK_OFF_BITS);

  --DAT Byte Enable
  dat_be <= (others => '1');

  --DAT Index
  processing_17 : process (mem_vreq_dly, memfsm_state, tag_idx_hold, vadr_dly_idx, vadr_idx)
  begin
    case ((memfsm_state)) is
      when ARMED =>
        --read access
        dat_idx <= vadr_idx;
      when RECOVER =>
        --read pending cycle
        --read new access
        if (mem_vreq_dly = '1') then
          dat_idx <= vadr_dly_idx;
        else
          dat_idx <= vadr_idx;
        end if;
      when others =>
        dat_idx <= tag_idx_hold;
    end case;
  end process;

  --delayed dat_idx
  processing_18 : process (clk_i)
  begin
    if (rising_edge(clk_i)) then
      dat_idx_dly <= dat_idx;
    end if;
  end process;

  --DAT Write Enable
  generating_5 : for way in 0 to ICACHE_WAYS - 1 generate
    processing_19 : process (biufsm_ack, fill_way_select_hold, memfsm_state)
    begin
      case ((memfsm_state)) is
        when WAIT4BIUCMD0 =>
          --write BIU data
          dat_we(way) <= fill_way_select_hold(way) and biufsm_ack;
        when others =>
          dat_we(way) <= '0';
      end case;
    end process;
  end generate;

  --DAT Write Data
  processing_20 : process (biu_adro_i, biu_buffer, biu_q_i)
  begin
    dat_in <= biu_buffer;  --dat_in = biu_buffer
    dat_in(to_integer(unsigned(biu_adro_i(BLK_OFF_BITS+DAT_OFF_BITS-1 downto BLK_OFF_BITS)))*XLEN+XLEN-1 downto to_integer(unsigned(biu_adro_i(BLK_OFF_BITS+DAT_OFF_BITS-1 downto BLK_OFF_BITS)))*XLEN) <= biu_q_i;  --except for last transaction
  end process;

  ------------------------------------------------------------------
  -- TAG and Data memory control signals
  ------------------------------------------------------------------

  ------------------------------------------------------------------
  -- Bus Interface State Machine
  ------------------------------------------------------------------
  biu_lock_o <= '0';
  biu_prot_o <= (mem_prot_i or PROT_CACHEABLE);

  processing_21 : process (clk_i, rst_ni)
  begin
    if (rst_ni = '0') then
      biufsm_state <= IDLE;
    elsif (rising_edge(clk_i)) then
      case ((biufsm_state)) is
        when IDLE =>
          case ((biucmd)) is
            when NOP =>
              --do nothing
              null;
            when READ_WAY =>
              --read a way from main memory
              if (biu_stb_ack_i = '1') then
                biufsm_state <= BURST;
              else  --BIU is not ready to start a new transfer
                biufsm_state <= WAIT4BIU;
              end if;
            when WRITE_WAY =>
              --write way back to main memory
              if (biu_stb_ack_i = '1') then
                biufsm_state <= BURST;
              else  --BIU is not ready to start a new transfer
                biufsm_state <= WAIT4BIU;
              end if;
            when others =>
              null;
          end case;
        when WAIT4BIU =>
          if (biu_stb_ack_i = '1') then
            --BIU acknowledged burst transfer
            biufsm_state <= BURST;
          end if;
        when BURST =>
          if (biu_err_i = '1' or (reduce_nor(burst_cnt) and biu_ack_i) = '1') then
            --write complete
            biufsm_state <= IDLE;  --TODO: detect if another BURST request is pending, skip IDLE
          end if;
        when others =>
          null;
      end case;
    end if;
  end process;

  --write data
  processing_22 : process (clk_i)
  begin
    if (rising_edge(clk_i)) then
      case ((biufsm_state)) is
        when IDLE =>
          biu_buffer       <= (others => '0');
          biu_buffer_valid <= (others => '0');
        when BURST =>
          --latch incoming data when transfer-acknowledged
          if (biu_ack_i = '1') then
            biu_buffer(to_integer(unsigned(biu_adro_i(BLK_OFF_BITS+DAT_OFF_BITS-1 downto BLK_OFF_BITS)))*XLEN+XLEN-1 downto to_integer(unsigned(biu_adro_i(BLK_OFF_BITS+DAT_OFF_BITS-1 downto BLK_OFF_BITS)))*XLEN) <= biu_q_i;
            biu_buffer_valid(to_integer(unsigned(biu_adro_i(BLK_OFF_BITS+DAT_OFF_BITS-1 downto BLK_OFF_BITS)))) <= '1';
          end if;
        when others =>
          null;
      end case;
    end if;
  end process;

  --acknowledge burst to memfsm
  processing_23 : process (biufsm_state, burst_cnt, biu_err_i, biu_ack_i)
  begin
    case (biufsm_state) is
      when BURST =>
        biufsm_ack <= (reduce_nor(burst_cnt) and biu_ack_i) or biu_err_i;
      when others =>
        biufsm_ack <= '0';
    end case;
  end process;

  processing_24 : process (clk_i)
  begin
    if (rising_edge(clk_i)) then
      case (biufsm_state) is
        when IDLE =>
          case (biucmd) is
            when READ_WAY =>
              burst_cnt <= (others => '1');
            when WRITE_WAY =>
              burst_cnt <= (others => '1');
            when others =>
              null;
          end case;
        when BURST =>
          if (biu_ack_i = '1') then
            burst_cnt <= std_logic_vector(unsigned(burst_cnt)-to_unsigned(1, BURST_BITS));
          end if;
        when others =>
          null;
      end case;
    end if;
  end process;

  biufsm_err <= biu_err_i;

  --output BIU signals asynchronously for speed reasons. BIU will synchronize ...
  biu_d  <= (others => '0');
  biu_we_o <= '0';

  biu_d_o  <= biu_d;

  processing_25 : process (biu_adri_hold, biucmd, biufsm_state, mem_padr_dly)
  begin
    case ((biufsm_state)) is
      when IDLE =>
        case ((biucmd)) is
          when NOP =>
            biu_stb_o  <= '0';
            biu_adri <= (others => 'X');
          when READ_WAY =>
            biu_stb_o  <= '1';
            biu_adri <= (mem_padr_dly(PLEN-1 downto BURST_LSB) & (BURST_LSB-1 downto 0 => '0'));
          when others =>
            null;
        end case;
      when WAIT4BIU =>
        --stretch biu_*_o signals until BIU acknowledges strobe
        biu_stb_o  <= '1';
        biu_adri <= biu_adri_hold;
      when BURST =>
        biu_stb_o  <= '0';
        biu_adri <= (others => 'X');  --don't care
      when others =>
        biu_stb_o  <= '0';
        biu_adri <= (others => 'X');  --don't care
    end case;
  end process;

  --store biu_we/adri/d used when stretching biu_stb
  processing_26 : process (clk_i)
  begin
    if (rising_edge(clk_i)) then
      if (biufsm_state = IDLE) then
        biu_adri_hold <= biu_adri;
        biu_d_hold    <= biu_d;
      end if;
    end if;
  end process;

  biu_adri_o <= biu_adri;

  --transfer size
  biu_size_o <= DWORD
                when XLEN = 64 else WORD;

  --burst length
  generating_6 : if (BURST_SIZE = 16) generate
    biu_type_o <= WRAP16;
  elsif (BURST_SIZE = 8) generate
    biu_type_o <= WRAP8;
  elsif (BURST_SIZE /= 16 and BURST_SIZE /= 8) generate
    biu_type_o <= WRAP4;
  end generate;
end rtl;