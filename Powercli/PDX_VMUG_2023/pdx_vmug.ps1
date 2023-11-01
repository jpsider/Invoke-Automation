# PDX VMUG Usercon

# This is a Comment

<#
    This is also a comment
#>

Write-Output "some text" # You can comment here too!

# Verb-Noun
# Examples
Get-Process
Stop-Process
Write-Output






# Setup the Environment
# Start the vCenter simulator container
docker run --rm -d -p 443:443 lamw/govcsim

# Gather the IP address of the vCenter simulator container
$Server = (Get-NetIPAddress -InterfaceAlias *wsl* -AddressFamily IPv4).IPAddress
Disable-SSLValidation
$Server


# Connect to the vCenter Simulator
Connect-VIServer -Server $Server -Port 443 -User u -Password p

# Show the connected vCenter
$global:DefaultVIServer

# Other Commands
Get-VM
Get-VMHost
Get-Cluster
Get-DataStore
Get-Snapshot

# Objects


# Arrays vs. Hashtables


# The Pipeline


# Comment Based help

# Toggling the PowerState
