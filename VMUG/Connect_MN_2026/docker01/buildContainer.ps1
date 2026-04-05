# change directory to the specific location
set-Location "C:\open_projects\Invoke-Automation\VMUG\Connect_MN_2026\docker01"

# Lets list our images first!
docker images

# Now lets build
docker build . -t connectmn01

# Re-List the images
docker images

# Lets run our new container image!
docker run -it connectmn01

# List the Modules
Get-Module -ListAvailable

# Connect to the vCenter
Connect-VIServer -server 172.23.16.1 -user u -password p

# List some things!
Get-VM
Get-VMHost

# exit the container
exit

# Let's try this again!
docker run -it -e vcenter="172.23.16.1" connectmn01

# Now lets connect to the vcenter
Connect-VIServer -server $env:vcenter -user u -password p

# List some things!
Get-VM
Get-VMHost

# exit the container
exit

# One more time for automation sake!
# Get the vCenter IP
$vcenter = (Get-NetIPAddress -InterfaceAlias *wsl* -AddressFamily IPv4).IPAddress

# Start this bad boy up!
docker run -it -e vcenter="$vcenter" connectmn01

# Now lets connect to the vcenter
Connect-VIServer -server $env:vcenter -user u -password p

# exit the container
exit