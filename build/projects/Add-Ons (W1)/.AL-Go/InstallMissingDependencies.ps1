Param(
    [hashtable] $parameters
)

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