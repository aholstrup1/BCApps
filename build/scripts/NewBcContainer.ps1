Param(
    [Hashtable]$parameters,
    [string[]]$uninstallApps = @()
)

$parameters.multitenant = $false
$parameters.RunSandboxAsOnPrem = $true
if ("$env:GITHUB_RUN_ID" -eq "") {
    $parameters.includeAL = $true
    $parameters.doNotExportObjectsToText = $true
    $parameters.shortcuts = "none"
}

New-BcContainer @parameters

$installedApps = Get-BcContainerAppInfo -containerName $containerName -tenantSpecificProperties -sort DependenciesLast
if ($uninstallApps) {
    # Unpublish the apps we are building in BCApps
    # This also means that we can't have apps in NAV with dependencies to apps in BCApps (good thing?)
    foreach($app in $uninstallApps) {
        if ($installedApps.Name -contains $app) {
            Write-Host "Removing $app"
            Unpublish-BcContainerApp -containerName $parameters.ContainerName -name $app -unInstall -doNotSaveData -doNotSaveSchema -force
        }
    }
} else {
    # Unpublish all apps in the container
    $installedApps | ForEach-Object {
        Write-Host "Removing $($_.Name)"
        Unpublish-BcContainerApp -containerName $parameters.ContainerName -name $_.Name -unInstall -doNotSaveData -doNotSaveSchema -force
    }
}

Invoke-ScriptInBcContainer -containerName $parameters.ContainerName -scriptblock { $progressPreference = 'SilentlyContinue' }