-- Converted from rtl/verilog/core/cache/pu_riscv_dcache_core.sv
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
--              Core - Data Cache (Write Back)                                --
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
use ieee.math_real.all;

use work.peripheral_biu_vhdl_pkg.all;
use work.vhdl_pkg.all;

entity pu_riscv_dcache_core is
  generic (
    XLEN : integer := 64;
    PLEN : integer := 64;

    DCACHE_SIZE        : integer := 64;
    DCACHE_BLOCK_SIZE  : integer := 64;
    DCACHE_WAYS        : integer := 2;
    DCACHE_REPLACE_ALG : integer := 0;

    TECHNOLOGY : string := "GENERIC"
    );
  port (
    rst_ni : in std_logic;
    clk_i  : in std_logic;

    --CPU side
    mem_vreq_i : in  std_logic;
    mem_preq_i : in  std_logic;
    mem_vadr_i : in  std_logic_vector(XLEN-1 downto 0);
    mem_padr_i : in  std_logic_vector(PLEN-1 downto 0);
    mem_size_i : in  std_logic_vector(2 downto 0);
    mem_lock_i : in  std_logic;
    mem_prot_i : in  std_logic_vector(2 downto 0);
    mem_d_i    : in  std_logic_vector(XLEN-1 downto 0);
    mem_we_i   : in  std_logic;
    mem_q_o    : out std_logic_vector(XLEN-1 downto 0);
    mem_ack_o  : out std_logic;
    mem_err_o  : out std_logic;
    flush_i    : in  std_logic;
    flushrdy_o : out std_logic;

    --To BIU
    biu_stb_o     : out std_logic;      --access request
    biu_stb_ack_i : in  std_logic;      --access acknowledge
    biu_d_ack_i   : in  std_logic;      --BIU needs new data (biu_d_o)
    biu_adri_o    : out std_logic_vector(PLEN-1 downto 0);  --access start address
    biu_adro_i    : in  std_logic_vector(PLEN-1 downto 0);
    biu_size_o    : out std_logic_vector(2 downto 0);       --transfer size
    biu_type_o    : out std_logic_vector(2 downto 0);       --burst type
    biu_lock_o    : out std_logic;      --locked transfer
    biu_prot_o    : out std_logic_vector(2 downto 0);       --protection bits
    biu_we_o      : out std_logic;      --write enable
    biu_d_o       : out std_logic_vector(XLEN-1 downto 0);  --write data
    biu_q_i       : in  std_logic_vector(XLEN-1 downto 0);  --read data
    biu_ack_i     : in  std_logic;      --transfer acknowledge
    biu_err_i     : in  std_logic       --transfer error
    );
end pu_riscv_dcache_core;

