cd ../../../../..
call settings64_msim.bat
cd sim/verilog/tests/axi4/msim

vlib work
vlog -sv +incdir+../../../../../rtl/verilog/pkg -f system.vc
vsim -c -do run.do work.riscv_testbench_axi4
