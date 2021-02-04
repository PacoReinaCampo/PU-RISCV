source ../../../../../../settings64_vivado.sh

cd ../bin
rm -rf msim
make XLEN=64 SIM=vivado
