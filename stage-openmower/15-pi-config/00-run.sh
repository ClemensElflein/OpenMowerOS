#!/bin/bash -e

# Host-side installer: copy config files into the rootfs

STAGE_DIR="$(dirname "$0")"

# Install files
install -m 0755 -D "$STAGE_DIR/files/usr/lib/raspberrypi-sys-mods/imager_custom" "$ROOTFS_DIR/usr/lib/raspberrypi-sys-mods/imager_custom"
