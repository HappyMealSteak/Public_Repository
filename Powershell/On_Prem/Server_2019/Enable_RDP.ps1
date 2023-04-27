# Check if the script is running with administrative privileges
if (-not ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Host "Please run this script with administrative privileges."
    exit
}

# Enable Remote Desktop connections
Set-ItemProperty -Path 'HKLM:\System\CurrentControlSet\Control\Terminal Server' -Name 'fDenyTSConnections' -Value 0

# Allow Remote Desktop through the Windows Firewall
$FirewallRule = Get-NetFirewallRule -DisplayGroup 'Remote Desktop'
if ($FirewallRule.Enabled -ne 'True') {
    Enable-NetFirewallRule -DisplayGroup 'Remote Desktop'
}

# Enable Remote Desktop services
Set-Service -Name 'TermService' -StartupType 'Automatic'
Start-Service -Name 'TermService'

# Display the status of the Remote Desktop services
$RdpService = Get-Service -Name 'TermService'
if ($RdpService.Status -eq 'Running') {
    Write-Host "Remote Desktop has been enabled successfully."
} else {
    Write-Host "Failed to enable Remote Desktop."
}
