Param(
    [string] $appType,
    [ref] $compilationParams
)

if($appType -eq 'app')
{
    #compilationParams is a hashtable. Print all keys and values
    Write-Host "compilationParams:"
    foreach ($key in $compilationParams.Keys) {
        Write-Host "$key = $($compilationParams[$key])"
    }

    Compile-AppWithBcCompilerFolder $compilationParams | Out-Null

    $scriptPath = Join-Path $PSScriptRoot "../../../scripts/VerifyExecutePermissions.ps1" -Resolve
    . $scriptPath -ModulesDirectory $compilationParams.Value["appProjectFolder"]    
}