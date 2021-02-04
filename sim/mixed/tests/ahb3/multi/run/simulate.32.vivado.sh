source ../../../../../../settings64_vivado.sh

cd ../bin
rm -rf msim
make XLEN=32 SIM=vivado
