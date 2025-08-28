# OpenMowerOS v2.0 — What’s new (2025-08-28)

This document highlights the most relevant changes compared to previous OpenMowerOS images.

## What changed for you

- A couple of settings like WLAN SSID and password can be set during Raspberry Pi Imager configuration.
- No edit of files like `/boot/openmower/openmower_version.txt` before first boot.
- No delaying initial image pull on first boot.
- `OM_VERSION` has moved to `/etc/default/openmower` and needs to be set by you via mcedit, nano or the like (once it's reachable via SSH). I.e. `mcedit /etc/default/openmower`
- Only one `openmower.service` (**no** `openmower-debug.service` anymore). Debugging output can be chosen now via `OM_DEBUG` in `/etc/default/openmower`.
Also, it's "ON" by default now, so that newbies may recognize failures quicker.
- Straightforward image updates: if the Docker image is missing or outdated, run `openmower-pull.sh` and afterwards `sudo systemctl restart openmower`.
- TODO: All misc openmower scripts get placed now into PATH (/usr/local/bin)
- TODO: Common `openmower.sh` script for which will list/wrap all sub-scripts like docker shell, ...
- V1 mower_config has moved to `/home/openmower/mower_config.sh`.
- V2 mower config is in `/home/openmower/mower_params.yaml`

## Under the hood (for the curious)

- Debian Trixie (arm64) images built with [pi‑gen](https://github.com/RPi-Distro/pi-gen).
- OpenMower scripts moved to `/usr/local/[s]bin`

---
If you spot issues or have suggestions, please open an issue or PR.
