#!/bin/bash -e

export DEBIAN_FRONTEND=noninteractive

systemctl mask systemd-networkd-wait-online.service || true

cat >> "/etc/dhcpcd.conf" <<'EOF'

#
# OpenMower specific
#

# dhcpcd is only used for eth0 (ifupdown),
# NM is using it's own internal dhcp-client for wlan0
interface eth0

# Don't touch resolv.conf...
# (matches full name, or prefixed with 2 numbers optionally ending with .sh)
nohook resolv.conf

# ... instead of sending DNS-Informationen an resolvconf
option domain_name_servers domain_name domain_search
EOF

ln -sf /var/run/resolvconf/resolv.conf /etc/resolv.conf
