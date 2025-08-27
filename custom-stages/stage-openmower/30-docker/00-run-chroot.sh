#!/bin/bash -e

export DEBIAN_FRONTEND=noninteractive
apt-get update

# Install Docker engine from Debian (Trixie)
apt-get install -y --no-install-recommends docker.io docker-cli

# Enable the Docker daemon
systemctl enable docker.service || true

# Add the primary user to the docker group (if present)
PRIMARY_USER="openmower"
if id -u "$PRIMARY_USER" >/dev/null 2>&1; then
    usermod -aG docker "$PRIMARY_USER" || true
fi

# Prefer journald logging for consistency with system logs (create if absent)
install -d /etc/docker
if [ ! -f /etc/docker/daemon.json ]; then
cat > /etc/docker/daemon.json <<'EOF'
{
  "log-driver": "journald"
}
EOF
fi
