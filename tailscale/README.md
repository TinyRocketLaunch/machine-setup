# Tailscale Setup

Tailscale provides a zero-config overlay network for remote access to LAN devices without opening public inbound ports.

## Install

**Windows:**
```powershell
winget install Tailscale.Tailscale
```

**Linux (Debian/Ubuntu/Pi OS):**
```bash
curl -fsSL https://tailscale.com/install.sh | sh
```

## Join the network

```bash
sudo tailscale up
```

Authenticate via the browser link. The machine will appear in the Tailscale admin panel.

## Remote access posture

- Keep LAN services (dashboard, Prometheus node exporter, etc.) bound to LAN interfaces by default.
- Route remote admin access through Tailscale rather than opening public inbound ports.
- Example: dashboard at `http://<tailscale-ip>:8088` instead of exposing to the internet.

## Verify

```bash
tailscale status
tailscale ip
```

## Notes

- Tailscale IPs are stable across reboots and network changes — prefer them over LAN IPs for cross-device config once all devices are on the tailnet.
- Optional: set up Tailscale SSH (`tailscale up --ssh`) to replace traditional SSH key management for tailnet devices.
