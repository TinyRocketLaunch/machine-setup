param(
  [switch]$InstallPrereqs
)

$ErrorActionPreference = 'Stop'

$root = $PSScriptRoot
$home = $HOME
$repoConfig = Join-Path $root 'wezterm.lua'
$targetConfig = Join-Path $home '.wezterm.lua'
$iconScript = Join-Path $root 'apply-taskbar-icon.ps1'

if ($InstallPrereqs) {
  winget install --id Wez.WezTerm -e --accept-package-agreements --accept-source-agreements
  winget install --id JetBrains.JetBrainsMonoNerdFont -e --accept-package-agreements --accept-source-agreements
  winget install --id sharkdp.fd -e --accept-package-agreements --accept-source-agreements
  winget install --id junegunn.fzf -e --accept-package-agreements --accept-source-agreements
}

if (-not (Test-Path $repoConfig)) {
  throw "Missing config template: $repoConfig"
}

Copy-Item $repoConfig $targetConfig -Force

if (Test-Path $iconScript) {
  powershell -ExecutionPolicy Bypass -File $iconScript
}

$wallpaperDir = Join-Path $home 'Pictures\WezTerm'
$expectedWallpapers = @(
  'cyberpunk-tech.jpg',
  'cyberpunk-neon-city.jpg',
  'tonystark-lab.jpg'
)
$missing = @()
foreach ($name in $expectedWallpapers) {
  $path = Join-Path $wallpaperDir $name
  if (-not (Test-Path $path)) {
    $missing += $path
  }
}

if ($missing.Count -gt 0) {
  Write-Warning 'Wallpaper files are missing. Background image layers may fail until files are added:'
  $missing | ForEach-Object { Write-Warning " - $_" }
}

try {
  wezterm --config-file $targetConfig ls-fonts | Out-Null
} catch {
  throw "WezTerm config validation failed for $targetConfig. $($_.Exception.Message)"
}

try {
  wezterm cli reload-config
} catch {
  Write-Warning 'WezTerm reload failed (likely no running instance). Start or restart WezTerm manually.'
}

Write-Output "Applied WezTerm config: $targetConfig"
Write-Output 'Setup complete.'
