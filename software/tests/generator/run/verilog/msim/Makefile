all: build simulate

build:
	if [ ! -e work ]; then vlib work; fi
	if [ ! -e ../../../../mem ]; then mkdir ../../../../mem; fi
	vlog -sv -f system.f

simulate:
	vsim -c -do run.do work.generator_mem

clean:
	rm -rf work ../../../../mem transcript *.txt *.vstf
