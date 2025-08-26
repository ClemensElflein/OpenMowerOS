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

# Explicitly tell NetworkManager to use wpa_supplicant backend for Wi‑Fi and manage all devices
install -d /etc/NetworkManager/conf.d
cat > /etc/NetworkManager/conf.d/wifi-backend.conf <<'EOF'
[device]
wifi.backend=wpa_supplicant
EOF
cat > /etc/NetworkManager/conf.d/10-managed.conf <<'EOF'
[keyfile]
unmanaged-devices=none
EOF

# Prefer NetworkManager's internal DHCP client for reliability
cat > /etc/NetworkManager/conf.d/20-dhcp-internal.conf <<'EOF'
[main]
dhcp=internal
EOF

# Ensure Wi‑Fi is enabled in NM state on first boot (in case a default disables it)
install -d /var/lib/NetworkManager
cat > /var/lib/NetworkManager/NetworkManager.state <<'EOF'
[main]
WirelessEnabled=true
EOF

systemctl enable comitup.service || true
systemctl enable comitup-web.service || true

if ! grep -q '^ap_name:' /etc/comitup.conf 2>/dev/null; then
    printf '\n# Default OpenMower AP name for provisioning\nap_name: OpenMower-<nnn>\n' >> /etc/comitup.conf
fi

# Ensure Wi‑Fi is enabled and device is managed before Comitup tries to create hotspot
cat > /etc/systemd/system/openmower-nm-wifi-ensure.service <<'EOF'
[Unit]
Description=Ensure Wi‑Fi radio enabled and managed before Comitup
Wants=NetworkManager.service
After=NetworkManager.service
Before=comitup.service

[Service]
Type=oneshot
RemainAfterExit=yes
ExecStartPre=/usr/sbin/rfkill unblock wifi
ExecStart=/usr/bin/nmcli radio wifi on
ExecStartPost=/bin/sh -c 'nmcli -t -f DEVICE,TYPE dev status | grep -q "^wlan0:wifi" && nmcli dev set wlan0 managed yes || true'

[Install]
WantedBy=multi-user.target
EOF
systemctl enable openmower-nm-wifi-ensure.service || true
