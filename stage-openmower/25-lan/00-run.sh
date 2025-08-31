#!/bin/bash -e

# Host-side installer: copy config files into the rootfs

STAGE_DIR="$(dirname "$0")"

# Install files
install -m 0600 -D "$STAGE_DIR/files/etc/NetworkManager/system-connections/Wired connection 1.nmconnection" "$ROOTFS_DIR/etc/NetworkManager/system-connections/Wired connection 1.nmconnection"
install -m 0664 -D "$STAGE_DIR/files/etc/dnsmasq.d/10-openmower.conf" "$ROOTFS_DIR/etc/dnsmasq.d/10-openmower.conf"
