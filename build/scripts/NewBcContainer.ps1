Param(
    [Hashtable]$parameters,
    [string[]]$keepApps = @(),
    [boolean]$useProjectDependencies = $true
)

$parameters.multitenant = $false
$parameters.RunSandboxAsOnPrem = $true
if ("$env:GITHUB_RUN_ID" -eq "") {
    $parameters.includeAL = $true
    $parameters.doNotExportObjectsToText = $true
    $parameters.shortcuts = "none"
}

New-BcContainer @parameters

function PrepareEnvironment() {
    param(
        [string] $ContainerName,
        [boolean] $UseProjectDependencies,
        [string[]] $KeepApps = @()
    )
    $installedApps = Get-BcContainerAppInfo -containerName $containerName -tenantSpecificProperties -sort DependenciesLast

    if ($UseProjectDependencies) {
        # Clean the container for all apps. Apps will be installed by AL-Go
        foreach($app in $installedApps) {
            Write-Host "Removing $($app.Name)"
            Unpublish-BcContainerApp -containerName $parameters.ContainerName -name $app.Name -unInstall -doNotSaveData -doNotSaveSchema -force
        }  
    } else {
        # Keep the apps that are in the keepApps list
        # Unpublish apps that are not installed 
        # Uninstall apps that are installed
        foreach($app in $installedApps) {
            if (($keepApps -notcontains $app.Name)) {
                if ($app.IsInstalled -eq $false) {
                    Write-Host "Unpublishing $($app.Name)"
                    Unpublish-BcContainerApp -containerName $parameters.ContainerName -name $app.Name -unInstall -doNotSaveData -doNotSaveSchema -force
                } else {
                    Write-Host "Uninstalling $($app.Name)"
                    UnInstall-BcContainerApp -containerName $parameters.ContainerName -name $app.Name -doNotSaveData -doNotSaveSchema -force
                }
            }
        }
    }
}

PrepareEnvironment -ContainerName $parameters.ContainerName -UseProjectDependencies $useProjectDependencies -KeepApps $keepApps

foreach ($app in (Get-BcContainerAppInfo -containerName $parameters.ContainerName -tenantSpecificProperties -sort DependenciesLast)) {
    Write-Host "App: $($app.Name) ($($app.Version)) - Scope: $($app.Scope) - $($app.IsInstalled) / $($app.IsPublished)"
}

Invoke-ScriptInBcContainer -containerName $parameters.ContainerName -scriptblock { $progressPreference = 'SilentlyContinue' }