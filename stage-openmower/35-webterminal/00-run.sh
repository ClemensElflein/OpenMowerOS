#!/bin/bash -e

STAGE_DIR="$(dirname "$0")"

# Install the webterminal stack
TARGET="$ROOTFS_DIR/opt/stacks/webterminal"
echo "→ Installing webterminal stack to $TARGET"
install -d -m 0755 "$TARGET"
cp -a "$STAGE_DIR/files/opt/stacks/webterminal/." "$TARGET/"

echo "✓ Webterminal stack installed"
