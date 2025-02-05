function Update-Dependencies() {
    param(
        [string] $App,
        [hashtable] $CompilationParameters
    )

    Write-Host "Recompiling dependencies"
    # Copy apps to packagecachepath
    $projectFolder = $CompilationParameters["appProjectFolder"]
    $SymbolsFolder = $CompilationParameters["appSymbolsFolder"]

    # Log what is in the symbols folder
    Write-Host "Symbols folder: $SymbolsFolder"
    Get-ChildItem -Path $SymbolsFolder
    
    # Find out which version of the apps we need 
    $artifactVersion = "https://bcinsider-fvh2ekdjecfjd6gk.b02.azurefd.net/sandbox/26.0.29478.0/platform"

    # Download the artifact that contains the source code for those apps
    # Set up temp folder to download the artifact to
    $tempFolder = Join-Path $env:TEMP ([System.Guid]::NewGuid().ToString())
    $newSymbolsFolder = (Join-Path $tempFolder "Symbols")
    New-Item -ItemType Directory -Path $tempFolder -Force | Out-Null
    New-Item -ItemType Directory -Path $newSymbolsFolder -Force | Out-Null
    Download-Artifacts -artifactUrl $artifactVersion -basePath $tempFolder
    
    # Unzip it 
    $sourceCodeFolder = "$tempFolder/$($App -replace " ", "_")Source"
    Get-ChildItem -Path $tempFolder -Recurse -Filter "$App.Source.zip" | Expand-Archive -Destination $sourceCodeFolder

    if (-not (Test-Path $sourceCodeFolder)) {
        Write-Error "Could not find the source code for the Base Application"
        throw
    }

    # Find app.json inside the source code
    $appJson = Get-ChildItem -Path $sourceCodeFolder -Recurse -Filter "app.json" | Select-Object -First 1
    # print the app.json path
    Write-Host "Found app.json at $appJson"
    Write-Host $appJson.FullName

    # Recompile them
    $CompilationParameters["appProjectFolder"] = $sourceCodeFolder
    $CompilationParameters["appOutputFolder"] = $SymbolsFolder
    $CompilationParameters["appSymbolsFolder"] = $newSymbolsFolder
    $CompilationParameters["EnableAppSourceCop"] = $false
    $CompilationParameters["EnableCodeCop"] = $false
    $CompilationParameters["EnableUICop"] = $false
    $CompilationParameters["EnablePerTenantExtensionCop"] = $false

    $CompilationParameters.Remove("ruleset")

    # Iterate through hashtable and print keys and values
    foreach ($key in $CompilationParameters.Keys) {
        Write-Host "$key : $($CompilationParameters[$key])"
    }


    Compile-AppWithBcCompilerFolder @CompilationParameters
    # Find the created .app file in the newSymbolsFolder
    $appFiles = Get-ChildItem -Path $newSymbolsFolder -Filter "*$App*.app"
    # Copy the new app files to the symbols folder
    <#foreach ($appFile in $appFiles) {
        Write-Host "Copying $appFile to $SymbolsFolder"
        $appFile | Copy-Item -Destination $SymbolsFolder -Force
    }#>
    #
    <#
    # Copy the new app files to the symbols folder
    $appFiles = Get-ChildItem -Path $projectFolder -Filter "*.app"
    
    foreach ($appFile in $appFiles) {
        Write-Host "Copying $appFile to $SymbolsFolder"
        $appFile | Copy-Item -Destination $SymbolsFolder -Force
    }
    #>
}