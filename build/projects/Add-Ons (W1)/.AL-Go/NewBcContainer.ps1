Param(
    [Hashtable]$parameters
)
$keepApps = @()

$projectSettings = Get-Content (Join-Path $PSScriptRoot "settings.json" -Resolve) | ConvertFrom-Json
if ($projectSettings.useProjectDependencies -eq $false) {
    $keepApps = @("System Application", "Business Foundation", "Base Application", "Application")
}

$script = Join-Path $PSScriptRoot "../../../scripts/NewBcContainer.ps1" -Resolve
. $script -parameters $parameters -keepApps $keepApps