#!/bin/bash -e

STAGE_DIR="$(dirname "$0")"

install -m 0644 -D "$STAGE_DIR/files/etc/systemd/system/dockge.service" "$ROOTFS_DIR/etc/systemd/system/dockge.service"

# Pre-seeded Dockge database with default user and password
echo "→ Seeding Dockge data directory"
install -d -m 0755 "$ROOTFS_DIR/opt/dockge/data"
cp -a "$STAGE_DIR/files/opt/dockge/data/." "$ROOTFS_DIR/opt/dockge/data/"
# Ensure correct permissions (root inside container)
chown -R root:root "$ROOTFS_DIR/opt/dockge/data"
chmod -R u=rwX,g=rX,o= "$ROOTFS_DIR/opt/dockge/data"
echo "✓ Dockge DB seeded"