architecture rtl of pu_riscv_dcache_core is
  component pu_riscv_ram_1rw
    generic (
      ABITS      : integer := 10;
      DBITS      : integer := 32;
      TECHNOLOGY : string  := "GENERIC"
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
  constant MAX_IDX_BITS : integer := integer(log2(real(PAGE_SIZE)))-integer(log2(real(DCACHE_BLOCK_SIZE)));  --Maximum IDX_BITS

  constant SETS         : integer := (DCACHE_SIZE*1024)/DCACHE_BLOCK_SIZE/DCACHE_WAYS;  --Number of sets TODO:SETS=1 doesn't work
  constant BLK_OFF_BITS : integer := integer(log2(real(DCACHE_BLOCK_SIZE)));  --Number of BlockOffset bits
  constant IDX_BITS     : integer := integer(log2(real(SETS)));  --Number of Index-bits
  constant TAG_BITS     : integer := XLEN-IDX_BITS-BLK_OFF_BITS;  --Number of TAG-bits
  constant BLK_BITS     : integer := 8*DCACHE_BLOCK_SIZE;  --Total number of bits in a Block
  constant BURST_SIZE   : integer := BLK_BITS/XLEN;  --Number of transfers to load 1 Block
  constant BURST_BITS   : integer := integer(log2(real(BURST_SIZE)));
  constant BURST_OFF    : integer := XLEN/8;
  constant BURST_LSB    : integer := integer(log2(real(BURST_OFF)));

  --BLOCK decoding
  constant DAT_OFF_BITS : integer := integer(log2(real(BLK_BITS/XLEN)));  --Byte offset in block

  --Memory FIFO
  constant MEM_FIFO_DEPTH : integer := 4;

  ------------------------------------------------------------------------------
  -- Constants
  ------------------------------------------------------------------------------
  constant ARMED        : std_logic_vector(4 downto 0) := "00000";
  constant FLUSH        : std_logic_vector(4 downto 0) := "00001";
  constant FLUSHWAYS    : std_logic_vector(4 downto 0) := "00010";
  constant WAIT4BIUCMD1 : std_logic_vector(4 downto 0) := "00100";
  constant WAIT4BIUCMD0 : std_logic_vector(4 downto 0) := "01000";
  constant RECOVER      : std_logic_vector(4 downto 0) := "10000";

  constant IDLE     : std_logic_vector(1 downto 0) := "10";
  constant WAIT4BIU : std_logic_vector(1 downto 0) := "01";
  constant BURST    : std_logic_vector(1 downto 0) := "00";

  constant NOP       : std_logic_vector(1 downto 0) := "00";
  constant WRITE_WAY : std_logic_vector(1 downto 0) := "01";
  constant READ_WAY  : std_logic_vector(1 downto 0) := "10";

  ------------------------------------------------------------------------------
  -- Functions
  ------------------------------------------------------------------------------
  function onehot2int (
    a : std_logic_vector(DCACHE_WAYS-1 downto 0)
    ) return integer is
    variable onehot2int_return : integer;
  begin
    onehot2int_return := 0;

    for i in 0 to DCACHE_WAYS - 1 loop
      if (a(i) = '1') then
        onehot2int_return := i;
      end if;
    end loop;
    return onehot2int_return;
  end onehot2int;

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

  function be_mux (
    be : std_logic_vector(XLEN/8-1 downto 0);
    o  : std_logic_vector(XLEN-1 downto 0);  --old data
    n  : std_logic_vector(XLEN-1 downto 0)   --new data
    ) return std_logic_vector is
    variable be_mux_return : std_logic_vector (XLEN-1 downto 0);
  begin
    if (be(0) = '1') then
      be_mux_return(7 downto 0) := n(7 downto 0);
    else
      be_mux_return(7 downto 0) := o(7 downto 0);
    end if;

    if (be(1) = '1') then
      be_mux_return(15 downto 8) := n(15 downto 8);
    else
      be_mux_return(15 downto 8) := o(15 downto 8);
    end if;

    if (be(2) = '1') then
      be_mux_return(23 downto 16) := n(23 downto 16);
    else
      be_mux_return(23 downto 16) := o(23 downto 16);
    end if;

    if (be(3) = '1') then
      be_mux_return(31 downto 24) := n(31 downto 24);
    else
      be_mux_return(31 downto 24) := o(31 downto 24);
    end if;

    return be_mux_return;
  end be_mux;

  function reduce_mor (
    reduce_mor_in : std_logic_matrix(DCACHE_WAYS-1 downto 0)(SETS-1 downto 0)
    ) return std_logic is
    variable reduce_mor_out : std_logic := '0';
  begin
    for i in DCACHE_WAYS-1 downto 0 loop
      for j in SETS-1 downto 0 loop
        reduce_mor_out := reduce_mor_out or reduce_mor_in(i)(j);
      end loop;
    end loop;
    return reduce_mor_out;
  end reduce_mor;

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
  signal mem_we_dly   : std_logic;
  signal mem_d_dly    : std_logic_vector(XLEN-1 downto 0);

  signal core_tag      : std_logic_vector(TAG_BITS-1 downto 0);
  signal core_tag_hold : std_logic_vector(TAG_BITS-1 downto 0);

  signal hold_flush : std_logic;  --stretch flush_i until FSM is ready to serve

  signal memfsm_state : std_logic_vector(4 downto 0);

  --Cache Section
  signal idx                 : std_logic_vector(IDX_BITS-1 downto 0);
  signal tag_idx             : std_logic_vector(IDX_BITS-1 downto 0);
  signal tag_idx_dly         : std_logic_vector(IDX_BITS-1 downto 0);  --delayed version for writing valid/dirty
  signal tag_idx_hold        : std_logic_vector(IDX_BITS-1 downto 0);  --stretched version for writing TAG during fill
  signal tag_dirty_write_idx : std_logic_vector(IDX_BITS-1 downto 0);  --index for writing tag.dirty
  signal vadr_idx            : std_logic_vector(IDX_BITS-1 downto 0);  --index bits extracted from vadr_i
  signal vadr_dly_idx        : std_logic_vector(IDX_BITS-1 downto 0);  --index bits extracted from vadr_dly
  signal padr_idx            : std_logic_vector(IDX_BITS-1 downto 0);
  signal padr_dly_idx        : std_logic_vector(IDX_BITS-1 downto 0);

  signal tag_we       : std_logic_vector(DCACHE_WAYS-1 downto 0);
  signal tag_we_dirty : std_logic_vector(DCACHE_WAYS-1 downto 0);

  signal tag_in_valid : std_logic_vector(DCACHE_WAYS-1 downto 0);
  signal tag_in_dirty : std_logic_vector(DCACHE_WAYS-1 downto 0);
  signal tag_in_tag   : std_logic_matrix(DCACHE_WAYS-1 downto 0)(TAG_BITS-1 downto 0);

  signal tag_out_valid : std_logic_vector(DCACHE_WAYS-1 downto 0);
  signal tag_out_dirty : std_logic_vector(DCACHE_WAYS-1 downto 0);
  signal tag_out_tag   : std_logic_matrix(DCACHE_WAYS-1 downto 0)(TAG_BITS-1 downto 0);

  signal tag_byp_idx : std_logic_matrix(DCACHE_WAYS-1 downto 0)(IDX_BITS-1 downto 0);
  signal tag_byp_tag : std_logic_matrix(DCACHE_WAYS-1 downto 0)(TAG_BITS-1 downto 0);
  signal tag_valid   : std_logic_matrix(DCACHE_WAYS-1 downto 0)(SETS-1 downto 0);
  signal tag_dirty   : std_logic_matrix(DCACHE_WAYS-1 downto 0)(SETS-1 downto 0);

  signal write_buffer_idx       : std_logic_vector(IDX_BITS-1 downto 0);
  signal write_buffer_adr       : std_logic_vector(PLEN-1 downto 0);  --physical address
  signal write_buffer_be        : std_logic_vector(XLEN/8-1 downto 0);
  signal write_buffer_data      : std_logic_vector(XLEN-1 downto 0);
  signal write_buffer_hit       : std_logic_vector(DCACHE_WAYS-1 downto 0);
  signal write_buffer_was_write : std_logic;
  signal write_buffer_dly       : std_logic_vector(DCACHE_WAYS-1 downto 0);

  signal in_writebuffer : std_logic;

  signal dat_idx       : std_logic_vector(IDX_BITS-1 downto 0);
  signal dat_idx_dly   : std_logic_vector(IDX_BITS-1 downto 0);
  signal dat_we        : std_logic_vector(DCACHE_WAYS-1 downto 0);
  signal dat_we_enable : std_logic;
  signal dat_be        : std_logic_vector(BLK_BITS/8-1 downto 0);
  signal dat_in        : std_logic_vector(BLK_BITS-1 downto 0);
  signal dat_out       : std_logic_matrix(DCACHE_WAYS-1 downto 0)(BLK_BITS-1 downto 0);

  signal way_q_mux   : std_logic_matrix(DCACHE_WAYS-1 downto 0)(BLK_BITS-1 downto 0);
  signal way_q       : std_logic_vector(XLEN-1 downto 0);  --Only use XLEN bits from way_q
  signal way_hit     : std_logic_vector(DCACHE_WAYS-1 downto 0);
  signal way_dirty   : std_logic_vector(DCACHE_WAYS-1 downto 0);
  signal way_compare : std_logic_matrix(DCACHE_WAYS-1 downto 0)(TAG_BITS-1 downto 0);

  signal dat_offset : std_logic_vector(DAT_OFF_BITS-1 downto 0);

  signal cache_hit : std_logic;
  signal cache_q   : std_logic_vector(XLEN-1 downto 0);

  signal way_random           : std_logic_vector(19 downto 0);
  signal fill_way_select      : std_logic_vector(DCACHE_WAYS-1 downto 0);
  signal fill_way_select_hold : std_logic_vector(DCACHE_WAYS-1 downto 0);

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
  signal biu_q                : std_logic_vector(XLEN-1 downto 0);
  signal biu_buffer           : std_logic_vector(BLK_BITS-1 downto 0);
  signal biu_buffer_valid     : std_logic_vector(BURST_SIZE-1 downto 0);
  signal biu_buffer_dirty     : std_logic;
  signal in_biubuffer         : std_logic;

  signal biu_we_hold   : std_logic;
  signal biu_adri_hold : std_logic_vector(PLEN-1 downto 0);
  signal biu_d_hold    : std_logic_vector(XLEN-1 downto 0);

  signal evict_buffer_adr  : std_logic_vector(PLEN-1 downto 0);
  signal evict_buffer_data : std_logic_vector(BLK_BITS-1 downto 0);

  signal is_read_way        : std_logic;
  signal is_read_way_dly    : std_logic;
  signal write_evict_buffer : std_logic;

  signal burst_cnt : std_logic_vector(BURST_BITS-1 downto 0);

  signal get_dirty_way_idx : std_logic_matrix(DCACHE_WAYS-1 downto 0)(integer(log2(real(DCACHE_WAYS)))-1 downto 0);
  signal get_dirty_set_idx : std_logic_matrix(DCACHE_WAYS-1 downto 0)(IDX_BITS-1 downto 0);

  signal dirty_sets : std_logic_vector(SETS-1 downto 0);

  --Riviera bug workaround
  signal pwb_adr        : std_logic_vector(PLEN-1 downto 0);
  signal pwb_dat_offset : std_logic_vector(DAT_OFF_BITS-1 downto 0);

  --CPU side
  signal mem_ack : std_logic;

  --To BIU
  signal biu_we   : std_logic;                          --write enable
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
  processing_0 : process (clk_i, rst_ni, mem_ack, mem_vreq_dly, mem_vreq_i)
  begin
    if (rst_ni = '0') then
      mem_vreq_dly <= '0';
    elsif (rising_edge(clk_i) or falling_edge(rst_ni)) then
      mem_vreq_dly <= mem_vreq_i or (mem_vreq_dly and not mem_ack);
    end if;
  end process;

  processing_1 : process (clk_i, rst_ni, mem_ack, mem_preq_dly, mem_preq_i)
  begin
    if (rst_ni = '0') then
      mem_preq_dly <= '0';
    elsif (rising_edge(clk_i) or falling_edge(rst_ni)) then
      mem_preq_dly <= (mem_preq_i or mem_preq_dly) and not mem_ack;
    end if;
  end process;

  --register memory signals
  processing_2 : process (clk_i)
  begin
    if (rising_edge(clk_i)) then
      if (mem_vreq_i = '1') then
        mem_vadr_dly <= mem_vadr_i;
        mem_we_dly   <= mem_we_i;
        mem_be_dly   <= mem_be;
        mem_d_dly    <= mem_d_i;
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
  processing_5 : process (clk_i, rst_ni, flush_i, flushing, hold_flush)
  begin
    if (rst_ni = '0') then
      hold_flush <= '0';
    elsif (rising_edge(clk_i) or falling_edge(rst_ni)) then
      hold_flush <= not flushing and (flush_i or hold_flush);
    end if;
  end process;

  --signal Instruction Cache when FLUSH is done
  flushrdy_o <= not (flush_i or hold_flush or flushing);

  --State Machine
  processing_6 : process (clk_i, rst_ni, biufsm_ack, biufsm_err, cache_hit, fill_way_select, flush_i, hold_flush, idx, mem_preq_dly, mem_preq_i, mem_vreq_dly, mem_vreq_i, mem_we_dly, mem_we_i, memfsm_state, tag_dirty, tag_idx_hold, tag_out_dirty, tag_out_valid, vadr_idx, way_dirty, write_buffer_idx)
  begin
    if (rst_ni = '0') then
      memfsm_state <= ARMED;
      flushing     <= '0';
      filling      <= '0';
      biucmd       <= NOP;
    elsif (rising_edge(clk_i) or falling_edge(rst_ni)) then
      case (memfsm_state) is
        when ARMED =>
          if ((flush_i or hold_flush) = '1' and (mem_vreq_i and mem_we_i) = '0' and (mem_vreq_dly = '1' and mem_we_dly = '1' and (mem_preq_i or mem_preq_dly) = '1')) then
            memfsm_state <= FLUSH;
            flushing     <= '1';
          elsif (mem_vreq_dly = '1' and cache_hit = '0' and (mem_preq_i or mem_preq_dly) = '1') then  --it takes 1 cycle to read TAG
            if (tag_out_valid(onehot2int(fill_way_select)) = '1' and tag_out_dirty(onehot2int(fill_way_select)) = '1') then
              --selected way is dirty, write back to upstream
              memfsm_state <= WAIT4BIUCMD1;
              biucmd       <= READ_WAY;
              filling      <= '1';
            else                        --selected way not dirty, overwrite
              memfsm_state <= WAIT4BIUCMD0;
              biucmd       <= READ_WAY;
              filling      <= '1';
            end if;
          else
            biucmd <= NOP;
          end if;
        when FLUSH =>
          if (reduce_mor(tag_dirty) = '1') then
            --There are dirty ways in this set
            --TODO
            --First determine dat_idx; this reads all ways for that index (FLUSH)
            --then check which ways are dirty (FLUSHWAYS)
            --write dirty way
            --clear dirty bit
            memfsm_state <= FLUSHWAYS;
          else                          --allow to read new tag_idx
            memfsm_state <= RECOVER;
            flushing     <= '0';
          end if;
        when FLUSHWAYS =>
          --assert WRITE_WAY here (instead of in FLUSH) to allow time to load evict_buffer
          biucmd <= WRITE_WAY;
          if (biufsm_ack = '1') then
            --Check if there are more dirty ways in this set
            if (reduce_nor(way_dirty) = '1') then
              memfsm_state <= FLUSH;
              biucmd       <= NOP;
            end if;
          end if;
        --TODO: Can we merge WAIT4BIUCMD0 and WAIT4BIUCMD1?
        when WAIT4BIUCMD1 =>
          if (biufsm_err = '1') then
            --if tag_idx already selected, go to ARMED
            --otherwise go to RECOVER to read tag (1 cycle delay)
            if (idx /= tag_idx_hold) then
              memfsm_state <= RECOVER;
            else
              memfsm_state <= ARMED;
            end if;
            if (mem_preq_dly = '1' and mem_we_dly = '1') then
              idx <= write_buffer_idx;
            else
              idx <= vadr_idx;
            end if;
            biucmd  <= WRITE_WAY;
            filling <= '0';
          elsif (biufsm_ack = '1') then  --wait for READ_WAY to complete
            --if tag_idx already selected, go to ARMED
            --otherwise go to recover to read tag (1 cycle delay)
            if (idx /= tag_idx_hold) then
              memfsm_state <= RECOVER;
            else
              memfsm_state <= ARMED;
            end if;
            if (mem_preq_dly = '1' and mem_we_dly = '1') then
              idx <= write_buffer_idx;
            else
              idx <= vadr_idx;
            end if;
            biucmd  <= WRITE_WAY;
            filling <= '0';
          end if;
        when WAIT4BIUCMD0 =>
          if (biufsm_err = '1') then
            if (idx /= tag_idx_hold) then
              memfsm_state <= RECOVER;
            else
              memfsm_state <= ARMED;
            end if;
            if (mem_preq_dly = '1' and mem_we_dly = '1') then
              idx <= write_buffer_idx;
            else
              idx <= vadr_idx;
            end if;
            biucmd  <= NOP;
            filling <= '0';
          elsif (biufsm_ack = '1') then
            if (idx /= tag_idx_hold) then
              memfsm_state <= RECOVER;
            else
              memfsm_state <= ARMED;
            end if;
            if (mem_preq_dly = '1' and mem_we_dly = '1') then
              idx <= write_buffer_idx;
            else
              idx <= vadr_idx;
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

  --dat/tag index during flushing
  --flush_idx <= get_dirty_set_idx(IDX_BITS-1);

  --return which SET has dirty WAYs
  --generating_0 : for set in 0 to SETS - 1 generate
  --dirty_sets(set) <= reduce_or(tag_dirty(set) & tag_dirty(set));
  --end generate;

  --generating_1 : for set in 0 to SETS - 1 generate
  --processing_7 : process (dirty_sets)
  --begin
  --if (dirty_sets(set) = '1') then
  --get_dirty_set_idx(set) <= std_logic_vector(to_unsigned(set, IDX_BITS));
  --else
  --get_dirty_set_idx(set) <= std_logic_vector(to_unsigned(0, IDX_BITS));
  --end if;
  --end process;
  --end generate;

  --signal downstream that data is ready
  processing_8 : process (biu_ack_i, biu_adro_eq_cache_adr_dly, cache_hit, mem_preq_dly, mem_preq_i, mem_vreq_dly, memfsm_state)
  begin
    case (memfsm_state) is
      when ARMED =>
        --cache_hit
        mem_ack <= mem_vreq_dly and cache_hit and (mem_preq_i or mem_preq_dly);
      when WAIT4BIUCMD1 =>
        mem_ack <= biu_ack_i and biu_adro_eq_cache_adr_dly;
      when WAIT4BIUCMD0 =>
        mem_ack <= biu_ack_i and biu_adro_eq_cache_adr_dly;
      when others =>
        mem_ack <= '0';
    end case;
  end process;

  mem_ack_o <= mem_ack;

  --signal downstream the BIU reported an error
  mem_err_o <= biu_err_i;

  --Assign mem_q
  processing_9 : process (biu_q_i, cache_q, memfsm_state)
  begin
    case (memfsm_state) is
      when WAIT4BIUCMD1 =>
        mem_q_o <= biu_q_i;
      when WAIT4BIUCMD0 =>
        mem_q_o <= biu_q_i;
      when others =>
        mem_q_o <= cache_q;
    end case;
  end process;

  ------------------------------------------------------------------
  -- End Memory Interface State Machine
  ------------------------------------------------------------------

  ------------------------------------------------------------------
  -- TAG and Data memory
  ------------------------------------------------------------------

  --TAG
  generating_2 : for way in 0 to DCACHE_WAYS - 1 generate
    --TAG is stored in RAM
    tag_ram : pu_riscv_ram_1rw
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
    processing_10 : process (clk_i)
    begin
      if (rising_edge(clk_i)) then
        if (tag_we(way) = '1') then
          tag_byp_tag(way) <= tag_in_tag(way);
          tag_byp_idx(way) <= tag_idx;
        end if;
      end if;
    end process;

    --Valid is stored in DFF
    processing_11 : process (clk_i, rst_ni, tag_idx, tag_in_valid, tag_we)
    begin
      if (rst_ni = '0') then
        tag_valid(way)(SETS-1) <= '0';
      elsif (rising_edge(clk_i) or falling_edge(rst_ni)) then
        if (tag_we(way) = '1') then
          tag_valid(way)(to_integer(unsigned(tag_idx))) <= tag_in_valid(way);
        end if;
      end if;
    end process;

    tag_out_valid(way) <= tag_valid(way)(to_integer(unsigned(tag_idx_dly)));

    --Dirty is stored in DFF
    processing_12 : process (clk_i, rst_ni, tag_dirty_write_idx, tag_in_dirty, tag_we_dirty)
    begin
      if (rst_ni = '0') then
        tag_dirty(way)(SETS-1) <= '0';
      elsif (rising_edge(clk_i) or falling_edge(rst_ni)) then
        if (tag_we_dirty(way) = '1') then
          tag_dirty(way)(to_integer(unsigned(tag_dirty_write_idx))) <= tag_in_dirty(way);
        end if;
      end if;
    end process;

    tag_out_dirty(way) <= tag_dirty(way)(to_integer(unsigned(tag_idx_dly)));

    --extract 'dirty' from tag
    way_dirty(way) <= tag_out_dirty(way);

    --compare way-tag to TAG
    way_hit(way) <= tag_out_valid(way) and to_stdlogic(core_tag = way_compare(way));

  --way_compare(way) <= tag_byp_tag(way)
  --when (tag_idx_dly = tag_byp_idx(way)) else tag_out_tag(way);
  end generate;

  -- Generate 'hit'
  cache_hit <= reduce_or(way_hit);      -- & mem_vreq_dly;

  --DATA

  --pipelined write buffer
  dat_we_enable <= (mem_vreq_i and mem_we_i) or not mem_vreq_i;  --enable writing to data memory

  processing_13 : process (clk_i)
  begin
    if (rising_edge(clk_i)) then
      write_buffer_was_write <= (mem_vreq_i and mem_we_i);
    end if;
  end process;

  processing_14 : process (clk_i)
  begin
    if (rising_edge(clk_i)) then
      if (mem_vreq_i = '1' and mem_we_i = '1') then  --must store during vreq, otherwise data gets lost
        write_buffer_idx  <= vadr_idx;
        write_buffer_data <= mem_d_i;
        write_buffer_be   <= mem_be;
      end if;
    end if;
  end process;

  processing_15 : process (clk_i, rst_ni, dat_we_enable, mem_preq_i, way_hit, write_buffer_was_write)
  begin
    if (rst_ni = '0') then
      write_buffer_hit <= (others => '0');
    elsif (rising_edge(clk_i) or falling_edge(rst_ni)) then
      if (write_buffer_was_write = '1') then
        write_buffer_hit <= way_hit and (way_hit'range => mem_preq_i);  --store current transaction's hit, qualify with preq
      elsif (dat_we_enable = '1') then
        write_buffer_hit <= (others => '0');  --data written into RAM
      end if;
    end if;
  end process;

  processing_16 : process (clk_i)
  begin
    if (rising_edge(clk_i)) then
      if (write_buffer_was_write = '1' and mem_preq_i = '1') then
        write_buffer_adr <= mem_padr_i;
      end if;
    end if;
  end process;

  generating_3 : for way in 0 to DCACHE_WAYS - 1 generate
    data_ram : pu_riscv_ram_1rw
      generic map (
        ABITS      => IDX_BITS,
        DBITS      => BLK_BITS,
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
    generating_4 : if (way = 0) generate
      way_q_mux(way) <= dat_out(way) and (BLK_BITS-1 downto 0 => way_hit(way));
    end generate;
    generating_5 : if (way /= 0) generate
      way_q_mux(way) <= (dat_out(way) and (BLK_BITS-1 downto 0 => way_hit(way))) or way_q_mux(way-1);
    end generate generating_5;
  end generate generating_3;

  --get requested data (XLEN-size) from way_q_mux(BLK_BITS-size)
  way_q <= std_logic_vector(unsigned(way_q_mux(DCACHE_WAYS-1)(XLEN-1 downto 0)) srl (to_integer(unsigned(dat_offset)*XLEN)));

  --in_biubuffer <= to_stdlogic(biu_adri_hold(PLEN-1 downto BLK_OFF_BITS) = (mem_padr_dly(PLEN-1 downto BLK_OFF_BITS) and std_logic_vector(unsigned(biu_buffer_valid(PLEN+BLK_OFF_BITS-1 downto 0)) srl to_integer(unsigned(dat_offset)))))
  --when mem_preq_dly = '1' else to_stdlogic(biu_adri_hold(PLEN-1 downto BLK_OFF_BITS) = (mem_padr_i(PLEN-1 downto BLK_OFF_BITS) and std_logic_vector(unsigned(biu_buffer_valid(PLEN+BLK_OFF_BITS-1 downto 0)) srl to_integer(unsigned(dat_offset)))));

  in_writebuffer <= to_stdlogic(mem_padr_i = write_buffer_adr) and reduce_or(write_buffer_hit);

  cache_q <= std_logic_vector(unsigned(biu_buffer(XLEN-1 downto 0)) srl (to_integer(unsigned(dat_offset)*XLEN)))
             when in_biubuffer = '1'   else be_mux(write_buffer_be, way_q, write_buffer_data)
             when in_writebuffer = '1' else way_q;

  ------------------------------------------------------------------
  -- END TAG and Data memory
  ------------------------------------------------------------------

  ------------------------------------------------------------------
  -- TAG and Data memory control signals
  ------------------------------------------------------------------

  --Random generator for RANDOM replacement algorithm
  processing_17 : process (clk_i, rst_ni, filling, way_random(16), way_random(19 downto 1), way_random(19))
  begin
    if (rst_ni = '0') then
      way_random <= (others => '0');
    elsif (rising_edge(clk_i) or falling_edge(rst_ni)) then
      if (filling = '0') then
        way_random <= way_random(19 downto 1) & (way_random(19) xnor way_random(16));
      end if;
    end if;
  end process;

  --select which way to fill
  fill_way_select <= std_logic_vector(to_unsigned(1, DCACHE_WAYS))
                     when (DCACHE_WAYS = 1) else std_logic_vector(to_unsigned(2**to_integer(unsigned(way_random(integer(log2(real(DCACHE_WAYS)))-1 downto 0))), DCACHE_WAYS));

  --FILL / WRITE_WAYS use fill_way_select 1 cycle later
  processing_18 : process (clk_i)
  begin
    if (rising_edge(clk_i)) then
      case ((memfsm_state)) is
        when ARMED =>
          fill_way_select_hold <= fill_way_select;
        when others =>
          null;
      end case;
    end if;
  end process;

  --TAG Index
  processing_19 : process (flush_idx, mem_vreq_dly, memfsm_state, tag_idx_hold, vadr_dly_idx, vadr_idx)
  begin
    case ((memfsm_state)) is
      --TAG write
      when WAIT4BIUCMD1 =>
        tag_idx <= tag_idx_hold;
      when WAIT4BIUCMD0 =>
        tag_idx <= tag_idx_hold;
      --TAG read
      when FLUSH =>
        tag_idx <= flush_idx;
      when FLUSHWAYS =>
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

  processing_20 : process (mem_preq_dly, mem_we_dly, memfsm_state, tag_idx_dly, write_buffer_idx)
  begin
    case ((memfsm_state)) is
      --TAG write
      when WAIT4BIUCMD1 =>
        tag_dirty_write_idx <= tag_idx_dly;
      when WAIT4BIUCMD0 =>
        tag_dirty_write_idx <= tag_idx_dly;
      when others =>
        if (mem_preq_dly = '1' and mem_we_dly = '1') then
          tag_dirty_write_idx <= write_buffer_idx;
        else
          tag_dirty_write_idx <= tag_idx_dly;
        end if;
    end case;
  end process;

  --registered version, for tag_valid/dirty
  processing_21 : process (clk_i)
  begin
    if (rising_edge(clk_i)) then
      tag_idx_dly <= tag_idx;
    end if;
  end process;

  --hold tag-idx; prevent new mem_vreq_i from messing up tag during filling
  processing_22 : process (clk_i)
  begin
    if (rising_edge(clk_i)) then
      case ((memfsm_state)) is
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
  --Update tag
  -- 1. during flushing    (clear valid/dirty bits)
  -- 2. during cache-write (set dirty bit)
  generating_5 : for way in 0 to DCACHE_WAYS - 1 generate
    processing_23 : process (biufsm_ack, fill_way_select_hold, filling, memfsm_state)
    begin
      case ((memfsm_state)) is
        when others =>
          tag_we(way) <= filling and fill_way_select_hold(way) and biufsm_ack;
      end case;
    end process;

    processing_24 : process (memfsm_state, biufsm_ack, fill_way_select_hold, filling, flushing, get_dirty_way_idx, mem_preq_dly, mem_preq_i, mem_vreq_dly, mem_we_dly, way_hit, write_evict_buffer)
    begin
      case (memfsm_state) is
        when ARMED =>
          tag_we_dirty(way) <= way_hit(way) and ((mem_vreq_dly and mem_we_dly and mem_preq_i) or (mem_preq_dly and mem_we_dly));
        when others =>
          tag_we_dirty(way) <= (filling and fill_way_select_hold(way) and biufsm_ack) or (flushing and write_evict_buffer and
                                                                                          to_stdlogic(unsigned(get_dirty_way_idx(DCACHE_WAYS-1)) = to_unsigned(way, integer(log2(real(DCACHE_WAYS))))));
      end case;
    end process;
  end generate;

  --TAG Write Data
  generating_6 : for way in 0 to DCACHE_WAYS - 1 generate
    --clear valid tag during cache-coherency checks
    tag_in_valid(way) <= '1';           --~flushing;

    --set dirty bit when
    -- 1. read new line from memory and data in new line is overwritten
    -- 2. during a write to a valid line
    --clear dirty bit when flushing
    tag_in_tag(way) <= core_tag_hold;

    processing_25 : process (biufsm_ack, biu_adro_eq_cache_adr_dly, biu_buffer_dirty, flushing, mem_we_dly)
    begin
      case (biufsm_ack) is
        when '1' =>
          tag_in_dirty(way) <= biu_buffer_dirty or (mem_we_dly and biu_adro_eq_cache_adr_dly);
        when '0' =>
          tag_in_dirty(way) <= not flushing and mem_we_dly;
        when others =>
          null;
      end case;
    end process;
  end generate;

  --Shift amount for data
  dat_offset <= mem_vadr_dly(BLK_OFF_BITS+DAT_OFF_BITS-1 downto BLK_OFF_BITS);

  --Riviera bug workaround
  pwb_adr        <= write_buffer_adr;
  pwb_dat_offset <= mem_padr_i(BLK_OFF_BITS+DAT_OFF_BITS-1 downto BLK_OFF_BITS)
                    when (write_buffer_was_write = '1' and mem_preq_i = '1') else pwb_adr(BLK_OFF_BITS+DAT_OFF_BITS-1 downto BLK_OFF_BITS);
  --TODO: Can't we use vadr?

  --DAT Byte Enable
  dat_be <= (dat_be'range => '1')
            when biufsm_ack = '1' else std_logic_vector(X"00000000000000" & (unsigned(write_buffer_be)) sll (to_integer(unsigned(pwb_dat_offset))*XLEN/8));

  --DAT Index
  processing_26 : process (dat_we_enable, flush_idx, mem_vreq_dly, memfsm_state, tag_idx_hold, vadr_dly_idx, vadr_idx, write_buffer_idx)
  begin
    case ((memfsm_state)) is
      when ARMED =>
        --write old 'write-data'
        --read access
        if (dat_we_enable = '1') then
          dat_idx <= write_buffer_idx;
        else
          dat_idx <= vadr_idx;
        end if;
      when RECOVER =>
        --read pending cycle
        --read new access
        if (mem_vreq_dly = '1') then
          dat_idx <= vadr_dly_idx;
        else
          dat_idx <= vadr_idx;
        end if;
      when FLUSH =>
        dat_idx <= flush_idx;
      when FLUSHWAYS =>
        dat_idx <= flush_idx;
      when others =>
        dat_idx <= tag_idx_hold;
    end case;
  end process;

  --delayed dat_idx
  processing_27 : process (clk_i)
  begin
    if (rising_edge(clk_i)) then
      dat_idx_dly <= dat_idx;
    end if;
  end process;

  --DAT Write Enable
  generating_7 : for way in 0 to DCACHE_WAYS - 1 generate
    processing_28 : process (biufsm_ack, dat_we_enable, fill_way_select_hold, mem_preq_dly, mem_preq_i, mem_we_dly, memfsm_state, way_hit, write_buffer_dly, write_buffer_hit, write_buffer_was_write)
    begin
      case ((memfsm_state)) is
        when WAIT4BIUCMD0 =>
          --write BIU data
          dat_we(way) <= fill_way_select_hold(way) and biufsm_ack;
        when WAIT4BIUCMD1 =>
          dat_we(way) <= fill_way_select_hold(way) and biufsm_ack;
        when RECOVER =>
          dat_we(way) <= '0';
        --current cycle and previous cycle are writes, no time to write 'hit' into write buffer, use way_hit directly
        --current access is a write and there's still a write request pending (e.g. write during READ_WAY), use way_hit directly
        when others =>
          dat_we(way) <= dat_we_enable and write_buffer_dly(way);

          if (mem_preq_dly = '1' and mem_we_dly = '1') then
            write_buffer_dly(way) <= (write_buffer_was_write and mem_preq_i) or way_hit(way);
          else
            write_buffer_dly(way) <= write_buffer_hit(way);
          end if;
      end case;
    end process;
  end generate;

  --DAT Write Data
  processing_29 : process (biufsm_ack, biu_adro_i, biu_buffer, biu_q, write_buffer_data)
  begin
    case (biufsm_ack) is
      when '1' =>
        --dat_in = biu_buffer
        dat_in                                                                                                                                                                                              <= biu_buffer;
        dat_in(to_integer(unsigned(biu_adro_i(BLK_OFF_BITS+DAT_OFF_BITS-1 downto BLK_OFF_BITS)))*XLEN+XLEN-1 downto to_integer(unsigned(biu_adro_i(BLK_OFF_BITS+DAT_OFF_BITS-1 downto BLK_OFF_BITS)))*XLEN) <= biu_q;  --except for last transaction
      when '0' =>
        --dat_in = write-data over all words
        dat_in <= (BLK_BITS-1 downto XLEN => '0') & write_buffer_data;
      when others =>
        null;
    end case;
  end process;
  --dat_be gates writing

  ------------------------------------------------------------------
  -- TAG and Data memory control signals
  ------------------------------------------------------------------

  ------------------------------------------------------------------
  -- Bus Interface State Machine
  ------------------------------------------------------------------
  biu_lock_o <= '0';
  biu_prot_o <= (mem_prot_i or PROT_CACHEABLE);

  processing_30 : process (clk_i, rst_ni, biu_ack_i, biu_err_i, biu_stb_ack_i, biucmd, biufsm_state, burst_cnt)
  begin
    if (rst_ni = '0') then
      biufsm_state <= IDLE;
    elsif (rising_edge(clk_i) or falling_edge(rst_ni)) then
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
              else                 --BIU is not ready to start a new transfer
                biufsm_state <= WAIT4BIU;
              end if;
            when WRITE_WAY =>
              --write way back to main memory
              if (biu_stb_ack_i = '1') then
                biufsm_state <= BURST;
              else                 --BIU is not ready to start a new transfer
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

  --handle writing bits in read-cache-line
  biu_q <= be_mux(mem_be_dly, biu_q_i, mem_d_dly)
           when mem_we_dly = '1' and biu_adro_eq_cache_adr_dly = '1' else biu_q_i;

  --write data
  processing_31 : process (clk_i)
  begin
    if (rising_edge(clk_i)) then
      case (biufsm_state) is
        when IDLE =>
          --first XLEN bits went out already
          if (biucmd = WRITE_WAY) then
            biu_buffer <= std_logic_vector(unsigned(evict_buffer_data) srl XLEN);
          end if;
          biu_buffer_valid <= (others => '0');
          biu_buffer_dirty <= '0';
        when BURST =>
          if (biu_we_hold = '0') then
            if (biu_ack_i = '1') then  --latch incoming data when transfer-acknowledged
              biu_buffer(to_integer(unsigned(biu_adro_i(BLK_OFF_BITS+DAT_OFF_BITS-1 downto BLK_OFF_BITS)))*XLEN+XLEN-1 downto to_integer(unsigned(biu_adro_i(BLK_OFF_BITS+DAT_OFF_BITS-1 downto BLK_OFF_BITS)))*XLEN) <= biu_q;
              biu_buffer_valid(to_integer(unsigned(biu_adro_i(BLK_OFF_BITS+DAT_OFF_BITS-1 downto BLK_OFF_BITS))))                                                                                                     <= '1';
              biu_buffer_dirty                                                                                                                                                                                        <= biu_buffer_dirty or (mem_we_dly and biu_adro_eq_cache_adr_dly);
            end if;
          elsif (biu_d_ack_i = '1') then  --present new data when previous transfer acknowledged
            biu_buffer       <= std_logic_vector(unsigned(biu_buffer) srl XLEN);
            biu_buffer_valid <= (others => '0');
            biu_buffer_dirty <= '0';
          end if;
        when others =>
          null;
      end case;
    end if;
  end process;

  --store dirty line in evict buffer
  --TODO: change name
  processing_32 : process (clk_i)
  begin
    if (rising_edge(clk_i)) then
      is_read_way <= to_stdlogic(biucmd = READ_WAY) or to_stdlogic(memfsm_state = FLUSH) or (to_stdlogic(memfsm_state = FLUSHWAYS) and biufsm_ack and reduce_or(way_dirty));
    end if;
  end process;

  processing_33 : process (clk_i)
  begin
    if (rising_edge(clk_i)) then
      is_read_way_dly <= is_read_way;
    end if;
  end process;

  --ARMED: write evict buffer 1 cycle after starting READ_WAY. That ensures DAT and TAG are valid
  --        and there no new data from the BIU yet
  --FLUSH: write evict buffer when entering FLUSHWAYS state and as long as current SET has dirty WAYs.
  write_evict_buffer <= is_read_way and not is_read_way_dly;

  processing_34 : process (clk_i)
  begin
    if (rising_edge(clk_i)) then
      if (write_evict_buffer = '1') then
        if (flushing = '1') then
          evict_buffer_adr  <= (tag_out_tag(to_integer(unsigned(get_dirty_way_idx(DCACHE_WAYS-1)))) & flush_idx & (BLK_OFF_BITS-1 downto 0 => '0'));
          evict_buffer_data <= dat_out(to_integer(unsigned(get_dirty_way_idx(DCACHE_WAYS-1))));
        else
          evict_buffer_adr  <= (tag_out_tag(onehot2int(fill_way_select_hold)) & padr_dly_idx & (BLK_OFF_BITS-1 downto 0 => '0'));
          evict_buffer_data <= dat_out(onehot2int(fill_way_select_hold));
        end if;
      end if;
    end if;
  end process;

  --return next dirty WAY in dirty SET
  generating_8 : for way in 0 to DCACHE_WAYS - 1 generate
    processing_35 : process (flush_idx, tag_dirty)
    begin
      if (tag_dirty(way)(to_integer(unsigned(flush_idx))) = '1') then
        get_dirty_way_idx(way) <= std_logic_vector(to_unsigned(way, integer(log2(real(DCACHE_WAYS)))));
      else
        get_dirty_way_idx(way) <= (others => '0');
      end if;
    end process;
  end generate;

  --acknowledge burst to memfsm
  processing_36 : process (biufsm_state, burst_cnt, biu_ack_i, biu_we_hold, flushing, biu_err_i)
  begin
    case (biufsm_state) is
      when BURST =>
        biufsm_ack <= (reduce_nor(burst_cnt) and biu_ack_i and (not biu_we_hold or flushing)) or biu_err_i;
      when others =>
        biufsm_ack <= '0';
    end case;
  end process;

  processing_37 : process (clk_i)
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
  processing_38 : process (biu_adri_hold, biu_buffer, biu_we_hold, biucmd, biufsm_state, evict_buffer_adr, evict_buffer_data, mem_padr_dly)
  begin
    case (biufsm_state) is
      when IDLE =>
        case (biucmd) is
          when NOP =>
            biu_stb_o <= '0';
            biu_we    <= 'X';
            biu_adri  <= (others => 'X');
            biu_d     <= (others => 'X');
          when READ_WAY =>
            biu_stb_o <= '1';
            biu_we    <= '0';                             --read
            biu_adri  <= (mem_padr_dly(PLEN-1 downto BURST_LSB) & (BURST_LSB-1 downto 0 => '0'));
            biu_d     <= (others                                                        => 'X');
          when WRITE_WAY =>
            biu_stb_o <= '1';
            biu_we    <= '1';
            biu_adri  <= evict_buffer_adr;
            biu_d     <= evict_buffer_data(XLEN-1 downto 0);
          when others =>
            null;
        end case;
      when WAIT4BIU =>
        --stretch biu_*_o signals until BIU acknowledges strobe
        biu_stb_o <= '1';
        biu_we    <= biu_we_hold;
        biu_adri  <= biu_adri_hold;
        biu_d     <= evict_buffer_data(XLEN-1 downto 0);  --retain same data
      when BURST =>
        biu_stb_o <= '0';
        biu_we    <= 'X';                                 --don't care
        biu_adri  <= (others => 'X');                     --don't care
        biu_d     <= biu_buffer(XLEN-1 downto 0);
      when others =>
        biu_stb_o <= '0';
        biu_we    <= 'X';                                 --don't care
        biu_adri  <= (others => 'X');                     --don't care
        biu_d     <= (others => 'X');                     --don't care
    end case;
  end process;

  biu_we_o   <= biu_we;
  biu_adri_o <= biu_adri;
  biu_d_o    <= biu_d;

  --store biu_we/adri/d used when stretching biu_stb
  processing_39 : process (clk_i)
  begin
    if (rising_edge(clk_i)) then
      if (biufsm_state = IDLE) then
        biu_we_hold   <= biu_we;
        biu_adri_hold <= biu_adri;
        biu_d_hold    <= biu_d;
      end if;
    end if;
  end process;

  --transfer size
  biu_size_o <= DWORD
                when XLEN = 64 else WORD;

  --burst length
  generating_9 : if (BURST_SIZE = 16) generate
    biu_type_o <= WRAP16;
  elsif (BURST_SIZE = 8) generate
    biu_type_o <= WRAP8;
  elsif (BURST_SIZE /= 16 and BURST_SIZE /= 8) generate
    biu_type_o <= WRAP4;
  end generate;
end rtl;
