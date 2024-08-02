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

read_verilog -sv ../../../../rtl/verilog/pkg/peripheral_wb_verilog_pkg.sv
read_verilog -sv ../../../../rtl/verilog/pkg/peripheral_wb_verilog_pkg.sv
read_verilog -sv ../../../../rtl/verilog/pkg/pu_riscv_verilog_pkg.sv

read_verilog -sv ../../../../rtl/verilog/core/cache/pu_riscv_dcache_core.sv
read_verilog -sv ../../../../rtl/verilog/core/cache/pu_riscv_dext.sv
read_verilog -sv ../../../../rtl/verilog/core/cache/pu_riscv_icache_core.sv
read_verilog -sv ../../../../rtl/verilog/core/cache/pu_riscv_noicache_core.sv
read_verilog -sv ../../../../rtl/verilog/core/decode/pu_riscv_id.sv
read_verilog -sv ../../../../rtl/verilog/core/execute/pu_riscv_alu.sv
read_verilog -sv ../../../../rtl/verilog/core/execute/pu_riscv_bu.sv
read_verilog -sv ../../../../rtl/verilog/core/execute/pu_riscv_divider.sv
read_verilog -sv ../../../../rtl/verilog/core/execute/pu_riscv_execution.sv
read_verilog -sv ../../../../rtl/verilog/core/execute/pu_riscv_lsu.sv
read_verilog -sv ../../../../rtl/verilog/core/execute/pu_riscv_multiplier.sv
read_verilog -sv ../../../../rtl/verilog/core/fetch/pu_riscv_if.sv
read_verilog -sv ../../../../rtl/verilog/core/memory/pu_riscv_dmem_ctrl.sv
read_verilog -sv ../../../../rtl/verilog/core/memory/pu_riscv_imem_ctrl.sv
read_verilog -sv ../../../../rtl/verilog/core/memory/pu_riscv_membuf.sv
read_verilog -sv ../../../../rtl/verilog/core/memory/pu_riscv_memmisaligned.sv
read_verilog -sv ../../../../rtl/verilog/core/memory/pu_riscv_mmu.sv
read_verilog -sv ../../../../rtl/verilog/core/memory/pu_riscv_mux.sv
read_verilog -sv ../../../../rtl/verilog/core/memory/pu_riscv_pmachk.sv
read_verilog -sv ../../../../rtl/verilog/core/memory/pu_riscv_pmpchk.sv
read_verilog -sv ../../../../rtl/verilog/core/main/pu_riscv_bp.sv
read_verilog -sv ../../../../rtl/verilog/core/main/pu_riscv_core.sv
read_verilog -sv ../../../../rtl/verilog/core/main/pu_riscv_du.sv
read_verilog -sv ../../../../rtl/verilog/core/main/pu_riscv_memory.sv
read_verilog -sv ../../../../rtl/verilog/core/main/pu_riscv_rf.sv
read_verilog -sv ../../../../rtl/verilog/core/main/pu_riscv_state.sv
read_verilog -sv ../../../../rtl/verilog/core/main/pu_riscv_writeback.sv

read_verilog -sv ../../../../rtl/verilog/memory/pu_riscv_ram_1r1w_generic.sv
read_verilog -sv ../../../../rtl/verilog/memory/pu_riscv_ram_1r1w.sv
read_verilog -sv ../../../../rtl/verilog/memory/pu_riscv_ram_1rw_generic.sv
read_verilog -sv ../../../../rtl/verilog/memory/pu_riscv_ram_1rw.sv
read_verilog -sv ../../../../rtl/verilog/memory/pu_riscv_ram_queue.sv

read_verilog -sv ../../../../rtl/verilog/pu/wb/pu_riscv_wb2wb.sv
read_verilog -sv ../../../../rtl/verilog/pu/wb/pu_riscv_wb.sv

read_verilog -sv spram/core/peripheral_ram_generic_wb.sv
read_verilog -sv spram/core/peripheral_spram_wb.sv

read_verilog -sv pu_riscv_synthesis.sv

read_xdc system.xdc

synth_design -part xc7z020-clg484-1 -top pu_riscv_synthesis

opt_design
place_design
route_design

report_utilization
report_timing

write_bitstream -force system.bit
