call ../../../../../settings64_vivado.bat

vlib work
vlog -sv +incdir+../../../../../rtl/verilog/pkg -f system.vc
vsim -c -do run.do work.riscv_testbench_wb
