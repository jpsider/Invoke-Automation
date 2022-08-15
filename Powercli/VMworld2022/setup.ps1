docker run --rm -d -p 443:443 lamw/govcsim

$Server = (Get-NetIPAddress -InterfaceAlias *wsl* -AddressFamily IPv4).IPAddress
Disable-SSLValidation
$Server
Connect-VIServer -Server $Server -Port 443 -User u -Password p
