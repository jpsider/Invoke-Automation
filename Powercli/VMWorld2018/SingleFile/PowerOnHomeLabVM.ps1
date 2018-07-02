<#
.DESCRIPTION
	Power on a VM in my homelab. This script assumes a connection to vCenter.
.PARAMETER VM
    A vm Name is required
.EXAMPLE
    .\PowerOnHomeLabVM.ps1 -VM Win_7_Test_vm
.NOTES
    Returns a boolean
#>

Param (
    [Parameter(Mandatory)]
    [string]$VM
)

# Validate the vm exists
$results = Get-VM -Name $VM -ErrorAction SilentlyContinue

if ($results -eq $null)
{
    Write-Output "No VM by the name : $VM"
}
else
{
    foreach ($vmname in $results)
    {
        # Verify the VM is not powered on
        if ($vmname.PowerState -eq "PoweredOn")
        {
            Write-Output "The VM: $vmname is already PoweredOn."
        }
        else
        {
            # Power on the VM
            Write-Output "Powering On VM: $vmname"
            if (Start-VM -VM $vmname)
            {
                Write-Output "The VM: $vmname powered on Successfully."
            }
            else
            {
                Write-Output "The VM: $vmname did not power on."
            }
        }
    }
}

