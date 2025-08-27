#!/bin/bash -e

# Host-side installer: copy config files into the rootfs

STAGE_DIR="$(dirname "$0")"

# Install all staged files preserving permissions
rsync -aH "$STAGE_DIR/files/" "$ROOTFS_DIR/"

# Ensure directories exist (rsync handles this, but be explicit for safety)
install -d "$ROOTFS_DIR/etc/NetworkManager/conf.d" || true
install -d "$ROOTFS_DIR/var/lib/NetworkManager" || true
