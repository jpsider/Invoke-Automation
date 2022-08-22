# How about this?
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
        Set-VM -VM $vmname -NumCpu 4 -MemoryGB 16 -Confirm:$false | Out-Null
        
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
Get-VM | Select-Object Name,NumCpu,MemoryGB | Format-Table