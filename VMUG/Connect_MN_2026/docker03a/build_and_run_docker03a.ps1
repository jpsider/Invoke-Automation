# change directory to the specific location
set-Location "C:\open_projects\Invoke-Automation\VMUG\Connect_MN_2026\docker03a"

# Build the container
docker build . -t connectmn03a

# Run the container and pass in the vCenter!
# Get the vCenter IP
$vcenter = (Get-NetIPAddress -InterfaceAlias *wsl* -AddressFamily IPv4).IPAddress

# Start this bad boy up!
docker run -it -e vcenter="$vcenter" connectmn03a