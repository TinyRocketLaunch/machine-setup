# Linux Dev Environment Setup

Post-Claude setup for a Linux machine (Debian/Ubuntu/Pi OS). Claude can assist with most of this once `cld` is working.

## Essential tools

```bash
sudo apt-get update
sudo apt-get install -y git gh curl wget unzip build-essential
```

Node.js (via nvm for version flexibility):
```bash
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
source ~/.bashrc
nvm install --lts
```

Starship prompt:
```bash
curl -sS https://starship.rs/install.sh | sh
echo 'eval "$(starship init bash)"' >> ~/.bashrc
```

Tailscale: see [tailscale/README.md](../tailscale/README.md)

## Shell setup

Source Claude aliases from `~/.bashrc`:
```bash
echo "source ~/claude-workspace/machine-setup/claude-setup/aliases/aliases.sh" >> ~/.bashrc
source ~/.bashrc
```

## SSH server

```bash
sudo apt-get install -y openssh-server
sudo systemctl enable --now ssh
```

See [ssh/README.md](../ssh/README.md) for key setup and host aliases.

## Notes

- For Raspberry Pi OS specifically, see the [raspberry-rig](https://github.com/TinyRocketLaunch/raspberry-rig) repo for server hardening, backups, monitoring, and Jellyfin.
