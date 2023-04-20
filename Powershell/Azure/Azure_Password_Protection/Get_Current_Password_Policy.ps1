# Import the Azure AD module
Import-Module AzureAD

# Connect to Azure AD using an account with Global Administrator or Password Administrator permissions
Connect-AzureAD

# Get the current password policy
(Get-AzureADDirectorySetting | Where-Object {$_.DisplayName -eq "PasswordPolicy"}).Values[0]
