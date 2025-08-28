#!/bin/bash
set -euo pipefail

# libbash
if [ -f /usr/lib/bash/colors.sh ]; then
    source /usr/lib/bash/colors.sh
fi

# Defaults (service-level)
if [ -r /etc/default/openmower ]; then
    source /etc/default/openmower
fi

# Check if OM_VERSION is still the placeholder from /etc/default/openmower
if [ "${OM_VERSION}" = "choose-your-version" ]; then
    colorPrintN Red "OM_VERSION is still set to 'choose-your-version'."
    colorPrintN Yellow "Please edit /etc/default/openmower and set OM_VERSION to one of the documented values, then try again."
    exit 77
fi

OM_IMAGE=${OM_IMAGE:-${OM_REPO}:${OM_VERSION}}

echo "Pulling $OM_IMAGE ..."
exec /usr/bin/docker pull "$OM_IMAGE"
