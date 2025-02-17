Param(
    [string] $appType,
    [ref] $compilationParams
)

function Get-ExternalAppDependencies() {
    param(
        [string]$folder
    )
    # Look for all app.json files in the folder or subfolders. Grab the "Name" property from the file
    $apps = Get-ChildItem -Path $folder -Recurse -Filter "app.json" | ForEach-Object {
        $appJson = Get-Content -Path $_.FullName | ConvertFrom-Json
        $appJson.dependencies.Name
    }

    return @($apps)
}

if ($ENV:BuildMode -eq 'Clean') {
    $externalDependencies = (Get-Content (Join-Path $PSScriptRoot "customSettings.json" -Resolve) | ConvertFrom-Json).ExternalAppDependencies

    $scriptPath = Join-Path $PSScriptRoot "../../../scripts/PreCompileApp.ps1" -Resolve
    . $scriptPath -parameters $compilationParams -appType $appType -recompileDependencies $externalDependencies
}