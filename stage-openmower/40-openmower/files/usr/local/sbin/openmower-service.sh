#!/bin/bash
set -euo pipefail

# Service wrapper (not user-facing): prepares env and runs the container attached

# OM Defaults (OM_VERSION, OM_REPO, ...)
if [ ! -r /etc/default/openmower ]; then
    /usr/bin/logger -p user.err -t openmower-service "Missing /etc/default/openmower defaults!"
    exit 2
fi
source /etc/default/openmower


OM_DEBUG="${OM_DEBUG:-true}"
OM_CONTAINER="${OM_CONTAINER:-openmower}"

# If OM_VERSION is not set or is still the placeholder from /etc/default/openmower, quit early with a clear message
if [ -z "${OM_VERSION}" ] || [ "${OM_VERSION}" = "choose-your-version" ]; then
    /usr/bin/logger -p user.err -t openmower-service "OM_VERSION is still set to 'choose-your-version'." || true
    /usr/bin/logger -p user.notice -t openmower-service "Please edit /etc/default/openmower and set OM_VERSION to one of the documented values, then restart the service via (sudo systemctl restart openmower)." || true
    # Exit with special code so systemd won't restart the unit in a loop
    exit 77
fi

OM_IMAGE=${OM_IMAGE:-${OM_REPO}:${OM_VERSION}}

# Preflight: required bind-mounts
CONFIG_SRC="/home/openmower/mower_config.sh"
if [ ! -r "$CONFIG_SRC" ]; then
    /usr/bin/logger -p user.err -t openmower-service "Missing required config file: $CONFIG_SRC"
    /usr/bin/logger -p user.notice -t openmower-service "Create it (e.g., copy from a template) and retry: openmower restart"
    exit 77
fi

# ROS home
ROS_HOME_DIR="/home/openmower/ros_home"
mkdir -p "$ROS_HOME_DIR" 2>/dev/null || true

# Check if OM_IMAGE is already available locally
if ! /usr/bin/docker image inspect "$OM_IMAGE" >/dev/null 2>&1; then
    /usr/bin/logger -t openmower-service "'OM_IMAGE' is not yet available locally. Please pull the image by running `openmower-pull.sh`, then restart the service via `sudo systemctl restart openmower`." || true
    exit 77
fi

# Ensure no stale container
if /usr/bin/docker ps -a --format '{{.Names}}' | grep -q '^openmower$'; then
    /usr/bin/docker rm -f openmower >/dev/null 2>&1 || true
fi

# Build run args
RUN_ARGS=(
    --name openmower
    --tty
    --privileged
    --network=host
    --volume /dev:/dev
    --volume "$CONFIG_SRC":/config/mower_config.sh:ro
    --volume "$ROS_HOME_DIR":/root
)

# Optional ROS logging config if present
if [ -f /root/rosconsole.config ]; then
    RUN_ARGS+=(--volume /root/rosconsole.config:/config/rosconsole.config)
    RUN_ARGS+=(--env ROSCONSOLE_CONFIG_FILE=/config/rosconsole.config)
else
    RUN_ARGS+=(--env ROSOUT_DISABLE_FILE_LOGGING=True)
fi

# Create and start attached so systemd tracks the container
/usr/bin/docker create "${RUN_ARGS[@]}" "$OM_IMAGE" >/dev/null
exec /usr/bin/docker start -a openmower
