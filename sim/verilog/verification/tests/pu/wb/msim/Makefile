all: build simulate

build:
	if [ ! -e work ]; then vlib work; fi
	vlog -sv -f system.f

simulate:
	vsim -c -do run.do work.pu_riscv_writeback

clean:
	rm -rf work transcript
