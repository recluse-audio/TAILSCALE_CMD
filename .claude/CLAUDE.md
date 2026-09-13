# TAILSCALE_CMD project rules

This repo holds scripts and a `CMD.org` for reaching devices over Ryan's tailnet, runnable through
`rd_cmd` (CMD_TUI) or directly from a shell. No app is built here, only scripts and the CMD.org
wiring them in.

- Tailscale account setup and the per-device join steps live in
  `RD_CMD/CONFIG/COMMON/TAILSCALE/INSTALL.org` and `RD_CMD/CONFIG/COMMON/TAILSCALE/setup.sh`. Do
  not duplicate that content here; link to it.
- Prior single-webcam work on `pi-organizer` (Motion, browser at port 8081) is recorded in
  `NOTES/DEV_KNOWLEDGE/GENERAL/PI_TailScale.md` in the top-level NOTES repo. This repo
  deliberately uses ffmpeg piped over `tailscale ssh` into local `ffplay` instead, so any of the
  4 cameras can be selected at runtime with no pi-side config edit or restart.
- `pi_host.conf` at the repo root names the current pi target (`PI_HOST=user@tailnet-hostname`).
  Scripts under `SCRIPTS/` source it through `SCRIPTS/load_pi_host.sh`. Never hardcode a hostname
  into a script.
- New scripts follow the `CMD.org` format documented in `CMD_TUI/README.org`
  (`/home/artie/REPOS/PROJECTS/CMD_TUI/README.org`): one Org heading per command, `#+KIND:`
  required, `#+PLAIN:` required outside a `reference` block.
