cd ../../../..
call settings64_vivado.bat
cd synthesis/verilog/ahb3/vivado

vivado -nojournal -log system.log -mode batch -source system.tcl
