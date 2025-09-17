#!/bin/bash -e

chown -R openmower:openmower /home/openmower/ /opt/stacks/openmower/
chmod -R u=rwX,g=rwX,o=rX /home/openmower/ /opt/stacks/openmower/

# Make sure user is in docker group for user-run service
usermod -aG docker openmower

# Create the dir for recordings (so that it has the correct permissions)
mkdir -p /home/openmower/recordings
chown -R 1000:1000 /home/openmower/recordings
mkdir -p /home/openmower/ros
chown -R 1000:1000 /home/openmower/ros
mkdir -p /home/openmower/params
chown -R 1000:1000 /home/openmower/params

export DEBIAN_FRONTEND=noninteractive

# Minimal deps for fetching & unpacking
apt-get update
apt-get install -y --no-install-recommends curl jq unzip ca-certificates
REPO="ClemensElflein/openmower-cli"

API="https://api.github.com/repos/${REPO}/releases/latest"
AUTH=()
[ -n "${GITHUB_TOKEN:-}" ] && AUTH=(-H "Authorization: Bearer ${GITHUB_TOKEN}")

tmp="$(mktemp -d)"
trap 'rm -rf "$tmp"' EXIT

echo "→ Fetching latest release metadata for ${REPO}"
json="$(curl -fsSL "${AUTH[@]}" \
  -H "Accept: application/vnd.github+json" \
  -H "X-GitHub-Api-Version: 2022-11-28" \
  "$API")"

asset_url="$(jq -r '
  .assets[] | select(.name | test("^openmower-cli-.*\\.zip$"))
  | .browser_download_url
' <<<"$json" | head -n1)"

if [ -z "$asset_url" ] || [ "$asset_url" = "null" ]; then
  echo "No asset matching openmower-cli-*.zip found." >&2
  jq -r '.assets[].name' <<<"$json" >&2 || true
  exit 1
fi

zipfile="$tmp/cli.zip"
echo "→ Downloading $(basename "$asset_url")"
curl -fsSL --retry 5 --retry-delay 2 -o "$zipfile" "$asset_url"

echo "→ Unzipping"
unzip -qq -o "$zipfile" -d "$tmp"

if [ ! -f "$tmp/openmower" ]; then
  echo "Expected 'openmower' at zip root, not found." >&2
  exit 1
fi

echo "→ Installing to /usr/local/bin/openmower"
install -m 0755 "$tmp/openmower" /usr/local/bin/openmower

# Nice to have: verify it responds (won't fail the build if it doesn't)
echo "✓ Installed. Version check (if supported):"
/usr/local/bin/openmower --version

echo "→ Installing tab completion for /usr/local/bin/openmower"
sudo -u openmower /usr/local/bin/openmower --install-completion
echo "✓ Installed"

echo "→ Updating bash prompts to show 🐳 when STACK_NAME is set"
for f in /home/openmower/.bashrc /root/.bashrc /etc/skel/.bashrc; do
  cat >> "$f" <<'OMEOF'

# Prefix PS1 with docker whale if in stack context
if [ -n "$STACK_NAME" ]; then
    PS1="🐳 $PS1"
fi
OMEOF
done
