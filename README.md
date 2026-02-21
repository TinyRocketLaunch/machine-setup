# machine-setup

Device ecosystem onboarding for any new machine. Follow these sections in order.

## Onboarding order

1. **[bootstrap/](bootstrap/)** — Get git and GitHub CLI working (pre-Claude)
2. **[claude-setup/](claude-setup/)** — Install and configure Claude Code
3. **[ssh/](ssh/)** — Set up SSH keys and host aliases across devices
4. **[tailscale/](tailscale/)** — Join the Tailscale network for remote access
5. **[windows/](windows/)** or **[linux/](linux/)** — OS-specific dev environment setup

## Repos

| Repo | Purpose |
|------|---------|
| [machine-setup](https://github.com/TinyRocketLaunch/machine-setup) | This repo — ecosystem setup for any device |
| [raspberry-rig](https://github.com/TinyRocketLaunch/raspberry-rig) | Pi 5 home server — backup, monitoring, Jellyfin, dashboard |

## Philosophy

- Claude is the first dev tool set up on any new machine — it assists with the rest.
- SSH and Tailscale are the network layer; set them up early so all machines can reach each other.
- Keep project-specific config in project repos. This repo is for the machine itself.
