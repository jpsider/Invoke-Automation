# Import Power* modules from temp directory
Import-Module c:\temp\PowerLumber.psm1
Import-Module c:\temp\PowerWamp.psm1

# Unzip Powercli Modules
Expand-Archive C:\temp\PowerCLI.zip -DestinationPath 'C:\temp'

# Move Modules to correct Directory
Move-Item -Path 'C:\temp\PowerCLI\*' -Destination 'C:\Program Files\WindowsPowerShell\Modules'

# Import PowerCLI Modules
Get-Module -ListAvailable VMware.VimAutomation.C* | Import-Module -ErrorAction SilentlyContinue

#Write installed modules to txt file.
Get-Module | Out-File c:\temp\Loadedmodules.log