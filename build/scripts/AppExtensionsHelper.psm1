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

function Get-AssemblyProbingPaths() {
    param(
        [string] $TargetDotnetVersion = "8"
    )
    # Check if the target .NET version is installed
    $DotNetSharedPath = "$env:ProgramFiles\dotnet\shared\Microsoft.AspNetCore.App\$TargetDotnetVersion.*"
    if(!(Test-Path $DotNetSharedPath)) {
        throw "Please install dotnet $TargetDotnetVersion SDK, path not found $DotNetSharedPath"
    }    

    # Get the .NET latest minor version
    $versions = (Get-ChildItem "$DotNetSharedPath" -Name)
    $latestVersion = [version]"0.0.0"
    foreach ($currentVersion in $versions) {
        if ([version]$currentVersion -gt $latestVersion) {
            $latestVersion = [version]$currentVersion
        }
    }

    $assemblyProbingPaths = @()
    $assemblyProbingPaths += "$env:ProgramFiles\dotnet\shared\Microsoft.AspNetCore.App\$latestVersion"
    $assemblyProbingPaths += "$env:ProgramFiles\dotnet\shared\Microsoft.NETCore.App\$latestVersion"
    $assemblyProbingPaths += "$env:ProgramFiles\dotnet\shared\Microsoft.WindowsDesktop.App\$latestVersion"

    if (($null -ne $bcContainerHelperConfig)) {
        # Set the minimum .NET runtime version for the bccontainerhelper to avoid containerhelper injecting a newer version of the .NET runtime
        $bcContainerHelperConfig.MinimumDotNetRuntimeVersionStr = "99.0.0"
    }
    return $assemblyProbingPaths -join ","
}
function Build-Dependency() {
    param(
        [string] $App,
        [hashtable] $CompilationParameters
    )
    # Set up temp folder if not already set
    if ($null -eq $script:tempFolder) {
        $script:tempFolder = Join-Path $env:TEMP ([System.Guid]::NewGuid().ToString())
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
    $CompilationParameters["assemblyProbingPaths"] = Get-AssemblyProbingPaths
    
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

    Compile-AppWithBcCompilerFolder @CompilationParameters
}

Export-ModuleMember -Function GetSourceCode, Build-Dependency