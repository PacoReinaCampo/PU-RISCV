###################################################################################
##                                            __ _      _     _                  ##
##                                           / _(_)    | |   | |                 ##
##                __ _ _   _  ___  ___ _ __ | |_ _  ___| | __| |                 ##
##               / _` | | | |/ _ \/ _ \ '_ \|  _| |/ _ \ |/ _` |                 ##
##              | (_| | |_| |  __/  __/ | | | | | |  __/ | (_| |                 ##
##               \__, |\__,_|\___|\___|_| |_|_| |_|\___|_|\__,_|                 ##
##                  | |                                                          ##
##                  |_|                                                          ##
##                                                                               ##
##                                                                               ##
##              Architecture                                                     ##
##              QueenField                                                       ##
##                                                                               ##
###################################################################################

###################################################################################
##                                                                               ##
## Copyright (c) 2019-2020 by the author(s)                                      ##
##                                                                               ##
## Permission is hereby granted, free of charge, to any person obtaining a copy  ##
## of this software and associated documentation files (the "Software"), to deal ##
## in the Software without restriction, including without limitation the rights  ##
## to use, copy, modify, merge, publish, distribute, sublicense, and/or sell     ##
## copies of the Software, and to permit persons to whom the Software is         ##
## furnished to do so, subject to the following conditions:                      ##
##                                                                               ##
## The above copyright notice and this permission notice shall be included in    ##
## all copies or substantial portions of the Software.                           ##
##                                                                               ##
## THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR    ##
## IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,      ##
## FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE   ##
## AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER        ##
## LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, ##
## OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN     ##
## THE SOFTWARE.                                                                 ##
##                                                                               ##
## ============================================================================= ##
## Author(s):                                                                    ##
##   Paco Reina Campo <pacoreinacampo@queenfield.tech>                           ##
##                                                                               ##
###################################################################################

../../../../../../../rtl/vhdl/pkg/peripheral_axi4_vhdl_pkg.vhd
../../../../../../../rtl/vhdl/pkg/peripheral_axi4_vhdl_pkg.vhd
../../../../../../../rtl/vhdl/pkg/pu_riscv_vhdl_pkg.vhd
../../../../../../../rtl/vhdl/pkg/vhdl_pkg.vhd

../../../../../../../rtl/vhdl/core/cache/pu_riscv_dcache_core.vhd
../../../../../../../rtl/vhdl/core/cache/pu_riscv_dext.vhd
../../../../../../../rtl/vhdl/core/cache/pu_riscv_icache_core.vhd
../../../../../../../rtl/vhdl/core/cache/pu_riscv_noicache_core.vhd
../../../../../../../rtl/vhdl/core/decode/pu_riscv_id.vhd
../../../../../../../rtl/vhdl/core/execute/pu_riscv_alu.vhd
../../../../../../../rtl/vhdl/core/execute/pu_riscv_bu.vhd
../../../../../../../rtl/vhdl/core/execute/pu_riscv_divider.vhd
../../../../../../../rtl/vhdl/core/execute/pu_riscv_execution.vhd
../../../../../../../rtl/vhdl/core/execute/pu_riscv_lsu.vhd
../../../../../../../rtl/vhdl/core/execute/pu_riscv_multiplier.vhd
../../../../../../../rtl/vhdl/core/fetch/pu_riscv_if.vhd
../../../../../../../rtl/vhdl/core/memory/pu_riscv_dmem_ctrl.vhd
../../../../../../../rtl/vhdl/core/memory/pu_riscv_imem_ctrl.vhd
../../../../../../../rtl/vhdl/core/memory/pu_riscv_membuf.vhd
../../../../../../../rtl/vhdl/core/memory/pu_riscv_memmisaligned.vhd
../../../../../../../rtl/vhdl/core/memory/pu_riscv_mmu.vhd
../../../../../../../rtl/vhdl/core/memory/pu_riscv_mux.vhd
../../../../../../../rtl/vhdl/core/memory/pu_riscv_pmachk.vhd
../../../../../../../rtl/vhdl/core/memory/pu_riscv_pmpchk.vhd
../../../../../../../rtl/vhdl/core/main/pu_riscv_bp.vhd
../../../../../../../rtl/vhdl/core/main/pu_riscv_core.vhd
../../../../../../../rtl/vhdl/core/main/pu_riscv_du.vhd
../../../../../../../rtl/vhdl/core/main/pu_riscv_memory.vhd
../../../../../../../rtl/vhdl/core/main/pu_riscv_rf.vhd
../../../../../../../rtl/vhdl/core/main/pu_riscv_state.vhd
../../../../../../../rtl/vhdl/core/main/pu_riscv_axi4.vhd

../../../../../../../rtl/vhdl/memory/pu_riscv_ram_1r1w.vhd
../../../../../../../rtl/vhdl/memory/pu_riscv_ram_1r1w_generic.vhd
../../../../../../../rtl/vhdl/memory/pu_riscv_ram_1rw.vhd
../../../../../../../rtl/vhdl/memory/pu_riscv_ram_1rw_generic.vhd
../../../../../../../rtl/vhdl/memory/pu_riscv_ram_queue.vhd

../../../../../../../rtl/vhdl/pu/axi4/pu_riscv_axi42ahb3.vhd
../../../../../../../rtl/vhdl/pu/axi4/pu_riscv_axi4.vhd

../../../../../../../verification/tasks/vhdl/library/pu/axi4/pu_riscv_memory_model_axi4.vhd
../../../../../../../verification/tasks/vhdl/library/pu/axi4/pu_riscv_mmio_if_axi4.vhd
../../../../../../../verification/tasks/vhdl/library/pu/axi4/pu_riscv_testbench_axi4.vhd
../../../../../../../verification/tasks/vhdl/library/bfm/pu_riscv_dbg_bfm.vhd
../../../../../../../verification/tasks/vhdl/library/bfm/pu_riscv_htif.vhd
