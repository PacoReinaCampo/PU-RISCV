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
##   Francisco Javier Reina Campo <frareicam@gmail.com>                          ##
##                                                                               ##
###################################################################################

read_vhdl -vhdl2008 ../../../../rtl/vhdl/pkg/peripheral_ahb3_pkg.vhd
read_vhdl -vhdl2008 ../../../../rtl/vhdl/pkg/peripheral_biu_pkg.vhd
read_vhdl -vhdl2008 ../../../../rtl/vhdl/pkg/pu_riscv_pkg.vhd
read_vhdl -vhdl2008 ../../../../rtl/vhdl/pkg/vhdl_pkg.vhd

read_vhdl -vhdl2008 ../../../../rtl/vhdl/core/cache/riscv_dcache_core.vhd
read_vhdl -vhdl2008 ../../../../rtl/vhdl/core/cache/riscv_dext.vhd
read_vhdl -vhdl2008 ../../../../rtl/vhdl/core/cache/riscv_icache_core.vhd
read_vhdl -vhdl2008 ../../../../rtl/vhdl/core/cache/riscv_noicache_core.vhd
read_vhdl -vhdl2008 ../../../../rtl/vhdl/core/decode/riscv_id.vhd
read_vhdl -vhdl2008 ../../../../rtl/vhdl/core/execute/riscv_alu.vhd
read_vhdl -vhdl2008 ../../../../rtl/vhdl/core/execute/riscv_bu.vhd
read_vhdl -vhdl2008 ../../../../rtl/vhdl/core/execute/riscv_div.vhd
read_vhdl -vhdl2008 ../../../../rtl/vhdl/core/execute/riscv_execution.vhd
read_vhdl -vhdl2008 ../../../../rtl/vhdl/core/execute/riscv_lsu.vhd
read_vhdl -vhdl2008 ../../../../rtl/vhdl/core/execute/riscv_mul.vhd
read_vhdl -vhdl2008 ../../../../rtl/vhdl/core/fetch/riscv_if.vhd
read_vhdl -vhdl2008 ../../../../rtl/vhdl/core/memory/riscv_dmem_ctrl.vhd
read_vhdl -vhdl2008 ../../../../rtl/vhdl/core/memory/riscv_imem_ctrl.vhd
read_vhdl -vhdl2008 ../../../../rtl/vhdl/core/memory/riscv_membuf.vhd
read_vhdl -vhdl2008 ../../../../rtl/vhdl/core/memory/riscv_memmisaligned.vhd
read_vhdl -vhdl2008 ../../../../rtl/vhdl/core/memory/riscv_mmu.vhd
read_vhdl -vhdl2008 ../../../../rtl/vhdl/core/memory/riscv_mux.vhd
read_vhdl -vhdl2008 ../../../../rtl/vhdl/core/memory/riscv_pmachk.vhd
read_vhdl -vhdl2008 ../../../../rtl/vhdl/core/memory/riscv_pmpchk.vhd
read_vhdl -vhdl2008 ../../../../rtl/vhdl/core/riscv_bp.vhd
read_vhdl -vhdl2008 ../../../../rtl/vhdl/core/riscv_core.vhd
read_vhdl -vhdl2008 ../../../../rtl/vhdl/core/riscv_du.vhd
read_vhdl -vhdl2008 ../../../../rtl/vhdl/core/riscv_memory.vhd
read_vhdl -vhdl2008 ../../../../rtl/vhdl/core/riscv_rf.vhd
read_vhdl -vhdl2008 ../../../../rtl/vhdl/core/riscv_state.vhd
read_vhdl -vhdl2008 ../../../../rtl/vhdl/core/riscv_wb.vhd

read_vhdl -vhdl2008 ../../../../rtl/vhdl/memory/riscv_ram_1r1w_generic.vhd
read_vhdl -vhdl2008 ../../../../rtl/vhdl/memory/riscv_ram_1r1w.vhd
read_vhdl -vhdl2008 ../../../../rtl/vhdl/memory/riscv_ram_1rw_generic.vhd
read_vhdl -vhdl2008 ../../../../rtl/vhdl/memory/riscv_ram_1rw.vhd
read_vhdl -vhdl2008 ../../../../rtl/vhdl/memory/riscv_ram_queue.vhd

read_vhdl -vhdl2008 ../../../../rtl/vhdl/pu/ahb3/riscv_biu2ahb3.vhd
read_vhdl -vhdl2008 ../../../../rtl/vhdl/pu/ahb3/riscv_pu_ahb3.vhd

read_vhdl -vhdl2008 spram/core/mpsoc_ahb3_spram.vhd
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
