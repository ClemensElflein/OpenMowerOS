#!/bin/bash
# Starts a bash in the docker container.
# Use this for ROS specific commands (e.g. rostopic echo)

sudo podman exec -it openmower /openmower_entrypoint.sh ${@:-/bin/bash}
