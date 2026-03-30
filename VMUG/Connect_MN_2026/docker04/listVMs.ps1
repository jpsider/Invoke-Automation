# Connect to the vCenter
Connect-VIServer -server $env:vcenter -user u -password p

# List the virtual machines
do {
    Write-Output "############################" | Out-File -FilePath /app/logs/mylog.txt -Encoding ascii -Append
    Write-Output "Starting loop!" | Out-File -FilePath /app/logs/mylog.txt -Encoding ascii -Append
    $vms = Get-VM

    foreach ($vm in $vms) {
        $vmname = $vm.Name
        $PowerState = $vm.PowerState

        Write-Output "The VM $vmname has a powerstate of: $PowerState" | Out-File -FilePath /app/logs/mylog.txt -Encoding ascii -Append
    }
    
    Write-Output "End of loop, waiting 5 seconds!" | Out-File -FilePath /app/logs/mylog.txt -Encoding ascii -Append
    Get-Date -format mmddyyyy:ss  | Out-File -FilePath /app/logs/mylog.txt -Encoding ascii -Append
    Start-sleep -s 5

} while ($true)