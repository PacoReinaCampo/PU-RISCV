all: build simulate

build:
	iverilog -g2012 -o system.vvp -c system.s -s pu_riscv_testbench_axi4

simulate:
	vvp system.vvp

clean:
	rm -rf system.vvp
