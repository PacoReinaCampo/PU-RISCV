cd ../../../..
call settings64_vivado.bat
cd synthesis/vhdl/bb/vivado

vivado -nojournal -log system.log -mode batch -source system.tcl
