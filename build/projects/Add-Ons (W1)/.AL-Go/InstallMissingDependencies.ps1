Param(
    [hashtable] $parameters
)

function Publish-AppsFromFile() {
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

function InstallDependencies() {
    param(
        [Parameter(Mandatory = $true)]
        [string] $ContainerName,
        [Parameter(Mandatory = $true)]
        [string[]] $DependenciesToInstall
    )
    $allAppsInEnvironment = Get-BcContainerAppInfo -containerName $ContainerName -tenantSpecificProperties -sort DependenciesFirst
    $missingDependencies = @()
    foreach($dependency in $DependenciesToInstall) {
        $appInContainer = $allAppsInEnvironment | Where-Object Name -eq $dependency
        if (-not $appInContainer) {
            Write-Host "$($dependency) is not published to the container"
            $missingDependencies += $dependency
            continue
        }

        $isAppInstalled = $appInContainer | Where-Object IsInstalled -eq $true
        if ($isAppInstalled) {
            Write-Host "$($dependency) ($($isAppInstalled.Version)) is already installed"
            continue
        }
        
        $uninstalledApps = @($appInContainer | Where-Object IsInstalled -eq $false)
        if ($uninstalledApps.Count -gt 1) {
            throw "$($dependency) has multiple versions published. Cannot determine which one to install"
        }

        $appToInstall = $uninstalledApps[0]
        Write-Host "[Install Missing Dependencies] - Installing $($dependency)"
        Sync-BcContainerApp -containerName $ContainerName -appName $appToInstall.Name -appPublisher $appToInstall.Publisher -Mode ForceSync -Force
        Install-BcContainerApp -containerName $ContainerName -appName $appToInstall.Name -appPublisher $appToInstall.Publisher -appVersion $appToInstall.Version -Force
    }
}
# Reinstall the dependencies in the container
$customSettings = Get-Content -Path (Join-Path $PSScriptRoot "customSettings.json" -Resolve) | ConvertFrom-Json
$dependenciesToInstall = $customSettings.ExternalAppDependencies
InstallDependencies -ContainerName $containerName -DependenciesToInstall $dependenciesToInstall

# When we use project dependencies we get the test toolkit from 
$projectSettings = Get-Content "$PSScriptRoot/settings.json" | ConvertFrom-Json
if ($projectSettings.useProjectDependencies -eq $false) {
    Import-TestToolkitToBcContainer -containerName $containerName
} else {
    # Install Tests-TestLibraries - Remaining test libraries should be in BCApps so they are installed as project dependencies
    Publish-AppsFromFile -ContainerName $containerName -AppName "Tests-TestLibraries"
}

<#
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
#>