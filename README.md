# orin-nano
Scripts and code to support the Orin Nano Developer kit

# NVIDIA Jetson Linux
The current release is [R36.4.0](https://developer.nvidia.com/embedded/jetson-linux-r3640), which has a default Ubuntu 22.04 rootfs.

Resources:
* [Linux for Tegra](https://developer.nvidia.com/downloads/embedded/l4t/r36_release_v4.0/release/Jetson_Linux_R36.4.0_aarch64.tbz2)
* [Sample Root Filesystem](https://developer.nvidia.com/downloads/embedded/l4t/r36_release_v4.0/release/Tegra_Linux_Sample-Root-Filesystem_R36.4.0_aarch64.tbz2)

# Usage
This tool is only tested on Ubuntu 22.04 or newer.
* Install the host dependencies
  * ```sudo apt install -y abootimg binfmt-support binutils cpio cpp device-tree-compiler dosfstools iproute2 iputils-ping lbzip2 libxml2-utils netcat nfs-kernel-server openssl python3-yaml qemu-user-static rsync sshpass udev uuid-runtime whois xmlstarlet zstd lz4```
* Make a copy of the release yaml, and edit username and password.
  * Example: `cp r3640.yaml myconfig.yaml`
* Setup the rootfs and SDK with `nano-cli.py`
  * `python nano-cli.sh --download --rootfs --config myconfig.yaml`
* Install a blank SD card and blank NVME ssd to the board. Disconnect display and any peripherals on the USB-A ports.
* Put the board into forced recovery and connect its USB-C port to the host.
* Check that `0955:7523 NVIDIA Corp. APX` appears, with `lsusb`
* Disconnect the jumper used to put the board into forced recovery mode.
* Flash the board.
  * `python nano-cli.sh --flash --config myconfig.yaml`

# Troubleshooting
Flashing the devkit can be kind of finicky, here are some workarounds for issues I've encountered.

### USB error
If flashing fails and you have a USB Error
```ERROR: might be timeout in USB write.```

Try disabling autosuspend on the host, AND replugging the Orin with the jumper set to put it in forced recovery. This change to the host is temporary, and lost after rebooting.
```
sudo -s
echo -1 > /sys/module/usbcore/parameters/autosuspend
```

### Setup can't complete after board boots up.
* The flasher tries to reboot the board at least once - if there is a bootable image on either SD card or NVMe, try removing or wiping them first.
* Setup relies on NFS to transfer some files from the host after it reboots the orin nano. You may need to manually open the default port for NFS, or temporarily disable firewall.
* Make sure that you have removed the jumper for forced recovery, so that the board is trying to boot normally.


### No config for nano super
See https://forums.developer.nvidia.com/t/initrd-flashing-for-orin-nano-super-developer-kit/318874. The orin-nano-devkit-super seems to have been accidentally omitted from the release.

This is what you're supposed to do.
https://docs.nvidia.com/jetson/archives/r36.4/DeveloperGuide/IN/QuickStart.html#to-flash-the-jetson-developer-kit-operating-software

This sort of works in the meantime, but no MAXN mode.
https://docs.nvidia.com/jetson/archives/r36.4/DeveloperGuide/SD/FlashingSupport.html#using-flash-sh-with-orin-nx-and-nano
