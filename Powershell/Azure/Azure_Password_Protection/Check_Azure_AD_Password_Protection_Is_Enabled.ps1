# Import the Azure AD module
Import-Module AzureAD

# Connect to Azure AD using an account with Global Administrator or Password Administrator permissions
Connect-AzureAD

# Check if Azure AD Password Protection is enabled
(Get-AzureADDirectorySetting | Where-Object {$_.DisplayName -eq "PasswordPolicy"}).Values[0]
