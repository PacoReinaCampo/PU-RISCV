@echo off
call ../../../../../../settings64_iverilog.bat

iverilog -g2012 -o system.vvp -c system.s -s peripheral_bfm_testbench
vvp system.vvp
pause
