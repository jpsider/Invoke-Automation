# start the vCenter Simulator
docker run --rm -d -p 443:443 lamw/govcsim

# get the IP address of the vCenter Simulator
$Server = (Get-NetIPAddress -InterfaceAlias *wsl* -AddressFamily IPv4).IPAddress
Disable-SSLValidation
$Server


