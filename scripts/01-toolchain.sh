#!/bin/bash
set -e
export LFS=/mnt/lfs
cat > /tmp/toolchain.sh <<'EOF'
cd /src
# Binutils Pass 1
tar -xf binutils-2.42.tar.xz
cd binutils-2.42
mkdir build && cd build
../configure --prefix=$LFS/tools --with-sysroot=$LFS \
  --target=x86_64-lfs-linux-gnu --disable-nls --disable-werror
make -j$(nproc) && make install
cd ../.. && rm -rf binutils-2.42
# GCC Pass 1
tar -xf gcc-13.2.0.tar.xz
cd gcc-13.2.0
tar -xf ../mpfr-*.tar.xz && mv mpfr-* mpfr
tar -xf ../gmp-*.tar.xz && mv gmp-* gmp
tar -xf ../mpc-*.tar.xz && mv mpc-* mpc
mkdir build && cd build
../configure --prefix=$LFS/tools --with-glibc-version=2.39 \
  --with-sysroot=$LFS --with-newlib --without-headers \
  --enable-default-pie --enable-default-ssp \
  --disable-nls --disable-shared --disable-multilib \
  --disable-threads --disable-libatomic --disable-libgomp \
  --disable-libquadmath --disable-libssp --disable-libvtv --disable-libstdcxx \
  --enable-languages=c,c++
make -j$(nproc) && make install
cd ../.. && rm -rf gcc-13.2.0
# Linux Headers
tar -xf linux-6.10.5.tar.xz
cd linux-6.10.5
make mrproper
make headers
find usr/include -type f ! -name '*.h' -delete
cp -rv usr/include $LFS/usr
cd .. && rm -rf linux-6.10.5
# Glibc
tar -xf glibc-2.39.tar.xz
cd glibc-2.39
mkdir build && cd build
echo "rootsbindir=/usr/sbin" > configparms
../configure --prefix=/usr --disable-werror \
  --enable-kernel=4.19 --enable-stack-protector=strong \
  --with-headers=$LFS/usr/include --libc_cv_slibdir=/usr/lib
make -j$(nproc) && make DESTDIR=$LFS install
cd ../.. && rm -rf glibc-2.39
echo "Toolchain Pass 1 OK"
EOF
chmod +x /tmp/toolchain.sh
su - lfs -c "bash /tmp/toolchain.sh"
