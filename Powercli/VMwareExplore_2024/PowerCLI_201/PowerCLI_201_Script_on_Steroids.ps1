<#
    .DESCRIPTION
        This is a Script created for VMware Explore 2024 Las Vegas!
    .PARAMETER VMname
        The name of a Virtual machine
    .EXAMPLE
        . PowerCLI_201_Script_on_Steroids.ps1 -vmname "vmname"
    .NOTES
        I love PowerCLI!
#>

param(
    [Parameter(Mandatory)][String]$vmname
)

Try {
    $thisVM = Get-VM -Name $vmname
}
Catch {
    Throw "The VM $vmname does not exist."
}

if (($thisVM | Measure-Object).count -eq 1) {
    Try {
        if($thisVM.Powerstate -like '*on'){
            Write-Host "The vm is ON, Attempting to shutdown $vmname"
            ($thisVM | Get-View).ShutdownGuest()

            Write-Host "Waiting 3 seconds for the guest to shutdown"
            start-sleep -s 3
        } else {
            Write-Host "The vm is not powered on."
        }
    }
    Catch {
        $ErrorMessage = $_.Exception.Message
        $FailedItem = $_.Exception.ItemName
        Throw "Could not power VM off: $ErrorMessage $FailedItem"
    }
} elseif (($thisVM | Measure-Object).count -eq 0) {
    Write-Host "No vm's returned"
} else {
    Write-Host "More than one VM returned"
}


Write-Host "Status of all VMS:"
try {
    Get-VM
}
Catch {
    $ErrorMessage = $_.Exception.Message
    $FailedItem = $_.Exception.ItemName
    Throw "Could not display vm details: $ErrorMessage $FailedItem"
}