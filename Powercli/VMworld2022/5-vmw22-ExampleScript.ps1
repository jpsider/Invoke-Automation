# Example 1
# Why run the Get-VM if we never connect to a server?
$ErrorActionPreference = "Continue"
Connect-VIServer -Server 0.0.0.0 -User u -Password p
$vmlist = Get-VM
foreach ($vm in $vmlist) {
    Stop-VM -vm $vm -Confirm:$false
}

# Example 2
# This is a little better
Connect-VIServer -Server 0.0.0.0 -User u -Password p -ErrorAction Stop
$vmlist = Get-VM
foreach ($vm in $vmlist) {
    Stop-VM -vm $vm -Confirm:$false
}

# Example 3
# There are a ton of options out there, not all are right.
Get-vm "DC0_H0_VM1" | Stop-VM -Confirm:$false | Out-null
$ErrorActionPreference = "Stop"
$Server = (Get-NetIPAddress -InterfaceAlias *wsl* -AddressFamily IPv4).IPAddress
Disable-SSLValidation | Out-Null
Connect-VIServer -Server $Server -Port 443 -User u -Password p | Out-Null

$vmlist = Get-VM
foreach ($vm in $vmlist) {
    Stop-VM -vm $vm -Confirm:$false | Out-Null
    Set-VM -vm $vm -NumCpu 1 -MemoryGB 4 -Confirm:$false | Out-Null
    Start-VM -VM $vm -Confirm:$false | Out-Null
}