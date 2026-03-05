# WezTerm + PowerShell (Windows-only)

This folder is the authoritative, reproducible setup for the current Windows WezTerm workflow.

Do not use this as-is on Linux. A Linux-specific variant should live separately.

## What this config provides

- Fancy tab bar with normal tab look.
- `+` button visible in tab bar.
- Right-click on `+` opens a feature menu:
  - New tab
  - Split horizontal / vertical
  - Move pane to new tab
  - Close current pane
  - Launcher menu
  - Command palette
- Date/time in top-right status area (left of Windows window controls).
- Native Windows title buttons on top-right (`minimize`, `maximize`, `close`).
- Right-click in terminal opens `Copy / Cut / Paste` menu.
- Keybindings:
  - `Ctrl+Shift+W` close current tab (no confirm)
  - `Ctrl+Shift+Q` close current pane (no confirm)
  - `Ctrl+Shift+Y` move current pane to a new tab
  - `Alt+Shift+-` split horizontal
  - `Alt+Shift+=` split vertical
  - `Ctrl+Shift+-` decrease font size
  - `Ctrl+Shift+=` increase font size

## Files in this folder

- `wezterm.lua` - Copyable config for `C:\Users\<USERNAME>\.wezterm.lua`.
- `apply-full-setup.ps1` - One-shot setup (copy config, apply icon, validate, reload).
- `apply-taskbar-icon.ps1` - Applies the repo icon to Start Menu + pinned taskbar WezTerm shortcuts.
- `icons/*.ico` - Icon library. Script auto-selects the newest `.ico` by modified time.

## Prerequisites (Windows-specific)

1. Install WezTerm:
```powershell
winget install --id Wez.WezTerm -e
```

2. Install font used by config:
```powershell
winget install --id JetBrains.JetBrainsMonoNerdFont -e
```

3. Optional tools used by one launcher shortcut:
```powershell
winget install --id sharkdp.fd -e
winget install --id junegunn.fzf -e
```

## Install steps (Windows-specific)

Recommended one-shot setup:
```powershell
powershell -ExecutionPolicy Bypass -File "$HOME\Documents\codex-workspace\machine-setup\windows\wezterm-pwrshell\apply-full-setup.ps1" -InstallPrereqs
```

If WezTerm and dependencies are already installed, omit prereq install:
```powershell
powershell -ExecutionPolicy Bypass -File "$HOME\Documents\codex-workspace\machine-setup\windows\wezterm-pwrshell\apply-full-setup.ps1"
```

Manual path (if needed):

1. Copy config from this repo to your home directory:
```powershell
Copy-Item "$HOME\\Documents\\codex-workspace\\machine-setup\\windows\\wezterm-pwrshell\\wezterm.lua" "$HOME\\.wezterm.lua" -Force
```

2. Optional wallpapers for background rotation:
- Put images in `$HOME\Pictures\WezTerm\` named:
  - `cyberpunk-tech.jpg`
  - `cyberpunk-neon-city.jpg`
  - `tonystark-lab.jpg`
- If these files do not exist, replace `wallpapers` entries in `.wezterm.lua` with files that do.

3. Reload WezTerm config:
```powershell
wezterm cli reload-config
```

## Taskbar icon setup (Windows-specific)

Apply the icon shipped in this folder:

```powershell
powershell -ExecutionPolicy Bypass -File "$HOME\Documents\codex-workspace\machine-setup\windows\wezterm-pwrshell\apply-taskbar-icon.ps1"
```

If Windows still shows the old icon immediately, unpin/re-pin WezTerm once.

### Icon note

- `apply-taskbar-icon.ps1` auto-selects the newest icon in `icons/` unless `-IconPath` is passed.
- To force a specific icon: `-IconPath <path-to-ico>`.

## Validation checklist

Run:
```powershell
wezterm --config-file "$HOME\\.wezterm.lua" show-keys
```

Confirm:
- `Ctrl+Shift+W` maps to `CloseCurrentTab { confirm: false }`.
- `Ctrl+Shift+Q` maps to `CloseCurrentPane { confirm: false }`.
- `Shift+Alt Minus (Physical)` maps to split horizontal.
- `Shift+Alt Equal (Physical)` maps to split vertical.

Note:
- `wezterm show-keys` can display some `Ctrl+Shift+<letter>` mappings as `Ctrl+<letter>` due to key normalization on Windows.

## Successes (implemented and working)

- Integrated Windows titlebar buttons are present with `window_decorations = 'INTEGRATED_BUTTONS|RESIZE'`.
- `+` right-click feature menu works and left-click still opens a new tab.
- Pane move to new tab works through callback (`pane:move_to_new_tab()`).
- Right-click terminal clipboard menu works.

## Limitations / unavailable features

- `show_close_tab_button_in_tabs` is unavailable in current WezTerm build; leaving it in config causes startup error.
- Per-item styling (outline/button appearance) is not available for `InputSelector` entries.
- `InputSelector` pointer behavior (menu dismiss sensitivity while moving mouse) is not configurable.
- Direct `MovePaneToNewTab` key assignment variant is unavailable in this build; callback method is used instead.

## Recovery

If WezTerm fails to start due to config changes:

1. Launch without config:
```powershell
wezterm -n
```

2. Validate config parse:
```powershell
wezterm --config-file "$HOME\\.wezterm.lua" ls-fonts
```

3. Re-copy known-good config from this folder, then reload.
