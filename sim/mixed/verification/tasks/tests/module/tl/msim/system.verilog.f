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

../../../../../../../../rtl/verilog/pkg/core/peripheral_biu_verilog_pkg.sv
../../../../../../../../rtl/verilog/pkg/core/pu_riscv_verilog_pkg.sv

../../../../../../../../rtl/verilog/core/cache/pu_riscv_dcache_core.sv
../../../../../../../../rtl/verilog/core/cache/pu_riscv_icache_core.sv
../../../../../../../../rtl/verilog/core/cache/pu_riscv_noicache_core.sv
../../../../../../../../rtl/verilog/core/decode/pu_riscv_id.sv
../../../../../../../../rtl/verilog/core/execute/pu_riscv_alu.sv
../../../../../../../../rtl/verilog/core/execute/pu_riscv_bu.sv
../../../../../../../../rtl/verilog/core/execute/pu_riscv_execution.sv
../../../../../../../../rtl/verilog/core/execute/pu_riscv_lsu.sv
../../../../../../../../rtl/verilog/core/fetch/pu_riscv_if.sv
../../../../../../../../rtl/verilog/core/memory/pu_riscv_dmem_ctrl.sv
../../../../../../../../rtl/verilog/core/memory/pu_riscv_imem_ctrl.sv
../../../../../../../../rtl/verilog/core/memory/pu_riscv_membuf.sv
../../../../../../../../rtl/verilog/core/memory/pu_riscv_mux.sv
../../../../../../../../rtl/verilog/core/memory/pu_riscv_pmachk.sv
../../../../../../../../rtl/verilog/core/memory/pu_riscv_pmpchk.sv
../../../../../../../../rtl/verilog/core/main/pu_riscv_bp.sv
../../../../../../../../rtl/verilog/core/main/pu_riscv_core.sv
../../../../../../../../rtl/verilog/core/main/pu_riscv_du.sv
../../../../../../../../rtl/verilog/core/main/pu_riscv_rf.sv
../../../../../../../../rtl/verilog/core/main/pu_riscv_state.sv
../../../../../../../../rtl/verilog/memory/pu_riscv_ram_1rw_generic.sv
../../../../../../../../rtl/verilog/memory/pu_riscv_ram_queue.sv
../../../../../../../../rtl/verilog/module/tl/pu_riscv_tl.sv

../../../../../../../../verification/tasks/verilog/library/module/interface/tl/pu_riscv_memory_model_tl.sv
../../../../../../../../verification/tasks/verilog/library/module/interface/tl/pu_riscv_mmio_if_tl.sv
../../../../../../../../verification/tasks/verilog/library/module/interface/tl/pu_riscv_testbench_tl.sv
../../../../../../../../verification/tasks/verilog/library/module/main/pu_riscv_dbg_bfm.sv
../../../../../../../../verification/tasks/verilog/library/module/main/pu_riscv_htif.sv
