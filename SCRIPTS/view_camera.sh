#!/usr/bin/env bash
# Streams /dev/video<N> off the pi named in pi_host.conf and opens it in a
# local ffplay window. N is 0-3, one of the four USB webcams.
set -euo pipefail

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$DIR/load_pi_host.sh"

INDEX="${1:?usage: view_camera.sh <0-3>}"

tailscale ssh "$PI_HOST" -- \
    "ffmpeg -f v4l2 -input_format mjpeg -video_size 640x480 -i /dev/video$INDEX -f mpegts -" \
    | ffplay -i -
