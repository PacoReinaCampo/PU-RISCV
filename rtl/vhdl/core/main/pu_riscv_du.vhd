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
--              Core - Debug Unit                                             --
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
--   Paco Reina Campo <pacoreinacampo@queenfield.tech>

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.pu_riscv_vhdl_pkg.all;
use work.vhdl_pkg.all;

entity pu_riscv_du is
  generic (
    XLEN : integer := 64;
    PLEN : integer := 64;
    ILEN : integer := 64;

    EXCEPTION_SIZE : integer := 16;

    DU_ADDR_SIZE    : integer := 12;
    MAX_BREAKPOINTS : integer := 8;

    BREAKPOINTS : integer := 3
    );
  port (
    rstn : in std_logic;
    clk  : in std_logic;

    -- Debug Port interface
    dbg_stall : in  std_logic;
    dbg_strb  : in  std_logic;
    dbg_we    : in  std_logic;
    dbg_addr  : in  std_logic_vector(63 downto 0);
    dbg_dati  : in  std_logic_vector(XLEN-1 downto 0);
    dbg_dato  : out std_logic_vector(XLEN-1 downto 0);
    dbg_ack   : out std_logic;
    dbg_bp    : out std_logic;

    -- CPU signals
    du_stall     : out std_logic;
    du_stall_dly : out std_logic;
    du_flush     : out std_logic;
    du_we_rf     : out std_logic;
    du_we_frf    : out std_logic;
    du_we_csr    : out std_logic;
    du_we_pc     : out std_logic;
    du_addr      : out std_logic_vector(DU_ADDR_SIZE-1 downto 0);
    du_dato      : out std_logic_vector(XLEN-1 downto 0);
    du_ie        : out std_logic_vector(31 downto 0);
    du_dati_rf   : in  std_logic_vector(XLEN-1 downto 0);
    du_dati_frf  : in  std_logic_vector(XLEN-1 downto 0);
    st_csr_rval  : in  std_logic_vector(XLEN-1 downto 0);
    if_pc        : in  std_logic_vector(XLEN-1 downto 0);
    id_pc        : in  std_logic_vector(XLEN-1 downto 0);
    ex_pc        : in  std_logic_vector(XLEN-1 downto 0);
    bu_nxt_pc    : in  std_logic_vector(XLEN-1 downto 0);
    bu_flush     : in  std_logic;
    st_flush     : in  std_logic;

    if_instr      : in std_logic_vector(ILEN-1 downto 0);
    mem_instr     : in std_logic_vector(ILEN-1 downto 0);
    if_bubble     : in std_logic;
    mem_bubble    : in std_logic;
    mem_exception : in std_logic_vector(EXCEPTION_SIZE-1 downto 0);
    mem_memadr    : in std_logic_vector(XLEN-1 downto 0);
    dmem_ack      : in std_logic;
    ex_stall      : in std_logic;

    -- From state
    du_exceptions : in std_logic_vector(31 downto 0)
    );
end pu_riscv_du;

