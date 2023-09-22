# Resize OpenWRT's SquashFS Root Filesystem For x86 

OpenWRT with SquashFS offers numerous advantages, such as easier backups, factory reset to a known good config, no flash memory wear and config management simplicity. However, all this comes with a huge drawback for x86 systems that could better utilise their extra capacity if not for ***a default 100MB SquashFS root partition limitation*** (an artefact of OpenWRT's embedded device origins). To work around this limitation, typically x86 OWRT systems will use EXT4 filesystem images, but this sacrifices all the convenience, immutability, SD/MMC flash wear protection and excellent simplicity that SquashFS provides. But what if there was a way to have the best of both worlds?

## Overview

This script helps to overcome all the SquashFS limitations on x86 by:

- Building fresh OpenWRT SquashFS images for x86 with a **CUSTOMISABLE ROOT PARTITION SIZE** size.
- Eliminating the need for complex, painful & risky post-install command line wizardry to reconfigure partitions.
- Providing additional VMWare .vmdk versions of each image for virtualised of SquashFS x86 systems.

## Instructions

To utilise the script, pay attention to a few key variables:

1. Choose your preferred version or snapshot of the OWRT x86 Image Builder source:
   ```
   BUILDER="https://downloads.openwrt.org/snapshots/targets/x86/64/openwrt-imagebuilder-x86-64.Linux-x86_64.tar.xz"
   ```

2. Set the desired new partition sizes in megabytes:
   ```
   KERNEL_PARTSIZE=64
   ROOTFS_PARTSIZE=4096
   ```

3. List all the packages you wish to add to the new image. (This is just an example):
   ```
   CUSTOM_PACKAGES="blockd block-mount curl dnsmasq dnsmasq-full kmod-fs-ext4 kmod-usb2 kmod-usb3 kmod-usb-storage kmod-usb-core \
   usbutils nano socat tcpdump luci luci-app-ddns luci-app-mwan3 mwan3 luci-app-openvpn openvpn-openssl luci-app-samba4 open-vm-tools"
   ```

4. Add an image filename tag to better identify the new image:
   ```
   IMAGE_TAG="BigSquash"
   ```

5. Optionally inject images with additional pre-configured settings by adding config files here when prompted:
   ```
   INJECT_FILES="$(pwd)/owrt_inject_files"
   ```

## Important Note

- Please note that each run of the script clears all previous build files, retaining only the source tarball to start over. If you wish to change versions, remember to manually delete the source tar.xz file. 
- **DO NOT USE THIS SCRIPT FOR ROUTER FLASH MEMORY IMAGES, x86 ONLY!**

## Further Hybrid File System Expansion

It is also possible to combine SquashFS with a third EXT4 data partition (manually created after installation). This new EXT4 PART-UUID then be injected into a second updated Image Builder config, with a sysupgrade to this second image combining all into an immutable config that can survive a factory reset! (Future sysupgrades and resets will leave the new EXT4 data partition intact.)
