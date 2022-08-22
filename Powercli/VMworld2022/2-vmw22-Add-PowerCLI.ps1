# We have already connected to the vCenter in the setup script.
Get-VM

Get-VM myvm

Get-VM myvm -ErrorAction Continue

Get-VM myvm -ErrorAction SilentlyContinue


###############################################################################
# Why is this important?

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