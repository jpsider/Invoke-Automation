# Setup
$Logfile = "c:\temp\DockerDemo.log"
$esx = "192.168.2.202"
$esxuser = "root"
$esxpass = "VMware1!"
$DBserver = "192.168.2.68"


# Import desired modules
Import-module "C:\temp\PowerLumber.psm1"
Import-module "c:\temp\powerWamp.psm1"
Get-Module -ListAvailable VMware* | Import-Module

# Write Imported Modules to a new logfile
$ImportedModules = Get-module
write-Log -Message "--------- Imported Modules ---------" -Logfile $Logfile
foreach($mod in $ImportedModules) {
    write-log -Message "$mod" -Logfile $Logfile
}
write-Log -Message "--------- End Imported Modules ---------" -Logfile $Logfile

# Connect to an Esx Server
write-log -Message "Connecting to esx" -Logfile $Logfile
Connect-VIServer -Server $esx -User $esxuser -Password $esxpass

# Get a list of VM's
write-log -Message "Grab a list of vm's" -Logfile $Logfile
$vms = Get-VM

write-log -Message "Write the vm's to a log file" -Logfile $Logfile
write-Log -Message "--------- VM's ---------" -Logfile $Logfile
foreach($vm in $vms){
    write-log -Message "$vm" -Logfile $Logfile
}
write-Log -Message "--------- end VM's ---------" -Logfile $Logfile

# DisConnect to an Esx Server
write-log -Message "Disconnect from esx" -Logfile $Logfile
Disconnect-VIServer -Server $esx -Confirm:$false

# Pull information from MySQL
write-log -Message "Run query against MySQL database" -Logfile $Logfile
$query = "select name,status_Id from test_cases"	
$Data = @(Invoke-MySQLQuery -Query $query -MySQLUsername root -MySQLPassword " " -MySQLDatabase summitrts -MySQLServer $DBserver)

# Print data to log
write-Log -Message "--------- Data rows ---------" -Logfile $Logfile
foreach($row in $Data) {
    $TCname = $row.name
    $TCstatus = $row.status_Id
    write-log -Message "TC-Name - $TCname , TC-Status - $TCstatus" -Logfile $Logfile
}
write-Log -Message "--------- end Data rows ---------" -Logfile $Logfile

# Put the vm's data into the $DBserver
write-log -Message "Entering VM data into DB" -Logfile $Logfile
foreach($vm in $vms){
    $vmname = $vm.name
    $vmGuestOS = $vm.ExtensionData.config.GuestFullName
    $query = "insert into DockerDemo (vmName,GuestOS) VALUES ('$vmname','$vmGuestOS')"
    write-log -Message "Entering $VM data into DB, $vmname : $vmGuestOS" -Logfile $Logfile
    Invoke-MySQLQuery -Query $query -MySQLUsername root -MySQLPassword " " -MySQLDatabase test -MySQLServer $DBserver
}