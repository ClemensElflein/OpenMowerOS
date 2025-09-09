#!/usr/bin/env bash
# install-openmower-cli.sh
# Usage: ./install-openmower-cli.sh
# Optional: export GITHUB_TOKEN=... to avoid rate limits

set -euo pipefail

command -v curl >/dev/null  || { echo "Need: curl" >&2; exit 1; }
command -v unzip >/dev/null || { echo "Need: unzip" >&2; exit 1; }
command -v jq >/dev/null    || { echo "Need: jq" >&2; exit 1; }

REPO="ClemensElflein/openmower-cli"
API="https://api.github.com/repos/${REPO}/releases/latest"
AUTH=()
[[ -n "${GITHUB_TOKEN:-}" ]] && AUTH=(-H "Authorization: Bearer ${GITHUB_TOKEN}")

tmp="$(mktemp -d)"; trap 'rm -rf "$tmp"' EXIT

echo "→ Fetching latest release for ${REPO}…"
json="$(curl -fsSL "${AUTH[@]}" "$API")"

asset_url="$(
  jq -r '
    .assets[] | select(.name | test("^openmower-cli-.*\\.zip$"))
    | .browser_download_url
  ' <<<"$json" | head -n1
)"

[[ -n "$asset_url" && "$asset_url" != "null" ]] || {
  echo "No asset matching openmower-cli-*.zip found." >&2
  jq -r '.assets[].name' <<<"$json" >&2
  exit 1
}

zipfile="$tmp/$(basename "$asset_url")"
echo "→ Downloading $(basename "$asset_url")"
curl -fsSL -o "$zipfile" "$asset_url"

echo "→ Unzipping"
unzip -qq "$zipfile" -d "$tmp"

[[ -f "$tmp/openmower" ]] || { echo "Expected 'openmower' at zip root, not found." >&2; exit 1; }

echo "→ Installing to /usr/local/bin/openmower"
install -m 0755 "$tmp/openmower" /usr/local/bin/openmower

echo "✓ Installed. Version (if supported):"
/usr/local/bin/openmower --version || true
