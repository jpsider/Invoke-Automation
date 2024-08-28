# My Script
<#
Get a list of Virtual machines based on a search term
    Get the Number of VM's in the list & display it
    Set the counter to 0
    Loop through each VM
        Power off the Virtual machine
        Update the CPU count
        Update the memory 
        Power on the vm
        Update the Counter
        Display the number of VM's updated so far
    Give the final number of VM's updated
#>

# Display current VM details
Write-Warning "---------- Starting Deets ----------"
Get-VM

# Get a list of Virtual machines based on a search term
$vmlist = Find-VM -searchterm RP0
$TotalCount = ($vmlist | Measure-object).count

# Get the Number of VM's in the list & display it
Write-MyLog "The total count of vms is $totalCount"

# Set the counter to 0
$Counter = 0

# Loop through each VM
Foreach ($vm in $vmlist){
    # Power off the Virtual machine
    Stop-MyVM -vm $vm

    # Update the CPU count
    Update-VMCPU -vm $vm -NewCPU 99

    # Update the Mem count
    Update-VMMem -vm $vm -NewMem 100

    # Power on the vm
    Start-MyVM -vm $vm

    # Update the Counter
    $Counter++

    # Display the number of VMs updated so far
    Write-MyLog "Total number of VMs so far: $Counter"
}
# Give the final number of VMs updated
Write-MyLog "Total number of VMs: $Counter of $TotalCount"

# Display the final vm details
Write-Warning "---------- Final Deets ----------"
Get-VM