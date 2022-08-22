$MyVMList = @(
    "DC0_H0_VM0",
    "DC0_H0_VM1",
    "DC0_C0_RP0_VM1"
)

Foreach ($vmname in $MyVMList){
    Write-Host "Stopping vm $vmname"
    try{
        Stop-VM $vmname -Confirm:$false -ErrorAction Stop | Out-Null
        Write-Host "The VM is off! - Editing configuration."
        Set-VM -VM $vmname -NumCpu 4 -MemoryGB 12 -Confirm:$false | Out-Null
    } 
    catch {
        Write-Host -ForegroundColor red "The vm $vmname did not power off!"
        $ErrorMessage = $_.Exception.Message
        Write-Host -ForegroundColor Yellow "The errorMessage: $errorMessage"
        Write-Host -ForegroundColor Yellow "FailedItem: $FailedItem"
    }
    finally {
        <#Do this after the try block regardless of whether an exception occurred or not#>
        Start-VM -VM $vmname -Confirm:$false | Out-Null
        Write-Host -ForegroundColor Green "This is the finally block"
    }
}
    Write-Host "My script is done!"

Get-VM