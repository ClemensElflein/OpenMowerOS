#!/bin/bash -e

# Host-side installer: copy config files into the rootfs

STAGE_DIR="$(dirname "$0")"

# Install files
install -m 0755 -D "$STAGE_DIR/files/usr/lib/raspberrypi-sys-mods/imager_custom" "$ROOTFS_DIR/usr/lib/raspberrypi-sys-mods/imager_custom"
install -m 0755 -D "$STAGE_DIR/files/usr/lib/userconf-pi/userconf" "$ROOTFS_DIR/usr/lib/userconf-pi/userconf"
install -m 0755 -D "$STAGE_DIR/files/boot/firmware/config.addendum" "$ROOTFS_DIR/boot/firmware/config.addendum"
