$ErrorActionPreference = "Stop"

$scriptRoot = Split-Path -Parent $MyInvocation.MyCommand.Path
$sourceRoot = Split-Path -Parent $scriptRoot
$pluginRoot = Join-Path $sourceRoot "plugins\\ddd-clean-migration"
$codexHome = "$HOME\.codex"

Write-Host "Cleaning plugin-managed Codex directories in: $codexHome"

$managedPaths = @(
    (Join-Path $codexHome "agents"),
    (Join-Path $codexHome "prompts"),
    (Join-Path $codexHome "templates"),
    (Join-Path $codexHome "scripts")
)

foreach ($path in $managedPaths) {
    if (Test-Path $path) {
        Remove-Item -Recurse -Force $path
    }
}

$managedSkills = @(
    "architecture-validation",
    "clean-architecture-boundaries",
    "ddd-aggregate-design",
    "legacy-business-logic-extraction",
    "migration-slice-planning",
    "migration-code-guardrails"
)

$skillsRoot = Join-Path $codexHome "skills"
foreach ($skillName in $managedSkills) {
    $skillPath = Join-Path $skillsRoot $skillName
    if (Test-Path $skillPath) {
        Remove-Item -Recurse -Force $skillPath
    }
}

Write-Host "Reinstalling plugin content from: $pluginRoot"
& (Join-Path $scriptRoot "install-global.ps1")
