#!/usr/bin/env bash
# Lists the USB video devices seen on the pi named in pi_host.conf.
set -euo pipefail

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$DIR/load_pi_host.sh"

tailscale ssh "$PI_HOST" -- 'ls -1 /dev/video* 2>/dev/null; echo; v4l2-ctl --list-devices 2>/dev/null || echo "v4l2-ctl not installed on the pi (apt install v4l-utils)"'
