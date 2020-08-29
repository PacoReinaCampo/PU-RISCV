rm -rf hello_cpp.run
rm -rf hello_cpp.elf
rm -rf hello_cpp.hex

export PATH=/opt/riscv-elf-gcc/bin:${PATH}

# x86-64 ISA
g++ hello_cpp.cpp -o hello_cpp.run

# RISCV-64 ISA
riscv64-unknown-elf-g++ -o hello_cpp.elf hello_cpp.cpp
riscv64-unknown-elf-objcopy -O ihex hello_cpp.elf hello_cpp.hex

# Linux RISCV-64 ISA
riscv64-unknown-linux-gnu-g++ -o hello_cpp.linux hello_cpp.cpp
