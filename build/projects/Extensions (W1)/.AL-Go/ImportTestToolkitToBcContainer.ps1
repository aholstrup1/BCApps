[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', 'parameters', Justification = 'The parameter is not used, but it''s script needs to match this format')]
Param(
    [hashtable] $parameters
)

# Ordered list of test framework apps to install
$installAdditionalApps = "Microsoft_Permissions Mock.app", "Microsoft_Test Runner.app", "Microsoft_Any.app", "Microsoft_Library Assert.app", "Microsoft_Library Variable Storage.app", "Microsoft_System Application Test Library.app", "Microsoft_Business Foundation Test Libraries.app", "Microsoft_Performance Toolkit.app", "Microsoft_AI Test Toolkit.app"
$allApps = (Invoke-ScriptInBCContainer -containerName $containerName -scriptblock { Get-ChildItem -Path "C:\Applications\" -Filter "*.app" -Recurse })

foreach ($app in $installAdditionalApps) {
    $appFile = $allApps | Where-Object { $_.Name -eq $app }
    Publish-BcContainerApp -containerName $containerName -appFile ":$($appFile.FullName)" -skipVerification -scope Tenant -install -sync
    $appFile = $null
} 