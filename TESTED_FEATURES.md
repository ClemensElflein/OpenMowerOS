# OpenMowerOS v2 – Tested Features Matrix

Legend: ✅ Pass · ❌ Fail · 🟡 Todo · 🔁 Retry · 🧪 Manual-only

| Feature          | Expected                                  | OM‑V1<br>Pi4 | OM‑V1<br>CM4 | OM‑V1<br>Pi5 | OM‑V1<br>CM5 | OM‑V2<br>Pi4 | OM‑V2<br>CM4 | OM‑V2<br>Pi5 | OM‑V2<br>CM5 |
| ---------------- | ----------------------------------------- | :----------: | :----------: | :----------: | :----------: | :----------: | :----------: | :----------: | :----------: |
| Debian release   | Debian GNU/Linux 13 (trixie)              |      🟡       |      🟡       |      🟡       |      🟡       |      🟡       |      ✅       |      🟡       |      🟡       |
| Hostname default | `openmower`                               |      🟡       |      🟡       |      🟡       |      🟡       |      🟡       |      ✅       |      🟡       |      🟡       |
| Hostname         | \<set by imager>                          |      🟡       |      🟡       |      🟡       |      🟡       |      🟡       |      🟡       |      🟡       |      🟡       |
| Default user     | `openmower` / `openmower`                 |      🟡       |      🟡       |      🟡       |      🟡       |      🟡       |      ✅       |      🟡       |      🟡       |
| SSH enabled      | SSH active on first boot                  |      🟡       |      🟡       |      🟡       |      🟡       |      🟡       |      ✅       |      🟡       |      🟡       |
| Imager Wi‑Fi     | Preseeded Wi‑Fi connects on first boot    |      🟡       |      🟡       |      🟡       |      🟡       |      🟡       |      🟡       |      🟡       |      🟡       |
| Imager user/pass | Applied when configured                   |      🟡       |      🟡       |      🟡       |      🟡       |      🟡       |      🟡       |      🟡       |      🟡       |
| No known Wi‑Fi   | Comitup AP appears (default SSID pattern) |      🟡       |      🟡       |      🟡       |      🟡       |      🟡       |      ✅       |      🟡       |      🟡       |
| AP portal        | Able to configure Wi‑Fi, then joins WLAN  |      🟡       |      🟡       |      🟡       |      🟡       |      🟡       |      ✅       |      🟡       |      🟡       |
| SSH              | Reachable after network is up             |      🟡       |      🟡       |      🟡       |      🟡       |      🟡       |      ✅       |      🟡       |      🟡       |

## Notes

- Update cells as you validate on each hardware combo.
- If Imager Wi‑Fi is set, Comitup should not spawn AP; if not, AP should appear.

## Quick manual checklist

- 🧪 First boot login with `openmower` user
- 🧪 With no Wi‑Fi: Comitup AP visible, portal config succeeds
- 🧪 With Imager Wi‑Fi: device joins network, SSH reachable
