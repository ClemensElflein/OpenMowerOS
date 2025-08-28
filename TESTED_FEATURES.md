# OpenMowerOS v2 – Tested Features Matrix

Legend: ✅ Pass · ❌ Fail · 🟡 Todo · 🔁 Retry · 🧪 Manual-only

| Feature                           | Expected                                        | OM‑V1<br>Pi4 | OM‑V1<br>CM4 | OM‑V1<br>Pi5 | OM‑V1<br>CM5 | OM‑V2<br>Pi4 | OM‑V2<br>CM4 | OM‑V2<br>Pi5 | OM‑V2<br>CM5 |
| --------------------------------- | ----------------------------------------------- | :----------: | :----------: | :----------: | :----------: | :----------: | :----------: | :----------: | :----------: |
| Debian release                    | Debian GNU/Linux 13 (trixie)                    |      🟡       |      🟡       |      🟡       |      🟡       |      🟡       |      ✅       |      🟡       |      🟡       |
| Hostname default                  | `openmower`                                     |      🟡       |      🟡       |      🟡       |      🟡       |      🟡       |      ✅       |      🟡       |      🟡       |
| Hostname                          | \<set by imager>                                |      🟡       |      🟡       |      🟡       |      🟡       |      🟡       |      ✅       |      🟡       |      🟡       |
| Default user                      | `openmower` / `openmower`                       |      🟡       |      🟡       |      🟡       |      🟡       |      🟡       |      ✅       |      🟡       |      🟡       |
| SSH enabled                       | SSH active on first boot                        |      🟡       |      🟡       |      🟡       |      🟡       |      🟡       |      ✅       |      🟡       |      🟡       |
| Imager Wi‑Fi                      | Preseeded Wi‑Fi connects on first boot          |      🟡       |      🟡       |      🟡       |      🟡       |      🟡       |      ✅       |      🟡       |      🟡       |
| Imager openmower pass             | Applied when configured                         |      🟡       |      🟡       |      🟡       |      🟡       |      🟡       |      ✅       |      🟡       |      🟡       |
| No known Wi‑Fi                    | Comitup AP appears (default SSID pattern)       |      🟡       |      🟡       |      🟡       |      🟡       |      🟡       |      ✅       |      🟡       |      🟡       |
| AP portal                         | Able to configure Wi‑Fi, then joins WLAN        |      🟡       |      🟡       |      🟡       |      🟡       |      🟡       |      ✅       |      🟡       |      🟡       |
| LAN                               | eth0 IPv4 by your networks DHCP                 |      🟡       |      🟡       |      🟡       |      🟡       |      🟡       |      ✅       |      🟡       |      🟡       |
| SSH                               | Reachable after network is up                   |      🟡       |      🟡       |      🟡       |      🟡       |      🟡       |      ✅       |      🟡       |      🟡       |
| OpenMower OM_VERSION unconfigured | Service drops a reasonable message              |      🟡       |      🟡       |      🟡       |      🟡       |      🟡       |      🟡       |      🟡       |      🟡       |
| OpenMower OM_VERSION configured   | Drops a reasonable message if not pulled        |      🟡       |      🟡       |      🟡       |      🟡       |      🟡       |      🟡       |      🟡       |      🟡       |
| openmower-pull.sh                 | Pulls OM_VERSION image                          |      🟡       |      🟡       |      🟡       |      🟡       |      🟡       |      🟡       |      🟡       |      🟡       |
| openmower service                 | Service get started if OM_VERSION is configured |      🟡       |      🟡       |      🟡       |      🟡       |      🟡       |      🟡       |      🟡       |      🟡       |

## Notes

- Update cells as you validate on each hardware combo.
- If Imager Wi‑Fi is set, Comitup should not spawn AP; if not, AP should appear.
