cd ../../../../..
call settings64_msim.bat
cd sim/mixed/tests/axi4/msim

vlib work
vlog -sv +incdir+../../../../../rtl/verilog/pkg -f system.verilog.vc
vcom -2008 -f system.vhdl.vc
vsim -c -do run.do work.riscv_testbench_axi4
