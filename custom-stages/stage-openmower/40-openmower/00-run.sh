#!/bin/bash -e

# Host-side installer for 40-openmower; copies real files and enables service.

STAGE_DIR="$(dirname "$0")"

# Install files
install -m 0755 -D "$STAGE_DIR/files/usr/local/sbin/openmower-run.sh" \
  "$ROOTFS_DIR/usr/local/sbin/openmower-run.sh"
install -m 0644 -D "$STAGE_DIR/files/etc/systemd/system/openmower.service" \
  "$ROOTFS_DIR/etc/systemd/system/openmower.service"

# Seed external config if absent and ensure ownership
if on_chroot id -u openmower >/dev/null 2>&1; then
  install -d -o 1000 -g 1000 "$ROOTFS_DIR/home/openmower"
  if [ ! -f "$ROOTFS_DIR/home/openmower/mower_config.sh" ]; then
    cat > "$ROOTFS_DIR/home/openmower/mower_config.sh" <<'CFG'
# OpenMower external config
# Use true/false or 1/0
OM_DEBUG=false
# Auto-pull image on start
OM_AUTOPULL=true
# Optional override of image (defaults to ghcr.io/clemenselflein/open_mower_ros:releases-${OM_VERSION})
# OM_IMAGE=
CFG
    chown 1000:1000 "$ROOTFS_DIR/home/openmower/mower_config.sh"
    chmod 0644 "$ROOTFS_DIR/home/openmower/mower_config.sh"
  fi
fi

# Enable the service in target
on_chroot << 'EOF'
systemctl enable openmower.service || true
EOF
