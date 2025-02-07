Param(
    [string] $appType,
    [ref] $compilationParams
)

if ($ENV:BuildMode -eq 'Clean') {
    $externalDependencies = (Get-Content (Join-Path $PSScriptRoot "customSettings.json" -Resolve) | ConvertFrom-Json).ExternalAppDependencies

    $scriptPath = Join-Path $PSScriptRoot "../../../scripts/PreCompileApp.ps1" -Resolve
    . $scriptPath -parameters $compilationParams -appType $appType -recompileDependencies $externalDependencies
}