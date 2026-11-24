#!/bin/bash
set -e
export LFS=/mnt/lfs

# Copiar branding para dentro do LFS ANTES do chroot
mkdir -pv $LFS/usr/share/themes/Metaverse
cp -rv branding/metaverse-theme/* $LFS/usr/share/themes/Metaverse/
mkdir -pv $LFS/usr/share/backgrounds/metaverse
cp -v branding/wallpaper.png $LFS/usr/share/backgrounds/metaverse/wallpaper.png
cp -v branding/logo.png $LFS/usr/share/pixmaps/metaverse-logo.png
mkdir -pv $LFS/usr/share/glib-2.0/schemas
cp -v branding/schemas/99-metaverse.gschema.override $LFS/usr/share/glib-2.0/schemas/

chroot "$LFS" /usr/bin/env -i HOME=/root TERM="$TERM" \
  PATH=/usr/bin:/usr/sbin /bin/bash <<'EOF'
set -e
cd /src
# MATE na ordem certa
for pkg in mate-common libmatekbd libmatemixer libmateweather mate-desktop mate-menus mate-panel mate-session-manager mate-settings-daemon caja marco mate-control-center mate-media mate-power-manager mate-screensaver mate-system-monitor mate-terminal mate-utils mate-backgrounds pluma eom engrampa atril mate-calc; do
  tar -xf $pkg-*.tar.xz
  cd $pkg-*/
  ./configure --prefix=/usr --sysconfdir=/etc --localstatedir=/var
  make -j$(nproc) && make install
  cd .. && rm -rf $pkg-*/
done
# Sessão MATE
cat > /usr/share/xsessions/mate-metaverse.desktop <<DESKTOP
[Desktop Entry]
Name=Metaverse (MATE)
Comment=Metaverse Linux - MATE Desktop
Exec=mate-session
TryExec=mate-session
Type=Application
DesktopNames=MATE;Metaverse;
DESKTOP
# .xinitrc
echo "exec mate-session" > /etc/skel/.xinitrc
echo "exec mate-session" > /home/metaverse/.xinitrc
chown metaverse:metaverse /home/metaverse/.xinitrc
# Compilar schemas - OBRIGATÓRIO
glib-compile-schemas /usr/share/glib-2.0/schemas
echo "MATE OK"
EOF
