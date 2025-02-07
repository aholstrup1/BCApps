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

Restart-BcContainer -containerName $parameters.ContainerName

$publishedApps = Get-BcContainerAppInfo -containerName $parameters.ContainerName -tenantSpecificProperties -sort DependenciesLast
$appsToRemove = @($publishedApps | Where-Object IsInstalled -eq $false)

Write-Host "Found $($publishedApps.Count) apps in the container"
Write-Host "Found $($appsToRemove.Count) apps to remove"
<#if ($keepApps) {
} else {
    $appsToRemove = $publishedApps
}#>

foreach ($app in $appsToRemove) {
    Write-Host "Removing $($_.Name)"
    Unpublish-BcContainerApp -containerName $parameters.ContainerName -name $app.Name -unInstall -doNotSaveData -doNotSaveSchema -force
}

Unpublish-BcContainerApp -containerName $parameters.ContainerName -name "Shopify Connector" -unInstall -doNotSaveData -doNotSaveSchema -force

# Set the app version and move to dev scope
Import-Module "$PSScriptRoot\DevEnv\NewDevContainer.psm1"
Setup-ContainerForDevelopment -ContainerName $parameters.ContainerName -RepoVersion $null

Invoke-ScriptInBcContainer -containerName $parameters.ContainerName -scriptblock { $progressPreference = 'SilentlyContinue' }