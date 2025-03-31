function Invoke-ContosoDemoTool() {
    param(
        [string]$ContainerName,
        [string]$CompanyName = (Get-NavDefaultCompanyName),
        [switch]$SetupData = $false,
        [string]$DemodataApp = "Contoso Coffee Demo Dataset"
    )
    Install-AppsInContainer -ContainerName $ContainerName -Apps @($DemodataApp)
    
    Write-Host "Initializing company in container $ContainerName"
    Invoke-NavContainerCodeunit -Codeunitid 2 -containerName $ContainerName -CompanyName $CompanyName

    if ($SetupData) {
        Write-Host "Setting up demo data in container $ContainerName"
        Invoke-NavContainerCodeunit -Codeunitid 2 -containerName $ContainerName -CompanyName $CompanyName -MethodName "CreateSetupDemoData"
    } else {
        Write-Host "Importing configuration package"
        Invoke-NavContainerCodeunit -CodeunitId 5193 -containerName $containerName -CompanyName $CompanyName -MethodName "CreateAllDemoData"
        Invoke-NavContainerCodeunit -CodeunitId 5140 -containerName $containerName -CompanyName $CompanyName -MethodName "DeleteWarehouseEmployee"
    }

    Invoke-NavContainerCodeunit -CodeunitId 5691 -containerName $ContainerName -CompanyName $CompanyName
}

function Install-AppsInContainer() {
    param(
        [string] $ContainerName,
        [string[]] $Apps
    )
    $allAppsInEnvironment = Get-BcContainerAppInfo -containerName $ContainerName -tenantSpecificProperties -sort DependenciesFirst
    foreach ($app in $Apps) {
        # Check if app can be found in the container
        $appInContainer = $allAppsInEnvironment | Where-Object { ($($_.Name) -eq $app) }

        if (-not $appInContainer) {
            Write-Host "App $($app) not found in the container. Cannot install it until it is published."
            return $false
        } elseif ($appInContainer.IsInstalled -eq $true) {
            Write-Host "$($app) is already installed"
            return $true
        } else {
            Write-Host "Installing $appInContainer from container $ContainerName"
            Sync-BcContainerApp -containerName $ContainerName -appName $appInContainer.Name -appPublisher $appInContainer.Publisher -Mode ForceSync -Force
            Install-BcContainerApp -containerName $ContainerName -appName $appInContainer.Name -appPublisher $appInContainer.Publisher -appVersion $appInContainer.Version -Force
            return $true
        }
    }
}

function Get-NavDefaultCompanyName
{
    return "CRONUS International Ltd."
}

Export-ModuleMember Invoke-ContosoDemoTool