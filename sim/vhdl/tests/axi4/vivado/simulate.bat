call ../../../../../settings64_vivado.bat

xvhdl -prj system.prj
xelab riscv_testbench_axi4
xsim -R riscv_testbench_axi4
pause
