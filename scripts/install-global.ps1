$ErrorActionPreference = "Stop"

$scriptRoot = Split-Path -Parent $MyInvocation.MyCommand.Path
$sourceRoot = Split-Path -Parent $scriptRoot
$pluginRoot = Join-Path $sourceRoot "plugins\\ddd-clean-migration"
$codexHome = "$HOME\.codex"

Write-Host "Installing Codex DDD/Clean Migration Kit globally into: $codexHome"

New-Item -ItemType Directory -Force "$codexHome\skills" | Out-Null
New-Item -ItemType Directory -Force "$codexHome\prompts" | Out-Null
New-Item -ItemType Directory -Force "$codexHome\templates" | Out-Null
New-Item -ItemType Directory -Force "$codexHome\scripts" | Out-Null

Copy-Item "$pluginRoot\.codex\prompts\*" "$codexHome\prompts\" -Recurse -Force
Copy-Item "$pluginRoot\.codex\templates\*" "$codexHome\templates\" -Recurse -Force
Copy-Item "$pluginRoot\skills\*" "$codexHome\skills\" -Recurse -Force
Copy-Item "$pluginRoot\scripts\*" "$codexHome\scripts\" -Recurse -Force

$utf8NoBom = New-Object System.Text.UTF8Encoding($false)
Get-ChildItem "$codexHome\skills" -Recurse -Filter "SKILL.md" | ForEach-Object {
    $content = Get-Content -Raw $_.FullName
    [System.IO.File]::WriteAllText($_.FullName, $content.TrimStart(), $utf8NoBom)
}

Write-Host "Global installation completed."
Write-Host "Note: current Codex Desktop runtimes delegate with built-in subagent roles such as explorer/worker."
Write-Host "Use the installed skills and AGENTS guidance to make subagents act as legacy-discovery, ddd-design, or clean-migration-worker."
