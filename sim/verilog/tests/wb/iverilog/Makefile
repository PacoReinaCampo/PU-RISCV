all: build simulate

build:
	iverilog -g2012 -o system.vvp -c system.vc -s riscv_testbench_wb -I ../../../../../rtl/verilog/pkg

simulate:
	vvp system.vvp

clean:
	rm -rf system.vvp
