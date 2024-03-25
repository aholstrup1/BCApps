Param(
    [Hashtable]$parameters,
    [switch]$keepInstalledApps
)

$parameters.multitenant = $false
$parameters.RunSandboxAsOnPrem = $true
if ("$env:GITHUB_RUN_ID" -eq "") {
    $parameters.includeAL = $true
    $parameters.doNotExportObjectsToText = $true
    $parameters.shortcuts = "none"
}

Import-Module "$PSScriptRoot\DevEnv\NewDevContainer.psm1" -DisableNameChecking
Import-Module "$PSScriptRoot\EnlistmentHelperFunctions.psm1" -DisableNameChecking

New-BcContainer @parameters

if ($keepInstalledApps) {
    Setup-ContainerForDevelopment -ContainerName $ContainerName -RepoVersion (Get-ConfigValue -Key "repoVersion" -ConfigType AL-Go)
} else {
    $installedApps = Get-BcContainerAppInfo -containerName $containerName -tenantSpecificProperties -sort DependenciesLast
    $installedApps | ForEach-Object {
        Write-Host "Removing $($_.Name)"
        Unpublish-BcContainerApp -containerName $parameters.ContainerName -name $_.Name -unInstall -doNotSaveData -doNotSaveSchema -force
    }
}

Invoke-ScriptInBcContainer -containerName $parameters.ContainerName -scriptblock { $progressPreference = 'SilentlyContinue' }