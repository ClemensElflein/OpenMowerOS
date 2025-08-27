#!/bin/bash -e

# Host-side installer for 40-openmower; copies files into rootfs and enables service.

STAGE_DIR="$(dirname "$0")"

# Install files
install -m 0755 -D "$STAGE_DIR/files/usr/local/sbin/openmower-service.sh" \
"$ROOTFS_DIR/usr/local/sbin/openmower-service.sh"
install -m 0644 -D "$STAGE_DIR/files/etc/systemd/system/openmower.service" \
"$ROOTFS_DIR/etc/systemd/system/openmower.service"
install -m 0755 -D "$STAGE_DIR/files/usr/local/bin/openmower-pull.sh" \
"$ROOTFS_DIR/usr/local/bin/openmower-pull.sh"

# Seed external config if absent and ensure ownership
if on_chroot id -u openmower >/dev/null 2>&1; then
    install -d "$ROOTFS_DIR/home/openmower"
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
        on_chroot chown openmower:openmower "/home/openmower/mower_config.sh"
        chmod 0644 "$ROOTFS_DIR/home/openmower/mower_config.sh"
    fi
    # Ensure ros_home exists under user home with ownership
    install -d "$ROOTFS_DIR/home/openmower/ros_home"
    on_chroot chown -R openmower:openmower "/home/openmower/ros_home"
    # Make sure user is in docker group for user-run service
    on_chroot usermod -aG docker openmower || true
fi

# Enable the service in target
on_chroot <<'EOF'
systemctl enable openmower.service || true
EOF
