export PATH=/opt/riscv-elf-gcc/bin:${PATH}

git clone --recursive https://github.com/buildroot/buildroot

cd buildroot
make qemu_riscv32_virt_defconfig
make

qemu-system-riscv32 \
-M virt \
-nographic \
-bios output/images/fw_jump.elf \
-kernel output/images/Image \
-append "root=/dev/vda ro" \
-drive file=output/images/rootfs.ext2,format=raw,id=hd0 \
-device virtio-blk-device,drive=hd0 \
-netdev user,id=net0 \
-device virtio-net-device,netdev=net0
