Param(
    [string] $appType,
    [ref] $compilationParams
)

$scriptPath = Join-Path $PSScriptRoot "../../../scripts/VerifyExecutePermissions.ps1" -Resolve
. $scriptPath -ModulesDirectory $compilationParams.Value["appProjectFolder"]

Compile-AppWithBcCompilerFolder $compilationParams | Out-Null