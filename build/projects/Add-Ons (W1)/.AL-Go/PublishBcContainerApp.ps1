Param([Hashtable]$parameters)

try {
    $parameters["scope"] = "Tenant"
    $parameters["ignoreIfAppExists"] = $true
    if (Test-BcContainer -containerName $parameters.ContainerName) {
        Publish-BcContainerApp @parameters
    }    
} catch {
    # Sometimes Publishing fails after publishing "Application"
    # error AL1024: A package with publisher 'Microsoft', name 'Application', and a version compatible with '25.0.0.0' could not be loaded. Value cannot be null. (Parameter 'appId')
    # Restarting the container fixes this issue
    Restart-NavContainer -containerName $parameters.ContainerName
    if (Test-BcContainer -containerName $parameters.ContainerName) {
        Publish-BcContainerApp @parameters
    } 
}