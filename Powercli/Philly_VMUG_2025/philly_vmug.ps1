# PHILLY VMUG Usercon
###############################################################
# Basics

# Verb-Noun
Get-Process
Write-Output "some text"

# List the approved Verbs
Get-Verb

# This is a Comment

<#
    This is also a comment
#>

Write-Output "some text" # You can comment here too! But this is kinda strange.


###############################################################
# Installing a Module
Get-PSRepository
Find-Module -Name jpsider
Install-Module -Name jpsider
Update-Module -Name jpsider
Get-Module
Import-Module -Name jpsider
Get-Module
Get-Command -Module jpsider
Save-Module -Name jpsider -Path c:\temp


###############################################################
# Setup the Environment
# Start the vCenter simulator container
docker run --rm -d -p 443:443 lamw/govcsim

# Gather the IP address of the vCenter simulator container
$server = $null
$Server = (Get-NetIPAddress -InterfaceAlias *wsl* -AddressFamily IPv4).IPAddress
Disable-SSLValidation
$Server

# Connect to the vCenter Simulator
Connect-VIServer -Server $Server -Port 443 -User u -Password p
# change the name of the first vm to "myvm"
get-vm | Select-Object -First 1 | set-vm -name myvm -Confirm:$false

# Show the connected vCenter
$global:DefaultVIServer

# Disconnect from the vCenter
Disconnect-VIServer -Force -Confirm:$false

###############################################################
# Connect to the vCenter Simulator
Connect-VIServer -Server $Server -Port 443 -User u -Password p

# Get Data from the vCenter
Get-VM
Get-VMHost
Get-Cluster
Get-DataStore


###############################################################
# Functions and Parameters
#<Function Name> <Parameter name>  <Parameter Value>
Get-VM           -Name              “myvm”

#<Function Name>    <Parameter name>  <Parameter Value>
Update-ConsoleTitle -Title              “Nashville UserCon Demo”

# Is a parameter required? PowerShell will ask!
Update-ConsoleTitle

###############################################################
# Objects
$vm = Get-VM "myvm"
Get-Member -InputObject $vm

Get-VM "myvm" | Get-View

$vmlist = Get-VM
Get-Member -InputObject $vmlist


###############################################################
# The Pipeline
Get-VM | Select-Object -Property Name
Get-VM | Where-Object {$_.Name -like “*myvm*”}

Get-Module -ListAvailable
Get-Module -ListAvailable | Where-Object {$_.Name -like '*VMware.PowerCLI*'}
Get-Module -ListAvailable  | Where-Object {$_.name -like 'VMware.PowerCLI'} | Select-Object Name,Version


###############################################################
# Comment Based help
Get-Help -Name Get-VM -full
Get-Help -Name Update-ConsoleTitle -Full


###############################################################
# Toggling the PowerState
Get-VM -Name "myvm"
Get-VM -Name "myvm" | Stop-VM -Confirm:$false
Get-VM -Name "myvm"
Get-VM -Name "myvm" | Start-VM -Confirm:$false
Get-VM -Name "myvm"