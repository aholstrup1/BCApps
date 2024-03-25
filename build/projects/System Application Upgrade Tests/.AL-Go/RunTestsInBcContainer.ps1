Param(
    [Hashtable]$parameters
)

Invoke-ScriptInBcContainer -containerName $parameters.containerName -scriptblock { 
    $appfile = "C:\Applications\BaseApp\test\Microsoft_Tests-TestLibraries.app"
    if (Test-Path $appfile) {
        Write-Host "Importing test libraries..."
        Publish-NAVApp -Path $appfile -ServerInstance BC -SkipVerification
    } else {
        Write-Host "Test libraries not found."
    }
}

$script = Join-Path $PSScriptRoot "../../../scripts/RunTestsInBcContainer.ps1" -Resolve
. $script -parameters $parameters