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

read_verilog -sv ../../../../rtl/verilog/core/cache/riscv_dcache_core.sv
read_verilog -sv ../../../../rtl/verilog/core/cache/riscv_dext.sv
read_verilog -sv ../../../../rtl/verilog/core/cache/riscv_icache_core.sv
read_verilog -sv ../../../../rtl/verilog/core/cache/riscv_noicache_core.sv
read_verilog -sv ../../../../rtl/verilog/core/decode/riscv_id.sv
read_verilog -sv ../../../../rtl/verilog/core/execute/riscv_alu.sv
read_verilog -sv ../../../../rtl/verilog/core/execute/riscv_bu.sv
read_verilog -sv ../../../../rtl/verilog/core/execute/riscv_div.sv
read_verilog -sv ../../../../rtl/verilog/core/execute/riscv_execution.sv
read_verilog -sv ../../../../rtl/verilog/core/execute/riscv_lsu.sv
read_verilog -sv ../../../../rtl/verilog/core/execute/riscv_mul.sv
read_verilog -sv ../../../../rtl/verilog/core/fetch/riscv_if.sv
read_verilog -sv ../../../../rtl/verilog/core/memory/riscv_dmem_ctrl.sv
read_verilog -sv ../../../../rtl/verilog/core/memory/riscv_imem_ctrl.sv
read_verilog -sv ../../../../rtl/verilog/core/memory/riscv_membuf.sv
read_verilog -sv ../../../../rtl/verilog/core/memory/riscv_memmisaligned.sv
read_verilog -sv ../../../../rtl/verilog/core/memory/riscv_mmu.sv
read_verilog -sv ../../../../rtl/verilog/core/memory/riscv_mux.sv
read_verilog -sv ../../../../rtl/verilog/core/memory/riscv_pmachk.sv
read_verilog -sv ../../../../rtl/verilog/core/memory/riscv_pmpchk.sv
read_verilog -sv ../../../../rtl/verilog/core/riscv_bp.sv
read_verilog -sv ../../../../rtl/verilog/core/riscv_core.sv
read_verilog -sv ../../../../rtl/verilog/core/riscv_du.sv
read_verilog -sv ../../../../rtl/verilog/core/riscv_memory.sv
read_verilog -sv ../../../../rtl/verilog/core/riscv_rf.sv
read_verilog -sv ../../../../rtl/verilog/core/riscv_state.sv
read_verilog -sv ../../../../rtl/verilog/core/riscv_wb.sv

read_verilog -sv ../../../../rtl/verilog/memory/riscv_ram_1r1w_generic.sv
read_verilog -sv ../../../../rtl/verilog/memory/riscv_ram_1r1w.sv
read_verilog -sv ../../../../rtl/verilog/memory/riscv_ram_1rw_generic.sv
read_verilog -sv ../../../../rtl/verilog/memory/riscv_ram_1rw.sv
read_verilog -sv ../../../../rtl/verilog/memory/riscv_ram_queue.sv

read_verilog -sv ../../../../rtl/verilog/pu/axi4/riscv_biu2axi4.sv
read_verilog -sv ../../../../rtl/verilog/pu/axi4/riscv_pu_axi4.sv
read_verilog -sv ../../../../rtl/verilog/pu/riscv_ahb2axi.sv
read_verilog -sv ../../../../rtl/verilog/pu/riscv_axi2ahb.sv

read_verilog -sv spram/core/mpsoc_axi4_spram.sv
read_verilog -sv pu_riscv_synthesis.sv

read_xdc system.xdc

synth_design -part xc7z020-clg484-1 -include_dirs ../../../../rtl/verilog/pkg -top pu_riscv_synthesis

opt_design
place_design
route_design

report_utilization
report_timing

write_bitstream -force system.bit