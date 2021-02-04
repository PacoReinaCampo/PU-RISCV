cd ../../../../..
call settings64_vivado.bat
cd sim/verilog/tests/ahb3/vivado

xvlog -i ../../../../../rtl/verilog/pkg -prj system.prj
xelab riscv_testbench_ahb3
xsim -R riscv_testbench_ahb3
