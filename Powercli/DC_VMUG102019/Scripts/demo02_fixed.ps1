Get-VM | ForEach-Object { Start-VM }

# OR

$vmList = Get-VM

if(($vmList | Measure-Object).count -gt 0){
    foreach($vm in $vmList){
        Write-Output "Starting vm: $vm"
        Start-VM $vm
        Write-Output "The vm: $vm was started."
    }
}
# Invoke-ScriptAnalyzer -Path .\demo02_fixed.ps1