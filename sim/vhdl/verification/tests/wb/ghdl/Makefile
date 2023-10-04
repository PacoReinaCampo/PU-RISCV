all: build simulate

build:
	sh system.s

simulate:
	ghdl -e --std=08 pu_riscv_testbench_wb
	ghdl -r --std=08 pu_riscv_testbench_wb --ieee-asserts=disable-at-0 --vcd=riscv_testbench_wb.vcd --wave=system.ghw --stop-time=1ms

clean:
	rm -f *.cf *.vcd *.ghw
