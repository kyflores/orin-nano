# !/bin/bash
# Sync this directory to the remote.
#
pushd ../

TARGET="${1}:/data/orin-nano-support/"
echo "Sending to ${TARGET}"
rsync -avz \
    ./orin-nano-support/ \
    --exclude bsp/Linux_for_Tegra \
    --exclude bsp/orin_nano_l4t.tbz2 \
    --exclude bsp/orin_nano_rootfs.tbz2 \
    ${TARGET}

popd

