all: build

build:
	@if [ ! -e work ]; then vlib work; fi
	@vlog -sv +incdir+../../../../rtl/verilog/pkg -f pu_verilog.vc
	@vcom -2008 -f pu_vhdl.vc
	vsim -c -do run.do work.riscv_pu
