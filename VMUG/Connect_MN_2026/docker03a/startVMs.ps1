# Connect to the vCenter
Connect-VIServer -server $env:vcenter -user u -password p

Do {

    # List the virtual machines
    $vms = Get-VM

    foreach ($vm in $vms){
        If ($vm.PowerState -like "*On*"){
            $VMpowerState = $vm.PowerState
            $VMname = $vm.Name
            Write-Host "The VM $VMname is $VMpowerState"
        } else {
            $VMpowerState = $vm.PowerState
            $VMname = $vm.Name
            Write-Host "The VM $VMname is $VMpowerState - Flipping it on!"
            Start-VM -VM $vm -RunAsync | Out-null
        }
    }

    Write-Host "Sleeping for 30 seconds"
    start-sleep -Seconds 30

} while ($true)
