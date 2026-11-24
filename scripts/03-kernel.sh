#!/bin/bash
set -e
export LFS=/mnt/lfs
cp -v config/kernel.config $LFS/src/kernel.config
chroot "$LFS" /usr/bin/env -i HOME=/root TERM="$TERM" \
  PATH=/usr/bin:/usr/sbin /bin/bash <<'EOF'
set -e
cd /src
tar -xf linux-6.10.5.tar.xz
cd linux-6.10.5
cp ../kernel.config .config
make olddefconfig
make -j$(nproc)
make modules_install
cp -v arch/x86_64/boot/bzImage /boot/vmlinuz-metaverse
# initramfs
mkdir -pv /tmp/initramfs/{bin,dev,proc,sys,etc}
cp -v /bin/busybox /tmp/initramfs/bin/ || cp -v /usr/bin/busybox /tmp/initramfs/bin/
cat > /tmp/initramfs/init <<INIT
#!/bin/sh
mount -t proc proc /proc
mount -t sysfs sysfs /sys
mount -t devtmpfs devtmpfs /dev
exec /sbin/init
INIT
chmod +x /tmp/initramfs/init
cd /tmp/initramfs && find . | cpio -o -H newc | gzip > /boot/initramfs.img
echo "Kernel OK"
EOF
