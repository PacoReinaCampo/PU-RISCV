-- Converted from rtl/verilog/core/riscv_execution.sv
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
--              Core - Execution Unit                                         //
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

use work.riscv_mpsoc_pkg.all;

entity riscv_execution is
  generic (
    XLEN           : integer := 64;
    ILEN           : integer := 64;
    EXCEPTION_SIZE : integer := 64;
    BP_GLOBAL_BITS : integer := 64;
    HAS_RVC        : std_logic := '1';
    HAS_RVA        : std_logic := '1';
    HAS_RVM        : std_logic := '1';
    MULT_LATENCY   : std_logic := '1';

    PC_INIT : std_logic_vector(63 downto 0) := X"0000000080000000"
  );
  port (
    rstn : in std_logic;
    clk  : in std_logic;

    wb_stall : in  std_logic;
    ex_stall : out std_logic;

    --Program counter
    id_pc         : in  std_logic_vector(XLEN-1 downto 0);
    ex_pc         : out std_logic_vector(XLEN-1 downto 0);
    bu_nxt_pc     : out std_logic_vector(XLEN-1 downto 0);
    bu_flush      : out std_logic;
    bu_cacheflush : out std_logic;
    id_bp_predict : in  std_logic_vector(1 downto 0);
    bu_bp_predict : out std_logic_vector(1 downto 0);
    bu_bp_history : out std_logic_vector(BP_GLOBAL_BITS-1 downto 0);
    bu_bp_btaken  : out std_logic;
    bu_bp_update  : out std_logic;

    --Instruction
    id_bubble : in  std_logic;
    id_instr  : in  std_logic_vector(ILEN-1 downto 0);
    ex_bubble : out std_logic;
    ex_instr  : out std_logic_vector(ILEN-1 downto 0);

    id_exception  : in  std_logic_vector(EXCEPTION_SIZE-1 downto 0);
    mem_exception : in  std_logic_vector(EXCEPTION_SIZE-1 downto 0);
    wb_exception  : in  std_logic_vector(EXCEPTION_SIZE-1 downto 0);
    ex_exception  : out std_logic_vector(EXCEPTION_SIZE-1 downto 0);

    --from ID
    id_userf_opA  : in std_logic;
    id_userf_opB  : in std_logic;
    id_bypex_opA  : in std_logic;
    id_bypex_opB  : in std_logic;
    id_bypmem_opA : in std_logic;
    id_bypmem_opB : in std_logic;
    id_bypwb_opA  : in std_logic;
    id_bypwb_opB  : in std_logic;
    id_opA        : in std_logic_vector(XLEN-1 downto 0);
    id_opB        : in std_logic_vector(XLEN-1 downto 0);

    --from RF
    rf_srcv1 : in std_logic_vector(XLEN-1 downto 0);
    rf_srcv2 : in std_logic_vector(XLEN-1 downto 0);

    --to MEM
    ex_r : out std_logic_vector(XLEN-1 downto 0);

    --Bypasses
    mem_r : in std_logic_vector(XLEN-1 downto 0);
    wb_r  : in std_logic_vector(XLEN-1 downto 0);

    --To State
    ex_csr_reg  : out std_logic_vector(11 downto 0);
    ex_csr_wval : out std_logic_vector(XLEN-1 downto 0);
    ex_csr_we   : out std_logic;

    --From State
    st_prv      : in std_logic_vector(1 downto 0);
    st_xlen     : in std_logic_vector(1 downto 0);
    st_flush    : in std_logic;
    st_csr_rval : in std_logic_vector(XLEN-1 downto 0);

    --To DCACHE/Memory
    dmem_adr        : out std_logic_vector(XLEN-1 downto 0);
    dmem_d          : out std_logic_vector(XLEN-1 downto 0);
    dmem_req        : out std_logic;
    dmem_we         : out std_logic;
    dmem_size       : out std_logic_vector(2 downto 0);
    dmem_ack        : in  std_logic;
    dmem_q          : in  std_logic_vector(XLEN-1 downto 0);
    dmem_misaligned : in  std_logic;
    dmem_page_fault : in  std_logic;

    --Debug Unit
    du_stall     : in std_logic;
    du_stall_dly : in std_logic;
    du_flush     : in std_logic;
    du_we_pc     : in std_logic;
    du_dato      : in std_logic_vector(XLEN-1 downto 0);
    du_ie        : in std_logic_vector(31 downto 0)
  );
