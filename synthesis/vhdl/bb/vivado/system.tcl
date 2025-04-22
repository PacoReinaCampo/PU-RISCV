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
##              MPSoC-SPRAM CPU                                                  ##
##              Synthesis Test Makefile                                          ##
##                                                                               ##
###################################################################################

###################################################################################
##                                                                               ##
## Copyright (c) 2018-2019 by the author(s)                                      ##
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
##   Francisco Javier Reina Campo <pacoreinacampo@queenfield.tech>               ##
##                                                                               ##
###################################################################################

read_vhdl -vhdl2008 ../../../../rtl/vhdl/pkg/peripheral_bb_vhdl_pkg.vhd
read_vhdl -vhdl2008 ../../../../rtl/vhdl/pkg/peripheral_bb_vhdl_pkg.vhd
read_vhdl -vhdl2008 ../../../../rtl/vhdl/pkg/pu_riscv_vhdl_pkg.vhd
read_vhdl -vhdl2008 ../../../../rtl/vhdl/pkg/vhdl_pkg.vhd

read_vhdl -vhdl2008 ../../../../rtl/vhdl/core/cache/pu_riscv_dcache_core.vhd
read_vhdl -vhdl2008 ../../../../rtl/vhdl/core/cache/pu_riscv_dext.vhd
read_vhdl -vhdl2008 ../../../../rtl/vhdl/core/cache/pu_riscv_icache_core.vhd
read_vhdl -vhdl2008 ../../../../rtl/vhdl/core/cache/pu_riscv_noicache_core.vhd
read_vhdl -vhdl2008 ../../../../rtl/vhdl/core/decode/pu_riscv_id.vhd
read_vhdl -vhdl2008 ../../../../rtl/vhdl/core/execute/pu_riscv_alu.vhd
read_vhdl -vhdl2008 ../../../../rtl/vhdl/core/execute/pu_riscv_bu.vhd
read_vhdl -vhdl2008 ../../../../rtl/vhdl/core/execute/pu_riscv_divider.vhd
read_vhdl -vhdl2008 ../../../../rtl/vhdl/core/execute/pu_riscv_execution.vhd
read_vhdl -vhdl2008 ../../../../rtl/vhdl/core/execute/pu_riscv_lsu.vhd
read_vhdl -vhdl2008 ../../../../rtl/vhdl/core/execute/pu_riscv_multiplier.vhd
read_vhdl -vhdl2008 ../../../../rtl/vhdl/core/fetch/pu_riscv_if.vhd
read_vhdl -vhdl2008 ../../../../rtl/vhdl/core/memory/pu_riscv_dmem_ctrl.vhd
read_vhdl -vhdl2008 ../../../../rtl/vhdl/core/memory/pu_riscv_imem_ctrl.vhd
read_vhdl -vhdl2008 ../../../../rtl/vhdl/core/memory/pu_riscv_membuf.vhd
read_vhdl -vhdl2008 ../../../../rtl/vhdl/core/memory/pu_riscv_memmisaligned.vhd
read_vhdl -vhdl2008 ../../../../rtl/vhdl/core/memory/pu_riscv_mmu.vhd
read_vhdl -vhdl2008 ../../../../rtl/vhdl/core/memory/pu_riscv_mux.vhd
read_vhdl -vhdl2008 ../../../../rtl/vhdl/core/memory/pu_riscv_pmachk.vhd
read_vhdl -vhdl2008 ../../../../rtl/vhdl/core/memory/pu_riscv_pmpchk.vhd
read_vhdl -vhdl2008 ../../../../rtl/vhdl/core/main/pu_riscv_bp.vhd
read_vhdl -vhdl2008 ../../../../rtl/vhdl/core/main/pu_riscv_core.vhd
read_vhdl -vhdl2008 ../../../../rtl/vhdl/core/main/pu_riscv_du.vhd
read_vhdl -vhdl2008 ../../../../rtl/vhdl/core/main/pu_riscv_memory.vhd
read_vhdl -vhdl2008 ../../../../rtl/vhdl/core/main/pu_riscv_rf.vhd
read_vhdl -vhdl2008 ../../../../rtl/vhdl/core/main/pu_riscv_state.vhd
read_vhdl -vhdl2008 ../../../../rtl/vhdl/core/main/pu_riscv_bb.vhd

read_vhdl -vhdl2008 ../../../../rtl/vhdl/memory/pu_riscv_ram_1r1w_generic.vhd
read_vhdl -vhdl2008 ../../../../rtl/vhdl/memory/pu_riscv_ram_1r1w.vhd
read_vhdl -vhdl2008 ../../../../rtl/vhdl/memory/pu_riscv_ram_1rw_generic.vhd
read_vhdl -vhdl2008 ../../../../rtl/vhdl/memory/pu_riscv_ram_1rw.vhd
read_vhdl -vhdl2008 ../../../../rtl/vhdl/memory/pu_riscv_ram_queue.vhd

read_vhdl -vhdl2008 ../../../../rtl/vhdl/module/bb/pu_riscv_bb2ahb4.vhd
read_vhdl -vhdl2008 ../../../../rtl/vhdl/module/bb/pu_riscv_bb.vhd

read_vhdl -vhdl2008 spram/core/mpsoc_bb_spram.vhd
read_vhdl -vhdl2008 spram/core/mpsoc_ram_1r1w.vhd
read_vhdl -vhdl2008 spram/core/mpsoc_ram_1r1w_generic.vhd

read_vhdl -vhdl2008 pu_riscv_synthesis.vhd

read_xdc system.xdc

synth_design -part xc7z020-clg484-1 -top pu_riscv_synthesis

opt_design
place_design
route_design

report_utilization
report_timing

write_bitstream -force system.bit
