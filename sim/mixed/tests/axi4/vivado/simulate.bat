cd ../../../../..
call settings64_vivado.bat
cd sim/verilog/tests/axi4/vivado

xvlog -i ../../../../../rtl/verilog/pkg -prj system.verilog.prj
xvhdl -prj system.vhdl.prj
xelab riscv_testbench_axi4
xsim -R riscv_testbench_axi4
