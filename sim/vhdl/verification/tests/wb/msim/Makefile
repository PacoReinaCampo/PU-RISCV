all: build simulate

build:
	if [ ! -e work ]; then vlib work; fi
	vcom -2008 -f system.vc

simulate:
	vsim -c -do run.do work.riscv_pu_wb

clean:
	rm -rf work transcript
