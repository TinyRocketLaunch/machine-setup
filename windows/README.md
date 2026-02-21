# Windows Dev Environment Setup

Post-Claude setup for a Windows machine. Claude can assist with most of this once `cld` is working.

## Essential tools

```powershell
winget install git.git
winget install GitHub.cli
winget install OpenJS.NodeJS
winget install Microsoft.VisualStudioCode
winget install Starship.Starship
winget install Tailscale.Tailscale
```

## PowerShell profile

Profile location: `$PROFILE`
(typically `C:\Users\<USERNAME>\Documents\WindowsPowerShell\Microsoft.PowerShell_profile.ps1`)

Recommended additions — see `claude-setup/aliases/profile.ps1` for the `cld` function.

Starship prompt init (add to profile):
```powershell
Invoke-Expression (&starship init powershell)
```

## SSH server (optional — enables inbound SSH from other devices)

See [ssh/README.md](../ssh/README.md) for full setup.

## Notes

- Windows OpenSSH capability install can fail on resource-constrained systems — DISM/SFC + reboot may be needed first.
- Run PowerShell as admin for capability installs; regular user for everything else.
