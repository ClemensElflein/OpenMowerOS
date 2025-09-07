# OpenMowerOS v2.0 — What’s new (2025-09-07)

This document highlights the most relevant changes compared to previous OpenMowerOS images.

## ✨ What changed for you

- ⚙️ A couple of settings, like WLAN SSID and password, can be set during Raspberry Pi Imager configuration.
- ✍️ No need to edit files like `/boot/openmower/openmower_version.txt` before the first boot.
- 🚀 No delay for the initial image pull on first boot (except a 1–2 minute Dockge pull).
- 🖥️ [Dockge](https://dockge.kuma.pet/) GUI for container management.
- 🧰 A generic `openmower` script for essential tasks: pull/start/stop, status, logs, …
- 👤 Containers run with openmower permissions. No sudo required for openmower‑related edits, start, stop, …
- 🗂️ All relevant configs, maps, and logs live in `/home/openmower`.

## 🛠️ Under the hood (for the curious)

- 🐧 Debian Trixie (arm64) images built with [pi‑gen](https://github.com/RPi-Distro/pi-gen).
- 📁 OpenMower scripts moved to `/usr/local/[s]bin`.
- 📶 WLAN is managed by NetworkManager.
- 🔌 LAN is managed by ifupdown.
- 📡 DHCP for the internal (xCore) LAN is handled by dnsmasq.
- 🧠 dnsmasq is also used for DNS caching and is managed by the resolvconf package.
- 🔗 LAN can now be plugged into the home network.

---
If you spot issues or have suggestions, please open an issue or PR. 🙏
