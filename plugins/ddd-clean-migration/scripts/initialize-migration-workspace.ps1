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
$newProjectsRoot = Join-Path $migrationPath "new-projects"

Ensure-Directory $migrationPath
Ensure-Directory $systemRoot
Ensure-Directory $boundedContextsRoot
Ensure-Directory $newProjectsRoot

Copy-TemplateFile (Join-Path $templateRoot "migration-project.yaml") (Join-Path $migrationPath "migration-project.yaml")
Copy-TemplateFile (Join-Path $templateRoot "00-system\\bounded-context-catalog.md") (Join-Path $systemRoot "bounded-context-catalog.md")
Copy-TemplateFile (Join-Path $templateRoot "00-system\\bounded-context-catalog.yaml") (Join-Path $systemRoot "bounded-context-catalog.yaml")
Copy-TemplateFile (Join-Path $templateRoot "00-system\\context-map.md") (Join-Path $systemRoot "context-map.md")
Copy-TemplateFile (Join-Path $templateRoot "new-projects\\README.md") (Join-Path $newProjectsRoot "README.md")

if ($BoundedContextName) {
    $slug = Get-Slug $BoundedContextName
    $bcRoot = Join-Path $boundedContextsRoot $slug
    $bcProjectRoot = Join-Path $newProjectsRoot $slug

    Ensure-Directory $bcRoot

    Ensure-Directory (Join-Path $bcRoot "01-discovery")
    Ensure-Directory (Join-Path $bcRoot "02-design")
    Ensure-Directory (Join-Path $bcRoot "03-develop")

    Copy-TemplateFile (Join-Path $templateRoot "bounded-context\\01-discovery\\discovery.md") (Join-Path $bcRoot "01-discovery\\discovery.md")
    Copy-TemplateFile (Join-Path $templateRoot "bounded-context\\01-discovery\\discovery.yaml") (Join-Path $bcRoot "01-discovery\\discovery.yaml")
    Copy-TemplateFile (Join-Path $templateRoot "bounded-context\\02-design\\design.md") (Join-Path $bcRoot "02-design\\design.md")
    Copy-TemplateFile (Join-Path $templateRoot "bounded-context\\02-design\\model.yaml") (Join-Path $bcRoot "02-design\\model.yaml")
    Copy-TemplateFile (Join-Path $templateRoot "bounded-context\\03-develop\\README.md") (Join-Path $bcRoot "03-develop\\README.md")
    Copy-TemplateFile (Join-Path $templateRoot "bounded-context\\03-develop\\develop.md") (Join-Path $bcRoot "03-develop\\develop.md")
    Copy-TemplateFile (Join-Path $templateRoot "bounded-context\\03-develop\\validation.md") (Join-Path $bcRoot "03-develop\\validation.md")

    Ensure-Directory $bcProjectRoot
    Ensure-Directory (Join-Path $bcProjectRoot "src")
    Ensure-Directory (Join-Path $bcProjectRoot "src\\Domain")
    Ensure-Directory (Join-Path $bcProjectRoot "src\\Application")
    Ensure-Directory (Join-Path $bcProjectRoot "src\\Infrastructure")
    Ensure-Directory (Join-Path $bcProjectRoot "src\\Presentation")
    Ensure-Directory (Join-Path $bcProjectRoot "tests")
    Copy-TemplateFile (Join-Path $templateRoot "new-projects\\bounded-context-project\\README.md") (Join-Path $bcProjectRoot "README.md")
    Copy-TemplateFile (Join-Path $templateRoot "new-projects\\bounded-context-project\\src\\README.md") (Join-Path $bcProjectRoot "src\\README.md")
    Copy-TemplateFile (Join-Path $templateRoot "new-projects\\bounded-context-project\\tests\\README.md") (Join-Path $bcProjectRoot "tests\\README.md")

    Write-Host "Clean Architecture layers scaffolded for bounded context '$slug'."
    Write-Host "Layers: Domain, Application, Infrastructure, Presentation"
} else {
    Write-Host "Target-system workspace created without a bounded context scaffold."
    Write-Host "To generate DISCOVERY, DESIGN, and DEVELOP artifacts, rerun with -BoundedContextName <Name>."
}

Write-Host "Workspace ready at $migrationPath with DISCOVERY, DESIGN, and DEVELOP phase structure."
