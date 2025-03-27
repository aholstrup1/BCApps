Param(
    [Hashtable]$parameters
)

# Determine UseProjectDependencies
$projectSettings = Get-Content "$PSScriptRoot/settings.json" | ConvertFrom-Json
$useProjectDependencies = $projectSettings.useProjectDependencies

# Determine the external dependencies
$customSettings = Get-Content -Path (Join-Path $PSScriptRoot "customSettings.json" -Resolve) | ConvertFrom-Json
$keepApps = $customSettings.ExternalAppDependencies

$script = Join-Path $PSScriptRoot "../../../scripts/NewBcContainer.ps1" -Resolve
. $script -parameters $parameters -keepApps $keepApps -useProjectDependencies $useProjectDependencies