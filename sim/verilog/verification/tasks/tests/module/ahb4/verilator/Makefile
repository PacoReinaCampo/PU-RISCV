all: build simulate

build:
	verilator -Wno-lint -Wno-UNOPTFLAT -Wno-COMBDLY --cc -f system.vc --top-module pu_riscv_ahb4

simulate:

clean:
	rm -rf obj_dir
