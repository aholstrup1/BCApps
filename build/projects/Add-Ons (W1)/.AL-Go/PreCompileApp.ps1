Param(
    [string] $appType,
    [ref] $compilationParams
)

if($appType -eq 'app')
{
    Write-Host "compilationParams: $compilationParams"

    . $scriptPath -AppFolder $compilationParams.Value["appProjectFolder"]
}