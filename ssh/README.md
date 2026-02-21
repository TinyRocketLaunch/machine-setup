# SSH Setup

Cross-machine SSH configuration for the device ecosystem (Pi, PC, laptop).

## Shared key strategy

All machines use the same key pair: `raspberry_rig_ed25519`

- **Linux**: `~/.ssh/raspberry_rig_ed25519`
- **Windows**: `C:\Users\<USERNAME>\.ssh\raspberry_rig_ed25519`

Optional future improvement: rotate to per-device keys if stricter trust boundaries are needed.

---

## Canonical host aliases

Use `ssh <alias>` for LAN and `ssh <alias>-ts` for Tailscale from any device.

| Alias | LAN IP | Tailscale IP | User |
|-------|--------|-------------|------|
| `pi` / `pi-ts` | `10.0.0.49` | `100.72.127.67` | `rocket` |
| `pc` / `pc-ts` | `10.0.0.166` | `100.75.102.95` | `maver` |
| `laptop` / `laptop-ts` | `10.0.0.222` | `100.79.198.114` | `Rocket` |

### Laptop (`C:\Users\Rocket\.ssh\config`)
```
Host pi
    HostName 10.0.0.49
    User rocket
    IdentityFile ~/.ssh/raspberry_rig_ed25519
    IdentitiesOnly yes

Host pi-ts
    HostName 100.72.127.67
    User rocket
    IdentityFile ~/.ssh/raspberry_rig_ed25519
    IdentitiesOnly yes

Host pc
    HostName 10.0.0.166
    User maver
    IdentityFile ~/.ssh/raspberry_rig_ed25519
    IdentitiesOnly yes

Host pc-ts
    HostName 100.75.102.95
    User maver
    IdentityFile ~/.ssh/raspberry_rig_ed25519
    IdentitiesOnly yes
```

### Pi (`~/.ssh/config`)
```
Host pc
    HostName 10.0.0.166
    User maver
    IdentityFile ~/.ssh/raspberry_rig_ed25519
    IdentitiesOnly yes

Host pc-ts
    HostName 100.75.102.95
    User maver
    IdentityFile ~/.ssh/raspberry_rig_ed25519
    IdentitiesOnly yes

Host laptop
    HostName 10.0.0.222
    User Rocket
    IdentityFile ~/.ssh/raspberry_rig_ed25519
    IdentitiesOnly yes

Host laptop-ts
    HostName 100.79.198.114
    User Rocket
    IdentityFile ~/.ssh/raspberry_rig_ed25519
    IdentitiesOnly yes
```

### PC (`C:\Users\maver\.ssh\config`)
```
Host pi
    HostName 10.0.0.49
    User rocket
    IdentityFile ~/.ssh/raspberry_rig_ed25519
    IdentitiesOnly yes

Host pi-ts
    HostName 100.72.127.67
    User rocket
    IdentityFile ~/.ssh/raspberry_rig_ed25519
    IdentitiesOnly yes

Host laptop
    HostName 10.0.0.222
    User Rocket
    IdentityFile ~/.ssh/raspberry_rig_ed25519
    IdentitiesOnly yes

Host laptop-ts
    HostName 100.79.198.114
    User Rocket
    IdentityFile ~/.ssh/raspberry_rig_ed25519
    IdentitiesOnly yes
```

Note: `laptop` LAN alias may be stale if the laptop's LAN IP changes — Tailscale alias is more reliable for remote access.

---

## Windows: enable OpenSSH server

Run in **Admin PowerShell**:

```powershell
Add-WindowsCapability -Online -Name OpenSSH.Server~~~~0.0.1.0
Start-Service sshd
Set-Service -Name sshd -StartupType Automatic
if (-not (Get-NetFirewallRule -Name sshd -ErrorAction SilentlyContinue)) {
  New-NetFirewallRule -Name sshd -DisplayName "OpenSSH Server (sshd)" -Enabled True -Direction Inbound -Protocol TCP -Action Allow -LocalPort 22
}
```

### Add authorized key (Windows admin user)

> **Important:** On Windows, if the target account is in the Administrators group, key auth is read from `C:\ProgramData\ssh\administrators_authorized_keys` — NOT from `~\.ssh\authorized_keys` — unless `sshd_config` overrides the default `Match Group administrators` rule.

```powershell
$pub='ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIZCRolZivfa00w5kLzb34NPCU2UL5U5wIhsIwnoy3lg raspberry-rig'
$path='C:\ProgramData\ssh\administrators_authorized_keys'
if (Test-Path $path) {
  $existing = Get-Content $path
  if ($existing -notcontains $pub) { Add-Content -Path $path -Value $pub -Encoding ascii }
} else {
  Set-Content -Path $path -Value $pub -Encoding ascii
}
icacls $path /inheritance:r
icacls $path /grant:r "Administrators:F" "SYSTEM:F"
Restart-Service sshd
```

---

## Windows: fix broken key ACLs (client-side)

If SSH reports `Load key ... Permission denied`, run in PowerShell:

```powershell
$ssh = "$HOME\.ssh"
$u = "$env:USERDOMAIN\$env:USERNAME"
takeown /f $ssh /r /d y
icacls $ssh /inheritance:r /t
icacls $ssh /grant:r "${u}:(F)" /t
icacls $ssh /grant:r "SYSTEM:(F)" /t
```

Known risk: misapplied `icacls` can lock you out of key/config files until ownership/ACL is repaired. Run carefully.

---

## SSH keepalive (prevent drops)

On the **server** side (`/etc/ssh/sshd_config.d/60-keepalive.conf`):
```
ClientAliveInterval 60
ClientAliveCountMax 3
TCPKeepAlive yes
```

On the **client** side (`~/.ssh/config` per-host or globally):
```
ServerAliveInterval 60
ServerAliveCountMax 3
```

---

## Visual safety cue: red hostname in SSH sessions

Add to Starship config (`~/.config/starship.toml`) so remote shells are visually distinct:

```toml
[hostname]
ssh_only = true
style = "bold bright-red"
format = "[@$hostname]($style) "
```

Make sure `$hostname` is included in your main `format` chain.

---

## Risks / known issues

- Windows OpenSSH capability install can fail with resource errors — DISM/SFC cleanup and reboot may be required before retrying.
- Misapplied `icacls` can lock user out; repair via `takeown` before re-applying ACLs.
