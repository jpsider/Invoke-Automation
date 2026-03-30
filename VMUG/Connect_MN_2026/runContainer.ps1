# Start a PowerShell Container
docker run -it mcr.microsoft.com/powershell

# Get the version of PowerShell
$PSVersiontable.PSversion

# Install VCF.Powercli
Install-Module -Name VCF.PowerCLI -Force -Confirm:0

# Set PowerCLI Configuration
Set-PowerCLIConfiguration -InvalidCertificateAction Ignore -ParticipateInCeip $false -Confirm:0

# Connect to vCenter Simulator
Connect-VIServer -server 172.30.160.1 -user u -password p

# List some things!
Get-VM
Get-VMHost