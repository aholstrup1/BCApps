function Update-Dependencies() {
    param(
        [string] $App,
        [hashtable] $CompilationParameters
    )

    Write-Host "Recompiling dependencies"
    # Copy apps to packagecachepath
    $projectFolder = $CompilationParameters["appProjectFolder"]
    $SymbolsFolder = $CompilationParameters["appSymbolsFolder"]
    
    # Find out which version of the apps we need 
    $artifactVersion = "https://bcinsider-fvh2ekdjecfjd6gk.b02.azurefd.net/sandbox/26.0.29478.0/base"

    # Download the artifact that contains the source code for those apps
    # Set up temp folder to download the artifact to
    $tempFolder = Join-Path $env:TEMP ([System.Guid]::NewGuid().ToString())
    New-Item -ItemType Directory -Path $tempFolder -Force | Out-Null
    Download-Artifacts -artifactUrl $artifactVersion -basePath $tempFolder
    
    # Unzip it 
    Get-ChildItem -Path $tempFolder -Recurse -Filter "$App.Source.zip" | Expand-Archive -Destination $tempFolder/BaseApplicationSource

    # Recompile them
    $CompilationParameters["appProjectFolder"] = "$tempFolder/BaseApplicationSource"

    # Iterate through hashtable and print keys and values
    foreach ($key in $CompilationParameters.Keys) {
        Write-Host "$key : $($CompilationParameters[$key])"
    }
    Compile-AppWithBcCompilerFolder $CompilationParameters

    # Copy the new app files to the symbols folder
    $appFiles = Get-ChildItem -Path $projectFolder -Filter "*.app"
    
    foreach ($appFile in $appFiles) {
        Write-Host "Copying $appFile to $SymbolsFolder"
        $appFile | Copy-Item -Destination $SymbolsFolder -Force
    }
}