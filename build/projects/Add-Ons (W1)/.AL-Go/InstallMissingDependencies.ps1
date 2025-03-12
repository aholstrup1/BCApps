Param(
    [hashtable] $parameters
)

# Reinstall all the apps we uninstalled
$allAppsInEnvironment = Get-BcContainerAppInfo -containerName $containerName -tenantSpecificProperties -sort DependenciesFirst
foreach ($app in $allAppsInEnvironment) {
    $isAppAlreadyInstalled = $allAppsInEnvironment | Where-Object { ($($_.Name) -eq $app.Name) -and ($_.IsInstalled -eq $true) }
    if (($app.IsInstalled -eq $true) -or ($isAppAlreadyInstalled)) {
        Write-Host "$($app.Name) is already installed"
    } else {
        Write-Host "Installing $($app.Name)"
        Sync-BcContainerApp -containerName $containerName -appName $app.Name -appPublisher $app.Publisher -Mode ForceSync -Force
        Install-BcContainerApp -containerName $containerName -appName $app.Name -appPublisher $app.Publisher -appVersion $app.Version -Force
    }
}

$allApps = (Invoke-ScriptInBCContainer -containerName $containerName -scriptblock { Get-ChildItem -Path "C:\Applications\" -Filter "*.app" -Recurse })
foreach ($dependency in $parameters["missingDependencies"]) {
    # Format the dependency variable is AppId:Filename
    $appId, $appFileName = $dependency -split ":"
    # Remove the version from the filename
    $appFileName = $appFileName -replace "_\d+\.\d+\.\d+\.\d+\.app", ".app"

    Write-Host "Installing $appFileName"

    # Find the app file in the container
    $appFilePath = $allApps | Where-Object { $($_.Name) -eq "$appFileName" }
    if ($null -eq $appFilePath) {
        Write-Host "App file $appFileName not found in the container"
        continue
    }

    Publish-BcContainerApp -containerName $containerName -appFile ":$($appFilePath.FullName)" -skipVerification -scope Global -install -sync
    $appFilePath = $null
}