#!/bin/bash -e

# Set ownership & permissions for webterminal stack
chown -R openmower:openmower /opt/stacks/webterminal
chmod -R u=rwX,g=rwX,o=rX /opt/stacks/webterminal

chmod +x /usr/local/sbin/webterminal-shell-wrapper.sh

# Enable systemd unit for automatic start
systemctl enable webterminal.service >/dev/null 2>&1 || echo "[webterminal] WARN: could not enable webterminal.service" >&2
