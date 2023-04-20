# Import the Azure AD module
Import-Module AzureAD

# Connect to Azure AD using an account with Global Administrator or Password Administrator permissions
Connect-AzureAD

# Remove a banned password from the list
Remove-AzureADPasswordBannedList -BannedPassword "password123"
