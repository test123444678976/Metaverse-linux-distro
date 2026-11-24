#!/bin/bash
set -e
export LFS=/mnt/lfs
export METAVERSE_VERSION="1.0.0"
export METAVERSE_CODENAME="Framboesa"

echo "=== Metaverse Linux $METAVERSE_VERSION - $METAVERSE_CODENAME ==="
echo "=== Powered by Meta AI ==="

bash scripts/00-prepare.sh
bash scripts/01-toolchain.sh
bash scripts/02-system.sh
bash scripts/03-kernel.sh
bash scripts/04-xorg-mesa.sh
bash scripts/05-mate.sh
bash scripts/06-display-manager.sh
bash scripts/07-make-iso.sh

echo "✅ ISO PRONTO: metaverse-linux-1.0.0.iso"
ls -lh metaverse-linux-1.0.0.iso
