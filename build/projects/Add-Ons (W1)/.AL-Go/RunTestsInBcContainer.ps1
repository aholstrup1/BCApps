Param(
    [Hashtable]$parameters
)

# Reinstall all the apps we uninstalled
$allAppsInEnvironment = Get-BcContainerAppInfo -containerName $parameters.ContainerName -tenantSpecificProperties -sort DependenciesFirst
foreach ($app in $allAppsInEnvironment) {
    $isAppAlreadyInstalled = $allAppsInEnvironment | Where-Object { ($($_.Name) -eq $app.Name) -and ($_.IsInstalled -eq $true) }
    if (($app.IsInstalled -eq $true) -or ($isAppAlreadyInstalled)) {
        Write-Host "$($app.Name) is already installed"
    } else {
        Write-Host "Re-Installing $($app.Name)"
        Sync-BcContainerApp -containerName $parameters.ContainerName -appName $app.Name -appPublisher $app.Publisher -Mode ForceSync -Force
        Install-BcContainerApp -containerName $parameters.ContainerName -appName $app.Name -appPublisher $app.Publisher -appVersion $app.Version -Force
    }
}

# START LOGGING: Print all installed apps TODO
foreach ($app in (Get-BcContainerAppInfo -containerName $parameters.ContainerName -tenantSpecificProperties -sort DependenciesLast)) {
    Write-Host "App: $($app.Name) ($($app.Version)) - Scope: $($app.Scope) - $($app.IsInstalled) / $($app.IsPublished)"
}
# END LOGGING

$script = Join-Path $PSScriptRoot "../../../scripts/RunTestsInBcContainer.ps1" -Resolve
. $script -parameters $parameters