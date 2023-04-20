# Import the Azure AD module
Import-Module AzureAD

# Connect to Azure AD using an account with Global Administrator or Password Administrator permissions
Connect-AzureAD

# Define the custom password policy settings
$customSettings = @{
    "PasswordValidityPeriod" = "P90D" # Passwords expire after 90 days
    "MinPasswordLength" = 10 # Passwords must be at least 10 characters long
    "PasswordCharacterSet" = "UpperCase,LowerCase,Numeric,Special" # Passwords must contain uppercase letters, lowercase letters, numbers, and special characters
}

# Create a new password policy object with the custom settings
$newPolicy = New-Object -TypeName Microsoft.Open.AzureAD.Model.DirectorySetting
$newPolicy.DisplayName = "PasswordPolicy"
$newPolicy.Values = $customSettings

# Set the new password policy in Azure AD Password Protection
New-AzureADDirectorySetting -DirectorySetting $newPolicy
