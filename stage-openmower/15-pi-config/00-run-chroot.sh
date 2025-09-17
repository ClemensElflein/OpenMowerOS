#!/bin/bash -e

# Append OpenMowerOS addendum to /boot/firmware/config.txt from a separate file.
ADDENDUM="/boot/firmware/config.addendum"
TARGET="/boot/firmware/config.txt"

# Ensure required files exist
if [ ! -e "${ADDENDUM}" ]; then
    echo "Addendum not found: ${ADDENDUM}" >&2
    exit 1
fi
if [ ! -e "${TARGET}" ]; then
    echo "Target not found: ${TARGET}" >&2
    exit 1
fi

# Append the addendum and remove the temporary addendum file
cat "${ADDENDUM}" >> "${TARGET}"
rm "${ADDENDUM}"

exit 0
