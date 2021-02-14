@echo off
call ../../../../../settings64_verilator.bat

verilator -Wno-lint -Wno-UNOPTFLAT -Wno-COMBDLY --cc -f system.vc --top-module riscv_pu_axi4
pause
