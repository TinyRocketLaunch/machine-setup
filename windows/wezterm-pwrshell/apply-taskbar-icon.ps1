param(
  [string]$IconPath = "$PSScriptRoot\icons\wezterm_neon_icon.ico"
)

$ErrorActionPreference = 'Stop'

if (-not (Test-Path $IconPath)) {
  throw "Icon file not found: $IconPath"
}

$weztermCandidates = @(
  "$env:ProgramFiles\WezTerm\wezterm-gui.exe",
  "$env:LOCALAPPDATA\Programs\WezTerm\wezterm-gui.exe"
)
$weztermExe = $weztermCandidates | Where-Object { Test-Path $_ } | Select-Object -First 1
if (-not $weztermExe) {
  throw 'WezTerm executable not found.'
}

$shell = New-Object -ComObject WScript.Shell

$startShortcut = "$env:APPDATA\Microsoft\Windows\Start Menu\Programs\WezTerm.lnk"
$start = $shell.CreateShortcut($startShortcut)
$start.TargetPath = $weztermExe
$start.WorkingDirectory = $HOME
$start.IconLocation = "$IconPath,0"
$start.Save()

$taskbarDir = "$env:APPDATA\Microsoft\Internet Explorer\Quick Launch\User Pinned\TaskBar"
if (Test-Path $taskbarDir) {
  $taskbarLinks = Get-ChildItem $taskbarDir -Filter *.lnk | Where-Object { $_.Name -match 'wezterm' }
  foreach ($link in $taskbarLinks) {
    $lnk = $shell.CreateShortcut($link.FullName)
    $lnk.IconLocation = "$IconPath,0"
    $lnk.Save()
  }
}

Write-Output "Applied icon: $IconPath"
Write-Output "Start shortcut: $startShortcut"
Write-Output "WezTerm exe: $weztermExe"
Write-Output 'If taskbar icon cache is stale, unpin/re-pin WezTerm once.'
