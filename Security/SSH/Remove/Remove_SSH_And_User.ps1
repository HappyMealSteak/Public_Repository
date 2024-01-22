# Define variables for the service account and SSH setup
$serviceName = "S-SSHServiceAccount"
$domain = "YOURDOMAIN.com" # Specify your domain
$ouPath = "OU=ServiceAccounts,DC=YOURDOMAIN,DC=com" # Specify the OU path for service accounts

# Import necessary modules for Active Directory management if needed
# Uncomment the next line if the Active Directory module is not already imported in your session
# Import-Module ActiveDirectory

# Step 1: Stop and disable the SSHD service
Stop-Service sshd
Set-Service -Name sshd -StartupType 'Disabled'

# Step 2: Uninstall the OpenSSH Server feature (Windows 10 / Windows Server 2019 and later)
# This command requires Administrator privileges
Remove-WindowsCapability -Online -Name OpenSSH.Server~~~~0.0.1.0

# Step 3: Remove the service account from Active Directory
# Ensure you have the necessary permissions to remove AD accounts
try {
    Remove-ADUser -Identity $serviceName -Confirm:$false
    Write-Host "Service account $serviceName removed successfully."
} catch {
    Write-Error "Failed to remove service account $serviceName. Error: $_"
}

# Optionally, remove the service account from any groups if needed
# Remove-ADGroupMember -Identity "SSH Users" -Members $serviceName -Confirm:$false

Write-Host "SSH service and user account cleanup is complete."

# IMPORTANT: This script makes significant changes to your system. Ensure you have backups and understand the impact before running it.
