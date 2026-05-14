param(
    [Parameter(Mandatory = $true)]
    [string]$TargetRepo,

    [string]$BoundedContextName,

    [string]$MigrationRoot = "migration"
)

$ErrorActionPreference = "Stop"

function Ensure-Directory {
    param([string]$Path)
    New-Item -ItemType Directory -Force -Path $Path | Out-Null
}

function Copy-TemplateFile {
    param(
        [string]$SourcePath,
        [string]$DestinationPath
    )

    if (!(Test-Path $DestinationPath)) {
        Copy-Item $SourcePath $DestinationPath -Force
    }
}

function Get-Slug {
    param([string]$Value)

    $slug = $Value.ToLowerInvariant() -replace "[^a-z0-9]+", "-"
    $slug = $slug.Trim("-")
    if ([string]::IsNullOrWhiteSpace($slug)) {
        throw "Unable to derive a bounded-context slug from '$Value'."
    }
    return $slug
}

$scriptRoot = Split-Path -Parent $MyInvocation.MyCommand.Path
$templateRoot = Join-Path (Split-Path -Parent $scriptRoot) ".codex\\templates"
Ensure-Directory $TargetRepo
$targetRoot = (Resolve-Path $TargetRepo).Path
$migrationPath = Join-Path $targetRoot $MigrationRoot
$systemRoot = Join-Path $migrationPath "00-system"
$boundedContextsRoot = Join-Path $migrationPath "bounded-contexts"
$safeAreaRoot = Join-Path $migrationPath "safe-area"

Ensure-Directory $migrationPath
Ensure-Directory $systemRoot
Ensure-Directory $boundedContextsRoot
Ensure-Directory $safeAreaRoot
Ensure-Directory (Join-Path $safeAreaRoot "src")
Ensure-Directory (Join-Path $safeAreaRoot "tests")

Copy-TemplateFile (Join-Path $templateRoot "migration-project.yaml") (Join-Path $migrationPath "migration-project.yaml")
Copy-TemplateFile (Join-Path $templateRoot "00-system\\bounded-context-catalog.md") (Join-Path $systemRoot "bounded-context-catalog.md")
Copy-TemplateFile (Join-Path $templateRoot "00-system\\bounded-context-catalog.yaml") (Join-Path $systemRoot "bounded-context-catalog.yaml")
Copy-TemplateFile (Join-Path $templateRoot "00-system\\context-map.md") (Join-Path $systemRoot "context-map.md")
Copy-TemplateFile (Join-Path $templateRoot "safe-area\\README.md") (Join-Path $safeAreaRoot "README.md")
Copy-TemplateFile (Join-Path $templateRoot "safe-area\\src\\README.md") (Join-Path $safeAreaRoot "src\\README.md")
Copy-TemplateFile (Join-Path $templateRoot "safe-area\\tests\\README.md") (Join-Path $safeAreaRoot "tests\\README.md")

if ($BoundedContextName) {
    $slug = Get-Slug $BoundedContextName
    $bcRoot = Join-Path $boundedContextsRoot $slug
    $bcSafeAreaRoot = Join-Path $safeAreaRoot $slug

    Ensure-Directory $bcRoot
    Ensure-Directory $bcSafeAreaRoot
    Ensure-Directory (Join-Path $bcSafeAreaRoot "src")
    Ensure-Directory (Join-Path $bcSafeAreaRoot "src\\Domain")
    Ensure-Directory (Join-Path $bcSafeAreaRoot "src\\Application")
    Ensure-Directory (Join-Path $bcSafeAreaRoot "src\\Infrastructure")
    Ensure-Directory (Join-Path $bcSafeAreaRoot "src\\Presentation")
    Ensure-Directory (Join-Path $bcSafeAreaRoot "tests")

    Copy-TemplateFile (Join-Path $templateRoot "bounded-context\\01-discovery.md") (Join-Path $bcRoot "01-discovery.md")
    Copy-TemplateFile (Join-Path $templateRoot "bounded-context\\01-discovery.yaml") (Join-Path $bcRoot "01-discovery.yaml")
    Copy-TemplateFile (Join-Path $templateRoot "bounded-context\\02-design.md") (Join-Path $bcRoot "02-design.md")
    Copy-TemplateFile (Join-Path $templateRoot "bounded-context\\02-model.yaml") (Join-Path $bcRoot "02-model.yaml")
    Copy-TemplateFile (Join-Path $templateRoot "bounded-context\\03-migration-plan.md") (Join-Path $bcRoot "03-migration-plan.md")
    Copy-TemplateFile (Join-Path $templateRoot "bounded-context\\04-implementation-notes.md") (Join-Path $bcRoot "04-implementation-notes.md")
    Copy-TemplateFile (Join-Path $templateRoot "bounded-context\\05-validation.md") (Join-Path $bcRoot "05-validation.md")
}

Write-Host "Migration workspace ready at $migrationPath"
