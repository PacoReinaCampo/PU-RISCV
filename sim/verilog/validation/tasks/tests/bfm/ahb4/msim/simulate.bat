@echo off
call ../../../../../../../../settings64_msim.bat

vlib work
vlog -sv -f system.f
vsim -c -do run.do work.peripheral_bfm_testbench
pause
