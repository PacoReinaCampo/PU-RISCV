rm -rf life_c.run
rm -rf life_c.elf
rm -rf life_c.hex

export PATH=/opt/riscv-elf-gcc/bin:${PATH}

# x86-64 ISA
gcc life_c.c -o life_c.run

# RISCV-64 ISA
riscv64-unknown-elf-gcc -o life_c.elf life_c.c
riscv64-unknown-elf-objcopy -O ihex life_c.elf life_c.hex
