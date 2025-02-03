Param(
    [ValidateSet('app', 'testApp', 'bcptApp')]
    [string] $appType = 'app',
    [ref] $parameters,
    [boolean] $recompileDependencies = $false
)

Import-Module $PSScriptRoot\EnlistmentHelperFunctions.psm1

$appBuildMode = Get-BuildMode

if($appType -eq 'app')
{
    # Setup compiler features to generate captions and LCGs
    if (!$parameters.Value.ContainsKey("Features")) {
        $parameters.Value["Features"] = @()
    }
    $parameters.Value["Features"] += @("generateCaptions")

    # Setup compiler features to generate LCGs for the default build mode
    if($appBuildMode -eq 'Default') {
        $parameters.Value["Features"] += @("lcgtranslationfile")
    }

    if($appBuildMode -eq 'Translated') {
        Import-Module $PSScriptRoot\AppTranslations.psm1
        Restore-TranslationsForApp -AppProjectFolder $parameters.Value["appProjectFolder"]
    }

    # Restore the baseline app and generate the AppSourceCop.json file
    if($gitHubActions) {
        if (($parameters.Value.ContainsKey("EnableAppSourceCop") -and $parameters.Value["EnableAppSourceCop"]) -or ($parameters.Value.ContainsKey("EnablePerTenantExtensionCop") -and $parameters.Value["EnablePerTenantExtensionCop"])) {
            Import-Module $PSScriptRoot\GuardingV2ExtensionsHelper.psm1

            if($appBuildMode -eq 'Clean') {
                Write-Host "Compile the app without any preprocessor symbols to generate a baseline app to use for breaking changes check"

                $tempParameters = $parameters.Value.Clone()

                # Wipe the preprocessor symbols to ensure that the baseline is generated without any preprocessor symbols
                $tempParameters["preprocessorsymbols"] = @()

                # Place the app directly in the symbols folder
                $tempParameters["appOutputFolder"] = $tempParameters["appSymbolsFolder"]

                # Rename the app to avoid overwriting the app that will be generated with preprocessor symbols
                $appJson = Join-Path $tempParameters["appProjectFolder"] "app.json"
                $appName = (Get-Content -Path $appJson | ConvertFrom-Json).Name
                $tempParameters["appName"] = "$($appName)_clean.app"

                if ($recompileDependencies) {
                    Import-Module $PSScriptRoot\AppExtensionsHelper.psm1
                    # Temp fix for: Error: AL0196 The call is ambiguous between the method 
                    if (Test-Path "C:\Program Files\dotnet\shared\Microsoft.NETCore.App\9.0.1") {
                        Remove-Item "C:\Program Files\dotnet\shared\Microsoft.NETCore.App\9.0.1" -Recurse -Force
                    }
                    if (Test-Path "C:\Program Files\dotnet\shared\Microsoft.AspNetCore.App\9.0.1") {
                        Remove-Item "C:\Program Files\dotnet\shared\Microsoft.AspNetCore.App\9.0.1" -Recurse -Force
                    }
                    if (Test-Path "C:\Program Files\dotnet\shared\Microsoft.NETCore.App\8.0.12") {
                        Rename-Item "C:\Program Files\dotnet\shared\Microsoft.NETCore.App\8.0.12" "9.0.1"
                    }
                    if (Test-Path "C:\Program Files\dotnet\shared\Microsoft.AspNetCore.App\8.0.12") {
                        Rename-Item "C:\Program Files\dotnet\shared\Microsoft.AspNetCore.App\8.0.12" "9.0.1"
                    }
                    # End of temp fix
                    @("System Application", "Business Foundation", "Base Application", "Application") | ForEach-Object {
                        Update-Dependencies -App $_ -CompilationParameters ($parameters.Value.Clone())
                    }
                    #Update-Dependencies -App "System Application" -CompilationParameters ($parameters.Value.Clone())
                }

                if($useCompilerFolder) {
                    Compile-AppWithBcCompilerFolder @tempParameters | Out-Null
                }
                else {
                    Compile-AppInBcContainer @tempParameters | Out-Null
                }
            }

            if(($appBuildMode -eq 'Strict') -and !(Test-IsStrictModeEnabled)) {
                Write-Host "::Warning:: Strict mode is not enabled for this branch. Exiting without enabling the strict mode breaking changes check."
                return
            }

            Enable-BreakingChangesCheck -AppSymbolsFolder $parameters.Value["appSymbolsFolder"] -AppProjectFolder $parameters.Value["appProjectFolder"] -BuildMode $appBuildMode | Out-Null
        }
    }
}
