rm -rf life_go.elf
rm -rf life_go.hex

export PATH=/opt/riscv-elf-gcc/bin:${PATH}
export PATH=/opt/riscv-go/bin:${PATH}

# x86-64 ISA
go build life_go.go

# RISCV-64 ISA
GOOS=linux GOARCH=riscv64 go build -o life_go.elf life_go.go
riscv64-unknown-elf-objcopy -O ihex life_go.elf life_go.hex
