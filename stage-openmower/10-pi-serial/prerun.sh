#!/bin/bash
# Ensure our chroot script is executable
chmod +x "$(dirname "$0")/00-run-chroot.sh" 2>/dev/null || true