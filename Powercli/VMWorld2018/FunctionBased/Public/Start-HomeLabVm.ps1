function Start-HomeLabVm {
    # Should process
    # $null -eq $results
    # Describe Parameters


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
    [CmdletBinding(
        SupportsShouldProcess = $true,
        ConfirmImpact = "Low"
    )]
    [OutputType([boolean])]
    Param (
        [Parameter(Mandatory)]
        [string]$VM
    )

    if ($pscmdlet.ShouldProcess("Executing Start-HomeLabVm Function."))
    {
        # Validate Connection to vCenter
        if(!(Confirm-vCenter)){
            Throw "Not Connected to a vCenter."
        } else {
            # Gather a list of VM's from vCenter
            $results = Get-VM -Name $VM -ErrorAction SilentlyContinue

            if ($null -eq $results)
            {
                Throw "No VM by the name : $VM"
            }
            else
            {
                foreach ($VMname in $results)
                {
                    # Verify the VM is not powered on
                    if (Confirm-PowerState -VM $VMname)
                    {
                        Write-Warning "The VM: $VMname is already PoweredOn."
                        $true
                    }
                    else
                    {
                        # Power on the VM
                        Write-Output "Powering On VM: $VMname"
                        if (Start-VM -VM $VMname)
                        {
                            Write-Output "The VM: $VMname powered on Successfully."
                            $true
                        }
                        else
                        {
                            Throw "The VM: $VMname did not power on."
                        }
                    }
                } # End foreach
            } # End Results not null
        } # End vCenter connection
    } else {
        # -WhatIf was used.
        $false
    }
}