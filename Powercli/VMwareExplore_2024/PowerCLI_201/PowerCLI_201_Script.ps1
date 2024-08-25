# This is a Script created for VMware Explore 2024 Las Vegas!
param($vmname)

Write-Host "Attempting to shutdown $vmname"
(Get-VM -Name $vmname | Get-View).ShutdownGuest()

Write-Host "Waiting 3 seconds for the guest to shutdown"
start-sleep -s 3

Write-Host "Status of all VMS:"
Get-VM