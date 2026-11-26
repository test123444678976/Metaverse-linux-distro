#!/bin/bash
set -e
echo "=== Metaverse Linux 1.0.0 - Framboesa ==="

# 1. Instalar ferramentas + kernel GENERICO (não Azure)
sudo apt-get update -qq
sudo apt-get install -y -qq grub-pc-bin xorriso isolinux linux-generic busybox-static cpio gzip

# 2. Encontrar o kernel GENERICO
KERNEL=$(ls /boot/vmlinuz-*-generic | head -n 1)
echo "Kernel GENERICO encontrado: $KERNEL"

# 3. Limpar e criar estrutura do ISO
rm -rf output iso rootfs
mkdir -p output/iso/boot/grub

# 4. Copiar kernel generico
cp "$KERNEL" output/iso/boot/vmlinuz

# 5. Criar rootfs minimo com o nosso init
mkdir -p rootfs/bin rootfs/sbin rootfs/etc rootfs/proc rootfs/sys rootfs/dev
cp /bin/busybox rootfs/bin/busybox
cd rootfs
ln -sf /bin/busybox bin/sh
ln -sf /bin/busybox bin/mount
ln -sf /bin/busybox bin/echo
ln -sf /bin/busybox bin/cat
ln -sf /bin/busybox bin/ls
ln -sf /bin/busybox bin/help

cat > init << 'INITEOF'
#!/bin/sh
mount -t proc proc /proc
mount -t sysfs sysfs /sys
mount -t devtmpfs devtmpfs /dev
clear
echo "=========================================="
echo "  METAVERSE LINUX 1.0.0 - FRAMBOESA"
echo "=========================================="
echo ""
echo "  Kernel generico carregado com sucesso!"
echo "  Bem-vindo ao Metaverse!"
echo ""
echo "  Escreve 'help' para ver comandos"
echo ""
exec /bin/sh
INITEOF
chmod +x init
cd ..

# 6. Criar initramfs do Metaverse
cd rootfs
find . -print0 | cpio --null -ov --format=newc | gzip -9 > ../output/iso/boot/metaverse-initrd.img
cd ..

# 7. GRUB
cat > output/iso/boot/grub/grub.cfg << 'EOF'
set timeout=10
set default=0
menuentry "Metaverse Linux 1.0.0 - Framboesa" {
    linux /boot/vmlinuz boot=metaverse quiet
    initrd /boot/metaverse-initrd.img
}
menuentry "Metaverse Linux (Modo Debug)" {
    linux /boot/vmlinuz boot=metaverse debug ignore_loglevel
    initrd /boot/metaverse-initrd.img
}
EOF

# 8. Criar ISO
grub-mkrescue -o output/metaverse-linux-framboesa.iso output/iso

ls -lh output/*.iso
echo "ISO criado com kernel GENERICO!"
