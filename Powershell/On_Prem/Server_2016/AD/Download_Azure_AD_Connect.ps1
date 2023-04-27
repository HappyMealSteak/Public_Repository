# Install required PowerShell modules
Install-Module -Name MSOnline

# Specify the URL to download the AD Connect installer
$ADConnectInstallerURL = "https://download.microsoft.com/download/C/D/A/CDA366C0-9ED3-4323-BBE3-3A81A5326C49/ADKConnect.exe"

# Specify the path to save the downloaded installer
$InstallerFilePath = "C:\Apps\ADConnectInstaller.exe"

# Prompt for admin credentials
$adminUsername = Read-Host "Enter the global admin username"
$adminPassword = Read-Host -AsSecureString "Enter the global admin password"
$adminCredential = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $adminUsername, $adminPassword
Connect-MsolService -Credential $adminCredential

# Download the AD Connect installer
Invoke-WebRequest -Uri $ADConnectInstallerURL -OutFile $InstallerFilePath

# Set up AD Connect with default configuration
& $InstallerFilePath /silent /IAcceptAzureADConnectSyncServicesTerms

# Import the AD Connect module
Import-Module ADSync

# Configure AD Connect using Express Settings
Import-ADSyncConfiguration -SourcePath "C:\Program Files\Microsoft Azure AD Sync\Conf" -Verbose

# Start the AD Connect synchronization service
Start-ADSyncSyncCycle -PolicyType Initial

# Display synchronization status
Get-ADSyncConnectorRunStatus

# Optional: Customize AD Connect settings as needed
# For example, you can use the Set-ADSyncScheduler cmdlet to configure synchronization schedule

# Cleanup and exit
Remove-Module ADSync