end riscv_execution;

architecture RTL of riscv_execution is
  component riscv_alu
    generic (
      XLEN    : integer := 64;
      ILEN    : integer := 64;
      HAS_RVC : std_logic := '1'
    );
    port (
      rstn : in std_logic;
      clk  : in std_logic;

      ex_stall : in std_logic;

      --Program counter
      id_pc : in std_logic_vector(XLEN-1 downto 0);

      --Instruction
      id_bubble : in std_logic;
      id_instr  : in std_logic_vector(ILEN-1 downto 0);

      --Operands
      opA : in std_logic_vector(XLEN-1 downto 0);
      opB : in std_logic_vector(XLEN-1 downto 0);

      --to WB
      alu_bubble : out std_logic;
      alu_r      : out std_logic_vector(XLEN-1 downto 0);

      --To State
      ex_csr_reg  : out std_logic_vector(11 downto 0);
      ex_csr_wval : out std_logic_vector(XLEN-1 downto 0);
      ex_csr_we   : out std_logic;

      --From State
      st_csr_rval : in std_logic_vector(XLEN-1 downto 0);
      st_xlen     : in std_logic_vector(1 downto 0)
    );
  end component;

  component riscv_lsu
    generic (
      XLEN           : integer := 64;
      ILEN           : integer := 64;
      EXCEPTION_SIZE : integer := 16
    );
    port (
      rstn : in std_logic;
      clk  : in std_logic;

      ex_stall  : in  std_logic;
      lsu_stall : out std_logic;

      --Instruction
      id_bubble : in std_logic;
      id_instr  : in std_logic_vector(ILEN-1 downto 0);

      lsu_bubble : out std_logic;
      lsu_r      : out std_logic_vector(XLEN-1 downto 0);

      id_exception  : in  std_logic_vector(EXCEPTION_SIZE-1 downto 0);
      ex_exception  : in  std_logic_vector(EXCEPTION_SIZE-1 downto 0);
      mem_exception : in  std_logic_vector(EXCEPTION_SIZE-1 downto 0);
      wb_exception  : in  std_logic_vector(EXCEPTION_SIZE-1 downto 0);
      lsu_exception : out std_logic_vector(EXCEPTION_SIZE-1 downto 0);

      --Operands
      opA : in std_logic_vector(XLEN-1 downto 0);
      opB : in std_logic_vector(XLEN-1 downto 0);

      --From State
      st_xlen : in std_logic_vector(1 downto 0);

      --To Memory
      dmem_adr, dmem_d  : out std_logic_vector(XLEN-1 downto 0);
      dmem_req, dmem_we : out std_logic;
      dmem_size         : out std_logic_vector(2 downto 0);

      --From Memory (for AMO)
      dmem_ack        : in std_logic;
      dmem_q          : in std_logic_vector(XLEN-1 downto 0);
      dmem_misaligned : in std_logic;
      dmem_page_fault : in std_logic
    );
  end component;

  component riscv_bu
    generic (
      XLEN           : integer := 64;
      ILEN           : integer := 64;
      EXCEPTION_SIZE : integer := 16;
      BP_GLOBAL_BITS : integer := 2;

      HAS_RVC : std_logic := '1';
      PC_INIT : std_logic_vector(63 downto 0) := X"0000000080000000"
    );
    port (
      rstn : in std_logic;
      clk  : in std_logic;

      ex_stall : in std_logic;
      st_flush : in std_logic;

      --Program counter
      id_pc         : in  std_logic_vector(XLEN-1 downto 0);
      bu_nxt_pc     : out std_logic_vector(XLEN-1 downto 0);
      bu_flush      : out std_logic;
      bu_cacheflush : out std_logic;
      id_bp_predict : in  std_logic_vector(1 downto 0);
      bu_bp_predict : out std_logic_vector(1 downto 0);
      bu_bp_history : out std_logic_vector(BP_GLOBAL_BITS-1 downto 0);
      bu_bp_btaken  : out std_logic;
      bu_bp_update  : out std_logic;

      --Instruction
      id_bubble : in std_logic;
      id_instr  : in std_logic_vector(ILEN-1 downto 0);

      id_exception  : in  std_logic_vector(EXCEPTION_SIZE-1 downto 0);
      ex_exception  : in  std_logic_vector(EXCEPTION_SIZE-1 downto 0);
      mem_exception : in  std_logic_vector(EXCEPTION_SIZE-1 downto 0);
      wb_exception  : in  std_logic_vector(EXCEPTION_SIZE-1 downto 0);
      bu_exception  : out std_logic_vector(EXCEPTION_SIZE-1 downto 0);

      --from ID
      opA : in std_logic_vector(XLEN-1 downto 0);
      opB : in std_logic_vector(XLEN-1 downto 0);

      --Debug Unit
      du_stall : in std_logic;
      du_flush : in std_logic;
      du_we_pc : in std_logic;
      du_dato  : in std_logic_vector(XLEN-1 downto 0);
      du_ie    : in std_logic_vector(31 downto 0)
    );
  end component;

  component riscv_mul
    generic (
      XLEN : integer := 64;
      ILEN : integer := 64
    );
    port (
      rstn : in std_logic;
      clk  : in std_logic;

      ex_stall  : in  std_logic;
      mul_stall : out std_logic;

      --Instruction
      id_bubble : in std_logic;
      id_instr  : in std_logic_vector(ILEN-1 downto 0);

      --Operands
      opA : in std_logic_vector(XLEN-1 downto 0);
      opB : in std_logic_vector(XLEN-1 downto 0);

      --from State
      st_xlen : in std_logic_vector(1 downto 0);

      --to WB
      mul_bubble : out std_logic;
      mul_r      : out std_logic_vector(XLEN-1 downto 0)
    );
  end component;

  component riscv_div
    generic (
      XLEN : integer := 64;
      ILEN : integer := 64
    );
    port (
      rstn : in std_logic;
      clk  : in std_logic;

      ex_stall  : in  std_logic;
      div_stall : out std_logic;

      --Instruction
      id_bubble : in std_logic;
      id_instr  : in std_logic_vector(ILEN-1 downto 0);

      --Operands
      opA : in std_logic_vector(XLEN-1 downto 0);
      opB : in std_logic_vector(XLEN-1 downto 0);

      --From State
      st_xlen : in std_logic_vector(1 downto 0);

      --To WB
      div_bubble : out std_logic;
      div_r      : out std_logic_vector(XLEN-1 downto 0)
    );
  end component;

  --//////////////////////////////////////////////////////////////
  --
  -- Variables
  --

  --Operand generation
  signal opA : std_logic_vector(XLEN-1 downto 0);
  signal opB : std_logic_vector(XLEN-1 downto 0);

  signal alu_r : std_logic_vector(XLEN-1 downto 0);
  signal lsu_r : std_logic_vector(XLEN-1 downto 0);
  signal mul_r : std_logic_vector(XLEN-1 downto 0);
  signal div_r : std_logic_vector(XLEN-1 downto 0);

  --Pipeline Bubbles
  signal alu_bubble : std_logic;
  signal lsu_bubble : std_logic;
  signal mul_bubble : std_logic;
  signal div_bubble : std_logic;

  --Pipeline stalls
  signal lsu_stall : std_logic;
  signal mul_stall : std_logic;
  signal div_stall : std_logic;

  --Exceptions
  signal bu_exception  : std_logic_vector(EXCEPTION_SIZE-1 downto 0);
  signal lsu_exception : std_logic_vector(EXCEPTION_SIZE-1 downto 0);

  signal ex_stall_sgn     : std_logic;
  signal ex_r_sgn         : std_logic_vector(XLEN-1 downto 0);
  signal ex_exception_sgn : std_logic_vector(EXCEPTION_SIZE-1 downto 0);

