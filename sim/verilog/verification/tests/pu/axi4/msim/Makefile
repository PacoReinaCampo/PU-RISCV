all: build simulate

build:
	if [ ! -e work ]; then vlib work; fi
	vlog -sv -f system.vc

simulate:
	vsim -c -do run.do work.pu_riscv_mmio_if_axi4

clean:
	rm -rf work transcript
