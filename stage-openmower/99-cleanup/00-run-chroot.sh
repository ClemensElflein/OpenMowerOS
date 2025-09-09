#!/bin/bash -e

export DEBIAN_FRONTEND=noninteractive

# Final tidy-up to keep the image lean (these are allowed to fail)
apt-get -y purge polkitd modemmanager ppp mkvtoolnix ntfs-3g exfatprogs || true
apt-get -y autoremove --purge || true
apt-get -y clean || true
