@echo off
call ../../../../../settings64_iverilog.bat

iverilog -g2012 -o system.vvp -c system.vc -s riscv_testbench_ahb3 -I ../../../../../rtl/verilog/pkg
vvp system.vvp
pause
