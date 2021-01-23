rm -rf run
mkdir run

ln -s $PWD/bin/Makefile         $PWD/run
ln -s $PWD/bin/Makefile.include $PWD/run

cd run

export PATH=$PATH:/opt/Xilinx/Vivado/2020.2/bin/

make XLEN=64 SIM=vivado
