export PATH=/opt/riscv-elf-gcc/bin:${PATH}

rm -rf dump
rm -rf hex
rm -rf riscv-tests

mkdir dump
mkdir hex

git clone --recursive https://github.com/riscv/riscv-tests

cd riscv-tests
autoconf
./configure --prefix=/opt/riscv-elf-gcc/bin
make

cd isa

source ../../elf2hex.sh

mv *.dump ../../dump
mv *.hex ../../hex

cd ..

make clean
