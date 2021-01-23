rm -rf run
mkdir run

ln -s $PWD/bin/Makefile         $PWD/run
ln -s $PWD/bin/Makefile.include $PWD/run

cd run

make XLEN=64 SIM=iverilog
