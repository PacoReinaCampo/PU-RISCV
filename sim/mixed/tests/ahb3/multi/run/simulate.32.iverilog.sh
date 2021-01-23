export PATH=$PATH:/opt/intelFPGA_pro/20.2/modelsim_ase/linuxaloem/

cd ../bin
rm -rf msim
make XLEN=32 SIM=iverilog
