#!/bin/bash -e

# Create ROS home
mkdir -p /home/openmower/ros_home

chown -R openmower:openmower /home/openmower/
chmod -R u=rwX,g=rwX,o=rX /home/openmower/

# Make sure user is in docker group for user-run service
usermod -aG docker openmower
