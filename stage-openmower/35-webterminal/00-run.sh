#!/bin/bash -e

STAGE_DIR="$(dirname "$0")"

# Install the webterminal stack
TARGET="$ROOTFS_DIR/opt/stacks/webterminal"
echo "→ Installing webterminal stack to $TARGET"
install -d -m 0755 "$TARGET"
cp -a "$STAGE_DIR/files/opt/stacks/webterminal/." "$TARGET/"

# Ownership so Dockge/openmower user can manage stack (Dockge runs as root in container but host mapping may allow edits)
chown -R openmower:openmower "$ROOTFS_DIR/opt/stacks/webterminal"
chmod -R u=rwX,g=rwX,o=rX "$ROOTFS_DIR/opt/stacks/webterminal"

echo "✓ Webterminal stack installed"
