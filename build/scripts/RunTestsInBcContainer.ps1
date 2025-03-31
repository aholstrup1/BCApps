Param(
    [Hashtable] $parameters,
    [switch] $DisableTestIsolation,
    [switch] $ReinstallUninstalledApps
)

Import-Module $PSScriptRoot\EnlistmentHelperFunctions.psm1

function Get-DisabledTests
{
    $baseFolder = Get-BaseFolder

    $disabledCodeunits = Get-ChildItem -Path $baseFolder -Filter "DisabledTests" -Recurse -Directory | ForEach-Object { Get-ChildItem -Path $_.FullName -Filter "*.json" }
    $disabledTests = @()
    foreach($disabledCodeunit in $disabledCodeunits)
    {
        $disabledTests += (Get-Content -Raw -Path $disabledCodeunit.FullName | ConvertFrom-Json)
    }

    return @($disabledTests)
}

function Get-TestsInGroup {
    param(
        [Parameter(Mandatory = $true)]
        [string] $groupName
    )

    $baseFolder = Get-BaseFolder

    $groupFiles = Get-ChildItem -Path $baseFolder -Filter 'TestGroups.json' -Recurse -File

    $testsInGroup = @()
    foreach($groupFile in $groupFiles)
    {
        $testsInGroup += Get-Content -Raw -Path $groupFile.FullName | ConvertFrom-Json | Where-Object { $_.group -eq $groupName }
    }

    return $testsInGroup
}

function Install-UninstalledAppsInEnvironment() {
    param(
        [Parameter(Mandatory = $true)]
        [string] $ContainerName
    )
    # Get all apps in the environment
    $allAppsInEnvironment = Get-BcContainerAppInfo -containerName $ContainerName -tenantSpecificProperties -sort DependenciesFirst
    foreach ($app in $allAppsInEnvironment) {
        # Check if the app is already installed 
        $isAppAlreadyInstalled = $allAppsInEnvironment | Where-Object { ($($_.Name) -eq $app.Name) -and ($_.IsInstalled -eq $true) }
        if (($app.IsInstalled -eq $true) -or ($isAppAlreadyInstalled)) {
            Write-Host "$($app.Name) is already installed"
        } else {
            Write-Host "Re-Installing $($app.Name)"
            Sync-BcContainerApp -containerName $ContainerName -appName $app.Name -appPublisher $app.Publisher -Mode ForceSync -Force
            Install-BcContainerApp -containerName $ContainerName -appName $app.Name -appPublisher $app.Publisher -appVersion $app.Version -Force
        }
    }

    # START LOGGING: Print all installed apps TODO
    foreach ($app in (Get-BcContainerAppInfo -containerName $ContainerName -tenantSpecificProperties -sort DependenciesLast)) {
        Write-Host "App: $($app.Name) ($($app.Version)) - Scope: $($app.Scope) - $($app.IsInstalled) / $($app.IsPublished)"
    }
    # END LOGGING
}

$disabledTests = @(Get-DisabledTests)
$noIsolationTests = Get-TestsInGroup -groupName "No Test Isolation"

if ($DisableTestIsolation)
{
    $parameters["testRunnerCodeunitId"] = "130451" # Test Runner with disabled test isolation

    # When test isolation is disabled, only tests from the "No Test Isolation" group should be run
    $parameters["testCodeunitRange"] = @($noIsolationTests | ForEach-Object { $_.codeunitId }) -join "|"
}
else { # Test isolation is enabled
    # Manually disable the test codeunits, as they need to be run without test isolation
    $noIsolationTests | ForEach-Object {
        $disabledTests += @{
            "codeunitId" = $_.codeunitId
            "codeunitName" = $_.codeunitName
            "method" = "*"
        }
    }
}

if ($disabledTests)
{
    $parameters["disabledTests"] = $disabledTests
}

if ($ReinstallUninstalledApps) {
    Install-UninstalledAppsInEnvironment -ContainerName $parameters["containerName"]
}

Run-TestsInBcContainer @parameters
