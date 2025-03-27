[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', 'parameters', Justification = 'The parameter is not used, but it''s script needs to match this format')]
Param(
    [hashtable] $parameters
)

$projectSettings = Get-Content "$PSScriptRoot/settings.json" | ConvertFrom-Json
if ($projectSettings.useProjectDependencies -eq $false) {
    Import-TestToolkitToBcContainer @parameters
} else {
    # If using project dependencies we get the test toolkit from the project dependencies
    Write-Host "Project dependencies are enabled, skipping importing test toolkit"
}