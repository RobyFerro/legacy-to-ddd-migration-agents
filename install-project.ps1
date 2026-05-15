# Thin wrapper around scripts/install-project.ps1
# This file maintains backward compatibility with scripts called from the repository root.

param(
    [Parameter(Mandatory = $true)]
    [string]$TargetRepo,

    [switch]$OverwriteAgentsMd
)

$scriptRoot = Split-Path -Parent $MyInvocation.MyCommand.Path
$delegateScript = Join-Path $scriptRoot "scripts\install-project.ps1"

& $delegateScript -TargetRepo $TargetRepo @( if ($OverwriteAgentsMd) { "-OverwriteAgentsMd" } )
