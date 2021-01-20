del transcript
rmdir /s /q work
vlib work
vcom -2008 -f system.vc
vsim -c -do run.do work.riscv_pu_wb