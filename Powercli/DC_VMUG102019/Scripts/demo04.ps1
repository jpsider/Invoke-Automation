Function Confirm-PowerState{
    
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
# Invoke-ScriptAnalyzer -Path .\demo03.ps1
# Invoke-Pester -Script .\demo04.tests.ps1 -CodeCoverage .\demo04.ps1
    <#
	.DESCRIPTION
        This function will confirm a virtual machines PowerState.
    .PARAMETER VM
        Specify a VM name (Mandatory)
    .PARAMETER PowerState
        Specify a VM PowerState to verify (Default is 'PoweredOff')
	.EXAMPLE
        Confirm-PowerState
    #>