$ErrorActionPreference = "Stop"

$sourceRoot = Split-Path -Parent $MyInvocation.MyCommand.Path
$codexHome = "$HOME\.codex"

Write-Host "Installing Codex DDD/Clean Migration Kit globally into: $codexHome"

New-Item -ItemType Directory -Force "$codexHome\agents" | Out-Null
New-Item -ItemType Directory -Force "$codexHome\skills" | Out-Null

Copy-Item "$sourceRoot\.codex\agents\*" "$codexHome\agents\" -Recurse -Force
Copy-Item "$sourceRoot\skills\*" "$codexHome\skills\" -Recurse -Force

$utf8NoBom = New-Object System.Text.UTF8Encoding($false)
Get-ChildItem "$codexHome\skills" -Recurse -Filter "SKILL.md" | ForEach-Object {
    $content = Get-Content -Raw $_.FullName
    [System.IO.File]::WriteAllText($_.FullName, $content.TrimStart(), $utf8NoBom)
}

Write-Host "Global installation completed."
