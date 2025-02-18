Param(
    [hashtable] $parameters
)

# Ordered list of test framework apps to install
$allApps = (Invoke-ScriptInBCContainer -containerName $containerName -scriptblock { Get-ChildItem -Path "C:\Applications\" -Filter "*.app" -Recurse })
$testToolkitApps = @(
    "System Application Test Library", #temp fix
    "Tests-TestLibraries"
)

foreach ($app in $testToolkitApps) {
    $appFile = $allApps | Where-Object { $($_.Name) -eq "Microsoft_$($app).app" }
    Publish-BcContainerApp -containerName $containerName -appFile ":$($appFile.FullName)" -skipVerification -scope Tenant -install -sync
    $appFile = $null
} 