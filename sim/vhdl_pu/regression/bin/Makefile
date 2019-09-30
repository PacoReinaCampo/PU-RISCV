all: build

build:
	@if [ ! -e work ]; then vlib work; fi
	@vcom -2008 -f pu.vc
	vsim -c -do run.do work.riscv_pu
