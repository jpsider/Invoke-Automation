# ESX Start Host deployment Settings
$ESXIP = "192.168.2.202"
$ESXUser = "root"
$ESXPWD = "VMware1!"

# VCSA Configuration
$VCSACDDrive = "J:\"
$SSODomainName = "corp.local"
$VCNAME = "VC01"
$VCUser = "Administrator@$SSODomainName"
$VCPass = "VMware1!"
$VCIP = "192.168.2.200"
$VCDNS = "192.168.2.1"
$VCGW = "192.168.2.1"
$VCNetPrefix = "24"
$VCSADeploymentSize = "tiny"

# vCenter Configuration
$SSOSiteName = "Site01"
$datacenter = "DC01"
$cluster = "Cluster01"
$ntpserver = "pool.ntp.org"

# VSAN Configuration
$VSANPolicy = '(("hostFailuresToTolerate" i1) ("forceProvisioning" i1))'
$VMKNetforVSAN = "Management Network"

#NFS settings
$NFSPath = "/volume1/synology"
$NFSHOST = "192.168.2.3"
$NFSDatastoreName = "synology"

#TemplateVMs
$vms = @("Win_7_Test_vm","Win_10_test_vm","CentOS_6_test_vm")

# General Settings
$verboseLogFile = "$ENV:Temp\vsphere65-NUC-lab-deployment.log"