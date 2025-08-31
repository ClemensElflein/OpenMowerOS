#!/bin/bash -e

# Host-side installer for 40-openmower; copies files into rootfs and enables service.

STAGE_DIR="$(dirname "$0")"

# Install files
install -m 0664 -D "$STAGE_DIR/files/etc/systemd/system/openmower.service" "$ROOTFS_DIR/etc/systemd/system/openmower.service"
install -m 0664 -o root -g openmower -D "$STAGE_DIR/files/etc/default/openmower" "$ROOTFS_DIR/etc/default/openmower"
install -m 0775 -D "$STAGE_DIR/files/usr/local/sbin/openmower-service.sh" "$ROOTFS_DIR/usr/local/sbin/openmower-service.sh"
install -m 0775 -D "$STAGE_DIR/files/usr/local/bin/openmower" "$ROOTFS_DIR/usr/local/bin/openmower"
install -m 0664 -o openmower -g openmower -D "$STAGE_DIR/files/home/openmower/mower_params.yaml" "$ROOTFS_DIR/home/openmower/mower_params.yaml"
install -m 0664 -o openmower -g openmower -D "$STAGE_DIR/files/home/openmower/ros_home" "$ROOTFS_DIR/home/openmower/ros_home"