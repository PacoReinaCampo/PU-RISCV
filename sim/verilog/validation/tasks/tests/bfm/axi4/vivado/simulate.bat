@echo off
call ../../../../../../../../settings64_vivado.bat

xvlog -prj system.prj
xelab peripheral_bfm_testbench
xsim -R peripheral_bfm_testbench
pause
