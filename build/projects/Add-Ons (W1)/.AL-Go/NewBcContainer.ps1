Param(
    [Hashtable]$parameters
)

$projectSettings = Get-Content "$PSScriptRoot/settings.json" | ConvertFrom-Json

$keepApps = @()
$useProjectDependencies = $projectSettings.useProjectDependencies
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
} else {
    # We want to use the apps built in BCApps as project dependencies
    # We need to keep the base app in the container
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
. $script -parameters $parameters -keepApps $keepApps -useProjectDependencies $useProjectDependencies