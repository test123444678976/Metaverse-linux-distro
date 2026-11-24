#!/bin/bash
set -e
export LFS=/mnt/lfs
chroot "$LFS" /usr/bin/env -i HOME=/root TERM="$TERM" \
  PATH=/usr/bin:/usr/sbin /bin/bash <<'EOF'
set -e
# Utilizadores
groupadd -g 5 tty || true
groupadd -g 6 disk || true
useradd -c "Metaverse User" -m -s /bin/bash -G audio,video,cdrom metaverse || true
echo "metaverse:metaverse" | chpasswd
echo "root:metaverse" | chpasswd
# Hostname
echo "metaverse" > /etc/hostname
cat > /etc/hosts <<HOSTS
127.0.0.1 localhost metaverse
::1 localhost ip6-localhost ip6-loopback
HOSTS
# fstab
cat > /etc/fstab <<FSTAB
/dev/sr0 / iso9660 ro 0 0
proc /proc proc defaults 0 0
sysfs /sys sysfs defaults 0 0
devpts /dev/pts devpts gid=5,mode=620 0 0
tmpfs /run tmpfs defaults 0 0
FSTAB
# systemd
systemctl enable systemd-networkd || true
systemctl enable systemd-resolved || true
echo "System OK"
EOF
