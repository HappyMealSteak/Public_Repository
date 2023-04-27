# Function to create a new virtual switch if it doesn't exist
function New-VirtualSwitch {
    param (
        [string]$switchName
    )

    # Check if the virtual switch exists
    $existingSwitch = Get-VMSwitch -Name $switchName -ErrorAction SilentlyContinue

    # Create a new virtual switch if it doesn't exist
    if (-not $existingSwitch) {
        $physicalAdapter = Get-NetAdapter -Physical | Where-Object { $_.Status -eq "Up" } | Select-Object -First 1
        if ($physicalAdapter) {
            New-VMSwitch -Name $switchName -NetAdapterName $physicalAdapter.Name -AllowManagementOS $true
        } else {
            Write-Host "No active physical network adapters found. Please ensure at least one physical network adapter is enabled and try again." -ForegroundColor Red
            Exit
        }
    }
}

# Variables
$vmName = "WindowsServer2016VM"
$vmPath = "C:\VMs"
$isoPath = "C:\Downloads\Windows_Server_2016.iso"
$vSwitch = "ExternalSwitch"
$vmMemoryStartupBytes = 2GB
$vmProcessorCount = 2
$vmVHDSizeBytes = 40GB

# Create VM folder
if (!(Test-Path $vmPath)) {
    New-Item -ItemType Directory -Path $vmPath | Out-Null
}

# Create a new virtual switch or use an existing one
New-VirtualSwitch -switchName $vSwitch

# Create the VM
New-VM -Name $vmName -Path $vmPath -MemoryStartupBytes $vmMemoryStartupBytes -Generation 2 -SwitchName $vSwitch

# Configure VM settings
Set-VMProcessor -VMName $vmName -Count $vmProcessorCount
Set-VMMemory -VMName $vmName -DynamicMemoryEnabled $true -MinimumBytes (1GB) -MaximumBytes (4GB)

# Attach ISO to VM's DVD drive
Add-VMDvdDrive -VMName $vmName
Set-VMDvdDrive -VMName $vmName -Path $isoPath

# Create and attach VHD
$vmVHDPath = Join-Path $vmPath "$vmName\Virtual Hard Disks\$vmName.vhdx"
New-VHD -Path $vmVHDPath -Dynamic -SizeBytes $vmVHDSizeBytes
Add-VMHardDiskDrive -VMName $vmName -Path $vmVHDPath

# Set boot order
$dvdDrive = Get-VMDvdDrive -VMName $vmName
$hardDrive = Get-VMHardDiskDrive -VMName $vmName
$networkAdapter = Get-VMNetworkAdapter -VMName $vmName
Set-VMFirmware -VMName $vmName -BootOrder $dvdDrive, $hardDrive, $networkAdapter

# Start the VM
Start-VM -Name $vmName

Write-Host "VM '$vmName' has been created and started successfully. Please proceed with the OS installation."
