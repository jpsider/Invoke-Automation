# We have already connected to the vCenter in the setup script.
$Server = (Get-NetIPAddress -InterfaceAlias *wsl* -AddressFamily IPv4).IPAddress
Disable-SSLValidation
$Server
Connect-VIServer -Server $Server -Port 443 -User u -Password p

Get-VM

Get-VM myvm

Get-VM myvm -ErrorAction Continue

Get-VM myvm -ErrorAction SilentlyContinue 

Get-VM myvm -ErrorAction Continue; Get-VMHost "nohost" -ErrorAction stop; Write-host "Hello world"

Get-VM myvm -ErrorAction Continue; Get-VMHost "nohost" -ErrorAction Continue; Write-host "Hello world"

Get-VM myvm -ErrorAction SilentlyContinue; Get-VMHost "nohost" -ErrorAction SilentlyContinue; Write-host "Hello world"

#What about the PipeLine?
Get-VMHost "DC0_H0" | Get-VM

Get-VMHost "nohost" -ErrorAction SilentlyContinue | Get-VM

Get-VMHost "nohost" -ErrorAction SilentlyContinue | Get-VM -ErrorAction SilentlyContinue | Write-Host "nothing"

###############################################################################
# Why is this important?
cls
Write-Host "Let's mess with a script."

get-vm 

Write-Host "Script is complete."

###############################################################################
# Attempt 1 - Remember the system preference is to Continue!
Write-Host "Let's mess with a script."

get-vm myvm

Write-Host "Script is complete."

###############################################################################
# Attempt 2 - What if we stop?
Write-Host "Let's mess with a script."

get-vm myvm -ErrorAction Stop

Write-Host "Script is complete."

###############################################################################
# Attempt 3 - Better!
Write-Host "Let's mess with a script."

get-vm myvm -ErrorAction SilentlyContinue

Write-Host "Script is complete."

###############################################################################
# Attempt 4 - Ewww it's ugly!
Write-Host "Let's add some Logic"

$vmlist = get-vm myvm

if ($null -eq $vmlist){
    Write-Host "No VM's Returned."
} else {
    $vmlist
}

Write-Host "All Done"

###############################################################################
# Attempt 5
cls
Write-Host "Let's add some Logic & smarts!"

$vmlist = get-vm myvm -ErrorAction SilentlyContinue

if ($null -eq $vmlist){
    Write-Host "No VM's Returned."
} else {
    $vmlist
}

Write-Host "All Done"

###############################################################################
# Attempt 6
cls
Write-Host -ForegroundColor Yellow "ErrorActionPreference = $ErrorActionPreference"
$MyVMList = @(
    "DC0_H0_VM0",
    "DC0_H0_VM1",
    "myvm",
    "DC0_C0_RP0_VM1"
)

Foreach ($vm in $MyVMList){
    $vmname = $vm.name
    Write-Host "Stopping vm $vmname"
    Stop-VM $vm -Confirm:$false
    Write-Host "The VM is off!"
}
Write-Host "My script is done!"

###############################################################################
# Attempt 7
cls
Write-Host -ForegroundColor Yellow "ErrorActionPreference = $ErrorActionPreference"
$MyVMList = @(
    "DC0_H0_VM0",
    "DC0_H0_VM1",
    "myvm",
    "DC0_C0_RP0_VM1"
)

Foreach ($vm in $MyVMList){
    $vmname = $vm.name
    Write-Host "Stopping vm $vmname"
    Stop-VM $vm -Confirm:$false -ErrorAction Stop
    Write-Host "The VM is off!"
}
Write-Host "My script is done!"