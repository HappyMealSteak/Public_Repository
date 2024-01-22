# Import the Active Directory module for accessing AD cmdlets
Import-Module ActiveDirectory

# Define script parameters
$domain = "YOURDOMAIN.com"  # Specifies the target domain for authentication attempts
$commonPasswords = @("Password1", "Welcome123", "Spring2023") # Array of common passwords to test
$days = 90 # Defines the period (in days) to filter users by their last password change
$logPath = "C:\path\to\your\logFile.log" # Specifies the path for the output log file

# Function to log messages with timestamp
function Log-Output {
    param ($message)
    # Appends a message with a timestamp to the log file
    Add-Content -Path $logPath -Value "$(Get-Date) - $message"
}

# Script block for processing each user account in parallel
$scriptBlock = {
    param ($user, $domain, $commonPasswords, $logPath)
    foreach ($testPassword in $commonPasswords) {
        $username = $user.SamAccountName
        try {
            # Securely converts the plaintext password to a secure string
            $passwordSecure = ConvertTo-SecureString $testPassword -AsPlainText -Force
            # Initializes a PrincipalContext object for the specified domain
            $credential = New-Object System.DirectoryServices.AccountManagement.PrincipalContext('Domain', $domain)
            # Attempts to validate the credentials for the current username and password
            $result = $credential.ValidateCredentials($username, $testPassword)
            if ($result -eq $true) {
                # Logs the username and the tested password if authentication succeeds
                Log-Output "User $username might be using a weak password: $testPassword"
                break # Stops testing further passwords for this user to avoid lockouts
            }
        } catch {
            # Logs any errors encountered during authentication attempts
            Log-Output "Error encountered with user $username: $_"
        }
        # Pauses for a specified duration between password tests to mitigate account lockout risks
        Start-Sleep -Seconds 1
    }
}

# Retrieves user accounts that haven't changed their password within the specified timeframe
$userList = Get-ADUser -Filter {PasswordLastSet -lt (Get-Date).AddDays(-$days)} -Properties Name, SamAccountName

# Executes the script block in parallel for each user, adhering to the specified throttle limit
$userList | ForEach-Object -Parallel $scriptBlock -ArgumentList $domain, $commonPasswords, $logPath -ThrottleLimit 10
