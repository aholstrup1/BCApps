Param(
    [Hashtable]$parameters
)

$script = Join-Path $PSScriptRoot "../../../scripts/NewBcContainer.ps1" -Resolve
. $script -parameters $parameters -keepApps @("System Application", "Business Foundation", "Base Application", "Application")