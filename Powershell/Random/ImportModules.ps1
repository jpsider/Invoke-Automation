# Import the Modules
Import-Module VMware.PowerCLI, PowerWamp, PowerLumber, Vester, PowervRA

# Import local module
Import-Module c:\temp\PowerNSX.psm1

#Write installed modules to txt file.
Get-Module | Out-File c:\temp\modules.log
