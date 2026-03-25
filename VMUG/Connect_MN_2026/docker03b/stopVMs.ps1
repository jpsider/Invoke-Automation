# Connect to the vCenter
Connect-VIServer -server $env:vcenter -user u -password p

Do {

    # List the virtual machines
    $vms = Get-VM

    foreach ($vm in $vms){
        If ($vm.PowerState -like "*Off*"){
            $VMpowerState = $vm.PowerState
            $VMname = $vm.Name
            Write-Host "The VM $VMname is $VMpowerState"
        } else {
            $VMpowerState = $vm.PowerState
            $VMname = $vm.Name
            Write-Host "The VM $VMname is $VMpowerState - Flipping it off!"
            Stop-VM -VM $vm -Confirm:$false | Out-null
        }
    }

    Write-Host "Sleeping for 15 seconds"
    start-sleep -Seconds 15

} while ($true)
