all: build simulate

build:
	verilator -Wno-lint -Wno-UNOPTFLAT -Wno-COMBDLY --cc -f system.vc --top-module riscv_pu_axi4

simulate:

clean:
	rm -rf obj_dir
