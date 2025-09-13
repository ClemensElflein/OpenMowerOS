#!/bin/bash -e

# Set ownership for webterminal stack
chown -R openmower:openmower /opt/stacks/webterminal
chmod -R u=rwX,g=rwX,o=rX /opt/stacks/webterminal
chmod +x /usr/local/sbin/webterminal-shell-wrapper.sh
