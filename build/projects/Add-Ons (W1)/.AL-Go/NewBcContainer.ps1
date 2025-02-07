Param(
    [Hashtable]$parameters
)

$externalDependencies = (Get-Content (Join-Path $PSScriptRoot "customSettings.json" -Resolve) | ConvertFrom-Json).ExternalAppDependencies

$script = Join-Path $PSScriptRoot "../../../scripts/NewBcContainer.ps1" -Resolve
. $script -parameters $parameters -keepApps $externalDependencies