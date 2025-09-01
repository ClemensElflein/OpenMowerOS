#!/bin/bash -e

export DEBIAN_FRONTEND=noninteractive

systemctl mask  systemd-networkd-wait-online.service || true
