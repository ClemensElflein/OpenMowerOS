#!/bin/bash -e

export DEBIAN_FRONTEND=noninteractive

# Final tidy-up to keep the image lean
apt-get -y purge apt-listchanges || true
apt-get -y autoremove --purge || true
apt-get -y clean || true
