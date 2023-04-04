all: build simulate

build:
	iverilog -g2012 -o system.vvp -c system.vc -s pu_riscv_testbench_ahb3

simulate:
	vvp system.vvp

clean:
	rm -rf system.vvp
