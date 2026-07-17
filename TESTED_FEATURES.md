# OpenMowerOS v2 – Tested Features Matrix

Legend: ✅ Pass · ❌ Fail · 🟡 Todo · 🔁 Retry · 🧪 Manual-only

| Feature                                  | Expected                                      | HW‑V1<br>Pi4 | HW‑V2<br>CM4 | HW‑V2<br>CM5 |
| ---------------------------------------- | --------------------------------------------- | :----------: | :----------: | :----------: |
| Auto-reboot after initial boot           | yes                                           |      ✅       |      ✅       |      ✅       |
| Debian release `lsb_release -a`          | Debian GNU/Linux 13 (trixie)                  |      ✅       |      ✅       |      ✅       |
| OpenMowerOS release `cat /etc/rpi-issue` | OpenMowerOS v2.x YYYY-MM-DD                   |      ✅       |      ✅       |      ✅       |
| Hostname (default) `hostname`            | openmower                                     |      ✅       |      ✅       |      ✅       |
| Hostname (non-default) `hostname`        | <as set by Raspberry Pi Imager v1.9.x>        |      ✅       |      ✅       |      ✅       |
| Default user/password                    | openmower/openmower                           |      ✅       |      ✅       |      ✅       |
| SSH enabled                              | SSH active on first boot                      |      ✅       |      ✅       |      ✅       |
| SSH public key                           | Password less SSH login via SSH-key           |      ✅       |      ✅       |      ✅       |
| Imager Wi‑Fi                             | Preseeded Wi‑Fi connects on first boot        |      ✅       |      ✅       |      ✅       |
| Imager openmower pass                    | Applied when configured                       |      ✅       |      ✅       |      ✅       |
| No known Wi‑Fi                           | Comitup AP appears (default SSID pattern)     |      ✅       |      ✅       |      ✅       |
| Comitup captive portal                   | Able to configure Wi‑Fi, then joins WLAN [^1] |      ✅       |      ✅       |      ✅       |
| Internal LAN                             | xCore is getting an IPv4                      |      --       |      ✅       |      ✅       |
| Home LAN                                 | eth0 IPv4 by your networks DHCP               |      ✅       |      ✅       |      ✅       |
| SSH                                      | Reachable after network is up                 |      ✅       |      ✅       |      ✅       |
| WebTerminal (ttyd)                       | Reachable at port 7681                        |      ✅       |      ✅       |      ✅       |
| Dockge                                   | Reachable at port 5001                        |      ✅       |      ✅       |      ✅       |
| ESC access                               | Ports get exposed via `openmower ...` cmd     |      ✅       |      ✅       |      🟡       |
| GNSS access                              | Port get exposed via `openmower ...` cmd      |      ✅       |      🟡       |      🟡       |
| OpenOCD remote debugging                 | Remote debugging via `openmower openocd`      |      ✅       |      ✅       |      ✅       |
| Container shell (prefix)                 | `openmower shell` has docker prefix           |      ✅       |      ✅       |      ✅       |

## Notes

- Update cells as you validate on each hardware combo.
- If Imager Wi‑Fi is set, Comitup should not spawn AP; if not, AP should appear.

[^1]: You probably need to power-cycle your mower after entering your home WiFi credentials
