# Quick script to import desired Modules
# Set the Powershell Gallery to a Trusted source
Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Force
Set-PSRepository -name PSGallery -InstallationPolicy Trusted 

# Install desired modules from PSGallery
Install-Module -Name VMware.PowerCLI -Confirm:$false
Install-Module -Name PowerWamp -Confirm:$false
Install-Module -Name PowerLumber -Confirm:$false
Install-Module -Name PowervRA -Confirm:$false
Install-Module -Name Vester -Confirm:$false

# Install MySQL plugin
Start-Process c:\temp\mysql-connector.exe -ArgumentList '/quiet /passive' -Wait