Param(
    [Hashtable]$parameters,
    [string[]]$keepApps = @()
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
        [boolean] $KeepApps = $false
    )
    $installedApps = Get-BcContainerAppInfo -containerName $containerName -tenantSpecificProperties -sort DependenciesLast

    # Clean the container for all apps. Apps will be installed by AL-Go
    foreach($app in $installedApps) {
        UnInstall-BcContainerApp -containerName $ContainerName -name $app.Name -doNotSaveData -doNotSaveSchema -force

        if ((-not $KeepApps)) {
            Write-Host "Unpublishing $($app.Name)"
            Unpublish-BcContainerApp -containerName $ContainerName -name $app.Name -unInstall -doNotSaveData -doNotSaveSchema -force
        }
    }
}

PrepareEnvironment -ContainerName $parameters.ContainerName -KeepApps ($keepApps.Count -gt 0)

foreach ($app in (Get-BcContainerAppInfo -containerName $parameters.ContainerName -tenantSpecificProperties -sort DependenciesLast)) {
    Write-Host "App: $($app.Name) ($($app.Version)) - Scope: $($app.Scope) - $($app.IsInstalled) / $($app.IsPublished)"
}

Invoke-ScriptInBcContainer -containerName $parameters.ContainerName -scriptblock { $progressPreference = 'SilentlyContinue' }