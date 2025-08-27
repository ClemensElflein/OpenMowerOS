#!/bin/bash
set -euo pipefail

# Service wrapper (not user-facing): prepares env and runs the container attached

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

# Optional home mapping (moved to user home)
if [ -d /home/openmower/ros_home ]; then
  RUN_ARGS+=(--volume /home/openmower/ros_home:/root)
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
