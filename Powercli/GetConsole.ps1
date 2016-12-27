#=============================================================================================
#  ___                 _                _         _                        _   _              
# |_ _|_ ____   _____ | | _____        / \  _   _| |_ ___  _ __ ___   __ _| |_(_) ___  _ __   
#  | || '_ \ \ / / _ \| |/ / _ \_____ / _ \| | | | __/ _ \| '_ ` _ \ / _` | __| |/ _ \| '_ \  
#  | || | | \ V / (_) |   <  __/_____/ ___ \ |_| | || (_) | | | | | | (_| | |_| | (_) | | | | 
# |___|_| |_|\_/ \___/|_|\_\___|    /_/   \_\__,_|\__\___/|_| |_| |_|\__,_|\__|_|\___/|_| |_| 
#=============================================================================================                                                                                            

<#
Name:Get-ConsoleURL.ps1
Download Link: https://github.com/jpsider/invoke-automation/powercli/getConsole.ps1
Author: https://github.com/jpsider (feel free to reach out if you have questions)

Requirements: 
	Powershell 3.0
	Powercli 5.5 or greater

Comment:
	Absolutely open to input and improvements!
	This script will produce a shareable URL to a VM's console.
	I've only tested this with vCenter 5.5 and 6.0
	This page said I could use &sessionTicket=cst-VCT (http://vmnick0.me/?p=75) but I never got it to work
		So you might need to update the thumbprint to your vcenter.
	
Usage: 
	Get-ConsoleURL $vmName $hypVersion

Assumptions: 
	1. You are already connected to Vcenter!
	2. $vCenter, $VCenterUN, $VCenterPW are defined 
#>

#=======================================================================================
function GetConsoleUrl($vmName, $hypVersion) {
	if ($hypVersion -eq 6){
		$ConsolePort = 9443 
		$myVM = Get-VM $vmName
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
	Elseif ($hypVersion -eq 5) {
		#Create URL and place it in the Database
		$myVM = Get-VM $vmName
		$UUID = ((Connect-VIServer $Vcenter -user $VCenterUN -Password $VCenterPW -ErrorAction SilentlyContinue).InstanceUUID).ToUpper()
		$MoRef = $myVM.ExtensionData.MoRef.Value
		$ConsoleLink = "https://${Vcenter}:9443/vsphere-client/vmrc/vmrc.jsp?vm=urn:vmomi:VirtualMachine:${MoRef}:${UUID}"
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