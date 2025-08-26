#!/bin/bash -e

# Customize login banners with OpenMowerOS branding while keeping Debian details dynamic.

# Gather OS details
OS_LINE="Debian GNU/Linux"
if [ -r /etc/os-release ]; then
    . /etc/os-release || true
    # Build a concise line like: Debian GNU/Linux 13 (trixie)
    OS_LINE="${NAME:-Debian GNU/Linux}"
    [ -n "${VERSION_ID:-}" ] && OS_LINE="Debian GNU/Linux ${VERSION_ID}"
    [ -n "${VERSION_CODENAME:-}" ] && OS_LINE="${OS_LINE} (${VERSION_CODENAME})"
fi

# Backup the original issue files once for reference
[ -f /etc/issue ] && [ ! -f /etc/issue.debian ] && cp -a /etc/issue /etc/issue.debian || true
[ -f /etc/issue.net ] && [ ! -f /etc/issue.net.debian ] && cp -a /etc/issue.net /etc/issue.net.debian || true

cat > /etc/issue <<EOF

   ____                   __  ___                        ____  _____
  / __ \____  ___  ____  /  |/  /___ _      _____  _____/ __ \/ ___/
 / / / / __ \/ _ \/ __ \/ /|_/ / __ \ | /| / / _ \/ ___/ / / /\__ \
/ /_/ / /_/ /  __/ / / / /  / / /_/ / |/ |/ /  __/ /  / /_/ /___/ /
\____/ .___/\___/_/ /_/_/  /_/\____/|__/|__/\___/_/   \____//____/
    /_/                                            OpenMowerOS v2

$OS_LINE

EOF

cat > /etc/issue.net <<EOF
OpenMowerOS v2 - $OS_LINE
EOF

chmod 0644 /etc/issue /etc/issue.net