all: build simulate

build:
	xvlog -prj system.prj

simulate:
	xelab peripheral_bfm_testbench
	xsim -R peripheral_bfm_testbench

test:
	gtkwave basic.vcd

clean:
	rm -rf *.dir *.jou *.log *.pb *.vcd *.wdb .Xil
