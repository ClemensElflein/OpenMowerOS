#!/bin/bash
set -euo pipefail

CFG=/home/openmower/mower_config.sh
VER=/boot/openmower/openmower_version.txt

# Defaults
OM_VERSION=${OM_VERSION:-latest}
OM_IMAGE=${OM_IMAGE:-}

# Load config and version if present
[ -r "$CFG" ] && . "$CFG" || true
[ -r "$VER" ] && . "$VER" || true

OM_VERSION=${OM_VERSION:-latest}
OM_IMAGE=${OM_IMAGE:-ghcr.io/clemenselflein/open_mower_ros:releases-${OM_VERSION}}

echo "Pulling $OM_IMAGE ..."
exec /usr/bin/docker pull "$OM_IMAGE"