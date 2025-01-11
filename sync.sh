#!/bin/bash
# Sync this directory to the remote.
#
pushd ../

TARGET="${1}:/data/develop/"
echo "Sending to ${TARGET}"
rsync -avz \
    ./orin-nano/ \
    --exclude Linux_for_Tegra \
    --exclude orin_nano_l4t.tbz2 \
    --exclude orin_nano_rootfs.tbz2 \
    ${TARGET}

popd

