# Add the code to the psm1
# Update the Version
ModuleVersion = '2.0'
# Add the Function name to the .psd1
FunctionsToExport = @('Write-MyLog','Find-VM','Stop-MyVM','Start-MyVM','Update-VMCPU','Update-VMMem')
# Remove the Module from the console
Remove-Module mymodule
# Import the module
Import-module -Name "C:\open_projects\Invoke-Automation\Powercli\VMwareExplore_2024\PowerCLI_301\module_2\mymodule_2.psd1"

#run the new Script!

##########################################################
# Edit VM Memory
function Update-VMMem {
    param(
        $vm,
        $NewMem
    )
    if($null -eq $vm){
        # Throw and error.
        Throw "The vm is empty!"
    } elseif($null -eq $NewMem) {
        Throw "The NewMem is empty!"
    } else {
        $vmname = $vm.name
        # Get the current VM details
        $vm = Get-VM -Name $vmname
        if($vm.Powerstate -like '*PoweredOn'){
            # If the vm was magically turned on - don't make any changes!
            Throw "$vmname is Powered on - Cannot update CPU"
        } else {
            $CurrentMem = $vm.MemoryGB 
            # Check to see if the VM already has the correct Setting.
            if($CurrentMem -eq $NewMem){
                Write-MyLog "VM: $vmname already has Mem setting $NewMem."
            } else {
                # Update the VM's setting
                Write-MyLog "Updating VM: $vmname MemoryGB to $NewMem."
                Set-VM -VM $vm -MemoryGB $NewMem -Confirm:$false | Out-Null
            }
        }
    }
}