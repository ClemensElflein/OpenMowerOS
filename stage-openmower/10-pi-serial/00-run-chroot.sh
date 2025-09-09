#!/bin/bash -ex
# Disable serial console on ttyAMA0 (and aliases); these UARTs are used by the robot.
# Removes console=serial0/ttyAMA0/ttyS0 from cmdline and masks serial getty units.

clean_cmdline() {
    local f="$1"
    [ -e "$f" ]
    
    # Remove any serial console entries while preserving the rest of the line
    sed -i -E 's/(^| )console=(serial0|ttyAMA0|ttyS0)(,[0-9]+)?//g' "$f"
    # Collapse multiple spaces and trim
    awk '{$1=$1; print}' "$f" >"$f.tmp" && mv "$f.tmp" "$f"
}

# Handle both possible locations used across Raspberry Pi OS releases
if [ -e /boot/firmware/cmdline.txt ]; then
  clean_cmdline /boot/firmware/cmdline.txt
elif [ -e /boot/cmdline.txt ]; then
  clean_cmdline /boot/cmdline.txt
else
  echo "cmdline.txt not found in /boot/firmware or /boot" >&2
  exit 1
fi

# Mask and stop serial getty instances that could grab ttyAMA[0-4] (or its common aliases)
for n in 0 1 2 3 4; do
    for svc in "serial-getty@ttyAMA${n}"; do
        systemctl disable --now "$svc.service" 2>/dev/null
        systemctl mask "$svc.service" 2>/dev/null
    done
done
for svc in serial-getty@ttyS0 serial-getty@serial0; do
    systemctl disable --now "$svc.service" 2>/dev/null
    systemctl mask "$svc.service" 2>/dev/null
done

exit 0
