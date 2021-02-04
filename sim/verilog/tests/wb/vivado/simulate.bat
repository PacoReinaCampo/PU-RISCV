cd ../../../../..
call settings64_vivado.bat
cd sim/verilog/tests/wb/vivado

xvlog -i ../../../../../rtl/verilog/pkg -prj system.prj
xelab riscv_testbench_wb
xsim -R riscv_testbench_wb
