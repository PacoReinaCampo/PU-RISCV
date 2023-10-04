all: build simulate

build:
	sh system.s

simulate:
	ghdl -e --std=08 pu_riscv_testbench_ahb3
	ghdl -r --std=08 pu_riscv_testbench_ahb3 --ieee-asserts=disable-at-0 --vcd=riscv_testbench_ahb3.vcd --wave=system.ghw --stop-time=1ms

clean:
	rm -f *.cf *.vcd *.ghw
