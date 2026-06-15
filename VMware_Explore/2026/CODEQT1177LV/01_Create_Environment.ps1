# Connect to the vCenter
# Manually Create a VM named "base". Then run the follwing to create a snapshot for the linked clones in follow on scripts.

# Wait a few seconds
Start-Sleep -Seconds 5

# Take a snapshot for the linked clone.

#---------------CreateSnapshot_Task---------------
$name = 'base'
$memory = $false
$quiesce = $false
#$_this = Get-View -Id 'VirtualMachine-vm-9351'
$_this = Get-vm base | Get-View
$_this.CreateSnapshot_Task($name, $null, $memory, $quiesce)
