all: build simulate

build:
	if [ ! -e work ]; then vlib work; fi
	vcom -2008 -f system.f

simulate:
	vsim -c -do run.do work.pu_riscv_tl

clean:
	rm -rf work transcript
