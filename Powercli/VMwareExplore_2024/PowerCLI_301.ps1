###############################################################
# Setup the Environment
# Start the vCenter simulator container
docker run --rm -d -p 443:443 lamw/govcsim

# Gather the IP address of the vCenter simulator container
$server = $null
$Server = (Get-NetIPAddress -InterfaceAlias *wsl* -AddressFamily IPv4).IPAddress
Disable-SSLValidation
$Server


###############################################################
# Connect to the vCenter Simulator
Connect-VIServer -Server $Server -Port 443 -User u -Password p

# Show the connected vCenter
$global:DefaultVIServer

###############################################################
# Import my local module
Import-module -Name "C:\open_projects\Invoke-Automation\Powercli\VMwareExplore_2024\module\mymodule.psm1"
Import-module -Name "C:\open_projects\Invoke-Automation\Powercli\VMwareExplore_2024\module\mymodule.psd1"

# Show the Functions available in "MyModule"
Get-Command -Module mymodule

# Get help for a command
Get-Help -Full -Name Write-Mylog

# Remove the Module
Remove-Module -Name mymodule