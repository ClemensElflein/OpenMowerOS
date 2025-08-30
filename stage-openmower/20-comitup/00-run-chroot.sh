#!/bin/bash -e

export DEBIAN_FRONTEND=noninteractive
apt-get update
apt-get install -y --no-install-recommends comitup network-manager wpasupplicant rfkill

systemctl enable comitup.service || true
systemctl enable comitup-web.service || true
systemctl enable comitup-nm-wifi-ensure.service || true

if ! grep -q '^ap_name:' /etc/comitup.conf 2>/dev/null; then
    printf '\n# Default OpenMower AP name for provisioning\nap_name: OpenMower-<nnn>\n' >> /etc/comitup.conf
fi
