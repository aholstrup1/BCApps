[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', 'parameters', Justification = 'The parameter is not used, but it''s script needs to match this format')]
Param(
    [hashtable] $parameters
)

# Print all installed apps 
$installedApps = Get-BcContainerAppInfo -containerName $parameters.containerName -tenantSpecificProperties -sort DependenciesLast
foreach($app in $installedApps) {
    Write-Host "$($app.Name) - $($app.Version) - $($app.Scope) - $($app.Tenant) - $($app.IsPublished) - $($app.IsInstalled)"
}

$parameters.scope = "Tenant"

Import-TestToolkitToBcContainer @parameters