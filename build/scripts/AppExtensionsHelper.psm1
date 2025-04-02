function GetSourceCode() {
    param(
        [string] $App,
        [string] $TempFolder
    )
    $sourceArchive = Get-ChildItem -Path $TempFolder -Recurse -Filter "$App.Source.zip" -ErrorAction SilentlyContinue
    $sourceCodeFolder = "$TempFolder/$($App -replace " ", "_")Source"

    if (-not $sourceArchive) {
        # Find out which version of the apps we need 
        $artifactVersion = "https://bcinsider-fvh2ekdjecfjd6gk.b02.azurefd.net/sandbox/27.0.31285.0/platform"

        # Download the artifact that contains the source code for those apps
        Download-Artifacts -artifactUrl $artifactVersion -basePath $TempFolder | Out-Null

        # Unzip it 
        $sourceArchive = Get-ChildItem -Path $TempFolder -Recurse -Filter "$App.Source.zip" 
    }
    
    $sourceArchive | Expand-Archive -Destination $sourceCodeFolder

    if (-not (Test-Path $sourceCodeFolder)) {
        Write-Error "Could not find the source code for $App"
        throw
    }

    return $sourceCodeFolder
}

function Build-Dependency() {
    param(
        [string] $App,
        [hashtable] $CompilationParameters
    )
    # Set up temp folder if not already set
    if ($null -eq $script:tempFolder) {
        $sharedFolders = Get-BcContainerSharedFolders -containerName $CompilationParameters["containerName"] #hashtable with all the shared folders
        # print shared folders
        foreach ($key in $sharedFolders.Keys) {
            Write-Host "$key : $($sharedFolders[$key])"
        }
        # Pick the first shared folder as temp folder
        $sharedFolder = $sharedFolders.Values | Select-Object -Last 1
        Write-Host "Using $sharedFolder as temp folder"
        $script:tempFolder = Join-Path $sharedFolder ([System.Guid]::NewGuid().ToString())
        New-Item -ItemType Directory -Path $tempFolder -Force | Out-Null
    }

    # Create a new folder for the symbols if it does not exist
    $newSymbolsFolder = (Join-Path $script:tempFolder "Symbols")
    if (-not (Test-Path $newSymbolsFolder)) {
        New-Item -ItemType Directory -Path $newSymbolsFolder -Force | Out-Null
    }

    Write-Host "Get source code for $App"
    $sourceCodeFolder = GetSourceCode -App $App -TempFolder $script:tempFolder

    # Copy apps to packagecachepath
    $addOnsSymbolsFolder = $CompilationParameters["appSymbolsFolder"]

    # Log what is in the symbols folder
    Write-Host "Symbols folder: $SymbolsFolder"
    Get-ChildItem -Path $SymbolsFolder | ForEach-Object {
        Write-Host $_.Name
    }
    
    # Update the CompilationParameters
    $CompilationParameters["appProjectFolder"] = $sourceCodeFolder # Use the downloaded source code as the project folder
    $CompilationParameters["appOutputFolder"] = $addOnsSymbolsFolder # Place the app directly in the symbols folder for Add-Ons
    $CompilationParameters["appSymbolsFolder"] = $newSymbolsFolder # New symbols folder only used for recompliation. Not used for compilation of Add-Ons

    # Disable all cops for dependencies
    $CompilationParameters["EnableAppSourceCop"] = $false
    $CompilationParameters["EnableCodeCop"] = $false
    $CompilationParameters["EnableUICop"] = $false
    $CompilationParameters["EnablePerTenantExtensionCop"] = $false
    $CompilationParameters.Remove("ruleset")

    Write-Host "Recompile $App with parameters"
    foreach ($key in $CompilationParameters.Keys) {
        Write-Host "$key : $($CompilationParameters[$key])"
    }

    $ContainerName = $CompilationParameters["containerName"]
    $files = Get-ChildItem -Path "$($bcContainerHelperConfig.containerHelperFolder)\\Extensions\\$ContainerName" -Recurse
    $files | ForEach-Object {
        Write-Host $_.FullName
    }
    #$netPackages = @()
    #$netPackages += @(Get-ChildItem -Path "$($bcContainerHelperConfig.containerHelperFolder)\\Extensions\\$ContainerName\\.netPackages\\Shared\\Microsoft.AspNetCore.App" | Sort-Object -Descending | Select-Object -ExpandProperty FullName)
    #$netPackages += @(Get-ChildItem -Path "$($bcContainerHelperConfig.containerHelperFolder)\\Extensions\\$ContainerName\\.netPackages\\Shared\\Microsoft.NETCore.App" | Sort-Object -Descending | Select-Object -ExpandProperty FullName)
  
    
    #$CompilationParameters["assemblyProbingPaths"] = $netPackages
    $bcContainerHelperConfig.MinimumDotNetRuntimeVersionStr = "99.0.0"

    #Compile-AppWithBcCompilerFolder @CompilationParameters
    Compile-AppInBcContainer @CompilationParameters

    # Remove the source code folder
    if (Test-Path $sourceCodeFolder) {
        Write-Host "Removing source code folder $sourceCodeFolder"
        Remove-Item -Path $sourceCodeFolder -Recurse -Force
    }
}

Export-ModuleMember -Function GetSourceCode, Build-Dependency