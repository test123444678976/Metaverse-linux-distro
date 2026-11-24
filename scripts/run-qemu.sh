#!/bin/bash
# Metaverse Linux - Testar no QEMU

ISO=$(ls output/*.iso 2>/dev/null | head -n 1)
if [ -z "$ISO" ]; then
  ISO=$(ls *.iso 2>/dev/null | head -n 1)
fi

if [ -z "$ISO" ]; then
  echo "❌ Nenhum ISO encontrado! Faz o build primeiro."
  echo "sudo bash scripts/build-all.sh"
  exit 1
fi

echo "💜 A iniciar Metaverse Linux: $ISO"

qemu-system-x86_64 \
  -cdrom "$ISO" \
  -boot d \
  -m 4096 \
  -smp 4 \
  -cpu host \
  -enable-kvm \
  -vga virtio \
  -display default,show-cursor=on \
  -usb \
  -device usb-tablet \
  -name "Metaverse Linux"
