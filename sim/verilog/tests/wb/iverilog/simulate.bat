@echo off
call ../../../../../settings64_iverilog.bat

iverilog -g2012 -o system.vvp -c system.vc -s riscv_testbench_axi4
vvp system.vvp
pause
