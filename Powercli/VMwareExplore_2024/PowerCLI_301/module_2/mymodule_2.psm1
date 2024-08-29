# Logger
function Write-MyLog {
    param (
        $Message
    )
    # Determine if the Message is empty.
    if($null -eq $Message){
        # Throw and error.
        Throw "The Message is blank!"
    } else {
        # Write the message out to the console.
        Write-Host "$Message"
    }
}

# Search for VMs
function Find-VM {
    param(
        $SearchTerm
    )
    # Determine if the Searchterm is empty.
    if($null -eq $SearchTerm){
        # Throw and error.
        Throw "The SearchTerm is blank!"
    } else {
        # Search and return the list of Virtual machines.
        Write-MyLog "Searching for VM's that match the term: $SearchTerm"
        $vmlist = Get-VM | Where-Object {$_.Name -like "*$SearchTerm*"}
        $vmlist
    }
}

# Turn off VMs
function Stop-MyVM {
    param(
        $vm
    )
    # Determine if the vmname is empty.
    if($null -eq $vm){
        # Throw and error.
        Throw "The vm is empty!"
    } else {
        # Determine if the VM is PoweredOn
        $vmname = $vm.name
        if($vm.Powerstate -like '*PoweredOn'){
            Write-MyLog "Powering off $vmname"
            # Power the vm off
            Stop-VM -VM $vm -runasync -Confirm:$false | Out-Null
        } else {
            # Do nothing since the VM is powered off!
            Write-MyLog "The VM $vmname was already powered off."
        }
    }
}

# Edit VM CPUs
function Update-VMCPU {
    param(
        $vm,
        $NewCPU
    )
    if($null -eq $vm){
        # Throw and error.
        Throw "The vm is empty!"
    } elseif($null -eq $NewCPU) {
        Throw "The NewCPU is empty!"
    } else {
        $vmname = $vm.name
        # Get the current VM details
        $vm = Get-VM -Name $vmname
        if($vm.Powerstate -like '*PoweredOn'){
            # If the vm was magically turned on - don't make any changes!
            Throw "$vmname is Powered on - Cannot update CPU"
        } else {
            $CurrentCPU = $vm.NumCpu 
            # Check to see if the VM already has the correct Setting.
            if($CurrentCPU -eq $NewCPU){
                Write-MyLog "VM: $vmname already has CPU setting $NewCPU."
            } else {
                # Update the VM's setting
                Write-MyLog "Updating VM: $vmname CPU to $NewCPU."
                Set-VM -VM $vm -NumCpu $NewCPU -Confirm:$false | Out-Null
            }
        }
    }
}

# Power on a VM
function Start-MyVM {
    param(
        $vm
    )
    # Determine if the vmname is empty.
    if($null -eq $vm){
        # Throw and error.
        Throw "The vm is empty!"
    } else {
        # Determine if the VM is PoweredOn
        $vmname = $vm.name
        # Get the current VM details
        $vm = Get-VM -Name $vmname
        if($vm.Powerstate -like '*PoweredOn'){
            # Do nothing since the VM is powered on!
            Write-MyLog "The VM $vmname was already powered on."
        } else {
            # Power the vm on
            Write-MyLog "Powering on $vmname"
            Start-VM -VM $vm -runasync -Confirm:$false | Out-Null
            
        }
    }
}
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