all: build

build:
	@if [ ! -e work ]; then vlib work; fi
	@vlog -sv +incdir+../../../../rtl/verilog/pkg -f pu.vc
	vsim -c -do run.do work.riscv_pu
