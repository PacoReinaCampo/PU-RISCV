rm -rf life_cpp.run
rm -rf life_cpp.elf
rm -rf life_cpp.hex

export PATH=/opt/riscv-elf-gcc/bin:${PATH}

# x86-64 ISA
g++ life_cpp.cpp -o life_cpp.run

# RISCV-64 ISA
riscv64-unknown-elf-g++ -o life_cpp.elf life_cpp.cpp
riscv64-unknown-elf-objcopy -O ihex life_cpp.elf life_cpp.hex
