#!/bin/bash -e

# Install Docker-based OpenMower service using a wrapper that sources external config

install -d /usr/local/sbin /etc/systemd/system /home/openmower

cat > /usr/local/sbin/openmower-run.sh <<'EOF'
#!/bin/bash
set -euo pipefail

# Defaults
OM_DEBUG=${OM_DEBUG:-false}
OM_AUTOPULL=${OM_AUTOPULL:-true}

# Source external config if present (allows: export OM_DEBUG=true)
CFG=/home/openmower/mower_config.sh
if [ -r "$CFG" ]; then
  # shellcheck disable=SC1090
  . "$CFG"
fi

# Source version file if present (sets OM_VERSION=...)
VER=/boot/openmower/openmower_version.txt
if [ -r "$VER" ]; then
  # shellcheck disable=SC1091
  . "$VER"
fi

# Determine image
OM_VERSION=${OM_VERSION:-latest}
OM_IMAGE=${OM_IMAGE:-ghcr.io/clemenselflein/open_mower_ros:releases-${OM_VERSION}}

# Pull latest if enabled
if [ "${OM_AUTOPULL,,}" = "true" ] || [ "${OM_AUTOPULL}" = "1" ]; then
  /usr/bin/docker pull "$OM_IMAGE" || true
fi

# Ensure no stale container
/usr/bin/docker rm -f openmower >/dev/null 2>&1 || true

# Build run args
RUN_ARGS=(
  --name openmower
  --detach=false
  --tty
  --privileged
  --network=host
  --volume /dev:/dev
  --volume /home/openmower/mower_config.sh:/config/mower_config.sh:ro
)

# Optional ROS logging config if present
if [ -f /root/rosconsole.config ]; then
  RUN_ARGS+=(--volume /root/rosconsole.config:/config/rosconsole.config)
  RUN_ARGS+=(--env ROSCONSOLE_CONFIG_FILE=/config/rosconsole.config)
else
  RUN_ARGS+=(--env ROSOUT_DISABLE_FILE_LOGGING=True)
fi

# Optional home mapping (legacy behavior)
if [ -d /root/ros_home ]; then
  RUN_ARGS+=(--volume /root/ros_home:/root)
fi

# Propagate debug to container env as well
if [ "${OM_DEBUG,,}" = "true" ] || [ "${OM_DEBUG}" = "1" ]; then
  RUN_ARGS+=(--env OM_DEBUG=1)
else
  RUN_ARGS+=(--env OM_DEBUG=0)
fi

# Create and start attached so systemd tracks the container
/usr/bin/docker create "${RUN_ARGS[@]}" "$OM_IMAGE" >/dev/null
exec /usr/bin/docker start -a openmower
EOF

chmod 0755 /usr/local/sbin/openmower-run.sh

cat > /etc/systemd/system/openmower.service <<'EOF'
[Unit]
Description=OpenMower (Docker)
Wants=network-online.target
After=docker.service network-online.target NetworkManager.service

[Service]
Type=simple
Restart=always
RestartSec=15s
TimeoutStartSec=1h
TimeoutStopSec=120s
ExecStart=/usr/local/sbin/openmower-run.sh
ExecStop=/usr/bin/docker stop -t 10 openmower
ExecStopPost=/usr/bin/docker rm -f openmower

[Install]
WantedBy=multi-user.target
EOF

# Ensure owner of config dir and file exists, seed a default config if absent
if id -u openmower >/dev/null 2>&1; then
  install -d -o openmower -g openmower /home/openmower
  if [ ! -f /home/openmower/mower_config.sh ]; then
    cat > /home/openmower/mower_config.sh <<'CFG'
# OpenMower external config
# Use true/false or 1/0
OM_DEBUG=false
# Auto-pull image on start
OM_AUTOPULL=true
# Optional override of image (defaults to ghcr.io/clemenselflein/open_mower_ros:releases-${OM_VERSION})
# OM_IMAGE=
CFG
    chown openmower:openmower /home/openmower/mower_config.sh
    chmod 0644 /home/openmower/mower_config.sh
  fi
fi

# Enable service
systemctl enable openmower.service || true
