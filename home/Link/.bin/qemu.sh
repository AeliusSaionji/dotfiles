#!/bin/sh
# Default networking settings
# Create a scheduled task in the Windows guest to run the following at boot:
# ssh 10.0.2.2 -R 3389:localhost:3389
# RDP localhost, profit.
qemu-system-x86_64 \
-drive file=~/WinX.img,index=0,media=disk,if=virtio,format=raw \
-cpu host -smp cores=2 -m 4096 -machine type=pc,accel=kvm -enable-kvm \
-nographic -soundhw hda &
