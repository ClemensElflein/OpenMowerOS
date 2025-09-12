#!/bin/bash -e

# Set ownership for webterminal stack
echo "[webterminal] Setting ownership to openmower:openmower"
chown -R openmower:openmower /opt/stacks/webterminal
chmod -R u=rwX,g=rwX,o=rX /opt/stacks/webterminal