begin
  --//////////////////////////////////////////////////////////////
  --
  -- Module Body
  --

  --Program Counter
  processing_0 : process (clk, rstn)
  begin
    if (rstn = '0') then
      ex_pc <= PC_INIT;
    elsif (rising_edge(clk)) then
      if (ex_stall_sgn = '0' and du_stall = '0') then  --stall during DBG to retain PPC
        ex_pc <= id_pc;
      end if;
    end if;
  end process;

  --Instruction
  processing_1 : process (clk)
  begin
    if (rising_edge(clk)) then
       if (ex_stall_sgn = '0') then
        ex_instr <= id_instr;
      end if;
    end if;
  end process;

  --Bypasses

  --Ignore the bypasses during dbg_stall, use register-file instead
  --use du_stall_dly, because this is combinatorial
  --When the pipeline is longer than the time for the debugger to access the system, this fails
  processing_2 : process (du_stall_dly, ex_r_sgn, id_bypex_opA, id_bypmem_opA, id_bypwb_opA, id_opA, id_userf_opA, mem_r, rf_srcv1, wb_r)
    variable state : std_logic_vector(3 downto 0);
  begin
    case (state) is
      when "XXX1" =>
        if (du_stall_dly = '1') then
          opA <= rf_srcv1;
        else
          opA <= ex_r_sgn;
        end if;
      when "XX10" =>
        if (du_stall_dly = '1') then
          opA <= rf_srcv1;
        else
          opA <= mem_r;
        end if;
      when "X100" =>
        if (du_stall_dly = '1') then
          opA <= rf_srcv1;
        else
          opA <= wb_r;
        end if;
      when "1000" =>
        opA <= rf_srcv1;
      when others =>
        opA <= id_opA;
    end case;
    state := id_userf_opA & id_bypwb_opA & id_bypmem_opA & id_bypex_opA;
  end process;

  processing_3 : process (du_stall_dly, ex_r_sgn, id_bypex_opB, id_bypmem_opB, id_bypwb_opB, id_opB, id_userf_opB, mem_r, rf_srcv2, wb_r)
    variable state : std_logic_vector(3 downto 0);
  begin
    case (state) is
      when "XXX1" =>
        if (du_stall_dly = '1') then
          opB <= rf_srcv2;
        else
          opB <= ex_r_sgn;
        end if;
      when "XX10" =>
        if (du_stall_dly = '1') then
          opB <= rf_srcv2;
        else
          opB <= mem_r;
        end if;
      when "X100" =>
        if (du_stall_dly = '1') then
          opB <= rf_srcv2;
        else
          opB <= wb_r;
        end if;
      when "1000" =>
        opB <= rf_srcv2;
      when others =>
        opB <= id_opB;
    end case;
    state := id_userf_opB & id_bypwb_opB & id_bypmem_opB & id_bypex_opB;
  end process;

  --Execution Units
  alu : riscv_alu
    generic map (
      XLEN    => XLEN,
      ILEN    => ILEN,
      HAS_RVC => HAS_RVC
    )
    port map (
      rstn        => rstn,
      clk         => clk,
      ex_stall    => ex_stall_sgn,
      id_pc       => id_pc,
      id_bubble   => id_bubble,
      id_instr    => id_instr,
      opA         => opA,
      opB         => opB,
      alu_bubble  => alu_bubble,
      alu_r       => alu_r,
      ex_csr_reg  => ex_csr_reg,
      ex_csr_wval => ex_csr_wval,
      ex_csr_we   => ex_csr_we,
      st_csr_rval => st_csr_rval,
      st_xlen     => st_xlen
    );

  -- Load-Store Unit
  lsu : riscv_lsu
    generic map (
      XLEN           => XLEN,
      ILEN           => ILEN,
      EXCEPTION_SIZE => EXCEPTION_SIZE
    )
    port map (
      rstn            => rstn,
      clk             => clk,
      ex_stall        => ex_stall_sgn,
      lsu_stall       => lsu_stall,
      id_bubble       => id_bubble,
      id_instr        => id_instr,
      lsu_bubble      => lsu_bubble,
      lsu_r           => lsu_r,
      id_exception    => id_exception,
      ex_exception    => ex_exception_sgn,
      mem_exception   => mem_exception,
      wb_exception    => wb_exception,
      lsu_exception   => lsu_exception,
      opA             => opA,
      opB             => opB,
      st_xlen         => st_xlen,
      dmem_adr        => dmem_adr,
      dmem_d          => dmem_d,
      dmem_req        => dmem_req,
      dmem_we         => dmem_we,
      dmem_size       => dmem_size,
      dmem_ack        => dmem_ack,
      dmem_q          => dmem_q,
      dmem_misaligned => dmem_misaligned,
      dmem_page_fault => dmem_page_fault
    );

  -- Branch Unit
  bu : riscv_bu
    generic map (
      XLEN           => XLEN,
      ILEN           => ILEN,
      EXCEPTION_SIZE => EXCEPTION_SIZE,
      BP_GLOBAL_BITS => BP_GLOBAL_BITS,

      HAS_RVC => HAS_RVC,
      PC_INIT => PC_INIT
    )
    port map (
      rstn          => rstn,
      clk           => clk,
      ex_stall      => ex_stall_sgn,
      st_flush      => st_flush,
      id_pc         => id_pc,
      bu_nxt_pc     => bu_nxt_pc,
      bu_flush      => bu_flush,
      bu_cacheflush => bu_cacheflush,
      id_bp_predict => id_bp_predict,
      bu_bp_predict => bu_bp_predict,
      bu_bp_history => bu_bp_history,
      bu_bp_btaken  => bu_bp_btaken,
      bu_bp_update  => bu_bp_update,
      id_bubble     => id_bubble,
      id_instr      => id_instr,
      id_exception  => id_exception,
      ex_exception  => ex_exception_sgn,
      mem_exception => mem_exception,
      wb_exception  => wb_exception,
      bu_exception  => ex_exception_sgn,
      opA           => opA,
      opB           => opB,
      du_stall      => du_stall,
      du_flush      => du_flush,
      du_we_pc      => du_we_pc,
      du_dato       => du_dato,
      du_ie         => du_ie
    );

  ex_exception <= ex_exception_sgn;

  generating_0 : if (HAS_RVM = '1') generate
    mul : riscv_mul
      generic map (
        XLEN => XLEN,
        ILEN => ILEN
      )
      port map (
        rstn       => rstn,
        clk        => clk,
        ex_stall   => ex_stall_sgn,
        mul_stall  => mul_stall,
        id_bubble  => id_bubble,
        id_instr   => id_instr,
        opA        => opA,
        opB        => opB,
        st_xlen    => st_xlen,
        mul_bubble => mul_bubble,
        mul_r      => mul_r
      );

    div : riscv_div
      generic map (
        XLEN => XLEN,
        ILEN => ILEN
      )
      port map (
        rstn       => rstn,
        clk        => clk,
        ex_stall   => ex_stall_sgn,
        div_stall  => div_stall,
        id_bubble  => id_bubble,
        id_instr   => id_instr,
        opA        => opA,
        opB        => opB,
        st_xlen    => st_xlen,
        div_bubble => div_bubble,
        div_r      => div_r
      );
  elsif (HAS_RVM = '0') generate
    mul_bubble <= '1';
    mul_r      <= (others => '0');
    mul_stall  <= '0';

    div_bubble <= '1';
    div_r      <= (others => '0');
    div_stall  <= '0';
  end generate;

  --Combine outputs into 1 single EX output
  ex_bubble     <= alu_bubble and lsu_bubble and mul_bubble and div_bubble;
  ex_stall_sgn  <= wb_stall or lsu_stall or mul_stall or div_stall;

  ex_stall <= ex_stall_sgn;

  --result
  processing_4 : process (alu_r, div_bubble, div_r, lsu_bubble, lsu_r, mul_bubble, mul_r)
    variable state : std_logic_vector(2 downto 0);
  begin
    case (state) is
      when "110" =>
        ex_r_sgn <= lsu_r;
      when "101" =>
        ex_r_sgn <= div_r;
      when "011" =>
        ex_r_sgn <= mul_r;
      when others =>
        ex_r_sgn <= alu_r;
    end case;
    state := mul_bubble & div_bubble & lsu_bubble;
  end process;

  ex_r <= ex_r_sgn;
end RTL;
