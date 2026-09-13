#!/usr/bin/env bash
# Sourced by the other scripts in this directory. Reads PI_HOST out of
# ../pi_host.conf and fails loudly if it is still unset.
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
CONF="$ROOT/pi_host.conf"

# shellcheck disable=SC1090
source "$CONF"

if [ -z "${PI_HOST:-}" ]; then
    echo "PI_HOST is unset in $CONF" >&2
    echo "edit that file: PI_HOST=user@tailnet-hostname" >&2
    exit 1
fi
