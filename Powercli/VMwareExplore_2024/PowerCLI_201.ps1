###############################################################
# Setup the Environment
# Start the vCenter simulator container
docker run --rm -d -p 443:443 lamw/govcsim

# Gather the IP address of the vCenter simulator container
$server = $null
$Server = (Get-NetIPAddress -InterfaceAlias *wsl* -AddressFamily IPv4).IPAddress
Disable-SSLValidation
$Server


###############################################################
# Connect to the vCenter Simulator
Connect-VIServer -Server $Server -Port 443 -User u -Password p
# change the name of the first vm to "myvm"
get-vm | Select-Object -First 1 | set-vm -name myvm -Confirm:$false

# Show the connected vCenter
$global:DefaultVIServer

###############################################################
# List the Virtual machines
Get-VM

# Get a Single VM
Get-VM "DC0_H0_VM0"

# Get more details about the object Get-VM returns (VMware.VimAutomation.ViCore.Impl.V1.VM.UniversalVirtualMachineImpl)
Get-Member -InputObject (Get-VM "DC0_H0_VM0")

# Get more Details from the Get-View returns (TypeName: VMware.Vim.VirtualMachine)
Get-Member -InputObject (Get-VM "DC0_H0_VM0" | Get-View)

# Filter out just items that begin with 's'
Get-Member -InputObject (Get-VM "DC0_H0_VM0" | Get-View) | Where-Object {$_.Name -like 's*'}

# Shutdown the Guest vm
(Get-VM "DC0_H0_VM0" | Get-View).ShutdownGuest()

# List the VM's
Get-VM


###############################################################
# Run the script 
. C:\open_projects\Invoke-Automation\Powercli\VMwareExplore_2024\PowerCLI_201_Script.ps1 "DC0_H0_VM1"

###############################################################
# Bonus Time!
# What happens if we run it again?
. C:\open_projects\Invoke-Automation\Powercli\VMwareExplore_2024\PowerCLI_201_Script.ps1 "DC0_H0_VM1"

# What happens if we don't include a VMname?
. C:\open_projects\Invoke-Automation\Powercli\VMwareExplore_2024\PowerCLI_201_Script.ps1 

# Can we use a Parameter name? (YES!)
. C:\open_projects\Invoke-Automation\Powercli\VMwareExplore_2024\PowerCLI_201_Script.ps1 -vmname "DC0_C0_RP0_VM0"

###############################################################
# Super Bonus
# Vm does not exist
. C:\open_projects\Invoke-Automation\Powercli\VMwareExplore_2024\PowerCLI_201_Script_on_Steroids.ps1 -vmname "DoesNotExist"

# VM is Powered OFF
. C:\open_projects\Invoke-Automation\Powercli\VMwareExplore_2024\PowerCLI_201_Script_on_Steroids.ps1 -vmname "DC0_C0_RP0_VM0"

# VM is Powered On
. C:\open_projects\Invoke-Automation\Powercli\VMwareExplore_2024\PowerCLI_201_Script_on_Steroids.ps1 -vmname "DC0_C0_RP0_VM1"

# Get Help
Get-help -Full -Name "C:\open_projects\Invoke-Automation\Powercli\VMwareExplore_2024\PowerCLI_201_Script_on_Steroids.ps1"