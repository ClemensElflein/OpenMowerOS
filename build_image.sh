#!/usr/bin/env bash
set -euo pipefail

# Wrapper to build OpenMowerOS using the pi-gen submodule
# Requirements: docker or rootless docker with sudo wrapper

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PIGEN_DIR="${ROOT_DIR}/ext/pi-gen"
CONFIG_FILE="${ROOT_DIR}/pi-gen.config"

# Ensure standard admin tools are in PATH for non-root users on Debian
export PATH="/usr/sbin:/sbin:${PATH}"

if [ ! -d "${PIGEN_DIR}" ] || ! git -C "${PIGEN_DIR}" rev-parse --is-inside-work-tree >/dev/null 2>&1; then
    echo "pi-gen submodule missing. Initialize it first:"
    echo "  git submodule update --init --recursive ext/pi-gen"
    exit 1
fi

if [ ! -f "${CONFIG_FILE}" ]; then
    echo "Config file not found at ${CONFIG_FILE}"
    exit 1
fi

# Always mount our stage-openmower into the container
export PIGEN_DOCKER_OPTS="${PIGEN_DOCKER_OPTS:-} --volume ${ROOT_DIR}/stage-openmower:/stage-openmower:ro"

# Optionally map loop devices explicitly into the container (helps on some hosts)
if [ "${MAP_LOOP_DEVICES:-0}" = "1" ]; then
    for n in 0 1 2 3 4 5 6 7; do
        export PIGEN_DOCKER_OPTS+=" --device=/dev/loop${n}"
    done
    export PIGEN_DOCKER_OPTS+=" --device=/dev/loop-control"
fi

# Reuse existing build container unless explicitly overridden
export CONTINUE="${CONTINUE:-1}"

# If FRESH=1 is set, force a clean run and remove any previous pi-gen containers
if [ "${FRESH:-0}" = "1" ]; then
    export CONTINUE=0
    # Use docker or sudo docker depending on availability
    DOCKER_BIN=${DOCKER:-docker}
    if ! ${DOCKER_BIN} ps >/dev/null 2>&1; then
        DOCKER_BIN="sudo ${DOCKER_BIN}"
    fi
    # Attempt to remove any existing containers; ignore errors
    (${DOCKER_BIN} rm -v pigen_work_cont >/dev/null 2>&1 || true)
    (${DOCKER_BIN} rm -v pigen_work >/dev/null 2>&1 || true)
    # Ensure loop module is available on host (best effort)
    (lsmod | grep -q '^loop' || sudo modprobe loop) >/dev/null 2>&1
    # Detach stale loop devices on host to avoid losetup confusion
    (sudo losetup -D) >/dev/null 2>&1
fi

# Optional manual loop cleanup without full FRESH rebuild
if [ "${CLEAN_LOOPS:-0}" = "1" ]; then
    (sudo losetup -D) >/dev/null 2>&1
fi

cd "${PIGEN_DIR}"
exec ./build-docker.sh -c "${CONFIG_FILE}" "$@"
