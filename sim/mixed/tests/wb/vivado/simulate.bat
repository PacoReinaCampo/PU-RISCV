call ../../../../../settings64_vivado.bat

xvlog -prj system.verilog.prj
xvhdl -prj system.vhdl.prj
xelab riscv_testbench_wb
xsim -R riscv_testbench_wb
pause
