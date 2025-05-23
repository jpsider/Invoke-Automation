Disconnect-VIServer -Confirm:$false
# How about this?
cls
$ErrorActionPreference = "Stop"
try {
    $Server = (Get-NetIPAddress -InterfaceAlias *wsl* -AddressFamily IPv4).IPAddress
    Disable-SSLValidation | Out-Null
    Connect-VIServer -Server $Server -Port 443 -User u -Password p | Out-Null
}
Catch {
    $ErrorMessage = $_.Exception.Message
    Write-Host -ForegroundColor Yellow "The errorMessage: $errorMessage"
    Throw "Could not connect to the vCenter."
}

try {
    $vmList = Get-VM
    $vmlist
}
catch {
    $ErrorMessage = $_.Exception.Message
    Write-Host -ForegroundColor Yellow "The errorMessage: $errorMessage"
    Throw "Could not get the list of virtual machines."
}

Foreach ($vm in $vmlist){
    Try {
        $vmname = $vm.name
        Write-Host -ForegroundColor Green "Working on $vmname"
        Stop-VM -VM $vmname -Confirm:$false | Out-Null
    }
    Catch {
        $ErrorMessage = $_.Exception.Message
        Write-Host -ForegroundColor Yellow "The errorMessage: $errorMessage"
    }

    Try {
        if ((Get-VM $vmname).PowerState -eq "PoweredOff") {
            Set-VM -VM $vmname -NumCpu 2 -MemoryGB 8 -Confirm:$false | Out-Null
        } else {
            Throw "The Virtual machine is not powered off."
        }
        
    }
    Catch {
        $ErrorMessage = $_.Exception.Message
        Write-Host -ForegroundColor Yellow "The errorMessage: $errorMessage"
    }
    Finally {
        Write-Host -ForegroundColor Blue "Starting vm $vmname"
        Start-VM -VM $vmname -Confirm:$false | Out-Null
    }
}
Get-VM | Select-Object Name,NumCpu,MemoryGB,PowerState | Format-Table