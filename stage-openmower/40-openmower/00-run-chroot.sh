#!/bin/bash -e

# Fetch latest upstream example to a temp file
wget -O /tmp/mower_config.sh.example https://raw.githubusercontent.com/ClemensElflein/open_mower_ros/main/src/open_mower/config/mower_config.sh.example || true

# Prefix V2 selection and combine with downloaded example config
cat <<'EOF' > /home/openmower/mower_config.sh
###############################
##     OpenMower hardware    ##
###############################
source /etc/default/openmower
if [ "${OM_V2}" = "True" ]; then
    export OM_V2 OM_MOWER
    exit 0
fi

#
# OpenMower V2 based systems don't need to change anything more here.
# Their main configuration file is /home/openmower/mower_params.yaml
#
# OpenMower V1 based systems have to adapt their configuration accordingly here.
#

EOF

cat /tmp/mower_config.sh.example >> /home/openmower/mower_config.sh
rm -f /tmp/mower_config.sh.example

# Create ROS home
mkdir -p /home/openmower/ros_home

# Adapt permissions
chown openmower:openmower /etc/default/openmower
chmod 664 /etc/default/openmower

chown -R openmower:openmower /home/openmower/
chmod -R u=rwX,g=rwX,o=rX /home/openmower/

# Make sure user is in docker group for user-run service
usermod -aG docker openmower

systemctl enable openmower.service
