all: build simulate

build:
	if [ ! -e work ]; then vlib work; fi
	vlog -sv -f system.f

simulate:
	vsim -c -do run.do work.peripheral_bfm_testbench

test:
	gtkwave basic.vcd

clean:
	rm -rf work transcript *.vcd
