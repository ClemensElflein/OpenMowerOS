#!/bin/bash
# Wrapper to drop into an interactive shell as the non-root user 'openmower'.
# Falls back gracefully if the user or required tools are missing.
set -euo pipefail

USER_NAME="openmower"

if id "${USER_NAME}" >/dev/null 2>&1; then
    exec setpriv --reuid "${USER_NAME}" --regid "${USER_NAME}" --init-groups /usr/bin/env -i \
    HOME="/home/${USER_NAME}" USER="${USER_NAME}" LOGNAME="${USER_NAME}" SHELL="/bin/bash" TERM="${TERM:-xterm-256color}" \
    PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin" \
    /bin/bash -l
else
    echo "[webterminal-shell-wrapper] WARNING: user '${USER_NAME}' not found. Starting root login shell." >&2
    exec /bin/bash -l
fi
