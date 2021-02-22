call ../../../../../settings64_vivado.bat

xvhdl -prj system.prj
xelab riscv_testbench_wb
xsim -R riscv_testbench_wb
pause
