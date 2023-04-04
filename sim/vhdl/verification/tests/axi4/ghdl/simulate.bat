:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
::                                            __ _      _     _                  ::
::                                           / _(_)    | |   | |                 ::
::                __ _ _   _  ___  ___ _ __ | |_ _  ___| | __| |                 ::
::               / _` | | | |/ _ \/ _ \ '_ \|  _| |/ _ \ |/ _` |                 ::
::              | (_| | |_| |  __/  __/ | | | | | |  __/ | (_| |                 ::
::               \__, |\__,_|\___|\___|_| |_|_| |_|\___|_|\__,_|                 ::
::                  | |                                                          ::
::                  |_|                                                          ::
::                                                                               ::
::                                                                               ::
::              Peripheral for MPSoC                                             ::
::              Multi-Processor System on Chip                                   ::
::                                                                               ::
:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
::                                                                               ::
:: Copyright (c) 2015-2016 by the author(s)                                      ::
::                                                                               ::
:: Permission is hereby granted, free of charge, to any person obtaining a copy  ::
:: of this software and associated documentation files (the "Software"), to deal ::
:: in the Software without restriction, including without limitation the rights  ::
:: to use, copy, modify, merge, publish, distribute, sublicense, and/or sell     ::
:: copies of the Software, and to permit persons to whom the Software is         ::
:: furnished to do so, subject to the following conditions:                      ::
::                                                                               ::
:: The above copyright notice and this permission notice shall be included in    ::
:: all copies or substantial portions of the Software.                           ::
::                                                                               ::
:: THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR    ::
:: IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,      ::
:: FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE   ::
:: AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER        ::
:: LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, ::
:: OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN     ::
:: THE SOFTWARE.                                                                 ::
::                                                                               ::
:: ============================================================================= ::
:: Author(s):                                                                    ::
::   Paco Reina Campo <pacoreinacampo@queenfield.tech>                           ::
::                                                                               ::
:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

@echo off
call ../../../../../../../settings64_ghdl.bat

ghdl -a --std=08 ../../../../../../../rtl/vhdl/pkg/peripheral_axi4_pkg.vhd
ghdl -a --std=08 ../../../../../../../rtl/vhdl/pkg/peripheral_biu_pkg.vhd
ghdl -a --std=08 ../../../../../../../rtl/vhdl/pkg/pu_riscv_pkg.vhd
ghdl -a --std=08 ../../../../../../../rtl/vhdl/pkg/vhdl_pkg.vhd
ghdl -a --std=08 ../../../../../../../rtl/vhdl/core/cache/pu_riscv_dcache_core.vhd
ghdl -a --std=08 ../../../../../../../rtl/vhdl/core/cache/pu_riscv_dext.vhd
ghdl -a --std=08 ../../../../../../../rtl/vhdl/core/cache/pu_riscv_icache_core.vhd
ghdl -a --std=08 ../../../../../../../rtl/vhdl/core/cache/pu_riscv_noicache_core.vhd
ghdl -a --std=08 ../../../../../../../rtl/vhdl/core/decode/pu_riscv_id.vhd
ghdl -a --std=08 ../../../../../../../rtl/vhdl/core/decode/pu_riscv_if.vhd
ghdl -a --std=08 ../../../../../../../rtl/vhdl/core/execute/pu_riscv_alu.vhd
ghdl -a --std=08 ../../../../../../../rtl/vhdl/core/execute/pu_riscv_bu.vhd
ghdl -a --std=08 ../../../../../../../rtl/vhdl/core/execute/pu_riscv_div.vhd
ghdl -a --std=08 ../../../../../../../rtl/vhdl/core/execute/pu_riscv_execution.vhd
ghdl -a --std=08 ../../../../../../../rtl/vhdl/core/execute/pu_riscv_lsu.vhd
ghdl -a --std=08 ../../../../../../../rtl/vhdl/core/execute/pu_riscv_mul.vhd
ghdl -a --std=08 ../../../../../../../rtl/vhdl/core/memory/pu_riscv_dmem_ctrl.vhd
ghdl -a --std=08 ../../../../../../../rtl/vhdl/core/memory/pu_riscv_imem_ctrl.vhd
ghdl -a --std=08 ../../../../../../../rtl/vhdl/core/memory/pu_riscv_membuf.vhd
ghdl -a --std=08 ../../../../../../../rtl/vhdl/core/memory/pu_riscv_memmisaligned.vhd
ghdl -a --std=08 ../../../../../../../rtl/vhdl/core/memory/pu_riscv_mmu.vhd
ghdl -a --std=08 ../../../../../../../rtl/vhdl/core/memory/pu_riscv_mux.vhd
ghdl -a --std=08 ../../../../../../../rtl/vhdl/core/memory/pu_riscv_pmachk.vhd
ghdl -a --std=08 ../../../../../../../rtl/vhdl/core/memory/pu_riscv_pmpchk.vhd
ghdl -a --std=08 ../../../../../../../rtl/vhdl/core/main/pu_riscv_bp.vhd
ghdl -a --std=08 ../../../../../../../rtl/vhdl/core/main/pu_riscv_core.vhd
ghdl -a --std=08 ../../../../../../../rtl/vhdl/core/main/pu_riscv_du.vhd
ghdl -a --std=08 ../../../../../../../rtl/vhdl/core/main/pu_riscv_memory.vhd
ghdl -a --std=08 ../../../../../../../rtl/vhdl/core/main/pu_riscv_rf.vhd
ghdl -a --std=08 ../../../../../../../rtl/vhdl/core/main/pu_riscv_state.vhd
ghdl -a --std=08 ../../../../../../../rtl/vhdl/core/main/pu_riscv_wb.vhd
ghdl -a --std=08 ../../../../../../../rtl/vhdl/memory/pu_riscv_ram_1r1w.vhd
ghdl -a --std=08 ../../../../../../../rtl/vhdl/memory/pu_riscv_ram_1r1w_generic.vhd
ghdl -a --std=08 ../../../../../../../rtl/vhdl/memory/pu_riscv_ram_1rw.vhd
ghdl -a --std=08 ../../../../../../../rtl/vhdl/memory/pu_riscv_ram_1rw_generic.vhd
ghdl -a --std=08 ../../../../../../../rtl/vhdl/memory/pu_riscv_ram_queue.vhd
ghdl -a --std=08 ../../../../../../../rtl/vhdl/pu/axi4/pu_riscv_biu2axi4.vhd
ghdl -a --std=08 ../../../../../../../rtl/vhdl/pu/axi4/pu_riscv_axi4.vhd
ghdl -a --std=08 ../../../../../../../rtl/vhdl/pu/bridge/riscv_ahb2axi.vhd
ghdl -a --std=08 ../../../../../../../rtl/vhdl/pu/bridge/riscv_axi2ahb.vhd
ghdl -a --std=08 ../../../../../../../bench/vhdl/tests/pu/axi4/pu_riscv_memory_model_axi4.vhd
ghdl -a --std=08 ../../../../../../../bench/vhdl/tests/pu/axi4/pu_riscv_mmio_if_axi4.vhd
ghdl -a --std=08 ../../../../../../../bench/vhdl/tests/pu/axi4/pu_riscv_testbench_axi4.vhd
ghdl -a --std=08 ../../../../../../../bench/vhdl/tests/bfm/pu_riscv_dbg_bfm.vhd
ghdl -a --std=08 ../../../../../../../bench/vhdl/tests/bfm/pu_riscv_htif.vhd
ghdl -m --std=08 pu_riscv_testbench_axi4
ghdl -r --std=08 pu_riscv_testbench_axi4 --ieee-asserts=disable-at-0 --disp-tree=inst > riscv_testbench_axi4.tree
pause
