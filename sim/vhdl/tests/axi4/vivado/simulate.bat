call ../../../../../settings64_vivado.bat

xvlog -i ../../../../../rtl/vhdl/pkg -prj system.prj
xelab riscv_testbench_axi4
xsim -R riscv_testbench_axi4
