cd ../../../..
call settings64_vivado.bat
cd synthesis/verilog/wb/vivado

vivado -nojournal -log system.log -mode batch -source system.tcl
