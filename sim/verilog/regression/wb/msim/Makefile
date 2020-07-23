all: build simulate

build:
	if [ ! -e work ]; then vlib work; fi
	vlog -sv +incdir+../../../../../rtl/verilog/pkg -f system.vc

simulate:
	vsim -c -do run.do work.riscv_pu_wb
