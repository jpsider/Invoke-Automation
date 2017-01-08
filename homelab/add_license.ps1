function Apply_vCenter_License {
#Add License to vCenter
$VcLicMgr=$DefaultVIServer
$LicMgr = Get-View $VcLicMgr
$AddLic= Get-View $LicMgr.Content.LicenseManager
 
$AddLic.AddLicense($VC_LIC,$null)
  
}

function Apply_ESX_License {
	# Get all ESX hosts and apply license.
	get-vmhost $ESXIP | set-vmhost -LicenseKey $ESX_LIC
}


function Apply_vCenter_License_NEW {
	$MyVC = $DefaultVIServer
	$LicenseManager = get-view ($MyVC.ExtensionData.content.LicenseManager)
	$LicenseManager.AddLicense($VC_LIC,$null)
	$LicenseAssignmentManager = get-view ($LicenseManager.licenseAssignmentManager)
	$LicenseAssignmentManager.UpdateAssignedLicense($MyVC.InstanceUuid,$VC_LIC,$Null)
}
