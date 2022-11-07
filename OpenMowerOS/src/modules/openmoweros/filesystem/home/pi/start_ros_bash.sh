#!/bin/bash
# Starts a bash in the docker container.
# Use this for ROS specific commands (e.g. rostopic echo)

docker exec -it open-mower /openmower_entrypoint.sh /bin/bash
