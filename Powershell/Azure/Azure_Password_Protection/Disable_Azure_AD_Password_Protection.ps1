# Import the Azure AD module
Import-Module AzureAD

# Connect to Azure AD using an account with Global Administrator or Password Administrator permissions
Connect-AzureAD

# Disable Azure AD Password Protection
Disable-AzureADPasswordProtection
