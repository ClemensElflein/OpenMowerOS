#!/bin/bash -e

# Host-side installer for 40-openmower; copies files into rootfs and enables service.

STAGE_DIR="$(dirname "$0")"

# Install files
install -m 0664 -D "$STAGE_DIR/files/home/openmower/mower_params.yaml" "$ROOTFS_DIR/home/openmower/ros_home/mower_params.yaml"
install -m 0755 -d "$ROOTFS_DIR/opt/stacks/openmower"
install -m 0664 -D "$STAGE_DIR/files/opt/stacks/openmower/compose.yaml" "$ROOTFS_DIR/opt/stacks/openmower/compose.yaml"
install -m 0644 -D "$STAGE_DIR/files/opt/stacks/openmower/.env" "$ROOTFS_DIR/opt/stacks/openmower/.env"
install -m 0644 -D "$STAGE_DIR/files/opt/stacks/openmower/mosquitto.conf" "$ROOTFS_DIR/opt/stacks/openmower/mosquitto.conf"
