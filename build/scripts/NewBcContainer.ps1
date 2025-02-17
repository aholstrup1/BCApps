Param(
    [Hashtable]$parameters,
    [string[]]$uninstallApps = @("*")
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
foreach($app in $installedApps) {
    if (($uninstallApps -contains $app.Name) -or ($uninstallApps -contains "*")) {
        Write-Host "Removing $($app.Name)"
        Unpublish-BcContainerApp -containerName $parameters.ContainerName -name $app.Name -unInstall -doNotSaveData -doNotSaveSchema -force
    }
}

Invoke-ScriptInBcContainer -containerName $parameters.ContainerName -scriptblock { $progressPreference = 'SilentlyContinue' }