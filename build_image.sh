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

# Inject OpenMowerOS Git metadata into container environment

# Detect branch name robustly even in detached HEAD (common in CI)
detect_branch() {
    # 1. CI specific environment variables
    for var in GITHUB_HEAD_REF GITHUB_REF_NAME GIT_BRANCH CI_COMMIT_REF_NAME CI_BUILD_REF_NAME BUILD_SOURCEBRANCHNAME; do
        val="${!var:-}"
        printf '1: %s' "$val"
        if [ -n "$val" ]; then
            # Normalize refs/heads/* -> branch
            case "$val" in
                refs/heads/*) val="${val#refs/heads/}" ;;
                refs/tags/*) val="${val#refs/tags/}" ;;
            esac
            printf '2: %s' "$val"
            return 0
        fi
    done
    # 2. Direct rev-parse (gives 'HEAD' in detached state)
    local rp
    rp=$(git -C "${ROOT_DIR}" rev-parse --abbrev-ref HEAD 2>/dev/null || true)
    if [ -n "$rp" ] && [ "$rp" != "HEAD" ]; then
        printf '3: %s' "$rp"
        return 0
    fi
    # 3. Try to resolve first matching remote head for current commit
    local commit
    commit=$(git -C "${ROOT_DIR}" rev-parse HEAD 2>/dev/null || true)
    if [ -n "$commit" ]; then
        # List remote heads pointing to this commit
        local remote_head
        remote_head=$(git -C "${ROOT_DIR}" for-each-ref --format='%(objectname) %(refname:short)' refs/remotes 2>/dev/null | awk -v c="$commit" '$1==c {print $2; exit}')
        if [ -n "$remote_head" ]; then
            # Trim origin/ prefix if present
            remote_head="${remote_head#origin/}"
            printf '4: %s' "$remote_head"
            return 0
        fi
    fi
    # 4. Fallback to short hash label
    if [ -n "$commit" ]; then
        printf 'detached-%s' "${commit:0:8}"
        return 0
    fi
    printf 'unknown'
}

OMOS_GIT_HASH_FULL=$(git -C "${ROOT_DIR}" rev-parse HEAD 2>/dev/null || echo unknown)
OMOS_GIT_HASH=$(git -C "${ROOT_DIR}" rev-parse --short=8 HEAD 2>/dev/null || echo unknown)
OMOS_GIT_DESCRIBE=$(git -C "${ROOT_DIR}" describe --tags --dirty --always 2>/dev/null || echo unknown)
OMOS_GIT_BRANCH=$(detect_branch)
export PIGEN_DOCKER_OPTS+=" -e OMOS_GIT_HASH_FULL=${OMOS_GIT_HASH_FULL} -e OMOS_GIT_HASH=${OMOS_GIT_HASH} -e OMOS_GIT_DESCRIBE=${OMOS_GIT_DESCRIBE} -e OMOS_GIT_BRANCH=${OMOS_GIT_BRANCH}"

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
