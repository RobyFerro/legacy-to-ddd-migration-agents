param(
    [Parameter(Mandatory = $true)]
    [string]$TargetRepo,

    [Parameter(Mandatory = $true)]
    [string]$BoundedContextName,

    [string]$MigrationRoot = "migration",

    [string]$SliceId
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

function Get-NextSliceId {
    param([string]$SlicesRoot)

    if (!(Test-Path $SlicesRoot)) {
        return "slice-001"
    }

    $existing = @(
        Get-ChildItem -Path $SlicesRoot -Directory -ErrorAction SilentlyContinue |
            ForEach-Object {
                if ($_.Name -match '^slice-(\d{3})$') {
                    [int]$matches[1]
                }
            }
    )

    if (!$existing -or $existing.Count -eq 0) {
        return "slice-001"
    }

    $next = [int](($existing | Measure-Object -Maximum).Maximum + 1)
    return ("slice-" + $next.ToString("D3"))
}

$scriptRoot = Split-Path -Parent $MyInvocation.MyCommand.Path
$templateRoot = Join-Path (Split-Path -Parent $scriptRoot) ".codex\\templates"
$targetRoot = (Resolve-Path $TargetRepo).Path
$slug = Get-Slug $BoundedContextName
$slicesRoot = Join-Path $targetRoot "$MigrationRoot\\bounded-contexts\\$slug\\04-implementation\\slices"

Ensure-Directory $slicesRoot

if ([string]::IsNullOrWhiteSpace($SliceId)) {
    $SliceId = Get-NextSliceId $slicesRoot
}

$sliceRoot = Join-Path $slicesRoot $SliceId
Ensure-Directory $sliceRoot

Copy-TemplateFile (Join-Path $templateRoot "bounded-context\\04-implementation\\slices\\slice-template\\slice.md") (Join-Path $sliceRoot "slice.md")
Copy-TemplateFile (Join-Path $templateRoot "bounded-context\\04-implementation\\slices\\slice-template\\traceability.md") (Join-Path $sliceRoot "traceability.md")
Copy-TemplateFile (Join-Path $templateRoot "bounded-context\\04-implementation\\slices\\slice-template\\validation.md") (Join-Path $sliceRoot "validation.md")
Copy-TemplateFile (Join-Path $templateRoot "bounded-context\\04-implementation\\slices\\slice-template\\handoff.md") (Join-Path $sliceRoot "handoff.md")

Write-Host ((Resolve-Path $sliceRoot).Path)
