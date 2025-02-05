[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', 'parameters', Justification = 'The parameter is not used, but it''s script needs to match this format')]
Param(
    [hashtable] $parameters
)

Import-TestToolkitToBcContainer @parameters

Import-Module (Join-Path $PSScriptRoot "../../../scripts/DevEnv/NewDevContainer.psm1" -Resolve)
Setup-ContainerForDevelopment -ContainerName $parameters.ContainerName -RepoVersion "26.0"

$installedApps = Get-BcContainerAppInfo -containerName $parameters.ContainerName -tenantSpecificProperties -sort DependenciesLast
$installedApps | ForEach-Object {
    Write-Host "$($_.Name) - $($_.Version) - $($_.Tenant) - $($_.IsPublished) / $($_.IsInstalled)"
}