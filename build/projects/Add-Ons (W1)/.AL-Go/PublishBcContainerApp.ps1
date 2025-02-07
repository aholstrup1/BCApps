Param([Hashtable]$parameters)

$parameters["useDevEndpoint"] = $true
Publish-BcContainerApp @parameters