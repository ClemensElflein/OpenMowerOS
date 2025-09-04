# OpenMowerOS

[![OpenMower header](.github/img/open_mower_header.jpg)](https://github.com/ClemensElflein/OpenMower)

This repository contains the official OpenMowerOS image for running the [OpenMower](https://github.com/ClemensElflein/OpenMower) project on your OM's Pi4/CM4.

➡️ What’s new in the latest release? See [WHATSNEW.md](./WHATSNEW.md).


## Reference Information

- **hostname**: openmower

- **username**: openmower

- **password**: openmower ***CHANGE IT! (use `passwd` for that)***

- **ssh**: enabled on port 22

- **hotspot SSID**: OpenMower-\<somenumber\> (no password)


***

## How to Get Started

### Required

1. Burn the latest image available to an SD card. Preferably with [**Raspberry Pi** Imager](https://www.raspberrypi.com/software/).

2. ***Option A: Pi-Imager-Configuration***<br>
   When asked by Pi Imager, you may change some custom settings:
   1. Like shown here, but **never** use another username than `openmower`!<br>
   ![General Settings](.github/img/rpimager_general.png)
   1. You may also add your SSH's public key for quicker SSH login,
   but login via password remains active (even if it's a radio selector)<br>
   ![SSH Settings](.github/img/rpimager_ssh.png)
   

1. Once written, eject the card, put it in the mower and turn it on.

2. Your Pi will boot multiple times. Sometimes, after the first boot, it fails rebooting (red LED near the HDMI plug remains on, whereas green one doesn't flicker anymore). If that happen, one power-cycle will get him back on track.

3. ***Option B: Comitup-Hotspot***<br>
If you didn't entered your Wi-Fi Credentials when asked for the custom settings in the Raspberry Pi Imager (see step 2.), or even accidentally entered the wrong ones:

   1. After a short time an "OpenMower-\<somenumber>" wifi hotspot should appear - connect to it.

   2. Once you are connected to the hotspot your default browser should automatically open and you should see the wifi configuration webpage (if it doesn't open automatically, open http://10.41.0.1 with your browser):

      <p align="center"><img src=".github/img/comitup_hotspot.png" style="width:50%"></p>

   3. Click on your home wifi and fill in you password.

   4. The hotspot will disappear and the mower should connect to your wifi.

1. Try pinging your mower via `ping openmower` (or the hostname you entered during Pi Imager). If the host can't be found, check your router for the mowers IP address.

2.  SSH to your mower via `ssh openmower@openmower` or even `ssh openmower@<your hostname or mowers IP address>` (password "openmower" or the one your entered during Pi Imager).

3. ***Option B: Comitup-Hotspot***<br>
   1. Change your password! (`passwd`).
   2. Use `raspi-config` to change keyboard, timezone, WLAN country and the like.

4. Edit `nano /etc/default/openmower` and change `OM_VERSION` to your preferred one.

5. Pull the selected `OM_VERSION` by running `openmower-pull.sh`.

7. TODO: Restart openmower service via `systemctl restart openmower`

8. TODO: Check if everything runs fine by accessing the logs `docker logs -f openmower`


### Optional

TODO: - theoretically there is an auto update feature for podman but is it not tested yet

FIXME: For ROS specific commands (e.g. `rostopic echo`) use `./start_ros_bash` in the `/home/openmower` directory. This will allow you to access ROS.

