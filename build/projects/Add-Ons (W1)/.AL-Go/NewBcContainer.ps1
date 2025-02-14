Param(
    [Hashtable]$parameters
)

function Get-AppsInFolder() {
    param(
        [string]$folder
    )
    # Look for all app.json files in the folder or subfolders. Grab the "Name" property from the file
    $apps = Get-ChildItem -Path $folder -Recurse -Filter "app.json" | ForEach-Object {
        $appJson = Get-Content -Path $_.FullName | ConvertFrom-Json
        $appJson.Name
    }

    return @($apps)
}

$apps = Get-AppsInFolder -folder (Join-Path $PSScriptRoot "../../../../src/Add-Ons/W1" -Resolve)
$script = Join-Path $PSScriptRoot "../../../scripts/NewBcContainer.ps1" -Resolve
. $script -parameters $parameters -uninstallApps $apps