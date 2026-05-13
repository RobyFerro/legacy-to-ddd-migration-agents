param(
    [Parameter(Mandatory = $true)]
    [string]$TargetRepo,

    [switch]$OverwriteAgentsMd
)

$ErrorActionPreference = "Stop"

$sourceRoot = Split-Path -Parent $MyInvocation.MyCommand.Path
$pluginRoot = Join-Path $sourceRoot "plugins\\ddd-clean-migration"
$targetRoot = Resolve-Path $TargetRepo

Write-Host "Installing Codex DDD/Clean Migration Kit into: $targetRoot"

New-Item -ItemType Directory -Force "$targetRoot\.codex\agents" | Out-Null
New-Item -ItemType Directory -Force "$targetRoot\.codex\skills" | Out-Null
New-Item -ItemType Directory -Force "$targetRoot\.codex\prompts" | Out-Null

Copy-Item "$pluginRoot\.codex\agents\*" "$targetRoot\.codex\agents\" -Recurse -Force
Copy-Item "$pluginRoot\.codex\prompts\*" "$targetRoot\.codex\prompts\" -Recurse -Force
Copy-Item "$pluginRoot\skills\*" "$targetRoot\.codex\skills\" -Recurse -Force

$agentsTarget = "$targetRoot\AGENTS.md"
if (!(Test-Path $agentsTarget) -or $OverwriteAgentsMd) {
    Copy-Item "$sourceRoot\AGENTS.template.md" $agentsTarget -Force
    Write-Host "AGENTS.md installed."
} else {
    Write-Host "AGENTS.md already exists. Skipped. Use -OverwriteAgentsMd to replace it."
}

$utf8NoBom = New-Object System.Text.UTF8Encoding($false)
Get-ChildItem "$targetRoot\.codex\skills" -Recurse -Filter "SKILL.md" | ForEach-Object {
    $content = Get-Content -Raw $_.FullName
    [System.IO.File]::WriteAllText($_.FullName, $content.TrimStart(), $utf8NoBom)
}

Write-Host "Installation completed."
