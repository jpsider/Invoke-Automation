Get-VM | Start-VM -Confirm:$false -ErrorAction SilentlyContinue
# Same list of VM's
Write-Host -ForegroundColor Yellow "ErrorActionPreference = $ErrorActionPreference"
$MyVMList = @(
    "DC0_H0_VM0",
    "DC0_H0_VM1",
    "myvm",
    "DC0_C0_RP0_VM1"
)

Foreach ($vmname in $MyVMList){
    Write-Host "Stopping vm $vmname"
    try{
        Stop-VM $vmname -Confirm:$false -ErrorAction Stop | Out-Null
        Write-Host "The VM is off!"
    } 
    catch {
        Write-Host "The vm $vmname did not power off!"
    }
}
Write-Host "My script is done!"

# Power the VM's back on.
Get-VM | Start-VM -Confirm:$false -ErrorAction SilentlyContinue


# Get a little fancier
Write-Host -ForegroundColor Yellow "ErrorActionPreference = $ErrorActionPreference"
$MyVMList = @(
    "DC0_H0_VM0",
    "DC0_H0_VM1",
    "myvm",
    "DC0_C0_RP0_VM1"
)

Foreach ($vmname in $MyVMList){
    Write-Host "Stopping vm $vmname"
    try{
        Stop-VM $vmname -Confirm:$false -ErrorAction Stop | Out-Null
        Write-Host "The VM is off!"
        Set-VM -VM $vmname -NumCpu 4 -MemoryGB 12 -Confirm:$false | Out-Null
        Start-vm -VM $vmname -Confirm:$false | Out-Null
    } 
    catch {
        Write-Host -ForegroundColor red "The vm $vmname did not power off!"
        $ErrorMessage = $_.Exception.Message
        Write-Host -ForegroundColor Yellow "The errorMessage: $errorMessage"
    }
}
Write-Host "My script is done!"

# But are we done? What if one of the vm's is already powered off?
Get-VM DC0_H0_VM1 | Stop-VM -Confirm:$false

# Will all the vm's have their settings updated?
Write-Host -ForegroundColor Yellow "ErrorActionPreference = $ErrorActionPreference"
$MyVMList = @(
    "DC0_H0_VM0",
    "DC0_H0_VM1",
    "DC0_C0_RP0_VM1"
)

Foreach ($vmname in $MyVMList){
    Write-Host "Stopping vm $vmname"
    try{
        Stop-VM $vmname -Confirm:$false -ErrorAction Stop | Out-Null
        Write-Host "The VM is off!"
        Set-VM -VM $vmname -NumCpu 1 -MemoryGB 4 -Confirm:$false | Out-Null
        Start-vm -VM $vmname -Confirm:$false | Out-Null
    } 
    catch {
        Write-Host -ForegroundColor red "The vm $vmname did not power off!"
        $ErrorMessage = $_.Exception.Message
        Write-Host -ForegroundColor Yellow "The errorMessage: $errorMessage"
    }
}
Write-Host "My script is done!"

get-vm