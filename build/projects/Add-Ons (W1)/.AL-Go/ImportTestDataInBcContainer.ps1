Param(
    [Hashtable]$parameters
)

$projectSettings = Get-Content "$PSScriptRoot/settings.json" | ConvertFrom-Json
if ($projectSettings.useProjectDependencies -eq $true) {
    $script = Join-Path $PSScriptRoot "../../../scripts/ImportTestDataInBcContainer.ps1" -Resolve
    . $script -parameters $parameters
} else {
    # TODO: This should be fixed so we always import demo data
    Write-Host "Demo data is already imported, skipping importing demo data"
}