function Add_License_to_vCenter {
# Set some variables
$LicKey = "XXXXX-XXXXX-XXXXX-XXXXX-XXXXX"
$vcuser = "administrator@corp.local"
$vcpass = "VMware1!"

# Connect to vCenter
Connect-VIServer $DefaultVIServer -user $vcuser -password $vcpass
 
#Add Licenses
$VcLicMgr=$DefaultVIServer
$LicMgr = Get-View $VcLicMgr
$AddLic= Get-View $LicMgr.Content.LicenseManager
 
$AddLic.AddLicense($LicKey,$null)
 
# Disconnect from vCenter
Disconnect-VIServer -Confirm:$false
 
}

#Add_License_to_vCenter ($license)