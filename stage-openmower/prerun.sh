#!/bin/bash -e

# Ensure we have a previous rootfs to extend
if [ -z "$PREV_ROOTFS_DIR" ] || [ ! -d "$PREV_ROOTFS_DIR" ]; then
    echo "No previous stage rootfs found" >&2
    exit 1
fi

ROOTFS_DIR="$STAGE_WORK_DIR/rootfs"
mkdir -p "$ROOTFS_DIR"
rsync -aHAXx --delete --numeric-ids --exclude var/cache/apt/archives "$PREV_ROOTFS_DIR/" "$ROOTFS_DIR/"
