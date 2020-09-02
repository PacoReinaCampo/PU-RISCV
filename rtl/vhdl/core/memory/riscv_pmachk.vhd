-- Converted from rtl/verilog/core/memory/riscv_pmachk.sv
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
--              Core - Physical Memory Attributes Checker                     //
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
-- *   Paco Reina Campo <pacoreinacampo@queenfield.tech>
-- */

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.riscv_defines.all;

entity riscv_pmachk is
  generic (
    XLEN    : integer := 64;
    PLEN    : integer := 64;
    PMA_CNT : integer := 4
  );
  port (
    --PMA  configuration
    pma_cfg_i : std_logic_matrix(PMA_CNT-1 downto 0)(13 downto 0);
    pma_adr_i : std_logic_matrix(PMA_CNT-1 downto 0)(PLEN-1 downto 0);

    --Memory Access
    instruction_i : in std_logic;  --This is an instruction access
    req_i         : in std_logic;  --Memory access requested
    adr_i         : in std_logic_vector(PLEN-1 downto 0);  --Physical Memory address (i.e. after translation)
    size_i        : in std_logic_vector(2 downto 0);  --Transfer size
    lock_i        : in std_logic;  --AMO : TODO: specify AMO type
    we_i          : in std_logic;

    misaligned_i : in std_logic;  --Misaligned access

    --Output
    pma_o             : out std_logic_vector(13 downto 0);
    exception_o       : out std_logic;
    misaligned_o      : out std_logic;
    is_cache_access_o : out std_logic;
    is_ext_access_o   : out std_logic;
    is_tcm_access_o   : out std_logic
  );
end riscv_pmachk;

