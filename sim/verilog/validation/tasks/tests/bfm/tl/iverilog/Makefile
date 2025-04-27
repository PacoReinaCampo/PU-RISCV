all: build simulate

build:
	iverilog -g2012 -o system.vvp -c system.s -s peripheral_bfm_testbench

simulate:
	vvp system.vvp

test:
	gtkwave basic.vcd

clean:
	rm -rf *.vvp *.vcd
