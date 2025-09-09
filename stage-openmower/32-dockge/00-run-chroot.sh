#!/bin/bash -e

export DEBIAN_FRONTEND=noninteractive
apt-get update

mkdir -p /opt/stacks /opt/dockge
cd /opt/dockge

# Download the dockge compose.yaml
curl -fsSL https://raw.githubusercontent.com/louislam/dockge/master/compose.yaml --output compose.yaml

# Enable console inside Dockge container
if ! grep -q 'DOCKGE_ENABLE_CONSOLE' compose.yaml; then
    sed -i '/DOCKGE_STACKS_DIR=\/opt\/stacks/a\      - DOCKGE_ENABLE_CONSOLE=true' compose.yaml
fi

# Ensure stacks directory is usable from Dockge and by the openmower user
chown -R openmower:openmower /opt/stacks
chmod -R u=rwX,g=rwX,o=rX /opt/stacks

# Enable services installed by 00-run.sh
systemctl enable dockge.service
