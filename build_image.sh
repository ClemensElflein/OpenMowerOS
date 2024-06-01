#!/bin/bash
# Call this script to build the image

if compgen -G "./OpenMowerOS/src/image/*" > /dev/null; then
    echo "Image exists, skipping download."
else
    echo "No image found, downloading latest Raspbian image."
    bash -c "cd OpenMowerOS/src && mkdir -p image && cd image && wget -c --trust-server-names 'https://downloads.raspberrypi.org/raspios_lite_arm64_latest'"
fi

echo "Starting Image Build"
sudo bash -c "./OpenMowerOS/src/build_dist"

