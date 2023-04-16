# This PowerShell script installs Active Directory Domain Services (AD DS) role and configures a new domain on a Windows Server 2016 machine.
# Make sure to run this script with administrative privileges.

# Import the Server Manager module to enable management of server roles and features
Import-Module ServerManager

# Install the Active Directory Domain Services (AD DS) role
Install-WindowsFeature -Name AD-Domain-Services -IncludeManagementTools

# Import the Active Directory module to enable management of AD DS
Import-Module ADDSDeployment

# Prompt the user for the domain name
$domainName = Read-Host -Prompt 'Please enter the desired domain name (e.g., example.com)'

# Validate the domain name format
if (-not ($domainName -match '^(?=.{1,255})(?:(?!-)[A-Za-z0-9-]{1,63}(?<!-)\.?)+(?:[A-Za-z]{2,})$')) {
    Write-Host "Invalid domain name. Please provide a valid domain name and try again."
    exit
}

# Prompt the user for the NetBIOS name
$netbiosName = Read-Host -Prompt 'Please enter the desired NetBIOS name (e.g., EXAMPLE)'

# Validate the NetBIOS name format
if (-not ($netbiosName -match '^([A-Za-z0-9]{1,15})$')) {
    Write-Host "Invalid NetBIOS name. Please provide a valid NetBIOS name and try again."
    exit
}

# Prompt the user for the SafeMode administrator password
$adminPassword = Read-Host -Prompt 'Please enter a SafeMode administrator password' -AsSecureString

# Install and configure the new Active Directory forest with the provided domain name, NetBIOS name, and SafeMode administrator password
Install-ADDSForest `
    -CreateDnsDelegation:$false `
    -DatabasePath "C:\Windows\NTDS" `
    -DomainMode "WinThreshold" `
    -DomainName $domainName `
    -DomainNetbiosName $netbiosName `
    -ForestMode "WinThreshold" `
    -InstallDns:$true `
    -LogPath "C:\Windows\NTDS" `
    -NoRebootOnCompletion:$false `
    -SysvolPath "C:\Windows\SYSVOL" `
    -Force:$true `
    -SafeModeAdministratorPassword $adminPassword

# Once the script has finished executing, the server will reboot to complete the installation of AD DS.
