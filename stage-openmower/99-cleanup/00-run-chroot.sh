#!/bin/bash -e

export DEBIAN_FRONTEND=noninteractive

# Final tidy-up to keep the image lean
apt-get -y purge polkitd modemmanager ppp mkvtoolnix ntfs-3g exfatprogs
apt-get -y autoremove --purge
apt-get -y clean
