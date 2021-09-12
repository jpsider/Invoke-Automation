# Connect to the vCenter
Connect-VIServer 192.168.2.220 -User administrator -Password VMware1!
$vmhost = "192.168.2.203"

# Create a VM, take a snapshot.

#----------------- Start of code capture -----------------

#---------------ListKmipServers---------------
$_this = Get-View -Id 'CryptoManagerKmip-CryptoManager'
$_this.ListKmipServers($null)

#---------------QueryConfigOptionDescriptor---------------
$_this = Get-View -Id 'EnvironmentBrowser-envbrowser-7'
$_this.QueryConfigOptionDescriptor()

#---------------QueryConfigOption---------------
$key = 'vmx-17'
$hostParam = New-Object VMware.Vim.ManagedObjectReference
$hostParam.Type = 'HostSystem'
$hostParam.Value = 'host-223'
$_this = Get-View -Id 'EnvironmentBrowser-envbrowser-7'
$_this.QueryConfigOption($key, $hostParam)

#---------------QueryConfigOptionEx---------------
$spec = New-Object VMware.Vim.EnvironmentBrowserConfigOptionQuerySpec
$spec.Host = New-Object VMware.Vim.ManagedObjectReference
$spec.Host.Type = 'HostSystem'
$spec.Host.Value = 'host-223'
$spec.GuestId = New-Object String[] (1)
$spec.GuestId[0] = 'windows8Server64Guest'
$spec.Key = 'vmx-17'
$_this = Get-View -Id 'EnvironmentBrowser-envbrowser-7'
$_this.QueryConfigOptionEx($spec)

#---------------QueryConfigTarget---------------
$hostParam = New-Object VMware.Vim.ManagedObjectReference
$hostParam.Type = 'HostSystem'
$hostParam.Value = 'host-223'
$_this = Get-View -Id 'EnvironmentBrowser-envbrowser-7'
$_this.QueryConfigTarget($hostParam)

#---------------QueryTargetCapabilities---------------
$hostParam = New-Object VMware.Vim.ManagedObjectReference
$hostParam.Type = 'HostSystem'
$hostParam.Value = 'host-223'
$_this = Get-View -Id 'EnvironmentBrowser-envbrowser-7'
$_this.QueryTargetCapabilities($hostParam)

#---------------DatastoreBrowser---------------
$_this = Get-View -Id 'EnvironmentBrowser-envbrowser-7'
$_this.DatastoreBrowser

#---------------ListKmipServers---------------
$_this = Get-View -Id 'CryptoManagerKmip-CryptoManager'
$_this.ListKmipServers($null)

