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
--              Core - Load Store Unit                                        --
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

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.pu_riscv_vhdl_pkg.all;
use work.peripheral_biu_vhdl_pkg.all;
use work.vhdl_pkg.all;

entity pu_riscv_lsu is
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

    -- Instruction
    id_bubble : in std_logic;
    id_instr  : in std_logic_vector(ILEN-1 downto 0);

    lsu_bubble : out std_logic;
    lsu_r      : out std_logic_vector(XLEN-1 downto 0);

    id_exception  : in  std_logic_vector(EXCEPTION_SIZE-1 downto 0);
    ex_exception  : in  std_logic_vector(EXCEPTION_SIZE-1 downto 0);
    mem_exception : in  std_logic_vector(EXCEPTION_SIZE-1 downto 0);
    wb_exception  : in  std_logic_vector(EXCEPTION_SIZE-1 downto 0);
    lsu_exception : out std_logic_vector(EXCEPTION_SIZE-1 downto 0);

    -- Operands
    opA : in std_logic_vector(XLEN-1 downto 0);
    opB : in std_logic_vector(XLEN-1 downto 0);

    -- From State
    st_xlen : in std_logic_vector(1 downto 0);

    -- To Memory
    dmem_adr  : out std_logic_vector(XLEN-1 downto 0);
    dmem_d    : out std_logic_vector(XLEN-1 downto 0);
    dmem_req  : out std_logic;
    dmem_we   : out std_logic;
    dmem_size : out std_logic_vector(2 downto 0);

    -- From Memory (for AMO)
    dmem_ack        : in std_logic;
    dmem_q          : in std_logic_vector(XLEN-1 downto 0);
    dmem_misaligned : in std_logic;
    dmem_page_fault : in std_logic
    );
end pu_riscv_lsu;

architecture rtl of pu_riscv_lsu is
  ------------------------------------------------------------------------------
  -- Constants
  ------------------------------------------------------------------------------
  constant IDLE : std_logic_vector(1 downto 0) := "00";

  ------------------------------------------------------------------------------
  -- Variables
  ------------------------------------------------------------------------------
  signal opcode : std_logic_vector(6 downto 2);
  signal func3  : std_logic_vector(2 downto 0);
  signal func7  : std_logic_vector(6 downto 0);
  signal xlen32 : std_logic;

  -- Operand generation
  signal immS : std_logic_vector(XLEN-1 downto 0);

  -- FSM
  signal state : std_logic_vector(1 downto 0);

  signal adr  : std_logic_vector(XLEN-1 downto 0);
  signal d    : std_logic_vector(XLEN-1 downto 0);
  signal size : std_logic_vector(2 downto 0);

  signal lsu_stall_o : std_logic;

