set-ExecutionPolicy Bypass -Force

$MYINV = $MyInvocation
$SCRIPTDIR = split-path $MYINV.MyCommand.Path

# import homelab cmdlets and Configuration details
. "$SCRIPTDIR\homelab_cmdlets.ps1"
. "$SCRIPTDIR\Configuration_Details.ps1"

$verboseLogFile = "$SCRIPTDIR\vsphere65-NUC-lab-destruction.log"

write-host "Connecting to ESX host: $esxip"
Connect-viserver $esxip -user $ESXUser -pass $ESXPWD

#Power off and remove vm's from inventory.
write-host "Powering off and removing virtual machines."
Get-vm | where { $_.PowerState -eq “PoweredOn”} | Stop-VM -confirm:$false
Get-VM | Remove-VM -confirm:$false

write-host "Leaving vsan cluster"
$ESXCLI = Get-EsxCli -v2 -VMHost (get-VMHost)
$esxcli.vsan.cluster.leave.invoke()

$VSANDisks = $esxcli.storage.core.device.list.invoke() | Where {$_.isremovable -eq "false"} | Sort size
$Performance = $VSANDisks[0]
$Capacity = $VSANDisks[1]

write-host "Removing vSan Storage cluster"
$removal = $esxcli.vsan.storage.remove.CreateArgs()
$removal.ssd = $performance.Device
$esxcli.vsan.storage.remove.Invoke($removal)

write-host "Removing vSan Flash cluster"
$capacitytag = $esxcli.vsan.storage.tag.remove.CreateArgs()
$capacitytag.disk = $Capacity.Device
$capacitytag.tag = "capacityFlash"
$esxcli.vsan.storage.tag.remove.Invoke($capacitytag)

write-host "remove syslog server settings."
Set-VMHostSysLogServer $null

write-host "Remove NTP server."
Remove-VMHostNtpServer (Get-VMHostNtpServer) -Confirm:$false

write-host "Remove Synology Datastore"
Get-Datastore | where {$_.name -eq "synology"} | Remove-Datastore -Confirm:$false

write-host "All done"