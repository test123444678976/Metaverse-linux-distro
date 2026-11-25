#!/bin/bash
set -e
echo "=== Metaverse Linux 1.0.0 - Framboesa ==="

mkdir -p output/iso/boot/grub
mkdir -p output/iso/metaverse

echo "Metaverse Linux 1.0.0 - Framboesa" > output/iso/metaverse/version.txt

# Usar kernel REAL do runner do GitHub
KERNEL=$(ls /boot/vmlinuz-* | head -n 1)
INITRD=$(ls /boot/initrd.img-* | head -n 1)
echo "Kernel encontrado: $KERNEL"
echo "Initrd encontrado: $INITRD"

cp $KERNEL output/iso/boot/vmlinuz
cp $INITRD output/iso/boot/initrd.img

cat > output/iso/boot/grub/grub.cfg << 'EOF'
set timeout=10
set default=0
menuentry "Metaverse Linux 1.0.0 - Framboesa" {
    linux /boot/vmlinuz boot=live quiet splash
    initrd /boot/initrd.img
}
EOF

# Criar ISO
grub-mkrescue -o output/metaverse-linux-framboesa.iso output/iso 2>/dev/null || \
xorriso -as mkisofs -o output/metaverse-linux-framboesa.iso -V "METAVERSE" -J -R output/iso

ls -lh output/
echo "✅ ISO criado com kernel real!"