#---------------CreateVM_Task---------------
$config = New-Object VMware.Vim.VirtualMachineConfigSpec
$config.NumCPUs = 2
$config.Flags = New-Object VMware.Vim.VirtualMachineFlagInfo
$config.Flags.VirtualMmuUsage = 'automatic'
$config.Flags.MonitorType = 'release'
$config.Flags.EnableLogging = $true
$config.VirtualSMCPresent = $false
$config.MaxMksConnections = 40
$config.CpuFeatureMask = New-Object VMware.Vim.VirtualMachineCpuIdInfoSpec[] (0)
$config.Tools = New-Object VMware.Vim.ToolsConfigInfo
$config.Tools.BeforeGuestShutdown = $true
$config.Tools.ToolsUpgradePolicy = 'manual'
$config.Tools.BeforeGuestStandby = $true
$config.Tools.AfterResume = $true
$config.Tools.AfterPowerOn = $true
$config.Version = 'vmx-17'
$config.LatencySensitivity = New-Object VMware.Vim.LatencySensitivity
$config.LatencySensitivity.Level = 'normal'
$config.VirtualICH7MPresent = $false
$config.MemoryMB = 4096
$config.MemoryAllocation = New-Object VMware.Vim.ResourceAllocationInfo
$config.MemoryAllocation.Shares = New-Object VMware.Vim.SharesInfo
$config.MemoryAllocation.Shares.Shares = 40960
$config.MemoryAllocation.Shares.Level = 'normal'
$config.MemoryAllocation.Limit = -1
$config.MemoryAllocation.Reservation = 0
$config.NumCoresPerSocket = 2
$config.BootOptions = New-Object VMware.Vim.VirtualMachineBootOptions
$config.MigrateEncryption = 'opportunistic'
$config.CpuAllocation = New-Object VMware.Vim.ResourceAllocationInfo
$config.CpuAllocation.Shares = New-Object VMware.Vim.SharesInfo
$config.CpuAllocation.Shares.Shares = 2000
$config.CpuAllocation.Shares.Level = 'normal'
$config.CpuAllocation.Limit = -1
$config.CpuAllocation.Reservation = 0
$config.DeviceChange = New-Object VMware.Vim.VirtualDeviceConfigSpec[] (7)
$config.DeviceChange[0] = New-Object VMware.Vim.VirtualDeviceConfigSpec
$config.DeviceChange[0].Device = New-Object VMware.Vim.VirtualMachineVideoCard
$config.DeviceChange[0].Device.NumDisplays = 1
$config.DeviceChange[0].Device.UseAutoDetect = $false
$config.DeviceChange[0].Device.ControllerKey = 100
$config.DeviceChange[0].Device.UnitNumber = 0
$config.DeviceChange[0].Device.Use3dRenderer = 'automatic'
$config.DeviceChange[0].Device.Enable3DSupport = $false
$config.DeviceChange[0].Device.DeviceInfo = New-Object VMware.Vim.Description
$config.DeviceChange[0].Device.DeviceInfo.Summary = 'Video card'
$config.DeviceChange[0].Device.DeviceInfo.Label = 'Video card '
$config.DeviceChange[0].Device.Key = 500
$config.DeviceChange[0].Device.VideoRamSizeInKB = 8192
$config.DeviceChange[0].Operation = 'add'
$config.DeviceChange[1] = New-Object VMware.Vim.VirtualDeviceConfigSpec
$config.DeviceChange[1].Device = New-Object VMware.Vim.VirtualLsiLogicSASController
$config.DeviceChange[1].Device.SharedBus = 'noSharing'
$config.DeviceChange[1].Device.ScsiCtlrUnitNumber = 7
$config.DeviceChange[1].Device.DeviceInfo = New-Object VMware.Vim.Description
$config.DeviceChange[1].Device.DeviceInfo.Summary = 'New SCSI controller'
$config.DeviceChange[1].Device.DeviceInfo.Label = 'New SCSI controller'
$config.DeviceChange[1].Device.Key = -107
$config.DeviceChange[1].Device.BusNumber = 0
$config.DeviceChange[1].Operation = 'add'
$config.DeviceChange[2] = New-Object VMware.Vim.VirtualDeviceConfigSpec
$config.DeviceChange[2].FileOperation = 'create'
$config.DeviceChange[2].Device = New-Object VMware.Vim.VirtualDisk
$config.DeviceChange[2].Device.CapacityInBytes = 42949672960
$config.DeviceChange[2].Device.StorageIOAllocation = New-Object VMware.Vim.StorageIOAllocationInfo
$config.DeviceChange[2].Device.StorageIOAllocation.Shares = New-Object VMware.Vim.SharesInfo
$config.DeviceChange[2].Device.StorageIOAllocation.Shares.Shares = 1000
$config.DeviceChange[2].Device.StorageIOAllocation.Shares.Level = 'normal'
$config.DeviceChange[2].Device.StorageIOAllocation.Limit = -1
$config.DeviceChange[2].Device.Backing = New-Object VMware.Vim.VirtualDiskFlatVer2BackingInfo
$config.DeviceChange[2].Device.Backing.FileName = '[NVMe_203]'
$config.DeviceChange[2].Device.Backing.EagerlyScrub = $false
$config.DeviceChange[2].Device.Backing.ThinProvisioned = $false
$config.DeviceChange[2].Device.Backing.DiskMode = 'persistent'
$config.DeviceChange[2].Device.ControllerKey = -107
$config.DeviceChange[2].Device.UnitNumber = 0
$config.DeviceChange[2].Device.CapacityInKB = 41943040
$config.DeviceChange[2].Device.DeviceInfo = New-Object VMware.Vim.Description
$config.DeviceChange[2].Device.DeviceInfo.Summary = 'New Hard disk'
$config.DeviceChange[2].Device.DeviceInfo.Label = 'New Hard disk'
$config.DeviceChange[2].Device.Key = -108
$config.DeviceChange[2].Operation = 'add'
$config.DeviceChange[3] = New-Object VMware.Vim.VirtualDeviceConfigSpec
$config.DeviceChange[3].Device = New-Object VMware.Vim.VirtualE1000e
$config.DeviceChange[3].Device.MacAddress = ''
$config.DeviceChange[3].Device.Connectable = New-Object VMware.Vim.VirtualDeviceConnectInfo
$config.DeviceChange[3].Device.Connectable.Connected = $true
$config.DeviceChange[3].Device.Connectable.AllowGuestControl = $true
$config.DeviceChange[3].Device.Connectable.StartConnected = $true
$config.DeviceChange[3].Device.Backing = New-Object VMware.Vim.VirtualEthernetCardNetworkBackingInfo
$config.DeviceChange[3].Device.Backing.DeviceName = 'VM Network'
$config.DeviceChange[3].Device.Backing.Network = New-Object VMware.Vim.ManagedObjectReference
$config.DeviceChange[3].Device.Backing.Network.Type = 'Network'
$config.DeviceChange[3].Device.Backing.Network.Value = 'network-24'
$config.DeviceChange[3].Device.AddressType = 'generated'
$config.DeviceChange[3].Device.WakeOnLanEnabled = $true
$config.DeviceChange[3].Device.DeviceInfo = New-Object VMware.Vim.Description
$config.DeviceChange[3].Device.DeviceInfo.Summary = 'New Network'
$config.DeviceChange[3].Device.DeviceInfo.Label = 'New Network'
$config.DeviceChange[3].Device.Key = -109
$config.DeviceChange[3].Operation = 'add'
$config.DeviceChange[4] = New-Object VMware.Vim.VirtualDeviceConfigSpec
$config.DeviceChange[4].Device = New-Object VMware.Vim.VirtualAHCIController
$config.DeviceChange[4].Device.DeviceInfo = New-Object VMware.Vim.Description
$config.DeviceChange[4].Device.DeviceInfo.Summary = 'New SATA Controller'
$config.DeviceChange[4].Device.DeviceInfo.Label = 'New SATA Controller'
$config.DeviceChange[4].Device.Key = -110
$config.DeviceChange[4].Device.BusNumber = 0
$config.DeviceChange[4].Operation = 'add'
$config.DeviceChange[5] = New-Object VMware.Vim.VirtualDeviceConfigSpec
$config.DeviceChange[5].Device = New-Object VMware.Vim.VirtualCdrom
$config.DeviceChange[5].Device.Connectable = New-Object VMware.Vim.VirtualDeviceConnectInfo
$config.DeviceChange[5].Device.Connectable.Connected = $false
$config.DeviceChange[5].Device.Connectable.AllowGuestControl = $true
$config.DeviceChange[5].Device.Connectable.StartConnected = $false
$config.DeviceChange[5].Device.Backing = New-Object VMware.Vim.VirtualCdromRemotePassthroughBackingInfo
$config.DeviceChange[5].Device.Backing.Exclusive = $false
$config.DeviceChange[5].Device.Backing.DeviceName = ''
$config.DeviceChange[5].Device.ControllerKey = -110
$config.DeviceChange[5].Device.UnitNumber = 0
$config.DeviceChange[5].Device.DeviceInfo = New-Object VMware.Vim.Description
$config.DeviceChange[5].Device.DeviceInfo.Summary = 'New CD/DVD Drive'
$config.DeviceChange[5].Device.DeviceInfo.Label = 'New CD/DVD Drive'
$config.DeviceChange[5].Device.Key = -111
$config.DeviceChange[5].Operation = 'add'
$config.DeviceChange[6] = New-Object VMware.Vim.VirtualDeviceConfigSpec
$config.DeviceChange[6].Device = New-Object VMware.Vim.VirtualUSBController
$config.DeviceChange[6].Device.DeviceInfo = New-Object VMware.Vim.Description
$config.DeviceChange[6].Device.DeviceInfo.Summary = 'New USB Controller'
$config.DeviceChange[6].Device.DeviceInfo.Label = 'New USB Controller'
$config.DeviceChange[6].Device.Key = -112
$config.DeviceChange[6].Device.BusNumber = 0
$config.DeviceChange[6].Operation = 'add'
$config.MemoryReservationLockedToMax = $false
$config.Name = 'base'
$config.Files = New-Object VMware.Vim.VirtualMachineFileInfo
$config.Files.VmPathName = '[NVMe_203]'
$config.CpuAffinity = New-Object VMware.Vim.VirtualMachineAffinityInfo
$config.CpuAffinity.AffinitySet = New-Object int[] (0)
$config.PowerOpInfo = New-Object VMware.Vim.VirtualMachineDefaultPowerOpInfo
$config.PowerOpInfo.SuspendType = 'preset'
$config.PowerOpInfo.StandbyAction = 'checkpoint'
$config.PowerOpInfo.ResetType = 'preset'
$config.PowerOpInfo.PowerOffType = 'preset'
$config.SwapPlacement = 'inherit'
$config.Firmware = 'bios'
$config.GuestId = 'windows8Server64Guest'
$pool = New-Object VMware.Vim.ManagedObjectReference
$pool.Type = 'ResourcePool'
$pool.Value = 'resgroup-8'
$hostParam = New-Object VMware.Vim.ManagedObjectReference
$hostParam.Type = 'HostSystem'
$hostParam.Value = 'host-223'
$_this = Get-View -Id 'Folder-group-v3'
$_this.CreateVM_Task($config, $pool, $hostParam)


#----------------- End of code capture -----------------

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


#----------------- End of code capture -----------------
