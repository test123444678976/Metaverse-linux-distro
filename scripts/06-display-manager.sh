#!/bin/bash
set -e
export LFS=/mnt/lfs
chroot "$LFS" /usr/bin/env -i HOME=/root TERM="$TERM" \
  PATH=/usr/bin:/usr/sbin /bin/bash <<'EOF'
set -e
cd /src
tar -xf lightdm-1.32.0.tar.xz; cd lightdm-1.32.0
./configure --prefix=/usr --sysconfdir=/etc --localstatedir=/var \
  --with-greeter-user=lightdm --with-greeter-session=lightdm-gtk-greeter
make -j$(nproc) && make install
cd .. && rm -rf lightdm-1.32.0
tar -xf lightdm-gtk-greeter-2.0.8.tar.xz; cd lightdm-gtk-greeter-2.0.8
./configure --prefix=/usr --sysconfdir=/etc
make -j$(nproc) && make install
cd .. && rm -rf lightdm-gtk-greeter-2.0.8
# Config LightDM
cat > /etc/lightdm/lightdm.conf <<LIGHTDM
[Seat:*]
greeter-session=lightdm-gtk-greeter
user-session=mate-metaverse
autologin-user=metaverse
autologin-session=mate-metaverse
autologin-user-timeout=0
LIGHTDM
cat > /etc/lightdm/lightdm-gtk-greeter.conf <<GREETER
[greeter]
background=/usr/share/backgrounds/metaverse/wallpaper.png
theme-name=Metaverse
icon-theme-name=mate-icon-theme-faenza
font-name=Ubuntu 11
indicators=~session;~power
GREETER
systemctl enable lightdm
echo "LightDM OK"
EOF
