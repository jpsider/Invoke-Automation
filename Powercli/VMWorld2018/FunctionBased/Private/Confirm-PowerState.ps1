function Confirm-PowerState {
    <#
    .DESCRIPTION
    	Confirms the desired PowerState of a VM.
    .PARAMETER VM
        A VM Object is required
    .PARAMETER PowerState
        A PowerState is optional, PoweredOff is default.
    .EXAMPLE
        Confirm-PowerState -VM Win_7_Test_vm
    .NOTES
        Returns a boolean
    #>

    Param (
        [Parameter(Mandatory)]$VM,
        [Parameter()][string]$PowerState = "PoweredOff"
    )
    if ($VM.PowerState -eq "$PowerState"){
        $true
    } else {
        $false
    }
}