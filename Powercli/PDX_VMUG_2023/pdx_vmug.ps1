# PDX VMUG Usercon

# Verb-Noun









# Setup the Environment
# Start the vCenter simulator container
docker run --rm -d -p 443:443 lamw/govcsim

# Gather the IP address of the vCenter simulator container
$Server = (Get-NetIPAddress -InterfaceAlias *wsl* -AddressFamily IPv4).IPAddress
Disable-SSLValidation
$Server


# Connect to the vCenter Simulator
Connect-VIServer -Server $Server -Port 443 -User u -Password p