architecture rtl of pu_riscv_du is
  ------------------------------------------------------------------------------
  -- Constants
  ------------------------------------------------------------------------------
  constant DBG_ADDR_INTERNAL : std_logic_vector(63 downto 0) := "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX0000XXXXXXXXXXXX";
  constant DBG_ADDR_GPR      : std_logic_vector(63 downto 0) := "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX00010000000XXXXX";
  constant DBG_ADDR_FPR      : std_logic_vector(63 downto 0) := "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX00010001000XXXXX";
  constant DBG_ADDR_NPC      : std_logic_vector(63 downto 0) := "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX0001001000000000";
  constant DBG_ADDR_PPC      : std_logic_vector(63 downto 0) := "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX0001001000000001";
  constant DBG_ADDR_CSRS     : std_logic_vector(63 downto 0) := "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX0010XXXXXXXXXXXX";

  ------------------------------------------------------------------------------
  -- Variables
  ------------------------------------------------------------------------------
  signal dbg_strb_dly    : std_logic;
  signal du_bank_addr    : std_logic_vector(PLEN-1 downto DU_ADDR_SIZE);
  signal du_sel_internal : std_logic;
  signal du_sel_gprs     : std_logic;
  signal du_sel_csrs     : std_logic;
  signal du_access       : std_logic;
  signal du_we           : std_logic;
  signal du_ack          : std_logic_vector(2 downto 0);

  signal du_we_internal   : std_logic;
  signal du_internal_regs : std_logic_vector(XLEN-1 downto 0);

  signal dbg_branch_break_ena : std_logic;
  signal dbg_instr_break_ena  : std_logic;
  signal dbg_ies              : std_logic_vector(31 downto 0);
  signal dbg_causes           : std_logic_vector(XLEN-1 downto 0);
  signal dbg_bp_hit           : std_logic_vector(MAX_BREAKPOINTS-1 downto 0);
  signal dbg_branch_break_hit : std_logic;
  signal dbg_instr_break_hit  : std_logic;
  signal dbg_cc               : std_logic_matrix(7 downto 0)(2 downto 0);
  signal dbg_enabled          : std_logic_vector(MAX_BREAKPOINTS-1 downto 0);
  signal dbg_implemented      : std_logic_vector(MAX_BREAKPOINTS-1 downto 0);
  signal dbg_data             : std_logic_matrix(7 downto 0)(XLEN-1 downto 0);

  signal bp_instr_hit  : std_logic;
  signal bp_branch_hit : std_logic;
  signal bp_hit        : std_logic_vector(MAX_BREAKPOINTS-1 downto 0);

  signal mem_read  : std_logic;
  signal mem_write : std_logic;

  signal du_stall_dly_sgn : std_logic;
  signal du_flush_sgn     : std_logic;
  signal du_addr_sgn      : std_logic_vector(11 downto 0);
  signal du_dato_sgn      : std_logic_vector(XLEN-1 downto 0);

