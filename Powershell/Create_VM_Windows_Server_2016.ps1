# PowerShell script to create a Hyper-V VM using a specified ISO

# Ensure the script is running with administrative privileges
If (-NOT ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Host "Please run this script as an Administrator." -ForegroundColor Red
    Exit
}

# Check if Hyper-V is installed
$hyperV = Get-WindowsOptionalFeature -Online -FeatureName Microsoft-Hyper-V
if ($hyperV.State -ne "Enabled") {
    Write-Host "Hyper-V is not installed. Please install Hyper-V and try again." -ForegroundColor Red
    Exit
}

# VM settings
$vmName = "MyVM" # Name of the virtual machine
$memorySize = 4GB # Memory size (in GB) for the virtual machine
$processorCount = 2 # Number of processors for the virtual machine
$isoPath = "C:\Downloads\Windows_Server_2016.iso" # Path to the ISO file
$vhdPath = "C:\VirtualMachines\$vmName.vhdx" # Path to the VHDX file
$switchName = "ExternalSwitch" # Virtual switch name

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

# Create a new virtual switch or use an existing one
New-VirtualSwitch -switchName $switchName

# Create a new virtual machine
New-VM -Name $vmName -MemoryStartupBytes $memorySize -Generation 2 -Path "C:\VirtualMachines"

# Set the processor count for the virtual machine
Set-VMProcessor -VMName $vmName -Count $processorCount

# Create a new virtual hard disk for the VM
New-VHD -Path $vhdPath -SizeBytes 60GB -Dynamic

# Attach the virtual hard disk to the VM
Add-VMHardDiskDrive -VMName $vmName -Path $vhdPath

# Configure the VM to boot from the ISO file
Set-VMDvdDrive -VMName $vmName -Path $isoPath

# Connect the VM to the virtual switch
Add-VMNetworkAdapter -VMName $vmName -SwitchName $switchName

# Start the virtual machine
Start-VM -Name $vmName

# Output success message
Write-Host "Virtual Machine setup completed successfully." -ForegroundColor Green