begin
  ------------------------------------------------------------------------------
  -- Module Body
  ------------------------------------------------------------------------------

  -- Instruction
  func7  <= id_instr(31 downto 25);
  func3  <= id_instr(14 downto 12);
  opcode <= id_instr(6 downto 2);

  xlen32 <= to_stdlogic(st_xlen = RV32I);

  lsu_r <= (others => '0');             -- for AMO

  -- Decode Immediates
  immS <= ((XLEN-1 downto 11 => id_instr(31)) & id_instr(30 downto 25) & id_instr(11 downto 8) & id_instr(7));

  -- Access Statemachine
  processing_0 : process (clk, rstn)
  begin
    if (rstn = '0') then
      state       <= IDLE;
      lsu_stall_o <= '0';
      lsu_bubble  <= '1';
      dmem_req    <= '0';
    elsif (rising_edge(clk)) then
      dmem_req <= '0';
      case ((state)) is
        when IDLE =>
          if (ex_stall = '0') then
            if (id_bubble = '0' and (reduce_or(id_exception) or reduce_or(ex_exception) or reduce_or(mem_exception) or reduce_or(wb_exception)) = '0') then
              case ((opcode)) is
                when OPC_LOAD =>
                  dmem_req    <= '1';
                  lsu_stall_o <= '0';
                  lsu_bubble  <= '0';
                  state       <= IDLE;
                when OPC_STORE =>
                  dmem_req    <= '1';
                  lsu_stall_o <= '0';
                  lsu_bubble  <= '0';
                  state       <= IDLE;
                when others =>
                  dmem_req    <= '0';
                  lsu_stall_o <= '0';
                  lsu_bubble  <= '1';
                  state       <= IDLE;
              end case;
            else
              dmem_req    <= '0';
              lsu_stall_o <= '0';
              lsu_bubble  <= '1';
              state       <= IDLE;
            end if;
          end if;
        when others =>
          dmem_req    <= '0';
          lsu_stall_o <= '0';
          lsu_bubble  <= '1';
          state       <= IDLE;
      end case;
    end if;
  end process;

  lsu_stall <= lsu_stall_o;

  -- Memory Control Signals
  processing_1 : process (clk)
  begin
    if (rising_edge(clk)) then
      case ((state)) is
        when IDLE =>
          if (id_bubble = '0') then
            case ((opcode)) is
              when OPC_LOAD =>
                dmem_we   <= '0';
                dmem_size <= size;
                dmem_adr  <= adr;
                dmem_d    <= (others => 'X');
              when OPC_STORE =>
                dmem_we   <= '1';
                dmem_size <= size;
                dmem_adr  <= adr;
                dmem_d    <= d;
              when others =>
                -- do nothing
                null;
            end case;
          end if;
        when others =>
          dmem_we   <= 'X';
          dmem_size <= UNDEF_SIZE;
          dmem_adr  <= (others => 'X');
          dmem_d    <= (others => 'X');
      end case;
    end if;
  end process;

  -- memory address
  processing_2 : process (func3, func7, immS, opA, opB, opcode, xlen32)
    variable memory_address : std_logic_vector(15 downto 0);
  begin
    memory_address := xlen32 & func7 & func3 & opcode;
    case (memory_address) is
      when (LB) =>
        adr <= std_logic_vector(unsigned(opA)+unsigned(opB));
      when (LH) =>
        adr <= std_logic_vector(unsigned(opA)+unsigned(opB));
      when (LW) =>
        adr <= std_logic_vector(unsigned(opA)+unsigned(opB));
      when (LD) =>
        -- RV64
        adr <= std_logic_vector(unsigned(opA)+unsigned(opB));
      when (LBU) =>
        adr <= std_logic_vector(unsigned(opA)+unsigned(opB));
      when (LHU) =>
        adr <= std_logic_vector(unsigned(opA)+unsigned(opB));
      when (LWU) =>
        -- RV64
        adr <= std_logic_vector(unsigned(opA)+unsigned(opB));
      when (SB) =>
        adr <= std_logic_vector(unsigned(opA)+unsigned(immS));
      when (SH) =>
        adr <= std_logic_vector(unsigned(opA)+unsigned(immS));
      when (SW) =>
        adr <= std_logic_vector(unsigned(opA)+unsigned(immS));
      when (SD) =>
        -- RV64
        adr <= std_logic_vector(unsigned(opA)+unsigned(immS));
      when others =>
        -- 'hx;
        adr <= std_logic_vector(unsigned(opA)+unsigned(opB));
    end case;
  end process;

  -- memory byte enable
  generating_0 : if (XLEN = 64) generate  -- RV64
    processing_3 : process (func3, func7, opcode)
      variable memory_byte_enable : std_logic_vector(15 downto 0);
    begin
      memory_byte_enable := 'X' & func7 & func3 & opcode;
      case (memory_byte_enable) is        -- func7 is don't care
        when LB =>
          size <= BYTE;
        when LH =>
          size <= HWORD;
        when LW =>
          size <= WORD;
        when LD =>
          size <= DWORD;
        when LBU =>
          size <= BYTE;
        when LHU =>
          size <= HWORD;
        when LWU =>
          size <= WORD;
        when SB =>
          size <= BYTE;
        when SH =>
          size <= HWORD;
        when SW =>
          size <= WORD;
        when SD =>
          size <= DWORD;
        when others =>
          size <= UNDEF_SIZE;
      end case;
    end process;

    -- memory write data
    processing_4 : process (adr, func3, func7, opB, opcode)
      variable memory_write_data : std_logic_vector(15 downto 0);
    begin
      memory_write_data := 'X' & func7 & func3 & opcode;
      case (memory_write_data) is       -- func7 is don't care
        when SB =>
          d <= std_logic_vector(((XLEN-1 downto 8 => '0') & unsigned(opB(7 downto 0))) sll (8*to_integer(unsigned(adr(2 downto 0)))));
        when SH =>
          d <= std_logic_vector(((XLEN-1 downto 16 => '0') & unsigned(opB(15 downto 0))) sll (8*to_integer(unsigned(adr(2 downto 0)))));
        when SW =>
          d <= std_logic_vector(((XLEN-1 downto 32 => '0') & unsigned(opB(31 downto 0))) sll (8*to_integer(unsigned(adr(2 downto 0)))));
        when SD =>
          d <= opB;
        when others =>
          d <= (others => 'X');
      end case;
    end process;
  elsif (XLEN = 32) generate            -- RV32
    processing_5 : process (func3, func7, opcode)
      variable memory_write_data : std_logic_vector(15 downto 0);
    begin
      memory_write_data := 'X' & func7 & func3 & opcode;
      case (memory_write_data) is       -- func7 is don't care
        when LB =>
          size <= BYTE;
        when LH =>
          size <= HWORD;
        when LW =>
          size <= WORD;
        when LBU =>
          size <= BYTE;
        when LHU =>
          size <= HWORD;
        when SB =>
          size <= BYTE;
        when SH =>
          size <= HWORD;
        when SW =>
          size <= WORD;
        when others =>
          size <= UNDEF_SIZE;
      end case;
    end process;

    -- memory write data
    processing_6 : process (adr, func3, func7, opB, opcode)
      variable memory_write_data : std_logic_vector(15 downto 0);
    begin
      memory_write_data := 'X' & func7 & func3 & opcode;
      case (memory_write_data) is       -- func7 is don't care
        when SB =>
          d <= std_logic_vector(unsigned(opB(7 downto 0)) sll (8*to_integer(unsigned(adr(1 downto 0)))));
        when SH =>
          d <= std_logic_vector(unsigned(opB(15 downto 0)) sll (8*to_integer(unsigned(adr(1 downto 0)))));
        when SW =>
          d <= opB;
        when others =>
          d <= (others => 'X');
      end case;
    end process;
  end generate;

  --   * Exceptions
  --   * Regular memory exceptions are caught in the WB stage
  --   * However AMO accesses handle the 'load' here.

  processing_7 : process (clk, rstn)
  begin
    if (rstn = '0') then
      lsu_exception <= (others => '0');
    elsif (rising_edge(clk)) then
      if (lsu_stall_o = '0') then
        lsu_exception <= id_exception;
      end if;
    end if;
  end process;
end rtl;
