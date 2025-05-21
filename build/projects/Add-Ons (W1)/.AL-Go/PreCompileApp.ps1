Param(
    [string] $appType,
    [ref] $compilationParams
)

if ($ENV:BuildMode -eq 'Clean') {
    Import-Module (Join-Path $PSScriptRoot "../../../scripts/AppExtensionsHelper.psm1" -Resolve)
    $scriptPath = Join-Path $PSScriptRoot "../../../scripts/PreCompileApp.ps1" -Resolve

    $symbolsPath = Join-Path $compilationParams.Value["compilerFolder"] 'symbols'
    if (Test-Path $symbolsPath) {
        # Get all .app files in the symbols folder (but not System.app)
        $appFiles = Get-ChildItem -Path $symbolsPath -Filter *.app -Recurse | Where-Object { $_.Name -ne 'System.app' }
        foreach ($appFile in $appFiles) {
            # Remove the .app file
            Remove-Item -Path $appFile.FullName -Force -Verbose
        }
    }

    . $scriptPath -parameters $compilationParams -appType $appType -recompileDependencies (Get-ExternalDependencies)
}