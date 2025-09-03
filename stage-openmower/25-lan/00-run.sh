#!/bin/bash -e

# Host-side installer: copy config files into the rootfs

STAGE_DIR="$(dirname "$0")"

# Install files
install -m 0644 -D "$STAGE_DIR/files/etc/NetworkManager/conf.d/20-lan.conf" "$ROOTFS_DIR/etc/NetworkManager/conf.d/20-lan.conf"
install -m 0644 -D "$STAGE_DIR/files/etc/network/interfaces" "$ROOTFS_DIR/etc/network/interfaces"
install -m 0664 -D "$STAGE_DIR/files/etc/dnsmasq.d/10-openmower.conf" "$ROOTFS_DIR/etc/dnsmasq.d/10-openmower.conf"

# Somehow hacky, but better then adding a one time fixup service that revert it again
if [ -d /ext/pi-gen/export-image/03-network ]; then
    echo "[25-lan] Disabling export-image/03-network resolv.conf injection"
    rm -f /ext/pi-gen/export-image/03-network/01-run.sh || true
fi
