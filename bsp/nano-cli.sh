#!/bin/bash

sha1() {
    printf '%s %s\n' "$1" "$2" | sha1sum --check
}

do_download() {
    wget "$ROOTFS_URL" -O "orin_nano_rootfs.tbz2" --trust-server-names
    wget "$L4T_URL" -O "orin_nano_l4t.tbz2" --trust-server-names

    sha1 $ROOTFS_CHECKSUM orin_nano_rootfs.tbz2
    if [ $? -ne 0 ]; then
        echo "Rootfs checksum failed"; exit 1
    fi

    sha1 $L4T_CHECKSUM orin_nano_l4t.tbz2
    if [ $? -ne 0 ]; then
        echo "L4T checksum failed"; exit 1
    fi

}

do_rootfs() {
    tar xvf orin_nano_l4t.tbz2

    mkdir -p Linux_for_Tegra/rootfs/
    sudo tar -xjpf orin_nano_rootfs.tbz2 -C Linux_for_Tegra/rootfs/ -v

    pushd Linux_for_Tegra/
    sudo bash apply_binaries.sh

    printf "Installing host dependencies required for initrd flash"
    sudo bash tools/l4t_flash_prerequisites.sh

    sudo bash tools/l4t_create_default_user.sh \
        -u "${FLASH_USERNAME}" \
        -p "${FLASH_PASSWORD}" \
        --accept-license

    popd
}

do_flash_sh() {
    pushd Linux_for_Tegra
    # NVME flash is simplified for orin nano devkit. See:
    # https://docs.nvidia.com/jetson/archives/r36.4/DeveloperGuide/SD/FlashingSupport.html#using-flash-sh-with-orin-nx-and-nano
    sudo bash ./flash.sh jetson-orin-nano-devkit-super-nvme internal

    popd
}

do_flash_nvme() {
    pushd Linux_for_Tegra

    sudo bash ./tools/kernel_flash/l4t_initrd_flash.sh \
        --external-device nvme0n1p1 \
        -p "-c ./bootloader/generic/cfg/flash_t234_qspi.xml" \
        -c ./tools/kernel_flash/flash_l4t_t234_nvme.xml \
        --showlogs \
        --network usb0 \
        jetson-orin-nano-devkit-super external

    popd
}

clean=0; rootfs=0; download=0; flash=0;
# https://stackoverflow.com/a/31443098
while [ "$#" -gt 0 ]; do
  case "$1" in
    -c) config="$2"; shift 2;;
    -r) rootfs=1; shift 1;;
    -d) download=1; shift 1;;
    -f) flash=1; shift 1;;

    --config=*) config="${1#*=}"; shift 1;;
    --rootfs) rootfs=1; shift 1;;
    --download) download=1; shift 1;;
    --flash) flash=1; shift 1;;
    --clean) clean=1; shift 1;;
    --config) echo "$1 requires an argument" >&2; exit 1;;

    -*) echo "unknown option: $1" >&2; exit 1;;
    # *) handle_argument "$1"; shift 1;;
  esac
done

source "${config}"
if [ ${clean} == 1 ]; then
    sudo rm -rf Linux_for_Tegra/
    exit 0
fi

echo "Download" ${download}
echo "Rootfs" ${rootfs}
echo "Flash" ${flash}

if [ ${download} == 1 ]; then
    do_download
fi

if [ ${rootfs} == 1 ]; then
    do_rootfs
fi

if [ ${flash} == 1 ]; then
    do_flash_nvme
fi
