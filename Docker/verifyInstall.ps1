# Import Power* modules from temp directory
Import-Module c:\temp\PowerLumber.psm1
Import-Module c:\temp\PowerWamp.psm1
# Import PowerCLI Modules
Get-Module -ListAvailable VMware* | Import-Module

#Write installed modules to txt file.
Get-Module | Out-File c:\temp\modules.log