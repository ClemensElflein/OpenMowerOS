#!/bin/bash
set -euo pipefail

# Defaults (service-level)
if [ -r /etc/default/openmower ]; then
    . /etc/default/openmower
fi

# Check if OM_VERSION is still the placeholder from /etc/default/openmower
if [ "${OM_VERSION}" = "choose-your-version" ]; then
    MSG="OM_VERSION is still set to 'choose-your-version'.\nPlease edit /etc/default/openmower and set OM_VERSION to one of the documented values, then try again."
    # Print to stdout (captured by systemd journal) and also log explicitly
    echo -e "$MSG"
    exit 77
fi

OM_IMAGE=${OM_IMAGE:-${OM_REPO}:${OM_VERSION}}

echo "Pulling $OM_IMAGE ..."
exec /usr/bin/docker pull "$OM_IMAGE"