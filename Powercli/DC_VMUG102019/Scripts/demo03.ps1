function Start-VMlist{
    <#
	.DESCRIPTION
		This function will attempt to power on all vm's found in a vCenter. This is not a recommended practice!
	.EXAMPLE
        Start-vmList
    #>
    $vmList = Get-VM
    # Check for an empty list
    if(($vmList | Measure-Object).count -gt 0){
        foreach($vm in $vmList){
            try {
                Write-Output "Starting vm: $vm"
                # End this specific loop if the VM was not started!
                Start-VM $vm -ErrorAction Stop
                Write-Output "The vm was started."
            } 
            catch {
                Write-Output "Unable to Start vm: $vm"
                $_.Exception.Message
                Write-Output "------------------------------------------------"
            }
        }
    }
}
# Invoke-ScriptAnalyzer -Path .\demo03.ps1
# Get-Help Start-vmList
# Get-Help Start-vmList -Full
# Start-vmList