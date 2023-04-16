# Create C:\Apps folder if it doesn't exist
if (!(Test-Path "C:\Apps")) {
    New-Item -ItemType Directory -Path "C:\Apps" | Out-Null
}

# Define the log file path
$logFilePath = "C:\Apps\InitialServerConfig.log"

# Function to log messages
function Log-Message {
    param (
        [string]$message
    )

    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    Add-Content -Path $logFilePath -Value "[$timestamp] $message"
}

# Set computer name
try {
    $computerName = "WinSrv2016"
    Rename-Computer -NewName $computerName
    Log-Message -message "Set computer name: Success"
} catch {
    Log-Message -message "Set computer name: Failed with error code $($_.Exception.ErrorCode)"
}

# Download Chrome Enterprise installer
try {
    $chromeUrl = "https://dl.google.com/tag/s/dl/chrome/install/googlechromestandaloneenterprise64.msi"
    $chromeInstallerPath = "C:\Temp\googlechromestandaloneenterprise64.msi"
    if (!(Test-Path "C:\Temp")) {
        New-Item -ItemType Directory -Path "C:\Temp" | Out-Null
    }
    Invoke-WebRequest -Uri $chromeUrl -OutFile $chromeInstallerPath
    Log-Message -message "Download Chrome Enterprise installer: Success"
} catch {
    Log-Message -message "Download Chrome Enterprise installer: Failed with error code $($_.Exception.ErrorCode)"
}

# Install Chrome silently without tracking and sharing data
try {
    Start-Process -FilePath "msiexec.exe" -ArgumentList "/i $chromeInstallerPath /qn /norestart /L*V C:\Temp\ChromeInstall.log GOOGLE_UPDATE_DISABLED=1 CHROME_AUTOSELECT_DESKTOP_SHORTCUT=0 SEND_USAGE_STATISTICS=false" -Wait -NoNewWindow
    Log-Message -message "Install Chrome silently: Success"
} catch {
    Log-Message -message "Install Chrome silently: Failed with error code $($_.Exception.ErrorCode)"
}

# Set timezone
try {
    $tz = "Eastern Standard Time" # Change to your desired timezone
    Set-TimeZone -Id $tz
    Log-Message -message "Set timezone: Success"
} catch {
    Log-Message -message "Set timezone: Failed with error code $($_.Exception.ErrorCode)"
}

# Install Windows updates
try {
    Install-WindowsUpdate -AcceptAll -IgnoreReboot
    Log-Message -message "Install Windows updates: Success"
} catch {
    Log-Message -message "Install Windows updates: Failed with error code $($_.Exception.ErrorCode)"
}

# Enable Remote Desktop
try {
    Set-ItemProperty -Path "HKLM:\System\CurrentControlSet\Control\Terminal Server" -Name fDenyTSConnections -Value 0
    Enable-NetFirewallRule -DisplayGroup "Remote Desktop"
    Log-Message -message "Enable Remote Desktop: Success"
} catch {
    Log-Message -message "Enable Remote Desktop: Failed with error code $($_.Exception.ErrorCode)"
}

# Configure Windows Firewall to allow ping
try {
    New-NetFirewallRule -DisplayName "Allow ICMPv4-In" -Protocol ICMPv4
    New-NetFirewallRule -DisplayName "Allow ICMPv6-In" -Protocol ICMPv6
    Log-Message -message "Configure Windows Firewall to allow ping: Success"
} catch {
    Log-Message -message "Configure Windows Firewall to allow ping: Failed with error code $($_.Exception.ErrorCode)"
}

# Disable Internet Explorer Enhanced Security Configuration (IE ESC)
try {
    Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Active Setup\Installed Components\{A509B1A7-37EF-4b3f-8CFC-4F3A74704073}" -Name "IsInstalled" -Value 0
    Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Active Setup\Installed Components\{A509B1A8-37EF-4b3f-8CFC-4F3A74704073}" -Name "IsInstalled" -Value 0
    Log-Message -message "Disable IE ESC: Success"
} catch {
    Log-Message -message "Disable IE ESC: Failed with error code $($_.Exception.ErrorCode)"
}

# Enable PowerShell script execution
try {
    Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope LocalMachine -Force
    Log-Message -message "Enable PowerShell script execution: Success"
} catch {
    Log-Message -message "Enable PowerShell script execution: Failed with error code $($_.Exception.ErrorCode)"
}

# Configure Windows Update settings
try {
    # Set Windows Update to "Download updates but let me choose whether to install them"
    Set-ItemProperty -Path "HKLM:\Software\Policies\Microsoft\Windows\WindowsUpdate\AU" -Name "AUOptions" -Value 3
    Log-Message -message "Configure Windows Update settings: Success"
} catch {
    Log-Message -message "Configure Windows Update settings: Failed with error code $($_.Exception.ErrorCode)"
}

# Configure Power Plan settings
try {
    $powerPlan = "High performance" # Choose your preferred power plan (Balanced, High performance, Power saver)
    $guid = (Get-WmiObject -Class Win32_PowerPlan -Namespace root\cimv2\power -Filter "ElementName='$powerPlan'").InstanceID.Split('{', '}')[1]
    powercfg.exe /setactive $guid
    Log-Message -message "Configure Power Plan settings: Success"
} catch {
    Log-Message -message "Configure Power Plan settings: Failed with error code $($_.Exception.ErrorCode)"
}

# Configure WinRM (Windows Remote Management)
try {
    Enable-PSRemoting -Force
    Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WinRM\Service" -Name "AllowAutoConfig" -Value 1
    New-NetFirewallRule -DisplayName "WinRM HTTPS (TCP-In)" -Name "WinRM HTTPS (TCP-In)" -Profile Any -LocalPort 5986 -Protocol TCP
    Log-Message -message "Configure WinRM: Success"
} catch {
    Log-Message -message "Configure WinRM: Failed with error code $($_.Exception.ErrorCode)"
}

# Configure CredSSP settings to prevent RDP authentication errors
try {
    Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System\CredSSP\Parameters" -Name "AllowEncryptionOracle" -Value 2 -Type DWord -Force
    Log-Message -message "Configure CredSSP settings: Success"
} catch {
    Log-Message -message "Configure CredSSP settings: Failed with error code $($_.Exception.ErrorCode)"
}

# Restart the computer to apply changes
try {
    Restart-Computer -Force
    Log-Message -message "Restart computer: Success"
} catch {
    Log-Message -message "Restart computer: Failed with error code $($_.Exception.ErrorCode)"
}
