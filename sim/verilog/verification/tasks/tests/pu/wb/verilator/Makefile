all: build simulate

build:
	verilator -Wno-lint -Wno-UNOPTFLAT -Wno-COMBDLY --cc -f system.vc --top-module pu_riscv_writeback

simulate:

clean:
	rm -rf obj_dir
