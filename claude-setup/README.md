# Claude Setup

Get Claude Code installed and configured so it can assist with the rest of machine setup.

---

## 1. Install Claude Code

```bash
npm install -g @anthropic-ai/claude-code
```

Requires Node.js. If not installed:
- **Windows**: `winget install OpenJS.NodeJS`
- **Linux**: `sudo apt-get install -y nodejs npm` (or use [nvm](https://github.com/nvm-sh/nvm))

---

## 2. Install CLAUDE.md (global config)

Copy the template and update the username placeholder for your machine:

**Windows (PowerShell):**
```powershell
$dest = "$HOME\.claude"
if (-not (Test-Path $dest)) { New-Item -ItemType Directory -Path $dest }
Copy-Item "$HOME\claude-workspace\machine-setup\claude-setup\CLAUDE.md" "$dest\CLAUDE.md"
```

Then open `~\.claude\CLAUDE.md` and replace `<USERNAME>` with your Windows username (e.g. `Rocket`).

**Linux:**
```bash
mkdir -p ~/.claude
cp ~/claude-workspace/machine-setup/claude-setup/CLAUDE.md ~/.claude/CLAUDE.md
# No username placeholder needed on Linux — path uses ~ directly
```

---

## 3. Set up the `cld` alias

### Windows (PowerShell)

Add to your PowerShell profile (`$PROFILE`):
```powershell
# Append to profile
Add-Content $PROFILE "`nfunction cld { claude --dangerously-skip-permissions @args }"
```

Or manually add the line from `aliases/profile.ps1` to your `$PROFILE`.

### Linux / bash

Add to `~/.bashrc`:
```bash
echo "source ~/claude-workspace/machine-setup/claude-setup/aliases/aliases.sh" >> ~/.bashrc
source ~/.bashrc
```

---

## 4. Create workspace

**Windows:**
```powershell
New-Item -ItemType Directory -Force "$HOME\claude-workspace"
```

**Linux:**
```bash
mkdir -p ~/claude-workspace
```

---

## 5. Launch Claude

```bash
cld
```

Claude will read `~/.claude/CLAUDE.md` automatically on every session and have full context of your setup conventions.
