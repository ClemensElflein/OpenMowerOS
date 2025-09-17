#!/bin/bash -e

# Host-side installer: copy config files into the rootfs

STAGE_DIR="$(dirname "$0")"

# Install files
install -m 0644 -D "$STAGE_DIR/files/etc/NetworkManager/conf.d/10-comitup.conf" "$ROOTFS_DIR/etc/NetworkManager/conf.d/10-comitup.conf"
install -m 0644 -D "$STAGE_DIR/files/etc/systemd/system/comitup-nm-wifi-ensure.service" "$ROOTFS_DIR/etc/systemd/system/comitup-nm-wifi-ensure.service"
