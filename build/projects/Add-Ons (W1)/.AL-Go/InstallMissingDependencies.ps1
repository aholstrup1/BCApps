Param(
    [hashtable] $parameters
)

function Install-AppsFromFile() {
    param(
        [Parameter(Mandatory = $true)]
        [string] $ContainerName,
        [Parameter(Mandatory = $true, ParameterSetName = "ByAppFilePath")]
        [string] $AppFilePath,
        [Parameter(Mandatory = $true, ParameterSetName = "ByAppName")]
        [string] $AppName
    )
    if ($PSCmdlet.ParameterSetName -eq "ByAppName") {
        $allApps = (Invoke-ScriptInBCContainer -containerName $ContainerName -scriptblock { Get-ChildItem -Path "C:\Applications\" -Filter "*.app" -Recurse })
        $AppFilePath = $allApps | Where-Object { $($_.BaseName) -like "*$($AppName)" } | ForEach-Object { $_.FullName }
    }
    
    if (-not $AppFilePath) {
        throw "App file not found"
    }

    Write-Host "Installing app from file: $AppFilePath"
    Publish-BcContainerApp -containerName $ContainerName -appFile ":$($AppFilePath)" -skipVerification -scope Global -install -sync
}

$customSettings = Get-Content -Path (Join-Path $PSScriptRoot "customSettings.json" -Resolve) | ConvertFrom-Json
$dependenciesToInstall = $customSettings.ExternalAppDependencies

# Reinstall the dependencies in the container
$allAppsInEnvironment = Get-BcContainerAppInfo -containerName $containerName -tenantSpecificProperties -sort DependenciesFirst
foreach ($app in $allAppsInEnvironment) {
    $isAppAlreadyInstalled = $allAppsInEnvironment | Where-Object { ($($_.Name) -eq $app.Name) -and ($_.IsInstalled -eq $true) }
    $shouldInstall = $dependenciesToInstall | Where-Object { $_ -eq $app.Name }
    if (($app.IsInstalled -eq $true) -or ($isAppAlreadyInstalled)) {
        Write-Host "$($app.Name) is already installed"
    } elseif(-not $shouldInstall) {
        Write-Host "$($app.Name) is not in the list of dependencies to install"
    } else {
        Write-Host "Installing $($app.Name)"
        Sync-BcContainerApp -containerName $containerName -appName $app.Name -appPublisher $app.Publisher -Mode ForceSync -Force
        Install-BcContainerApp -containerName $containerName -appName $app.Name -appPublisher $app.Publisher -appVersion $app.Version -Force
    }
}

# When we use project dependencies we get the test toolkit from 
$projectSettings = Get-Content "$PSScriptRoot/settings.json" | ConvertFrom-Json
if ($projectSettings.useProjectDependencies -eq $false) {
    Import-TestToolkitToBcContainer -containerName $containerName
} else {
    # Install Tests-TestLibraries - Remaining test libraries should be in BCApps so they are installed as project dependencies
    Install-AppsFromFile -ContainerName $containerName -AppName "Tests-TestLibraries"
}
<#
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
#>