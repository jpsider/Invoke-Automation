docker run --rm -d -p 443:443 lamw/govcsim
set-location 'C:\OPEN_PROJECTS\Invoke-Automation\Powercli\DC_VMUG102019\Scripts'
$Server = (Get-NetIPAddress -InterfaceAlias *docker* -AddressFamily IPv4).IPAddress
Disable-SSLValidation
$Server
Connect-VIServer -Server $Server -Port 443 -User u -Password p