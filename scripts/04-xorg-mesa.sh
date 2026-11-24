#!/bin/bash
set -e
export LFS=/mnt/lfs
chroot "$LFS" /usr/bin/env -i HOME=/root TERM="$TERM" \
  PATH=/usr/bin:/usr/sbin /bin/bash <<'EOF'
set -e
cd /src
# Mesa
tar -xf mesa-24.1.0.tar.xz; cd mesa-24.1.0
mkdir build && cd build
meson setup .. --prefix=/usr --buildtype=release \
  -Dplatforms=x11,wayland \
  -Dgallium-drivers=r300,r600,radeonsi,nouveau,iris,crocus,virgl,svga,swrast \
  -Dvulkan-drivers=amd,intel,swrast \
  -Ddri3=enabled -Degl=enabled -Dgles1=enabled -Dgles2=enabled \
  -Dglx=dri -Dshared-glapi=enabled -Dgbm=enabled -Dopengl=true
ninja -j$(nproc) && ninja install
cd ../.. && rm -rf mesa-24.1.0
# Xorg Server
tar -xf xorg-server-21.1.13.tar.xz; cd xorg-server-21.1.13
./configure --prefix=/usr --sysconfdir=/etc --localstatedir=/var \
  --with-xkb-path=/usr/share/X11/xkb \
  --with-xkb-output=/var/lib/xkb \
  --enable-glamor --enable-dri3
make -j$(nproc) && make install
mkdir -pv /etc/X11/xorg.conf.d
cat > /etc/X11/xorg.conf.d/10-metaverse.conf <<XORG
Section "Device"
  Identifier "Metaverse GPU"
  Driver "modesetting"
  Option "AccelMethod" "glamor"
EndSection
XORG
echo "X.org + Mesa OK"
EOF
