call ../../../../../settings64_vivado.bat

xvlog -prj system.prj
xelab riscv_testbench_wb
xsim -R riscv_testbench_wb
pause
