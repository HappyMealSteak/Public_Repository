# Import the Azure AD module
Import-Module AzureAD

# Connect to Azure AD using an account with Global Administrator or Password Administrator permissions
Connect-AzureAD

# Get a list of banned passwords
$bannedPasswords = (Get-AzureADPasswordBannedList).BannedPasswordList

# Output the list of banned passwords
Write-Host "Banned Passwords:"
foreach ($password in $bannedPasswords) {
    Write-Host $password
}
