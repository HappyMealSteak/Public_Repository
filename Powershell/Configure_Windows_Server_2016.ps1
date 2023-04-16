# Set computer name
$computerName = "WinSrv2016"
Rename-Computer -NewName $computerName

# Download Chrome Enterprise installer
$chromeUrl = "https://dl.google.com/tag/s/dl/chrome/install/googlechromestandaloneenterprise64.msi"
$chromeInstallerPath = "C:\Temp\googlechromestandaloneenterprise64.msi"
if (!(Test-Path "C:\Temp")) {
    New-Item -ItemType Directory -Path "C:\Temp" | Out-Null
}
Invoke-WebRequest -Uri $chromeUrl -OutFile $chromeInstallerPath

# Install Chrome silently without tracking and sharing data
Start-Process -FilePath "msiexec.exe" -ArgumentList "/i $chromeInstallerPath /qn /norestart /L*V C:\Temp\ChromeInstall.log GOOGLE_UPDATE_DISABLED=1 CHROME_AUTOSELECT_DESKTOP_SHORTCUT=0 SEND_USAGE_STATISTICS=false" -Wait -NoNewWindow


# Set timezone
$tz = "Eastern Standard Time" # Change to your desired timezone
Set-TimeZone -Id $tz

# Install Windows updates
Install-WindowsUpdate -AcceptAll -IgnoreReboot

# Enable Remote Desktop
Set-ItemProperty -Path "HKLM:\System\CurrentControlSet\Control\Terminal Server" -Name fDenyTSConnections -Value 0
Enable-NetFirewallRule -DisplayGroup "Remote Desktop"

# Configure Windows Firewall to allow ping
New-NetFirewallRule -DisplayName "Allow ICMPv4-In" -Protocol ICMPv4
New-NetFirewallRule -DisplayName "Allow ICMPv6-In" -Protocol ICMPv6

# Disable Internet Explorer Enhanced Security Configuration (IE ESC)
Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Active Setup\Installed Components\{A509B1A7-37EF-4b3f-8CFC-4F3A74704073}" -Name "IsInstalled" -Value 0
Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Active Setup\Installed Components\{A509B1A8-37EF-4b3f-8CFC-4F3A74704073}" -Name "IsInstalled" -Value 0

# Enable PowerShell script execution
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope LocalMachine -Force

# Configure Windows Update settings
# Set Windows Update to "Download updates but let me choose whether to install them"
Set-ItemProperty -Path "HKLM:\Software\Policies\Microsoft\Windows\WindowsUpdate\AU" -Name "AUOptions" -Value 3

# Configure Power Plan settings
$powerPlan = "High performance" # Choose your preferred power plan (Balanced, High performance, Power saver)
$guid = (Get-WmiObject -Class Win32_PowerPlan -Namespace root\cimv2\power -Filter "ElementName='$powerPlan'").InstanceID.Split('{', '}')[1]
powercfg.exe /setactive $guid

# Configure WinRM (Windows Remote Management)
Enable-PSRemoting -Force
Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WinRM\Service" -Name "AllowAutoConfig" -Value 1
New-NetFirewallRule -DisplayName "WinRM HTTPS (TCP-In)" -Name "WinRM HTTPS (TCP-In)" -Profile Any -LocalPort 5986 -Protocol TCP

# Configure CredSSP settings to prevent RDP authentication errors
Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System\CredSSP\Parameters" -Name "AllowEncryptionOracle" -Value 2 -Type DWord -Force

# Restart the computer to apply changes
Restart-Computer -Force