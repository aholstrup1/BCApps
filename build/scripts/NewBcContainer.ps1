Param(
    [Hashtable]$parameters,
    [boolean]$keepApps = $false
)

$parameters.multitenant = $false
$parameters.RunSandboxAsOnPrem = $true
if ("$env:GITHUB_RUN_ID" -eq "") {
    $parameters.includeAL = $true
    $parameters.doNotExportObjectsToText = $true
    $parameters.shortcuts = "none"
}

New-BcContainer @parameters
if ($keepApps) {
    # Set the app version and move to dev scope
    Import-Module "$PSScriptRoot\DevEnv\NewDevContainer.psm1"
    #Setup-ContainerForDevelopment -ContainerName $parameters.ContainerName -RepoVersion $null

    # Unpublish the apps we are building in BCApps
    # This also means that we can't have apps in NAV with dependencies to apps in BCApps (good thing?)
    Unpublish-BcContainerApp -containerName $parameters.ContainerName -name "Shopify Connector" -unInstall -doNotSaveData -doNotSaveSchema -force
} else {
    $installedApps = Get-BcContainerAppInfo -containerName $containerName -tenantSpecificProperties -sort DependenciesLast
    $installedApps | ForEach-Object {
        Write-Host "Removing $($_.Name)"
        Unpublish-BcContainerApp -containerName $parameters.ContainerName -name $_.Name -unInstall -doNotSaveData -doNotSaveSchema -force
    }
}

Invoke-ScriptInBcContainer -containerName $parameters.ContainerName -scriptblock { $progressPreference = 'SilentlyContinue' }