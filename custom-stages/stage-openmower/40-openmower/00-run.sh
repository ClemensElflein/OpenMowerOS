#!/bin/bash -e

# Host-side installer for 40-openmower; copies files into rootfs and enables service.

STAGE_DIR="$(dirname "$0")"

# Install files
install -m 0664 -D "$STAGE_DIR/files/etc/systemd/system/openmower.service" "$ROOTFS_DIR/etc/systemd/system/openmower.service"
install -m 0775 -D "$STAGE_DIR/files/usr/local/sbin/openmower-service.sh" "$ROOTFS_DIR/usr/local/sbin/openmower-service.sh"
install -m 0775 -D "$STAGE_DIR/files/usr/local/bin/openmower-pull.sh" "$ROOTFS_DIR/usr/local/bin/openmower-pull.sh"
install -m 0664 -D "$STAGE_DIR/files/etc/default/openmower" "$ROOTFS_DIR/etc/default/openmower"
install -m 0664 -D "$STAGE_DIR/home/openmower/mower_params.yaml" "$ROOTFS_DIR/home/openmower/mower_params.yaml"

# Seed external config if absent and ensure ownership
if on_chroot id -u openmower >/dev/null 2>&1; then
    install -d "$ROOTFS_DIR/home/openmower" "$ROOTFS_DIR/boot/openmower"
    
    # Fetch latest upstream example into user home as mower_config.sh
    on_chroot bash -c "wget -O /home/openmower/mower_config.sh https://raw.githubusercontent.com/ClemensElflein/open_mower_ros/main/src/open_mower/config/mower_config.sh.example || true"
    
    # Ensure ownership
    on_chroot chown openmower:openmower "/etc/default/openmower"
    on_chroot chown -R openmower:openmower "/home/openmower"
    
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