architecture RTL of riscv_pmachk is
  --////////////////////////////////////////////////////////////////
  --
  -- Functions
  --

  --convert transfer size in number of bytes in transfer
  function size2bytes (
    size : std_logic_vector(2 downto 0)
    ) return integer is
    variable size2bytes_return : integer;
  begin
    case (size) is
      when BYTE =>
        size2bytes_return := 1;
      when HWORD =>
        size2bytes_return := 2;
      when WORD =>
        size2bytes_return := 4;
      when DWORD =>
        size2bytes_return := 8;
      when QWORD =>
        size2bytes_return := 16;
      when others =>
        size2bytes_return := -1;
    end case;
    return size2bytes_return;
  end size2bytes;

  --Lower and Upper bounds for NA4/NAPOT
  function napot_lb (
    na4    : std_logic;  --special case na4
    pmaddr : std_logic_vector(PLEN-1 downto 2)
    ) return std_logic_vector is
    variable n               : integer;
    variable truth           : std_logic;
    variable mask            : std_logic_vector(PLEN-1 downto 2);
    variable napot_lb_return : std_logic_vector(PLEN-1 downto 2);
  begin
    --find 'n' boundary = 2^(n+2) bytes
    n := 0;
    if (na4 = '0') then
      truth := '1';
      for i in 0 to PLEN - 1 loop
        if (truth = '1') then
          if (pmaddr(i+2) = '1') then
            n := n+1;
          else
            truth := '0';
          end if;
        end if;
      end loop;
      n := n+1;
    end if;

    --create mask
    mask := std_logic_vector(to_unsigned(1, PLEN-2) sll n);

    --lower bound address
    napot_lb_return := pmaddr and mask;
    return napot_lb_return;
  end napot_lb;

  function napot_ub (
    na4    : std_logic;  --special case na4
    pmaddr : std_logic_vector(PLEN-1 downto 2)
  ) return std_logic_vector is
    variable n               : integer;
    variable truth           : std_logic;
    variable mask            : std_logic_vector(PLEN-1 downto 2);
    variable incr            : std_logic_vector(PLEN-1 downto 2);
    variable napot_ub_return : std_logic_vector(PLEN-1 downto 2);
  begin
    --find 'n' boundary = 2^(n+2) bytes
    n := 0;
    if (na4 = '0') then
      truth := '1';
      for i in 0 to PLEN - 1 loop
        if (truth = '1') then
          if (pmaddr(i+2) = '1') then
            n := n+1;
          else
            truth := '0';
          end if;
        end if;
      end loop;
      n := n+1;
    end if;

    --create mask and increment
    mask := std_logic_vector(to_unsigned(1, PLEN-2) sll n);
    incr := std_logic_vector(to_unsigned(1, PLEN-2) sll n);

    --upper bound address
    napot_ub_return := std_logic_vector(unsigned(pmaddr)+unsigned(incr)) and mask;
    return napot_ub_return;
  end napot_ub;

  --Is ANY byte of 'access' in pma range?
  function match_any (
    access_lb : std_logic_vector(PLEN-1 downto 2);
    access_ub : std_logic_vector(PLEN-1 downto 2);
    pma_lb    : std_logic_vector(PLEN-1 downto 2);
    pma_ub    : std_logic_vector(PLEN-1 downto 2)

    ) return std_logic is
    variable match_any_return : std_logic;
  begin
    --    Check if ANY byte of the access lies within the PMA range
    --  *   pma_lb <= range < pma_ub
    --  * 
    --  *   match_none = (access_lb >= pma_ub) OR (access_ub < pma_lb)  (1)
    --  *   match_any  = !match_none                                    (2)

    if (access_lb >= pma_ub) or (access_ub <  pma_lb) then
      match_any_return := '0';
    else
      match_any_return := '1';
    end if;

    return match_any_return;
  end match_any;

  --Are ALL bytes of 'access' in PMA range?
  function match_all (
    access_lb : std_logic_vector(PLEN-1 downto 2);
    access_ub : std_logic_vector(PLEN-1 downto 2);
    pma_lb    : std_logic_vector(PLEN-1 downto 2);
    pma_ub    : std_logic_vector(PLEN-1 downto 2)

    ) return std_logic is
    variable match_all_return : std_logic;
  begin
    if (access_lb >= pma_lb) or (access_ub <  pma_ub) then
      match_all_return := '0';
    else
      match_all_return := '1';
    end if;

    return match_all_return;
  end match_all;

  --get highest priority (==lowest number) PMA that matches
  function highest_priority_match (
    m : std_logic_vector(PMA_CNT-1 downto 0)
  ) return integer is
    variable n : integer;
    variable highest_priority_match_return : integer;
  begin
    highest_priority_match_return := 0;  --default value

    for n in PMA_CNT-1 downto 0 loop
      if (m(n) = '1') then
        highest_priority_match_return := n;
      end if;
    end loop;
    return highest_priority_match_return;
  end highest_priority_match;

  --////////////////////////////////////////////////////////////////
  --
  -- Variables
  --
  signal access_ub         : std_logic_vector(PLEN-1 downto 0);
  signal access_lb         : std_logic_vector(PLEN-1 downto 0);
  signal pma_ub            : std_logic_matrix(PMA_CNT-1 downto 0)(PLEN-1 downto 2);
  signal pma_lb            : std_logic_matrix(PMA_CNT-1 downto 0)(PLEN-1 downto 2);
  signal pma_match         : std_logic_vector(PMA_CNT-1 downto 0);
  signal pma_match_all     : std_logic_vector(PMA_CNT-1 downto 0);
  signal matched_pma_idx   : std_logic_vector(PLEN-1 downto 0);
  signal pmacfg            : std_logic_matrix(PMA_CNT-1 downto 0)(13 downto 0);
  signal matched_pma       : std_logic_vector(13 downto 0);

  --Outputto 0);
  signal exception         : std_logic;
  signal misaligned        : std_logic;

