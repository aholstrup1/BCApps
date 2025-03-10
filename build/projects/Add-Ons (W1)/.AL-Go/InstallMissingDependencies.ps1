Param(
    [hashtable] $parameters
)

# Reinstall all the apps we uninstalled
$allAppsInEnvironment = Get-BcContainerAppInfo -containerName $containerName -tenantSpecificProperties -sort DependenciesFirst
foreach ($app in $allAppsInEnvironment) {
    if ($app.IsInstalled -eq $true) {
        Write-Host "$($app.Name) is already installed"
    } else {
        $isAppAlreadyInstalled = $allAppsInEnvironment | Where-Object { ($($_.Name) -eq $app.Name) -and $($_.IsInstalled -eq $true) }
        if ($isAppAlreadyInstalled) {
            Write-Host "$($app.Name) is already installed"
        } else {
            Write-Host "Installing $($app.Name)"
            Install-BcContainerApp -containerName $containerName -name $app.Name -sync
        }
    }
}

if ($parameters["missingDependencies"] -contains "5d86850b-0d76-4eca-bd7b-951ad998e997") { # Tests-TestLibraries
    Write-Host "Installing Tests-TestLibraries"
    # Ordered list of test framework apps to install
    $allApps = (Invoke-ScriptInBCContainer -containerName $containerName -scriptblock { Get-ChildItem -Path "C:\Applications\" -Filter "*.app" -Recurse })
    $testToolkitApps = @(
        "Tests-TestLibraries"
    )

    foreach ($app in $testToolkitApps) {
        $appFile = $allApps | Where-Object { $($_.Name) -eq "Microsoft_$($app).app" }
        Publish-BcContainerApp -containerName $containerName -appFile ":$($appFile.FullName)" -skipVerification -scope Global -install -sync
        $appFile = $null
    }
} else {
    Write-Host "Skipping..."
}