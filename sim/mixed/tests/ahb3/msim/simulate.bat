del transcript
rmdir /s /q work
vlib work
vlog -sv +incdir+../../../../../rtl/verilog/pkg -f system.verilog.vc
vcom -2008 -f system.vhdl.vc
vsim -c -do run.do work.riscv_testbench_ahb3