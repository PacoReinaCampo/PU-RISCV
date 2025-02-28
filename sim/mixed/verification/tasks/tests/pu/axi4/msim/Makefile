all: build simulate

build:
	if [ ! -e work ]; then vlib work; fi
	vlog -sv -f system.verilog.f
	vcom -2008 -f system.vhdl.f

simulate:
	vsim -c -do run.do work.pu_riscv_axi4

clean:
	rm -rf work transcript
