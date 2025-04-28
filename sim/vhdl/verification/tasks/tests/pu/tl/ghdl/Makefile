all: build simulate

build:
	sh system.g

simulate:
	ghdl -e --std=08 pu_riscv_testbench_tl
	ghdl -r --std=08 pu_riscv_testbench_tl --ieee-asserts=disable-at-0 --vcd=riscv_testbench_tl.vcd --wave=system.ghw --stop-time=1ms

test:
	gtkwave system.ghw

clean:
	rm -f *.cf *.vcd *.ghw
