#!/bin/bash -e

STAGE_DIR="$(dirname "$0")"

# Install the webterminal stack
TARGET="$ROOTFS_DIR/opt/stacks/webterminal"
echo "→ Installing webterminal stack to $TARGET"
install -d -m 0755 "$TARGET"
cp -a "$STAGE_DIR/files/opt/stacks/webterminal/." "$TARGET/"
echo "✓ Webterminal stack installed"

install -m 0644 -D "$STAGE_DIR/files/etc/systemd/system/webterminal.service" "$ROOTFS_DIR/etc/systemd/system/webterminal.service"
install -m 0644 -D "$STAGE_DIR/files/usr/local/sbin/webterminal-shell-wrapper.sh" "$ROOTFS_DIR/usr/local/sbin/webterminal-shell-wrapper.sh"
