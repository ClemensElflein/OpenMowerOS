#!/bin/bash -ex

# Remove any serial console entries while preserving the rest of the line
sed -i -E 's/(^| )console=(serial0|ttyAMA0|ttyS0)(,[0-9]+)?//g' /boot/firmware/cmdline.txt
# Collapse multiple spaces and trim
awk '{$1=$1; print}' /boot/firmware/cmdline.txt > /boot/firmware/cmdline.txt.tmp && mv /boot/firmware/cmdline.txt.tmp /boot/firmware/cmdline.txt

# Mask and stop serial getty instances that could grab ttyAMA[0-4] (or its common aliases)
for n in 0 1 2 3 4; do
    for svc in "serial-getty@ttyAMA${n}"; do
        systemctl disable "$svc.service"
        systemctl mask "$svc.service"
    done
done
for svc in serial-getty@ttyS0 serial-getty@serial0; do
    systemctl disable "$svc.service"
    systemctl mask "$svc.service"
done

exit 0
