@echo off
REM #################################################################
REM # Copyright (c) 1986-2020 Xilinx, Inc.  All rights reserved.    #
REM #################################################################

SET PATH=C:\Xilinx\Vivado\2020.1\bin;C:\Xilinx\Vivado\2020.1\lib\win64.o;%PATH%
SET XILINX_VIVADO=C:\Xilinx\Vivado\2020.1

vivado -nojournal -log system.log -mode batch -source system.tcl
