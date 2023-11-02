# PDX VMUG Usercon

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

Write-Output "some text" # You can comment here too!


###############################################################
# Installing a Module
Get-PSRepository
Find-Module -Name jpsider
Install-Module -Name jpsider
Update-Module -Name jpsider
Import-Module -Name jpsider
Get-Command -Module jpsider


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
Get-Snapshot


###############################################################
# Functions and Parameters
#<Function Name> <Parameter name>  <Parameter Value>
Get-VM           -Name              “myvm”

#<Function Name>    <Parameter name>  <Parameter Value>
Update-ConsoleTitle -Title              “Fancy New Title”


###############################################################
# Objects
$vm = Get-VM "myvm"
Get-Member -InputObject $vm

$vmlist = Get-VM
Get-Member -InputObject $vmlist


###############################################################
# The Pipeline
Get-VM | Select-Object -Property Name
Get-VM | Where-Object {$_.Name -like “*myvm*”}

Find-Module VMware.PowerCLI
Find-Module VMware.PowerCLI | Select Name,Version


###############################################################
# Comment Based help
Get-Help Get-VM -full
Get-Help Update-ConsoleTitle -Full


###############################################################
# Toggling the PowerState
Get-VM -Name "myvm"
Get-VM -Name "myvm" | Stop-VM -Confirm:$false
Get-VM -Name "myvm"
Get-VM -Name "myvm" | Start-VM -Confirm:$false
Get-VM -Name "myvm"