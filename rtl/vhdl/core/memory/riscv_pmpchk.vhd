-- Converted from rtl/verilog/core/memory/riscv_pmpchk.sv
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
--              Core - Physical Memory Protection Checker                     //
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

entity riscv_pmpchk is
  generic (
    XLEN    : integer := 64;
    PLEN    : integer := 64;
    PMP_CNT : integer := 16
  );
  port (
    --From State
    st_pmpcfg_i  : in M_PMP_CNT_7;
    st_pmpaddr_i : in M_PMP_CNT_PLEN;
    st_prv_i     : in std_logic_vector(1 downto 0);

    --Memory Access
    instruction_i : in std_logic;                          --This is an instruction access
    req_i         : in std_logic;                          --Memory access requested
    adr_i         : in std_logic_vector(PLEN-1 downto 0);  --Physical Memory address (i.e. after translation)
    size_i        : in std_logic_vector(2 downto 0);       --Transfer size
    we_i          : in std_logic;                          --Read/Write enable

    --Output
    exception_o : out std_logic
    );
end riscv_pmpchk;

architecture RTL of riscv_pmpchk is
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
    na4    : std_logic;                 --special case na4
    pmpddr : std_logic_vector(PLEN-1 downto 2)
    ) return std_logic_vector is
    variable n               : integer;
    variable truth           : std_logic;
    variable mask            : std_logic_vector(PLEN-1 downto 2);
    variable napot_lb_return : std_logic_vector (PLEN-1 downto 2);
  begin
    --find 'n' boundary = 2^(n+2) bytes
    n := 0;
    if (na4 = '0') then
      truth := '1';
      for i in 0 to PLEN - 1 loop
        if (truth = '1') then
          if (pmpddr(i+2) = '1') then
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
    napot_lb_return := pmpddr and mask;
    return napot_lb_return;
  end napot_lb;

  function napot_ub (
    na4    : std_logic;  --special case na4
    pmpddr : std_logic_vector(PLEN-1 downto 2)
    ) return std_logic_vector is
    variable n               : integer;
    variable truth           : std_logic;
    variable mask            : std_logic_vector(PLEN-1 downto 2);
    variable incr            : std_logic_vector(PLEN-1 downto 2);
    variable napot_ub_return : std_logic_vector (PLEN-1 downto 2);
  begin
    --find 'n' boundary = 2^(n+2) bytes
    n := 0;
    if (na4 = '0') then
      truth := '1';
      for i in 0 to PLEN - 1 loop
        if (truth = '1') then
          if (pmpddr(i+2) = '1') then
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
    napot_ub_return := std_logic_vector(unsigned(pmpddr)+unsigned(incr)) and mask;
    return napot_ub_return;
  end napot_ub;

  --Is ANY byte of 'access' in pmp range?
  function match_any (
    access_lb : std_logic_vector(PLEN-1 downto 2);
    access_ub : std_logic_vector(PLEN-1 downto 2);
    pmp_lb    : std_logic_vector(PLEN-1 downto 2);
    pmp_ub    : std_logic_vector(PLEN-1 downto 2)

    ) return std_logic is
    variable match_any_return : std_logic;
  begin
    --    Check if ANY byte of the access lies within the PMP range
    --  *   pmp_lb <= range < pmp_ub
    --  * 
    --  *   match_none = (access_lb >= pmp_ub) OR (access_ub < pmp_lb)  (1)
    --  *   match_any  = !match_none                                    (2)

    if (access_lb >= pmp_ub) or (access_ub < pmp_lb) then
      match_any_return := '0';
    else
      match_any_return := '1';
    end if;

    return match_any_return;
  end match_any;

  --Are ALL bytes of 'access' in PMP range?
  function match_all (
    access_lb : std_logic_vector(PLEN-1 downto 2);
    access_ub : std_logic_vector(PLEN-1 downto 2);
    pmp_lb    : std_logic_vector(PLEN-1 downto 2);
    pmp_ub    : std_logic_vector(PLEN-1 downto 2)

    ) return std_logic is
    variable match_all_return : std_logic;
  begin
    if (access_lb >= pmp_lb) or (access_ub < pmp_ub) then
      match_all_return := '0';
    else
      match_all_return := '1';
    end if;

    return match_all_return;
  end match_all;

  --get highest priority (==lowest number) PMP that matches
  function highest_priority_match (
    m : std_logic_vector(PMP_CNT-1 downto 0)
    ) return integer is
    variable n : integer;
    variable highest_priority_match_return : integer;
  begin
    highest_priority_match_return := 0;  --default value

    for n in PMP_CNT-1 downto 0 loop
      if (m(n) = '1') then
        highest_priority_match_return := n;
      end if;
    end loop;
    return highest_priority_match_return;
  end highest_priority_match;

  function to_stdlogic (
    input : boolean
  ) return std_logic is
  begin
    if input then
      return('1');
    else
      return('0');
    end if;
  end function to_stdlogic;

  function reduce_nor (
    reduce_nor_in : std_logic_vector
  ) return std_logic is
    variable reduce_nor_out : std_logic := '0';
  begin
    for i in reduce_nor_in'range loop
      reduce_nor_out := reduce_nor_out nor reduce_nor_in(i);
    end loop;
    return reduce_nor_out;
  end reduce_nor;

  --////////////////////////////////////////////////////////////////
  --
  -- Types
  --
  type M_PMP_CNT_PLEN2 is array (PMP_CNT-1 downto 0) of std_logic_vector(PLEN-1 downto 2);

  --////////////////////////////////////////////////////////////////
  --
  -- Variables
  --
  signal access_ub         : std_logic_vector(PLEN-1 downto 0);
  signal access_lb         : std_logic_vector(PLEN-1 downto 0);
  signal pmp_ub            : M_PMP_CNT_PLEN2;
  signal pmp_lb            : M_PMP_CNT_PLEN2;
  signal pmp_match         : std_logic_vector(15 downto 0);
  signal pmp_match_all     : std_logic_vector(15 downto 0);
  signal matched_pmp       : std_logic_vector(7 downto 0);
  signal matched_pmpcfg    : std_logic_vector(7 downto 0);
  signal exception_matched : std_logic;
  signal exception_pmpcfg  : std_logic;

