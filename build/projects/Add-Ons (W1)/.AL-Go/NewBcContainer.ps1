Param(
    [Hashtable]$parameters
)

$projectSettings = Get-Content "$PSScriptRoot/settings.json" | ConvertFrom-Json

$keepApps = @()
if ($projectSettings.useProjectDependencies -eq $false) {
    $keepApps = @(
        "System Application",
        "Business Foundation", 
        "Base Application", 
        "Application",
        "Any",
        "Library Assert",
        "Library Variable Storage",
        "System Application Test Library",
        "Tests-TestLibraries"
    )
}

$script = Join-Path $PSScriptRoot "../../../scripts/NewBcContainer.ps1" -Resolve
. $script -parameters $parameters -keepApps $keepApps