Param(
    [Hashtable]$parameters
)

$projectSettings = Get-Content "$PSScriptRoot/settings.json" | ConvertFrom-Json
$customSettings = Get-Content -Path (Join-Path $PSScriptRoot "customSettings.json" -Resolve) | ConvertFrom-Json

$keepApps = $customSettings.ExternalAppDependencies
$useProjectDependencies = $projectSettings.useProjectDependencies

$script = Join-Path $PSScriptRoot "../../../scripts/NewBcContainer.ps1" -Resolve
. $script -parameters $parameters -keepApps $keepApps -useProjectDependencies $useProjectDependencies