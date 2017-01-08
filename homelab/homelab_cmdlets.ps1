# Set up logging function.
Function writeLog {
    param(
    [Parameter(Mandatory=$true)]
    [String]$message
    )

    $timeStamp = Get-Date -Format "MM-dd-yyyy_hh:mm:ss"

    Write-Host -NoNewline -ForegroundColor White "[$timestamp]"
    Write-Host -ForegroundColor Green " $message"
    $logMessage = "[$timeStamp] $message"
    $logMessage | Out-File -Append -LiteralPath $verboseLogFile
}

# Register Template VM's
function RegisterTemplates {
	foreach ($vmname in $vms) {
		$vmxPath = "[$NFSDatastoreName] $vmname\$vmname.vmx"
		write-host $vmxpath
		write-host $ESXIP
		new-vm -vmfilePath $vmxPath -vmhost $ESXIP
	}
}