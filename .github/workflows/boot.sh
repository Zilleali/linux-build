#!/bin/bash

# Build the kernel
make defconfig
make -j$(nproc)

# Create root filesystem
mkdir -p rootfs
sudo debootstrap focal rootfs
sudo chroot rootfs apt install -y openssh-server
echo "root:password" | sudo chroot rootfs chpasswd
sudo tar -cvzf rootfs.tar.gz -C rootfs .

# Boot the kernel with QEMU
qemu-system-x86_64 \
  -kernel arch/x86/boot/bzImage \
  -initrd rootfs.tar.gz \
  -append "root=/dev/ram rw console=ttyS0" \
  -nographic \
  -netdev user,id=net0,hostfwd=tcp::2222-:22 \
  -device e1000,netdev=net0
