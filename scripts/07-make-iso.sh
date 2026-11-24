#!/bin/bash
set -e
ISO_DIR=/tmp/metaverse-iso
rm -rf $ISO_DIR
mkdir -pv $ISO_DIR/boot/grub
cp -v /mnt/lfs/boot/vmlinuz-metaverse $ISO_DIR/boot/
cp -v /mnt/lfs/boot/initramfs.img $ISO_DIR/boot/
cp -v branding/logo.png $ISO_DIR/boot/logo.png
cp -v branding/wallpaper.png $ISO_DIR/boot/wallpaper.png
cat > $ISO_DIR/boot/grub/grub.cfg <<'EOF'
set timeout=5
set default=0
menuentry "Metaverse Linux 1.0.0 - Framboesa" {
  linux /boot/vmlinuz-metaverse root=/dev/sr0 quiet splash
  initrd /boot/initramfs.img
}
menuentry "Metaverse Linux (Safe Mode)" {
  linux /boot/vmlinuz-metaverse root=/dev/sr0 single
  initrd /boot/initramfs.img
}
EOF
cp -v config/grub.cfg $ISO_DIR/boot/grub/grub.cfg || true
grub-mkrescue -o metaverse-linux-1.0.0.iso $ISO_DIR
ls -lh metaverse-linux-1.0.0.iso
