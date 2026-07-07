Param(
    [Parameter(Mandatory = $false)]
    $AppFiles,
    [Parameter(Mandatory = $false)]
    [string] $AppType = 'app',
    [Parameter(Mandatory = $false)]
    $CompilationParams
)

<#
.SYNOPSIS
    Prunes AL error-log files for apps that live under src/Layers.
.DESCRIPTION
    When trackALAlertsInGitHub is enabled together with workspace compilation, the AL compiler
    writes one '<appName>_<timestamp>.errorLog.json' file per project into the ErrorLogDirectory
    (the project's .buildartifacts/ErrorLogs folder). The src/Layers apps (Base Application,
    DemoTool, the Tests-* suites, ...) are by far the largest source of diagnostics and would push
    the merged SARIF beyond GitHub code scanning's per-run / per-rule limits.

    This PostCompileApp hook reads the application name from every app.json under src/Layers and
    deletes the matching error-log files, so only the actively developed src/Apps diagnostics are
    surfaced as AL alerts. It is a no-op when error-log tracking is off (ErrorLogDirectory unset).

    The hook never throws: any failure is logged as a warning so it cannot break the build.
#>

try {
    # Resolve the ErrorLogDirectory from the compilation parameters. When trackALAlertsInGitHub is
    # off, this key is absent and there is nothing to prune.
    $errorLogDirectory = $null
    if ($CompilationParams -is [System.Collections.IDictionary]) {
        $errorLogDirectory = $CompilationParams['ErrorLogDirectory']
    }
    if (-not $errorLogDirectory) {
        Write-Host "PostCompileApp: no ErrorLogDirectory in compilation parameters; nothing to prune."
        return
    }
    if (-not (Test-Path -Path $errorLogDirectory)) {
        Write-Host "PostCompileApp: ErrorLogDirectory '$errorLogDirectory' does not exist; nothing to prune."
        return
    }

    # Locate src/Layers relative to the repository root.
    $repoRoot = $env:GITHUB_WORKSPACE
    if (-not $repoRoot) { $repoRoot = (Get-Location).Path }
    $layersFolder = Join-Path $repoRoot 'src/Layers'
    if (-not (Test-Path -Path $layersFolder)) {
        Write-Host "PostCompileApp: '$layersFolder' not found; nothing to prune."
        return
    }

    # Normalizes an application name / file stem for comparison: replaces characters that are invalid
    # in file names (mirroring how the compiler builds the error-log file name), trims and lowercases.
    function Get-NormalizedName {
        param([string] $Name)
        if (-not $Name) { return '' }
        $invalidChars = [System.IO.Path]::GetInvalidFileNameChars()
        $builder = New-Object System.Text.StringBuilder
        foreach ($char in $Name.ToCharArray()) {
            if ($invalidChars -contains $char) { [void]$builder.Append('_') } else { [void]$builder.Append($char) }
        }
        return $builder.ToString().Trim().ToLowerInvariant()
    }

    # Collect the application name from every app.json under src/Layers (apps and test apps).
    $layersAppNames = @()
    Get-ChildItem -Path $layersFolder -Recurse -Filter 'app.json' -File -ErrorAction SilentlyContinue | ForEach-Object {
        try {
            $appJson = Get-Content -Path $_.FullName -Raw -Encoding UTF8 | ConvertFrom-Json
            if (($appJson.PSObject.Properties.Name -contains 'name') -and $appJson.name) {
                $layersAppNames += $appJson.name
            }
        }
        catch {
            Write-Host "::Warning::PostCompileApp: failed to read application name from '$($_.FullName)': $_"
        }
    }
    $layersAppNames = @($layersAppNames | Sort-Object -Unique)
    if ($layersAppNames.Count -eq 0) {
        Write-Host "PostCompileApp: no application names found under '$layersFolder'; nothing to prune."
        return
    }
    $normalizedLayersNames = @($layersAppNames | ForEach-Object { Get-NormalizedName $_ })

    # Delete error-log files whose name (before the '_<timestamp>' suffix) matches a src/Layers app.
    # The compiler emits '<appName>_<timestamp>.errorLog.json', so a normalized StartsWith('<name>_')
    # match is robust regardless of the exact timestamp format.
    $deletedCount = 0
    Get-ChildItem -Path $errorLogDirectory -Filter '*.errorLog.json' -File -ErrorAction SilentlyContinue | ForEach-Object {
        $stem = $_.Name -replace '(?i)\.errorLog\.json$', ''
        $normalizedStem = Get-NormalizedName $stem
        foreach ($normalizedName in $normalizedLayersNames) {
            if ($normalizedStem.StartsWith("$normalizedName" + '_')) {
                Remove-Item -Path $_.FullName -Force -ErrorAction SilentlyContinue
                $deletedCount++
                Write-Host "PostCompileApp: removed src/Layers error log '$($_.Name)'"
                break
            }
        }
    }

    Write-Host "PostCompileApp: removed $deletedCount src/Layers error log file(s) from '$errorLogDirectory'."
}
catch {
    Write-Host "::Warning::PostCompileApp: failed to prune src/Layers error logs: $_"
}
