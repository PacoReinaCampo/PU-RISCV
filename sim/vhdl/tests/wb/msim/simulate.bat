cd ../../../../..
call settings64_msim.bat
cd sim/vhdl/tests/wb/msim

vlib work
vcom -2008 -f system.vc
vsim -c -do run.do work.riscv_pu_wb
