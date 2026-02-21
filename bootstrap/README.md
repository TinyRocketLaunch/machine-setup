# Bootstrap (Pre-Claude)

Get git and GitHub CLI working so you can clone `machine-setup` and hand off to Claude.

---

## Windows

### 1. Install git and GitHub CLI

Open PowerShell (no admin needed):

```powershell
winget install git.git
winget install GitHub.cli
```

Close and reopen PowerShell after install.

### 2. Authenticate GitHub CLI

```powershell
gh auth login
```

Choose: **GitHub.com → HTTPS → Login with a web browser**

### 3. Clone machine-setup

```powershell
gh repo clone TinyRocketLaunch/machine-setup "$HOME\claude-workspace\machine-setup"
```

### 4. Hand off to Claude

Follow **[claude-setup/](../claude-setup/)** to install and configure Claude Code. Claude will assist with the rest of this guide.

---

## Linux

### 1. Install git and GitHub CLI

**Debian/Ubuntu/Raspberry Pi OS:**
```bash
sudo apt-get update
sudo apt-get install -y git gh
```

**Or via official GitHub CLI repo if `gh` is unavailable:**
```bash
curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null
sudo apt-get update && sudo apt-get install -y gh
```

### 2. Authenticate GitHub CLI

```bash
gh auth login
```

Choose: **GitHub.com → HTTPS → Login with a web browser** (or paste token)

### 3. Clone machine-setup

```bash
gh repo clone TinyRocketLaunch/machine-setup ~/claude-workspace/machine-setup
```

### 4. Hand off to Claude

Follow **[claude-setup/](../claude-setup/)** to install and configure Claude Code.
