#!/bin/bash -e

export DEBIAN_FRONTEND=noninteractive

apt-get update

# Set up Docker's official APT repository
apt-get install -y --no-install-recommends ca-certificates curl
install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/debian/gpg -o /etc/apt/keyrings/docker.asc
chmod a+r /etc/apt/keyrings/docker.asc

CODENAME="$(. /etc/os-release && echo "$VERSION_CODENAME")"
echo "deb [arch=arm64 signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/debian ${CODENAME} stable" > /etc/apt/sources.list.d/docker.list

apt-get update
apt-get install -y --no-install-recommends \
docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

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
