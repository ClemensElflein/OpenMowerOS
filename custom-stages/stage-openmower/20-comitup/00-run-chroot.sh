#!/bin/bash -e

export DEBIAN_FRONTEND=noninteractive
apt-get update
apt-get install -y --no-install-recommends comitup network-manager wpasupplicant rfkill

# Enable NetworkManager and mask services that conflict with it
systemctl enable NetworkManager.service
for svc in dhcpd.service dhcpcd.service raspberrypi-net-mods.service; do
    if systemctl list-unit-files | grep -q "^$svc"; then
        systemctl mask "$svc" || true
    fi
done

# Ensure Wi‑Fi isn't blocked at boot
rfkill unblock all || true

# Config files are now provided via files/ and installed by 00-run.sh

systemctl enable comitup.service || true
systemctl enable comitup-web.service || true

if ! grep -q '^ap_name:' /etc/comitup.conf 2>/dev/null; then
    printf '\n# Default OpenMower AP name for provisioning\nap_name: OpenMower-<nnn>\n' >> /etc/comitup.conf
fi

# Unit file provided via files/; just enable it now
systemctl enable openmower-nm-wifi-ensure.service || true
