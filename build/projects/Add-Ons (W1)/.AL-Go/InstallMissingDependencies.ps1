Param(
    [hashtable] $parameters
)

function Publish-AppFromFile() {
    param(
        [Parameter(Mandatory = $true)]
        [string] $ContainerName,
        [Parameter(Mandatory = $true, ParameterSetName = "ByAppFilePath")]
        [string] $AppFilePath,
        [Parameter(Mandatory = $true, ParameterSetName = "ByAppName")]
        [string] $AppName
    )
    if ($PSCmdlet.ParameterSetName -eq "ByAppName") {
        Write-Host "Searching for app file with name: $AppName"
        $allApps = (Invoke-ScriptInBCContainer -containerName $ContainerName -scriptblock { Get-ChildItem -Path "C:\Applications\" -Filter "*.app" -Recurse })
        $AppFilePath = $allApps | Where-Object { $($_.BaseName) -like "*$($AppName)" } | ForEach-Object { $_.FullName }
    }
    
    if (-not $AppFilePath) {
        throw "App file not found"
    }

    Write-Host "Installing app from file: $AppFilePath"
    Publish-BcContainerApp -containerName $ContainerName -appFile ":$($AppFilePath)" -skipVerification -scope Global -install -sync
}

function Install-MissingDependencies() {
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
            Write-Host "[Install Missing Dependencies] - $($dependency) is not published to the container"
            $missingDependencies += $dependency
            continue
        }

        $isAppInstalled = $appInContainer | Where-Object IsInstalled -eq $true
        if ($isAppInstalled) {
            Write-Host "[Install Missing Dependencies] - $($dependency) ($($isAppInstalled.Version)) is already installed"
            continue
        }
        
        $uninstalledApps = @($appInContainer | Where-Object IsInstalled -eq $false)
        if ($uninstalledApps.Count -gt 1) {
            throw "[Install Missing Dependencies] - $($dependency) has multiple versions published. Cannot determine which one to install"
        }

        $appToInstall = $uninstalledApps[0]
        Write-Host "[Install Missing Dependencies] - Installing $($dependency)"
        Sync-BcContainerApp -containerName $ContainerName -appName $appToInstall.Name -appPublisher $appToInstall.Publisher -Mode ForceSync -Force
        Install-BcContainerApp -containerName $ContainerName -appName $appToInstall.Name -appPublisher $appToInstall.Publisher -appVersion $appToInstall.Version -Force
    }

    if ($missingDependencies.Count -gt 0) {
        Write-Host "[Install Missing Dependencies] - The following dependencies are missing: $($missingDependencies -join ', ')"
    }
    return $missingDependencies
}

# Reinstall the dependencies in the container
$customSettings = Get-Content -Path (Join-Path $PSScriptRoot "customSettings.json" -Resolve) | ConvertFrom-Json
$dependenciesToInstall = $customSettings.ExternalAppDependencies

# Step 1: If the app is published to the container then we can install it from there
$dependenciesToInstall = Install-MissingDependencies -ContainerName $containerName -DependenciesToInstall $dependenciesToInstall

# Step 2: If the app is not published to the container then we need to install it from the file system
foreach ($dependency in $dependenciesToInstall) {
    Publish-AppFromFile -ContainerName $containerName -AppName $dependency
}