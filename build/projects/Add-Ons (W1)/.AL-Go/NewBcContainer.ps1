Param(
    [Hashtable]$parameters
)

# Determine the external dependencies
$customSettings = Get-Content -Path (Join-Path $PSScriptRoot "customSettings.json" -Resolve) | ConvertFrom-Json
$externalDependencies = $customSettings.ExternalAppDependencies

$script = Join-Path $PSScriptRoot "../../../scripts/NewBcContainer.ps1" -Resolve
. $script -parameters $parameters -keepApps $externalDependencies