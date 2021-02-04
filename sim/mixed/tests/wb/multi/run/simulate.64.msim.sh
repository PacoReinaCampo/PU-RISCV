source ../../../../../../settings64_msim.sh

cd ../bin
rm -rf msim
make XLEN=64 SIM=msim
