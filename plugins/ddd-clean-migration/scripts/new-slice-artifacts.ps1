param(
    [Parameter(Mandatory = $true)]
    [string]$TargetRepo,

    [Parameter(Mandatory = $true)]
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
$targetRoot = (Resolve-Path $TargetRepo).Path
$slug = Get-Slug $BoundedContextName
$developRoot = Join-Path $targetRoot "$MigrationRoot\\bounded-contexts\\$slug\\03-develop"

Ensure-Directory $developRoot

Copy-TemplateFile (Join-Path $templateRoot "bounded-context\\03-develop\\README.md") (Join-Path $developRoot "README.md")
Copy-TemplateFile (Join-Path $templateRoot "bounded-context\\03-develop\\develop.md") (Join-Path $developRoot "develop.md")
Copy-TemplateFile (Join-Path $templateRoot "bounded-context\\03-develop\\validation.md") (Join-Path $developRoot "validation.md")

Write-Host "The script name is kept for backward compatibility."
Write-Host "It now ensures the 03-develop artifacts for the selected bounded context."
Write-Host ((Resolve-Path $developRoot).Path)
