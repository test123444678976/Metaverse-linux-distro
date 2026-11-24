#!/bin/bash
set -e
export LFS=/mnt/lfs
mkdir -pv $LFS/{etc,var,usr,tools,src,boot}
mkdir -pv $LFS/{bin,sbin,lib,lib64}
ln -sfv usr/bin $LFS/bin
ln -sfv usr/sbin $LFS/sbin
ln -sfv usr/lib $LFS/lib
ln -sfv usr/lib $LFS/lib64
groupadd lfs || true
useradd -s /bin/bash -g lfs -m -k /dev/null lfs || true
chown -Rv lfs $LFS/tools $LFS/src
echo "Prepare OK"
