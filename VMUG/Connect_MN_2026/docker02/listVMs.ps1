# Connect to the vCenter
Connect-VIServer -server $env:vcenter -user u -password p

# List the virtual machines
Get-VM | Select-Object name, PowerState, NumCpu, MemoryGB