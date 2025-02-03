Param(
    [string] $appType,
    [ref] $compilationParams
)


Import-Module (Join-Path $PSScriptRoot "../../../scripts/EnlistmentHelperFunctions.psm1" -Resolve)

if (Get-BuildMode -eq "Clean") {
    $scriptPath = Join-Path $PSScriptRoot "../../../scripts/PreCompileApp.ps1" -Resolve
    . $scriptPath -parameters $compilationParams -appType $appType -recompileDependencies $true
}