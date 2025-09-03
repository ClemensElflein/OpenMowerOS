#!/bin/bash -e

STAGE_DIR="$(dirname "$0")"

install -m 0644 -D "$STAGE_DIR/files/etc/systemd/system/dockge.service" "$ROOTFS_DIR/etc/systemd/system/dockge.service"
