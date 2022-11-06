#!/bin/bash
# Call this script to build the image

if compgen -G "./OpenMowerOS/src/image/*.zip" > /dev/null; then
    echo "Image exists, skipping download."
else
    echo "No image found, downloading latest Raspbiann image."
    bash -c "cd OpenMowerOS/src && mkdir -p image && cd image && wget -c --trust-server-names 'https://downloads.raspberrypi.org/raspbian_lite_latest'"
fi

echo "Starting Image Build"
sudo bash -c "./OpenMowerOS/src/build_dist"

