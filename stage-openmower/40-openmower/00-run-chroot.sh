#!/bin/bash -e

# Fetch latest upstream example into user home as mower_config.sh
bash -c "wget -O /home/openmower/mower_config.sh https://raw.githubusercontent.com/ClemensElflein/open_mower_ros/main/src/open_mower/config/mower_config.sh.example || true"
chown openmower:openmower "/home/openmower/mower_config.sh"
chmod 664 "/home/openmower/mower_config.sh"

# Make sure user is in docker group for user-run service
usermod -aG docker openmower

systemctl enable openmower.service
