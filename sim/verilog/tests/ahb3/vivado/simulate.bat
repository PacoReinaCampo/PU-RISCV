call ../../../../../settings64_vivado.bat

xvlog -i ../../../../../rtl/verilog/pkg -prj system.prj
xelab riscv_testbench_ahb3
xsim -R riscv_testbench_ahb3
pause
