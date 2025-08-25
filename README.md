# OpenMowerOS

[![OpenMower header](.github/img/open_mower_header.jpg)](https://github.com/ClemensElflein/OpenMower)

~~*Based on [CustomPiOS](https://github.com/guysoft/CustomPiOS)*~~

This repository contains the official OpenMowerOS image for running the [OpenMower](https://github.com/ClemensElflein/OpenMower) project.

Currently this is based on the latest Debian 13.x (trixie) OS with the following changes:

- **[Comitup](https://github.com/davesteele/comitup)** opens a WiFi hotspot if no known network can be found. Connect to it with any device to connect the robot to your network.

TODO - **podman** fetches the latest version of the open-mower software and runs it for you automatically.

- **OpenOCD** is installed with GPIO support, so you can flash your pico's firmware from the Pi4

- **socat** allows you to redirect your Ardusimple to u-center for configuration

***

## Important Information

- **hostname**: openmower

- **username**: openmower

- **password**: openmower ***CHANGE IT! (use `passwd` for that)***

- **ssh**: enabled on port 22

- **hotspot SSID**: openmower-\<somenumber\>

- **default hotspot password**: openmower


TODO - **mower_config.txt**: Is in the /boot/openmower directory and can be edited with any PC after flashing the SD card

TODO - **mower_version.txt**: Is in the /boot/openmower directory and can be used to select the version to run.

***

## How to Get Started

### Required

 1. Burn the latest image available to an SD card. Preferably with [**Raspberry Pi** Imager](https://www.raspberrypi.com/software/).

 2. Optionally enter your Wi-Fi Credentials within the custom image settings.

 3. Open the SD cards `boot` partition and there the `openmower` folder.

 ~~3. Edit the `hotspot.txt` file to configure the fallback hotspot. **Change the password and remember it!**~~

    ~~You find a `hotspot.example` in there too.~~

    ~~On boot the system will apply the settings and rename the `hotspot.txt` to `hotspot.settings-applied`.~~

TODO 4. *(Open the `openmower_version.txt` and read its explanation. Optionally select a different version.)*

TODO 5. Edit the `mower_config.txt` file:

    - check for the latest revision of that file [here](https://github.com/ClemensElflein/open_mower_ros/blob/main/src/open_mower/config/mower_config.sh.example).

    - if the files differ apply the newest changes.

    - add your changes to that file.

 6. Eject the card, put it in the mower (do not close the mower yet) and turn it on.

 7. After a short time the hotspot wifi should appear - connect to it.

    - Once you are connected to the hotspot you default browser should automatically open and you should see the wifi configuration webpage:

      <p align="center"><img src=".github/img/comitup_hotspot.png" style="width:50%"></p>

    - Click on your home wifi and fill in you password.

    - The hotspot will disappear and the mower should connect to your wifi

 8. Check your router for the mowers IP address (and optionally set a static one)

 9. SSH to your mower *(the default credentials are above)*

10. Change you password! (`passwd`)

11. If you have `mower_config.txt` and `openmower_version.txt` configured, the Open Mower software will start automatically. The first start can easily take more than 10min.
    
12. Check if everything runs fine by accessing the logs `sudo podman logs -f openmower`


### Optional

- theoretically there is an auto update feature for podman but is it not tested yet

For ROS specific commands (e.g. `rostopic echo`) use `./start_ros_bash` in the `/home/openmower` directory. This will allow you to access ROS.

