#!/bin/bash
set -euo pipefail

# Service wrapper (not user-facing): prepares env and runs the container attached

# libbash (colors). Ensure TERM is set under systemd and prefer colorPrintN.
if [ -f /usr/lib/bash/colors.sh ]; then
    source /usr/lib/bash/colors.sh || true
fi

# Defaults (service-level)
if [ -r /etc/default/openmower ]; then
    . /etc/default/openmower
fi

OM_DEBUG=${OM_DEBUG:-true}
OM_AUTOPULL=${OM_AUTOPULL:-true}

# Avoid "tput: No value for $TERM" when running under systemd
if [ -z "${TERM:-}" ]; then
    export TERM=ansi
fi

# If OM_VERSION is still the placeholder from /etc/default/openmower, quit early with a clear message
if [ "${OM_VERSION:-}" = "choose-your-version" ]; then
    MSG1="OM_VERSION is still set to 'choose-your-version'."
    MSG2="Please edit /etc/default/openmower and set OM_VERSION to one of the documented values, then restart the service via (sudo systemctl restart openmower)."
    # Print to stdout (captured by systemd journal) and also log explicitly
    #colorPrintN Red "$MSG1"
    #colorPrintN Yellow "$MSG2"
    /usr/bin/logger -p user.err -t openmower-service "$MSG1" || true
    /usr/bin/logger -p user.notice -t openmower-service "$MSG2" || true
    # Exit with special code so systemd won't restart the unit in a loop
    exit 77
fi

OM_IMAGE=${OM_IMAGE:-${OM_REPO}:${OM_VERSION}}

# Check if OM_IMAGE is already available locally
if ! /usr/bin/docker image inspect "$OM_IMAGE" >/dev/null 2>&1; then
    MSG="'OM_IMAGE' is not yet available locally. Please pull the image by running `openmower-pull.sh`, then restart the service via `sudo systemctl restart openmower`."
    echo -e "$MSG"
    /usr/bin/logger -t openmower-service "$MSG" || true
    exit 77
fi

# Ensure no stale container
if /usr/bin/docker ps -a --format '{{.Names}}' | grep -q '^openmower$'; then
    /usr/bin/docker rm -f openmower >/dev/null 2>&1 || true
fi

# Build run args
RUN_ARGS=(
    --name openmower
    --detach=false
    --tty
    --privileged
    --network=host
    --volume /dev:/dev
    --volume /home/openmower/mower_config.sh:/config/mower_config.sh:ro
    --volume /home/openmower/ros_home:/root
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
