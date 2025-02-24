# Example 1
Disconnect-VIServer -Confirm:$false
$vmlist = $null
# Why run the Get-VM if we never connect to a server?
$ErrorActionPreference = "Continue"
cls
Connect-VIServer -Server 0.0.0.0 -User u -Password p
$vmlist = Get-VM
foreach ($vm in $vmlist) {
    Stop-VM -vm $vm -Confirm:$false
}

# Example 2
Disconnect-VIServer -Confirm:$false
cls
$Server = (Get-NetIPAddress -InterfaceAlias *wsl* -AddressFamily IPv4).IPAddress
Disable-SSLValidation | Out-Null
Connect-VIServer -Server $Server -Port 443 -User u -Password p | Out-Null
if ((($global:DefaultVIServer).isConnected) -eq $true) {
    Write-Host -ForegroundColor Green "We are connected, Take over the world!"
} else {
    Write-host -ForegroundColor RED "We have a problem! no vCenter connection!!"
}

# Example 3
# This is a little better
Disconnect-VIServer -Confirm:$false
cls
Connect-VIServer -Server 0.0.0.0 -User u -Password p -ErrorAction Stop
$vmlist = Get-VM
foreach ($vm in $vmlist) {
    Stop-VM -vm $vm -Confirm:$false
}

# Example 4
# There are a ton of options out there, not all are right.
cls
$ErrorActionPreference = "Stop"
$Server = (Get-NetIPAddress -InterfaceAlias *wsl* -AddressFamily IPv4).IPAddress
Disable-SSLValidation | Out-Null
Connect-VIServer -Server $Server -Port 443 -User u -Password p | Out-Null
Get-vm "DC0_H0_VM1" | Stop-VM -Confirm:$false | Out-null

$vmlist = Get-VM
foreach ($vm in $vmlist) {
    Stop-VM -vm $vm -Confirm:$false | Out-Null
    Set-VM -vm $vm -NumCpu 1 -MemoryGB 4 -Confirm:$false | Out-Null
    Start-VM -VM $vm -Confirm:$false | Out-Null
}