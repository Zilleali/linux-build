#!/bin/bash
make defconfig
make -j$(nproc)
make modules
sudo make modules_install
sudo make install
