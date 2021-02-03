@echo off
REM #################################################################
REM # Copyright (c) 1986-2020 Xilinx, Inc.  All rights reserved.    #
REM #################################################################

SET PATH=C:\apps\Xilinx\Vivado\2018.2\bin;C:\apps\Xilinx\Vivado\2018.2\lib\win64.o;%PATH%
SET XILINX_VIVADO=C:\apps\Xilinx\Vivado\2018.2

vivado -nojournal -log system.log -mode batch -source system.tcl
