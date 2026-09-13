#!/usr/bin/env bash
# This file exists to pick one pi webcam from a menu / stream it into ffplay
# CMD.org View-Camera heading runs it
# Menu built from /dev/v4l/by-id entries ending in -video-index0
set -euo pipefail

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$DIR/load_pi_host.sh"

# PI_HOST names this machine - tailscale ssh to itself gets refused
run_on_pi()
{
    if [ "${PI_HOST#*@}" = "$(hostname)" ]
    then
        bash -c "$1"
    else
        tailscale ssh "$PI_HOST" -- "$1"
    fi
}

mapfile -t CAMERAS < <(run_on_pi 'ls -1 /dev/v4l/by-id/ 2>/dev/null | grep -- "-video-index0$"' || true)

if [ "${#CAMERAS[@]}" -eq 0 ]
then
    echo "no webcams found in /dev/v4l/by-id on $PI_HOST" >&2
    exit 1
fi

PS3="camera: "
select CAMERA in "${CAMERAS[@]}"
do
    if [ -n "${CAMERA:-}" ]
    then
        break
    fi
    echo "pick a number from the list"
done

if [ -z "${CAMERA:-}" ]
then
    exit 1
fi

echo "==> streaming $CAMERA from $PI_HOST"
run_on_pi "ffmpeg -loglevel error -f v4l2 -input_format mjpeg -video_size 640x480 -i '/dev/v4l/by-id/$CAMERA' -f mpegts -" \
    | ffplay -loglevel error -window_title "$CAMERA" -i -
