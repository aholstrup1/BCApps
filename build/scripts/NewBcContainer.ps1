Param(
    [Hashtable]$parameters,
    [string[]]$keepApps
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
$installedApps | ForEach-Object {
    if (-not $keepApps) {
        Write-Host "Removing $($_.Name)"
        Unpublish-BcContainerApp -containerName $parameters.ContainerName -name $_.Name -unInstall -doNotSaveData -doNotSaveSchema -force
    }
}

# Set the app version and move to dev scope
<#Import-Module "$PSScriptRoot\DevEnv\NewDevContainer.psm1"
Setup-ContainerForDevelopment -ContainerName $parameters.ContainerName -RepoVersion "26.0"
#>
Invoke-ScriptInBcContainer -containerName $parameters.ContainerName -scriptblock { $progressPreference = 'SilentlyContinue' }