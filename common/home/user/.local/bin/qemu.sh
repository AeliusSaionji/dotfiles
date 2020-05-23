#!/bin/sh

qemu-system-x86_64 \
 -enable-kvm -cpu host -smp cores=4 -m 4G \
 -nic user,hostfwd=tcp::33890-:3389,hostfwd=udp::33890-:3389 \
 -drive file="$HOME/.local/qemu/WinX.qcow2" \
 -nographic