begin
  --////////////////////////////////////////////////////////////////
  --
  -- Module Body
  --

  --PMA configurations
  generating_0 : for i in 0 to PMA_CNT - 1 generate
    pmacfg(i)(13 downto 12) <= MEM_TYPE_IO(1 downto 0)
                               when pma_cfg_i(i)(13 downto 12) = MEM_TYPE_EMPTY(1 downto 0) else pma_cfg_i(i)(13 downto 12);
    pmacfg(i)(3 downto 2) <= AMO_TYPE_NONE(1 downto 0)
                             when pma_cfg_i(i)(13 downto 12) = MEM_TYPE_EMPTY(1 downto 0) else pma_cfg_i(i)(3 downto 2);
    pmacfg(i)(11) <= '0'
                     when pma_cfg_i(i)(13 downto 12) = MEM_TYPE_EMPTY(1 downto 0) else pma_cfg_i(i)(11);
    pmacfg(i)(10) <= '0'
                     when pma_cfg_i(i)(13 downto 12) = MEM_TYPE_EMPTY(1 downto 0) else pma_cfg_i(i)(10);
    pmacfg(i)(9) <= '0'
                    when pma_cfg_i(i)(13 downto 12) = MEM_TYPE_EMPTY(1 downto 0) else pma_cfg_i(i)(9);
    pmacfg(i)(8) <= pma_cfg_i(i)(8)
                    when pma_cfg_i(i)(13 downto 12) = MEM_TYPE_MAIN(1 downto 0) else '0';
    pmacfg(i)(7) <= pma_cfg_i(i)(7) and pmacfg(i)(8);
    pmacfg(i)(6) <= pma_cfg_i(i)(6)
                    when pma_cfg_i(i)(13 downto 12) = MEM_TYPE_IO(1 downto 0) else '1';
    pmacfg(i)(5) <= pma_cfg_i(i)(5)
                    when pma_cfg_i(i)(13 downto 12) = MEM_TYPE_IO(1 downto 0) else '1';
    pmacfg(i)(4)          <= pma_cfg_i(i)(4);
    pmacfg(i)(1 downto 0) <= pma_cfg_i(i)(1 downto 0);
  end generate;

  --Address Range Matching
  access_lb <= adr_i;
  access_ub <= std_logic_vector(unsigned(adr_i)+("0000000000000" & unsigned(size_i))-"0000000000000001");

  generating_1 : for i in 0 to PMA_CNT - 1 generate
    --lower bounds
    processing_0 : process (pma_adr_i, pma_ub, pmacfg)
    begin
      case ((pmacfg(i)(1 downto 0))) is
        -- TOR after NAPOT ...
        when TOR =>
          if (i = 0) then
            pma_lb(i) <= (others => '0');
          else
            if (pmacfg(i-1)(1 downto 0) /= TOR) then
              pma_lb(i) <= pma_ub(i-1);
            else
              pma_lb(i) <= pma_adr_i(i-1)(PLEN-2-1 downto 0);
            end if;
          end if;
        when NA4 =>
          pma_lb(i) <= napot_lb('1', pma_adr_i(i)(PLEN-2-1 downto 0));
        when NAPOT =>
          pma_lb(i) <= napot_lb('0', pma_adr_i(i)(PLEN-2-1 downto 0));
        when others =>
          pma_lb(i) <= (others => 'X');
      end case;
    end process;

    --upper bounds
    processing_1 : process (pma_adr_i, pmacfg)
    begin
      case ((pmacfg(i)(1 downto 0))) is
        when TOR =>
          pma_ub(i) <= pma_adr_i(i)(PLEN-2-1 downto 0);
        when NA4 =>
          pma_ub(i) <= napot_ub('1', pma_adr_i(i)(PLEN-2-1 downto 0));
        when NAPOT =>
          pma_ub(i) <= napot_ub('0', pma_adr_i(i)(PLEN-2-1 downto 0));
        when others =>
          pma_ub(i) <= (others => 'X');
      end case;
    end process;

    --match
    pma_match(i)     <= match_any(access_lb(PLEN-1 downto 2), access_ub(PLEN-1 downto 2), pma_lb(i), pma_ub(i)) and to_stdlogic(pmacfg(i)(1 downto 0) /= OFF);
    pma_match_all(i) <= match_any(access_lb(PLEN-1 downto 2), access_ub(PLEN-1 downto 2), pma_lb(i), pma_ub(i)) and to_stdlogic(pmacfg(i)(1 downto 0) /= OFF);
  end generate;

  matched_pma_idx <= std_logic_vector(to_unsigned(highest_priority_match(pma_match_all), PLEN));
  matched_pma     <= pmacfg(to_integer(unsigned(matched_pma_idx)));
  pma_o           <= matched_pma;

  --Access/Misaligned Exception
  exception <= req_i and (reduce_nor(pma_match_all) or  -- no memory range matched
            (instruction_i and not matched_pma(09)) or  -- not executable
                     (we_i and not matched_pma(10)) or  -- not writeable
                 (not we_i and not matched_pma(11)));   -- not readable

  exception_o <= exception;

  misaligned <= misaligned_i and not matched_pma(4);

  misaligned_o <= misaligned;

  --Access Types
  is_cache_access_o <= req_i and not exception and not misaligned and matched_pma(8);  --implies MEM_TYPE_MAIN
  is_ext_access_o   <= req_i and not exception and not misaligned and not matched_pma(8) and to_stdlogic(matched_pma(13 downto 12) /= MEM_TYPE_TCM(1 downto 0));
  is_tcm_access_o   <= req_i and not exception and not misaligned and to_stdlogic(matched_pma(13 downto 12) = MEM_TYPE_TCM(1 downto 0));
end RTL;
