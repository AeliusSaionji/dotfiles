# Default networking settings
# Create a scheduled task in the Windows guest to run the following at boot:
# ssh 10.0.2.2 -R 3389:localhost:3389
# RDP localhost, profit.
#!/bin/bash

qemu-system-x86_64 \
-bios /usr/share/ovmf/ovmf_x64.bin  -net nic,model=virtio -net user \
-cpu host -smp cores=2 -m 4096 -machine type=pc,accel=kvm -enable-kvm \
-drive file="$HOME/documents/qemu/WinX.img",index=0,media=disk,if=virtio,format=raw,cache=none \
-soundhw hda -usbdevice tablet -nographic
