Param(
    [Hashtable]$parameters
)

Import-Module "$PSScriptRoot\DemodataHelpers.psm1"
Invoke-ContosoDemoTool -ContainerName $parameters.containerName