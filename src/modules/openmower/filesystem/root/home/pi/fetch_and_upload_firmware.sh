#!/bin/bash

source /boot/openmower/mower_config

# remove old firmware
rm -rf firmware_download
mkdir firmware_download
cd firmware_download

# Download the latest firmware
echo "Fetching Firmware"
wget https://github.com/ClemensElflein/OpenMower/releases/download/latest/firmware.zip

unzip firmware.zip

cd ..

echo "Flashing Firmware: ./firmware_download/firmware/$OM_HARDWARE_VERSION/firmware.elf"
sudo ./upload_firmware.sh ./firmware_download/firmware/$OM_HARDWARE_VERSION/firmware.elf
