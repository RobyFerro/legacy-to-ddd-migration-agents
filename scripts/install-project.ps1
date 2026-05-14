param(
    [Parameter(Mandatory = $true)]
    [string]$TargetRepo,

    [switch]$OverwriteAgentsMd
)

$ErrorActionPreference = "Stop"

$scriptRoot = Split-Path -Parent $MyInvocation.MyCommand.Path
$sourceRoot = Split-Path -Parent $scriptRoot
$pluginRoot = Join-Path $sourceRoot "plugins\\ddd-clean-migration"
$targetRoot = Resolve-Path $TargetRepo

Write-Host "Installing Codex DDD/Clean Migration Kit into: $targetRoot"

New-Item -ItemType Directory -Force "$targetRoot\.codex\skills" | Out-Null
New-Item -ItemType Directory -Force "$targetRoot\.codex\prompts" | Out-Null
New-Item -ItemType Directory -Force "$targetRoot\.codex\templates" | Out-Null
New-Item -ItemType Directory -Force "$targetRoot\.codex\scripts" | Out-Null

Copy-Item "$pluginRoot\.codex\prompts\*" "$targetRoot\.codex\prompts\" -Recurse -Force
Copy-Item "$pluginRoot\.codex\templates\*" "$targetRoot\.codex\templates\" -Recurse -Force
Copy-Item "$pluginRoot\skills\*" "$targetRoot\.codex\skills\" -Recurse -Force
Copy-Item "$pluginRoot\scripts\*" "$targetRoot\.codex\scripts\" -Recurse -Force

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
Write-Host "Note: current Codex Desktop runtimes delegate with built-in subagent roles such as explorer/worker."
Write-Host "Use the installed skills and AGENTS.md guidance to make subagents act as legacy-discovery, ddd-design, or clean-migration-worker."
