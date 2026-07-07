Param(
    $appFiles,
    [string] $appType,
    $compilationParams
)

$scriptPath = Join-Path $PSScriptRoot "../../../scripts/PostCompileApp.ps1" -Resolve
. $scriptPath -AppFiles $appFiles -AppType $appType -CompilationParams $compilationParams
