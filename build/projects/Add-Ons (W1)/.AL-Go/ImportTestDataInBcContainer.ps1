Param(
    [Parameter(ParameterSetName="ALGo")]
    [Hashtable]$parameters,
    [Parameter(ParameterSetName="Manual")]
    [string]$containerName
)

function Get-NavDefaultCompanyName
{
    return "CRONUS International Ltd."
}

if ($PSCmdlet.ParameterSetName -eq 'ALGo') {
    $containerName = $parameters.ContainerName
}

$projectSettings = Get-Content "$PSScriptRoot/settings.json" | ConvertFrom-Json

if ($projectSettings.useProjectDependencies -eq $true) {
    # Get the repoversion
    #Import-Module "$PSScriptRoot\EnlistmentHelperFunctions.psm1"
    $repoVersion = "27.0" #Get-ConfigValue -ConfigType "AL-GO" -Key "RepoVersion"
    $DemoDataType = "EXTENDED"

    Write-Host "Initializing company"
    Invoke-NavContainerCodeunit -Codeunitid 2 -containerName $containerName -CompanyName (Get-NavDefaultCompanyName)

    Write-Host "Importing configuration package"
    Invoke-NavContainerCodeunit -Codeunitid 8620 -containerName $containerName -CompanyName (Get-NavDefaultCompanyName) -MethodName "ImportAndApplyRapidStartPackage" -Argument "C:\ConfigurationPackages\NAV$($repoVersion).W1.ENU.$($DemoDataType).rapidstart"

    <#
    Write-Host "Initializing company"
    Invoke-NavContainerCodeunit -Codeunitid 2 -containerName $containerName -CompanyName (Get-NavDefaultCompanyName)

    Write-Host "Importing configuration package"
    Invoke-NavContainerCodeunit -CodeunitId 5193 -containerName $containerName -CompanyName (Get-NavDefaultCompanyName) -MethodName "CreateAllDemoData"
    Invoke-NavContainerCodeunit -CodeunitId 5140 -containerName $containerName -CompanyName (Get-NavDefaultCompanyName) -MethodName "DeleteWarehouseEmployee"
#>
}

