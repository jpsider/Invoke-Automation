function Enable-PowerCLI
{
get-module -ListAvailable vm* | Import-Module
Import-Module Vester
Import-Module PowerNSX
Import-Module PowerWamp
Import-Module PowerLumber
Import-Module vDocumentation
Import-Module PSScriptAnalyzer
Import-Module PSCodeHealth
Import-Module PSDeploy
Import-Module Plaster
}
Enable-PowerCLI