begin
  --////////////////////////////////////////////////////////////////
  --
  -- Module Body
  --

  --  * Address Range Matching
  --  * Access Exception
  --  * Cacheable

  access_lb <= adr_i;
  access_ub <= std_logic_vector(unsigned(adr_i)+("0000000000000" & unsigned(size_i))-"0000000000000001");

  generating_0 : for i in 0 to PMP_CNT - 1 generate
    --lower bounds
    processing_0 : process (pmp_ub, st_pmpaddr_i, st_pmpcfg_i)
    begin
      case ((st_pmpcfg_i(i)(4 downto 3))) is
        -- TOR after NAPOT ...
        when TOR =>
          if (i = 0) then
            pmp_lb(i) <= (others => '0');
          else
            if (st_pmpcfg_i(i-1)(4 downto 3) /= TOR) then
              pmp_lb(i) <= pmp_ub(i-1);
            else
              pmp_lb(i) <= st_pmpaddr_i(i-1)(PLEN-3 downto 0);
            end if;
          end if;
        when NA4 =>
          pmp_lb(i) <= napot_lb('1', st_pmpaddr_i(i)(PLEN-1 downto 2));
        when NAPOT =>
          pmp_lb(i) <= napot_lb('0', st_pmpaddr_i(i)(PLEN-1 downto 2));
        when others =>
          pmp_lb(i) <= (others => 'X');
      end case;
    end process;

    --upper bounds
    processing_1 : process (st_pmpaddr_i, st_pmpcfg_i)
    begin
      case ((st_pmpcfg_i(i)(4 downto 3))) is
        when TOR =>
          pmp_ub(i) <= st_pmpaddr_i(i)(PLEN-3 downto 0);
        when NA4 =>
          pmp_ub(i) <= napot_ub('1', st_pmpaddr_i(i)(PLEN-1 downto 2));
        when NAPOT =>
          pmp_ub(i) <= napot_ub('0', st_pmpaddr_i(i)(PLEN-1 downto 2));
        when others =>
          pmp_ub(i) <= (others => 'X');
      end case;
    end process;

    --match-any
    pmp_match(i)     <= match_any( access_lb(PLEN-1 downto 2),
                                   access_ub(PLEN-1 downto 2),
                                   pmp_lb(i),
                                   pmp_ub(i)) and to_stdlogic(st_pmpcfg_i(i)(4 downto 3) /= OFF);

    pmp_match_all(i) <= match_all( access_lb(PLEN-1 downto 2),
                                   access_ub(PLEN-1 downto 2),
                                   pmp_lb(i),
                                   pmp_ub(i));
  end generate;

  matched_pmp <= std_logic_vector(to_unsigned(highest_priority_match(pmp_match), 8));

  matched_pmpcfg <= st_pmpcfg_i(to_integer(unsigned(matched_pmp)));

  -- Access FAIL when:
  --  * 1. some bytes matched highest priority PMP, but not the entire transfer range OR
  --  * 2. pmpcfg.l is set AND privilegel level is S or U AND pmpcfg.rwx tests fail OR
  --  * 3. privilegel level is S or U AND no PMPs matched AND PMPs are implemented

  exception_o <= (req_i and exception_matched) or exception_pmpcfg;

  exception_pmpcfg <= ((to_stdlogic(st_prv_i /= PRV_M) or matched_pmpcfg(7)) and  -- pmpcfg.l set or privilege level != M-mode
                                  ((not matched_pmpcfg(0) and not we_i) or        -- read-access while not allowed          -> FAIL
                                   (not matched_pmpcfg(1) and we_i) or            -- write-access while not allowed         -> FAIL 
                                   (not matched_pmpcfg(2) and instruction_i)));   -- instruction read, but not instruction  -> FAIL

  --Prv.Lvl != M-Mode, no PMP matched, but PMPs implemented -> FAIL
  exception_matched <= to_stdlogic(st_prv_i /= PRV_M) and to_stdlogic(PMP_CNT > 0)
                       when reduce_nor(pmp_match) = '1' else not pmp_match_all(to_integer(unsigned(matched_pmp)));
end RTL;
