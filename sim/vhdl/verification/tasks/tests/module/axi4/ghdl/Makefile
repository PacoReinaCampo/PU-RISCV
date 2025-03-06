all: build simulate

build:
	sh system.g

simulate:
	ghdl -e --std=08 pu_riscv_testbench_axi4
	ghdl -r --std=08 pu_riscv_testbench_axi4 --ieee-asserts=disable-at-0 --vcd=riscv_testbench_axi4.vcd --wave=system.ghw --stop-time=1ms

test:
	gtkwave system.ghw

clean:
	rm -f *.cf *.vcd *.ghw