begin
  ------------------------------------------------------------------------------
  -- Module Body
  ------------------------------------------------------------------------------

  -- Debugger Interface

  -- Decode incoming address
  du_bank_addr    <= dbg_addr(PLEN-1 downto DU_ADDR_SIZE);
  du_sel_internal <= to_stdlogic(du_bank_addr(15 downto 12) = DBG_INTERNAL);
  du_sel_gprs     <= to_stdlogic(du_bank_addr(15 downto 12) = DBG_GPRS);
  du_sel_csrs     <= to_stdlogic(du_bank_addr(15 downto 12) = DBG_CSRS);

  -- generate 1 cycle pulse strobe
  processing_0 : process (clk)
  begin
    if (rising_edge(clk)) then
      dbg_strb_dly <= dbg_strb;
    end if;
  end process;

  -- generate (write) access signals
  du_access <= (dbg_strb and dbg_stall) or (dbg_strb and du_sel_internal);
  du_we     <= du_access and not dbg_strb_dly and dbg_we;

  -- generate ACK
  processing_1 : process (clk, rstn)
  begin
    if (rstn = '0') then
      du_ack <= (others => '0');
    elsif (rising_edge(clk)) then
      if (ex_stall = '0') then
        du_ack <= ((du_access and not du_ack(0)) &
                   (du_access and not du_ack(0)) &
                   (du_access and not du_ack(0))) and ('1' & du_ack(2 downto 1));
      end if;
    end if;
  end process;

  dbg_ack <= du_ack(0);

  -- actual BreakPoint signal
  processing_2 : process (clk, rstn)
  begin
    if (rstn = '0') then
      dbg_bp <= '0';
    elsif (rising_edge(clk)) then
      dbg_bp <= not ex_stall and not dbg_stall and not du_flush_sgn and not bu_flush and not st_flush and (reduce_or(du_exceptions) or reduce_or((dbg_bp_hit & dbg_branch_break_hit & dbg_instr_break_hit)));
    end if;
  end process;

  -- CPU Interface

  -- assign CPU signals
  du_stall <= dbg_stall;

  processing_3 : process (clk, rstn)
  begin
    if (rstn = '0') then
      du_stall_dly_sgn <= '0';
    elsif (rising_edge(clk)) then
      du_stall_dly_sgn <= dbg_stall;
    end if;
  end process;

  du_stall_dly <= du_stall_dly_sgn;

  du_flush_sgn <= du_stall_dly_sgn and not dbg_stall and reduce_or(du_exceptions);
  du_flush     <= du_flush_sgn;

  processing_4 : process (clk)
  begin
    if (rising_edge(clk)) then
      du_addr_sgn <= dbg_addr(DU_ADDR_SIZE-1 downto 0);
      du_dato_sgn <= dbg_dati;

      du_we_rf       <= du_we and du_sel_gprs and to_stdlogic(dbg_addr(DU_ADDR_SIZE-1 downto 0) = DBG_GPR);
      du_we_frf      <= du_we and du_sel_gprs and to_stdlogic(dbg_addr(DU_ADDR_SIZE-1 downto 0) = DBG_FPR);
      du_we_internal <= du_we and du_sel_internal;
      du_we_csr      <= du_we and du_sel_csrs;
      du_we_pc       <= du_we and du_sel_gprs and to_stdlogic(dbg_addr(DU_ADDR_SIZE-1 downto 0) = DBG_NPC);
    end if;
  end process;

  du_addr <= du_addr_sgn;
  du_dato <= du_dato_sgn;

  -- Return signals
  processing_5 : process (dbg_bp_hit, dbg_branch_break_ena, dbg_branch_break_hit, dbg_causes, dbg_cc, dbg_data, dbg_enabled, dbg_ies, dbg_implemented, dbg_instr_break_ena, dbg_instr_break_hit, du_addr_sgn)
  begin
    case (du_addr_sgn) is
      when DBG_CTRL =>
        du_internal_regs <= ((XLEN-1 downto 2 => '0') & dbg_branch_break_ena & dbg_instr_break_ena);
      when DBG_HIT =>
        du_internal_regs <= ((XLEN-1 downto 14 => '0') & dbg_bp_hit & X"0" & dbg_branch_break_hit & dbg_instr_break_hit);
      when DBG_IE =>
        du_internal_regs <= ((XLEN-1 downto 32 => '0') & dbg_ies);
      when DBG_CAUSE =>
        du_internal_regs <= dbg_causes;
      when DBG_BPCTRL0 =>
        du_internal_regs <= ((XLEN-1 downto 7 => '0') & dbg_cc(0) & "00" & dbg_enabled(0) & dbg_implemented(0));
      when DBG_BPDATA0 =>
        du_internal_regs <= dbg_data(0);
      when DBG_BPCTRL1 =>
        du_internal_regs <= ((XLEN-1 downto 7 => '0') & dbg_cc(1) & "00" & dbg_enabled(1) & dbg_implemented(1));
      when DBG_BPDATA1 =>
        du_internal_regs <= dbg_data(1);
      when DBG_BPCTRL2 =>
        du_internal_regs <= ((XLEN-1 downto 7 => '0') & dbg_cc(2) & "00" & dbg_enabled(2) & dbg_implemented(2));
      when DBG_BPDATA2 =>
        du_internal_regs <= dbg_data(2);
      when DBG_BPCTRL3 =>
        du_internal_regs <= ((XLEN-1 downto 7 => '0') & dbg_cc(3) & "00" & dbg_enabled(3) & dbg_implemented(3));
      when DBG_BPDATA3 =>
        du_internal_regs <= dbg_data(3);
      when DBG_BPCTRL4 =>
        du_internal_regs <= ((XLEN-1 downto 7 => '0') & dbg_cc(4) & "00" & dbg_enabled(4) & dbg_implemented(4));
      when DBG_BPDATA4 =>
        du_internal_regs <= dbg_data(4);
      when DBG_BPCTRL5 =>
        du_internal_regs <= ((XLEN-1 downto 7 => '0') & dbg_cc(5) & "00" & dbg_enabled(5) & dbg_implemented(5));
      when DBG_BPDATA5 =>
        du_internal_regs <= dbg_data(5);
      when DBG_BPCTRL6 =>
        du_internal_regs <= ((XLEN-1 downto 7 => '0') & dbg_cc(6) & "00" & dbg_enabled(6) & dbg_implemented(6));
      when DBG_BPDATA6 =>
        du_internal_regs <= dbg_data(6);
      when DBG_BPCTRL7 =>
        du_internal_regs <= ((XLEN-1 downto 7 => '0') & dbg_cc(7) & "00" & dbg_enabled(7) & dbg_implemented(7));
      when DBG_BPDATA7 =>
        du_internal_regs <= dbg_data(7);
      when others =>
        du_internal_regs <= (others => '0');
    end case;
  end process;

  processing_6 : process (clk)
  begin
    if (rising_edge(clk)) then
      case (dbg_addr) is
        when (DBG_ADDR_INTERNAL) =>
          dbg_dato <= du_internal_regs;
        when (DBG_ADDR_GPR) =>
          dbg_dato <= du_dati_rf;
        when (DBG_ADDR_FPR) =>
          dbg_dato <= du_dati_frf;
        when (DBG_ADDR_NPC) =>
          if (bu_flush = '1') then
            dbg_dato <= bu_nxt_pc;
          else
            dbg_dato <= id_pc;
          end if;
        when (DBG_ADDR_PPC) =>
          dbg_dato <= ex_pc;
        when (DBG_ADDR_CSRS) =>
          dbg_dato <= st_csr_rval;
        when others =>
          dbg_dato <= (others => '0');
      end case;
    end if;
  end process;

  -- Registers

  -- DBG CTRL
  processing_7 : process (clk, rstn)
  begin
    if (rstn = '0') then
      dbg_instr_break_ena  <= '0';
      dbg_branch_break_ena <= '0';
    elsif (rising_edge(clk)) then
      if (du_we_internal = '1' and du_addr_sgn = DBG_CTRL) then
        dbg_instr_break_ena  <= du_dato_sgn(0);
        dbg_branch_break_ena <= du_dato_sgn(1);
      end if;
    end if;
  end process;

  -- DBG HIT
  processing_8 : process (clk, rstn)
  begin
    if (rstn = '0') then
      dbg_instr_break_hit  <= '0';
      dbg_branch_break_hit <= '0';
    elsif (rising_edge(clk)) then
      if (du_we_internal = '1' and du_addr_sgn = DBG_HIT) then
        dbg_instr_break_hit  <= du_dato_sgn(0);
        dbg_branch_break_hit <= du_dato_sgn(1);
      elsif (bp_instr_hit = '1') then
        dbg_instr_break_hit <= '1';
        if (bp_branch_hit = '1') then
          dbg_branch_break_hit <= '1';
        end if;
      end if;
    end if;
  end process;

  generating_0 : for n in 0 to MAX_BREAKPOINTS - 1 generate
    generating_1 : if (n < BREAKPOINTS) generate
      processing_9 : process (clk, rstn)
      begin
        if (rstn = '0') then
          dbg_bp_hit(n) <= '0';
        elsif (rising_edge(clk)) then
          if (du_we_internal = '1' and du_addr_sgn = DBG_HIT) then
            dbg_bp_hit(n) <= du_dato_sgn(n+4);
          elsif (bp_hit(n) = '1') then
            dbg_bp_hit(n) <= '1';
          end if;
        end if;
      end process;
    end generate generating_1;
  end generate generating_0;
  -- else //n >= BREAKPOINTS
  -- assign dbg_bp_hit[n] = 1'b0;

  -- DBG IE
  processing_10 : process (clk, rstn)
  begin
    if (rstn = '0') then
      dbg_ies <= (others => '0');
    elsif (rising_edge(clk)) then
      if (du_we_internal = '1' and du_addr_sgn = DBG_IE) then
        dbg_ies <= du_dato_sgn(31 downto 0);
      end if;
    end if;
  end process;

  -- send to Thread-State
  du_ie <= dbg_ies;

  -- DBG CAUSE
  processing_11 : process (clk, rstn)
  begin
    if (rstn = '0') then
      dbg_causes <= (others => '0');
    elsif (rising_edge(clk)) then
      if (du_we_internal = '1' and du_addr_sgn = DBG_CAUSE) then
        dbg_causes <= du_dato_sgn;
      elsif (reduce_or(du_exceptions(15 downto 0)) = '1') then   -- traps
        case ((du_exceptions(15 downto 0))) is
          when X"0001" =>
            dbg_causes <= X"0000000000000000";
          when X"0002" =>
            dbg_causes <= X"0000000000000001";
          when X"0004" =>
            dbg_causes <= X"0000000000000002";
          when X"0008" =>
            dbg_causes <= X"0000000000000003";
          when X"0010" =>
            dbg_causes <= X"0000000000000004";
          when X"0020" =>
            dbg_causes <= X"0000000000000005";
          when X"0040" =>
            dbg_causes <= X"0000000000000006";
          when X"0080" =>
            dbg_causes <= X"0000000000000007";
          when X"0100" =>
            dbg_causes <= X"0000000000000008";
          when X"0200" =>
            dbg_causes <= X"0000000000000009";
          when X"0400" =>
            dbg_causes <= X"0000000000000010";
          when X"0800" =>
            dbg_causes <= X"0000000000000011";
          when X"1000" =>
            dbg_causes <= X"0000000000000012";
          when X"2000" =>
            dbg_causes <= X"0000000000000013";
          when X"4000" =>
            dbg_causes <= X"0000000000000014";
          when X"8000" =>
            dbg_causes <= X"0000000000000015";
          when others =>
            dbg_causes <= X"0000000000000000";
        end case;
      elsif (reduce_or(du_exceptions(31 downto 16)) = '1') then  -- Interrupts
        case ((du_exceptions(31 downto 16))) is
          when X"0001" =>
            dbg_causes <= std_logic_vector(to_unsigned(1, XLEN) sll (XLEN-1)) or X"0000000000000000";
          when X"0002" =>
            dbg_causes <= std_logic_vector(to_unsigned(1, XLEN) sll (XLEN-1)) or X"0000000000000001";
          when X"0004" =>
            dbg_causes <= std_logic_vector(to_unsigned(1, XLEN) sll (XLEN-1)) or X"0000000000000002";
          when X"0008" =>
            dbg_causes <= std_logic_vector(to_unsigned(1, XLEN) sll (XLEN-1)) or X"0000000000000003";
          when X"0010" =>
            dbg_causes <= std_logic_vector(to_unsigned(1, XLEN) sll (XLEN-1)) or X"0000000000000004";
          when X"0020" =>
            dbg_causes <= std_logic_vector(to_unsigned(1, XLEN) sll (XLEN-1)) or X"0000000000000005";
          when X"0040" =>
            dbg_causes <= std_logic_vector(to_unsigned(1, XLEN) sll (XLEN-1)) or X"0000000000000006";
          when X"0080" =>
            dbg_causes <= std_logic_vector(to_unsigned(1, XLEN) sll (XLEN-1)) or X"0000000000000007";
          when X"0100" =>
            dbg_causes <= std_logic_vector(to_unsigned(1, XLEN) sll (XLEN-1)) or X"0000000000000008";
          when X"0200" =>
            dbg_causes <= std_logic_vector(to_unsigned(1, XLEN) sll (XLEN-1)) or X"0000000000000009";
          when X"0400" =>
            dbg_causes <= std_logic_vector(to_unsigned(1, XLEN) sll (XLEN-1)) or X"0000000000000010";
          when X"0800" =>
            dbg_causes <= std_logic_vector(to_unsigned(1, XLEN) sll (XLEN-1)) or X"0000000000000011";
          when X"1000" =>
            dbg_causes <= std_logic_vector(to_unsigned(1, XLEN) sll (XLEN-1)) or X"0000000000000012";
          when X"2000" =>
            dbg_causes <= std_logic_vector(to_unsigned(1, XLEN) sll (XLEN-1)) or X"0000000000000013";
          when X"4000" =>
            dbg_causes <= std_logic_vector(to_unsigned(1, XLEN) sll (XLEN-1)) or X"0000000000000014";
          when X"8000" =>
            dbg_causes <= std_logic_vector(to_unsigned(1, XLEN) sll (XLEN-1)) or X"0000000000000015";
          when others =>
            dbg_causes <= std_logic_vector(to_unsigned(1, XLEN) sll (XLEN-1)) or X"0000000000000000";
        end case;
      end if;
    end if;
  end process;

  -- DBG BPCTRL / DBG BPDATA
  generating_2 : for n in 0 to MAX_BREAKPOINTS - 1 generate
    generating_3 : if (n < BREAKPOINTS) generate
      dbg_implemented(n) <= '1';

      processing_12 : process (clk, rstn)
      begin
        if (rstn = '0') then
          dbg_enabled(n) <= '0';
          dbg_cc(n)      <= (others => '0');
        elsif (rising_edge(clk)) then
          if (du_we_internal = '1' and unsigned(du_addr_sgn) = unsigned(DBG_BPCTRL0)+to_unsigned(2*n, DU_ADDR_SIZE)) then
            dbg_enabled(n) <= du_dato_sgn(1);
            dbg_cc(n)      <= du_dato_sgn(6 downto 4);
          end if;
        end if;
      end process;
      processing_13 : process (clk, rstn)
      begin
        if (rstn = '0') then
          dbg_data(n) <= (others => '0');
        elsif (rising_edge(clk)) then
          if (du_we_internal = '1' and unsigned(du_addr_sgn) = unsigned(DBG_BPDATA0)+to_unsigned(2*n, DU_ADDR_SIZE)) then
            dbg_data(n) <= du_dato_sgn;
          end if;
        end if;
      end process;
    end generate generating_3;
  end generate generating_2;
  -- else begin
  -- assign dbg_cc                [(n+1)*3-1:n*3] = 'h0;
  -- assign dbg_enabled                       [n] = 'h0;
  -- assign dbg_implemented                   [n] = 'h0;
  -- assign dbg_data        [(n+1)*XLEN-1:n*XLEN] = 'h0;
  -- end

  --  * BreakPoints
  --  *
  --  * Combinatorial generation of break-point hit logic
  --  * For actual registers see 'Registers' section

  bp_instr_hit  <= dbg_instr_break_ena and not if_bubble;
  bp_branch_hit <= dbg_branch_break_ena and not if_bubble and to_stdlogic(if_instr(6 downto 2) = OPC_BRANCH);

  -- Memory access
  mem_read  <= reduce_nor(mem_exception) and not mem_bubble and to_stdlogic(mem_instr(6 downto 2) = OPC_LOAD);
  mem_write <= reduce_nor(mem_exception) and not mem_bubble and to_stdlogic(mem_instr(6 downto 2) = OPC_STORE);

  generating_4 : for n in 0 to MAX_BREAKPOINTS - 1 generate
    generating_5 : if (n < BREAKPOINTS) generate
      processing_14 : process (bu_flush, dbg_cc, dbg_data, dbg_enabled, dbg_implemented, dmem_ack, if_pc, mem_memadr, mem_read, mem_write, st_flush)
      begin
        if (dbg_enabled(n) = '0' or dbg_implemented(n) = '0') then
          bp_hit(n) <= '0';
        else
          case (dbg_cc(n)) is
            when BP_CTRL_CC_FETCH =>
              bp_hit(n) <= to_stdlogic(if_pc = dbg_data(n)) and not bu_flush and not st_flush;
            when BP_CTRL_CC_LD_ADR =>
              bp_hit(n) <= to_stdlogic(mem_memadr = dbg_data(n)) and dmem_ack and mem_read;
            when BP_CTRL_CC_ST_ADR =>
              bp_hit(n) <= to_stdlogic(mem_memadr = dbg_data(n)) and dmem_ack and mem_write;
            when BP_CTRL_CC_LDST_ADR =>
              bp_hit(n) <= to_stdlogic(mem_memadr = dbg_data(n)) and dmem_ack and (mem_read or mem_write);
            -- BP_CTRL_CC_LD_ADR   : bp_hit[n] = (mem_adr == dbg_data[(n+1)*XLEN-1:n*XLEN]) & mem_req & ~mem_we;
            -- BP_CTRL_CC_ST_ADR   : bp_hit[n] = (mem_adr == dbg_data[(n+1)*XLEN-1:n*XLEN]) & mem_req &  mem_we;
            -- BP_CTRL_CC_LDST_ADR : bp_hit[n] = (mem_adr == dbg_data[(n+1)*XLEN-1:n*XLEN]) & mem_req;
            when others =>
              bp_hit(n) <= '0';
          end case;
        end if;
      end process;
    end generate generating_5;
  end generate generating_4;
end rtl;
