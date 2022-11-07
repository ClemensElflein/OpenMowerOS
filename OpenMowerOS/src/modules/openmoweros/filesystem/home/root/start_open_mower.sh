#!/bin/bash

source /boot/om_version.sh

docker pull ghcr.io/clemenselflein/open_mower_ros:releases-${OM_VERSION}

docker run \
	-v /boot/mower_config.sh:/config/mower_config.sh \
	-v /home/pi/ros_home:/root\
	-v /root/rosconsole.config:/config/rosconsole.config\
	-e ROSCONSOLE_CONFIG_FILE=/config/rosconsole.config\
	-e ROSOUT_DISABLE_FILE_LOGGING=True\
	--network="host"\
        --privileged\
	-t\
	ghcr.io/clemenselflein/open_mower_ros:releases-${OM_VERSION}
