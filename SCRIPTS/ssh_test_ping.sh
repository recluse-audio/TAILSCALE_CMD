#!/usr/bin/env bash
# This file exists to test tailscale ssh into one online tailnet peer
# CMD.org SSH_Test_Ping heading runs it
# ssh_users.conf at repo root - login user per tailnet hostname
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
USERS_CONF="$ROOT/ssh_users.conf"

mapfile -t PEERS < <(tailscale status --json | python3 -c '
import json, sys
status = json.load(sys.stdin)
for peer in (status.get("Peer") or {}).values():
    if peer.get("Online"):
        print(peer["DNSName"].split(".")[0])
' | sort)

if [ "${#PEERS[@]}" -eq 0 ]
then
    echo "no online peers in tailscale status" >&2
    exit 1
fi

PS3="target device: "
select HOST in "${PEERS[@]}"
do
    if [ -n "${HOST:-}" ]
    then
        break
    fi
    echo "pick a number from the list"
done

if [ -z "${HOST:-}" ]
then
    exit 1
fi

SSH_USER=""
if [ -f "$USERS_CONF" ]
then
    SSH_USER="$(awk -v host="$HOST" '$1 == host { print $2 }' "$USERS_CONF")"
fi
if [ -z "$SSH_USER" ]
then
    read -rp "login user on $HOST: " SSH_USER || true
fi
if [ -z "$SSH_USER" ]
then
    echo "no login user for $HOST, add it to $USERS_CONF" >&2
    exit 1
fi

echo "==> tailscale ping $HOST"
tailscale ping -c 1 --timeout 5s "$HOST"

echo "==> tailscale ssh $SSH_USER@$HOST"
timeout 60 tailscale ssh "$SSH_USER@$HOST" -- 'echo "ssh ok on $(hostname) as $(whoami)"'
