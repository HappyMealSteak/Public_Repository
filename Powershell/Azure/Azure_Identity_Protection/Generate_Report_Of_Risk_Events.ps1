# Import Azure AD module
Import-Module AzureAD

# Set report settings
$filter = "riskEventType eq 'LeakedCredentials'"
$exportPath = "C:\Reports\LeakedCredentials.csv"

# Generate the report
Get-AzureADIdentityProtectionRiskEvent -Filter $filter | Export-Csv -Path $exportPath
