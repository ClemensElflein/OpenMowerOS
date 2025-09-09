#!/bin/bash -e

export DEBIAN_FRONTEND=noninteractive
apt-get update
apt-get install -y --no-install-recommends comitup network-manager wpasupplicant rfkill

systemctl enable comitup.service
systemctl enable comitup-web.service
systemctl enable comitup-nm-wifi-ensure.service

systemctl mask NetworkManager-wait-online.service

if ! grep -q '^ap_name:' /etc/comitup.conf 2>/dev/null; then
    printf '\n# Default OpenMower AP name for provisioning\nap_name: OpenMower-<nnn>\n' >> /etc/comitup.conf
fi
