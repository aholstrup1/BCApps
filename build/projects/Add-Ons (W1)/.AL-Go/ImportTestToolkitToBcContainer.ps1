[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', 'parameters', Justification = 'The parameter is not used, but it''s script needs to match this format')]
Param(
    [hashtable] $parameters
)

# Print all installed apps 
$installedApps = Get-BcContainerAppInfo -containerName $parameters.containerName -tenantSpecificProperties -sort DependenciesLast
foreach($app in $installedApps) {
    Write-Host "$($app.Name) - $($app.Version) - $($app.Scope) - $($app.Tenant) - $($app.IsPublished) - $($app.IsInstalled)"
}

#Import-TestToolkitToBcContainer @parameters

# Ordered list of test framework apps to install
$allApps = (Invoke-ScriptInBCContainer -containerName $containerName -scriptblock { Get-ChildItem -Path "C:\Applications\" -Filter "*.app" -Recurse })
$testToolkitApps = @(
    "Tests-TestLibraries"
)

foreach ($app in $testToolkitApps) {
    $appFile = $allApps | Where-Object { $($_.Name) -eq "Microsoft_$($app).app" }
    Publish-BcContainerApp -containerName $containerName -appFile ":$($appFile.FullName)" -skipVerification -scope Global -install -sync
    $appFile = $null
} 