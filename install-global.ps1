$ErrorActionPreference = "Stop"

$sourceRoot = Split-Path -Parent $MyInvocation.MyCommand.Path
$pluginRoot = Join-Path $sourceRoot "plugins\\ddd-clean-migration"
$codexHome = "$HOME\.codex"

Write-Host "Installing Codex DDD/Clean Migration Kit globally into: $codexHome"

New-Item -ItemType Directory -Force "$codexHome\agents" | Out-Null
New-Item -ItemType Directory -Force "$codexHome\skills" | Out-Null

Copy-Item "$pluginRoot\.codex\agents\*" "$codexHome\agents\" -Recurse -Force
Copy-Item "$pluginRoot\skills\*" "$codexHome\skills\" -Recurse -Force

$utf8NoBom = New-Object System.Text.UTF8Encoding($false)
Get-ChildItem "$codexHome\skills" -Recurse -Filter "SKILL.md" | ForEach-Object {
    $content = Get-Content -Raw $_.FullName
    [System.IO.File]::WriteAllText($_.FullName, $content.TrimStart(), $utf8NoBom)
}

Write-Host "Global installation completed."
