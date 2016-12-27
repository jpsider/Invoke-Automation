#=============================================================================================
#  ___                 _                _         _                        _   _              
# |_ _|_ ____   _____ | | _____        / \  _   _| |_ ___  _ __ ___   __ _| |_(_) ___  _ __   
#  | || '_ \ \ / / _ \| |/ / _ \_____ / _ \| | | | __/ _ \| '_ ` _ \ / _` | __| |/ _ \| '_ \  
#  | || | | \ V / (_) |   <  __/_____/ ___ \ |_| | || (_) | | | | | | (_| | |_| | (_) | | | | 
# |___|_| |_|\_/ \___/|_|\_\___|    /_/   \_\__,_|\__\___/|_| |_| |_|\__,_|\__|_|\___/|_| |_| 
#=============================================================================================                                                                                            
function Get-ConsoleUrl {
    <#
    .SYNOPSIS
        Name:Get-ConsoleURL.ps1
        Download Link: https://github.com/jpsider/invoke-automation/powercli/getConsole.ps1
        Requirements: 
    	    Powershell 3.0
    	    Powercli 5.5 or greater

    .DESCRIPTION
    	Absolutely open to input and improvements!
    	This script will produce a shareable URL to a VM's console.
    	I've only tested this with vCenter 5.5, 6.0, 6.5
    	This page said I could use &sessionTicket=cst-VCT (http://vmnick0.me/?p=75) but I never got it to work
    		So you might need to update the thumbprint to your vcenter.

    .PARAMETER vmName
        A valid Virtual machine name
    .PARAMETER vCenterUN
        A valid vCenter username
    .PARAMETER vCenterPW
        A valide vCenter password

    .EXAMPLE 
    	Get-ConsoleURL -vmName $vmName -vCenterUN $username -vCenterPW $password

    .NOTES
    	1. You are already connected to Vcenter!
    	2. $VCenterUN, $VCenterPW are defined 
    #>
    param(
		[Parameter(Mandatory=$true)]
			[string]$vmName,
        [Parameter(Mandatory=$true)]
            [string]$vCenterUN,
        [Parameter(Mandatory=$true)]
            [string]$vCenterPW
    )
    # Check for vcenter connectivity
    if ($global:defaultviservers.count -lt 1) {
        write-host "No vCenter connection detected"
        break
    } else {
        $vCenter = $global:defaultviservers.name
        $hypVersion = $global:DefaultVIServer.ExtensionData.Content.About.Apiversion
    }

    # Generic info
    $ConsolePort = 9443
    $myVM = Get-VM $vmName

	if ($hypVersion -eq "6.0"){
		$VMMoRef = $myVM.ExtensionData.MoRef.Value
		
		#Get Vcenter from advanced settings
		$UUID = ((Connect-VIServer $Vcenter -user $VCenterUN -Password $VCenterPW -ErrorAction SilentlyContinue).InstanceUUID)
		$SettingsMgr = Get-View $global:DefaultVIServer.ExtensionData.Client.ServiceContent.Setting
		$Settings = $SettingsMgr.Setting.GetEnumerator() 
		$AdvancedSettingsFQDN = ($Settings | Where {$_.Key -eq "VirtualCenter.FQDN" }).Value
		
		#Get vCenter ticket
		$SessionMgr = Get-View $global:DefaultVIServer.ExtensionData.Client.ServiceContent.SessionManager
		$Session = $SessionMgr.AcquireCloneTicket()
		
		#Create URL and place it in the Database
		$ConsoleLink = "https://$($Vcenter):$($ConsolePort)/vsphere-client/webconsole.html?vmId=$($VMMoRef)&vmName=$($myVM.Name)&serverGuid=${UUID}&host=$($AdvancedSettingsFQDN)&sessionTicket=$($Session)&thumbprint=5A:AB:D4:75:29:E8:D5:94:09:8F:D2:91:CF:DC:AB:C0:69:03:37:42"	
		return $ConsoleLink
	}
	Elseif ($hypVersion -eq "5.5") {
		#Create URL and place it in the Database
		$UUID = ((Connect-VIServer $Vcenter -user $VCenterUN -Password $VCenterPW -ErrorAction SilentlyContinue).InstanceUUID).ToUpper()
		$MoRef = $myVM.ExtensionData.MoRef.Value
		$ConsoleLink = "https://${Vcenter}:$ConsolePort/vsphere-client/vmrc/vmrc.jsp?vm=urn:vmomi:VirtualMachine:${MoRef}:${UUID}"
		return $ConsoleLink
	}
	Else {
	write-host "Unable to determine Hypervisor Version."
	}
}
#=============================================================================================
#    ____   _           _     _           
#   / __ \ (_)_ __  ___(_) __| | ___ _ __ 
#  / / _` || | '_ \/ __| |/ _` |/ _ \ '__|
# | | (_| || | |_) \__ \ | (_| |  __/ |   
#  \ \__,_|/ | .__/|___/_|\__,_|\___|_|   
#   \____/__/|_|                          
#=============================================================================================
