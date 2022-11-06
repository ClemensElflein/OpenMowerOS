# OpenMowerOS

This repository contains the official OpenMowerOS image for running the OpenMower project.

Currently this is based on the latest RaspberryPi OS with the following changes:

- **Comitup** opens a WiFi hotspot if no known network can be found. Connect to it with any device to connect the robot to your network.
- **Docker** fetches the latest version of the open-mower software and runs it for you automatically.
- **OpenOCD** is installed with GPIO support, so you can flash your pico's firmware from the Pi4
- **socat** allows you to redirect your Ardusimple to u-center for configuration



## Important Information

- **hostname**: openmower
- **username**: pi
- **password**: openmower
- **ssh**: enabled on port 22
- **hotspot SSID**: openmower-\<somenumber\>
- **hotspot password**: openmower
- **mower_config.sh**: Is in the /boot directory and can be edited with any PC after flashing the SD card
- **mower_version.sh**: Is in the /boot directory and can be used to select the version to run.

