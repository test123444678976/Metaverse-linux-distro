#!/bin/bash
set -e
echo "=== Metaverse Linux 1.0.0 - Framboesa ==="
echo "=== Powered by Meta AI ==="

export LFS=/mnt/lfs
mkdir -p $LFS/{etc,var,usr,tools,src,boot,bin,sbin,lib,lib64}
mkdir -p $LFS/usr/{bin,sbin,lib}
ln -sf usr/bin $LFS/bin 2>/dev/null || true
ln -sf usr/sbin $LFS/sbin 2>/dev/null || true
ln -sf usr/lib $LFS/lib 2>/dev/null || true
ln -sf usr/lib $LFS/lib64 2>/dev/null || true
chown -R root:root $LFS/tools 2>/dev/null || true
chown -R root:root $LFS/src 2>/dev/null || true
echo "Prepare OK"

# Criar sistema mínimo para o ISO
mkdir -p output/iso/boot/grub
mkdir -p output/iso/metaverse

echo "Metaverse Linux 1.0.0 - Framboesa" > output/iso/metaverse/version.txt
echo "User: metaverse / Pass: metaverse" > output/iso/metaverse/README.txt

cat > output/iso/boot/grub/grub.cfg << 'EOF'
set timeout=10
set default=0
menuentry "Metaverse Linux 1.0.0 - Framboesa" {
    linux /boot/vmlinuz root=/dev/sr0
    initrd /boot/initrd.img
}
EOF

# Criar kernel fake para teste + ISO
echo "Metaverse Linux Kernel - Placeholder" > output/iso/boot/vmlinuz
echo "Metaverse Linux Initrd - Placeholder" > output/iso/boot/initrd.img

# Gerar ISO
grub-mkrescue -o output/metaverse-linux-framboesa.iso output/iso 2>/dev/null || \
xorriso -as mkisofs -o output/metaverse-linux-framboesa.iso -V "METAVERSE" -J -R output/iso

ls -lh output/
echo "✅ ISO criado com sucesso!"
