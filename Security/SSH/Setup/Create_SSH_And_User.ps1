# Import necessary modules for Active Directory management if needed
# Import-Module ActiveDirectory

# Define variables for the service account and SSH setup
$serviceName = "S-SSHServiceAccount"
$servicePassword = "WeakPassword123!" # Ensure to use a secure password
$domain = "YOURDOMAIN.com" # Specify your domain
$ouPath = "OU=ServiceAccounts,DC=YOURDOMAIN,DC=com" # Specify the OU path for service accounts
$sshServerAddress = "your.ssh.server.address" # Replace with your actual SSH server address

# Step 1: Create the service account in Active Directory
New-ADUser -Name $serviceName -AccountPassword (ConvertTo-SecureString $servicePassword -AsPlainText -Force) -Enabled $true -PasswordNeverExpires $true -Path $ouPath -PassThru

# Optionally, add the service account to any required groups
# Add-ADGroupMember -Identity "SSH Users" -Members $serviceName

# Step 2: Install the OpenSSH Server feature (Windows 10 / Windows Server 2019 and later)
Add-WindowsCapability -Online -Name OpenSSH.Server~~~~0.0.1.0

# Step 3: Start the SSHD service and set it to start automatically
Start-Service sshd
Set-Service -Name sshd -StartupType 'Automatic'

# Step 4: Optionally configure the SSH server as needed
# This step is left as a placeholder as specific configurations will vary

# Step 5: Display the login information for the SSH service account
Write-Host "SSH service account has been created for testing purposes."
Write-Host "SSH Server Address: $sshServerAddress"
Write-Host "SSH Service Account Username: $serviceName"
Write-Host "Please use the secure password provided separately for testing."
Write-Host "Note: For security reasons, the password is not displayed here. Ensure it is securely communicated to authorized testers."

# IMPORTANT: Adjust the script to fit your environment, and ensure secure password practices and authorized testing.
