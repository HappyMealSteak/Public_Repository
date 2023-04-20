# Import Azure AD module
Import-Module AzureAD

# Set policy settings
$displayName = "Detect High-risk Application Usage"
$state = "Enabled"
$notificationMessage = "High-risk application usage detected for user {user}, please review"
$notificationEmails = "admin@example.com"
$threshold = 10
$windowSize = 5

# Create the policy
New-AzureADIdentityProtectionHighRiskApplicationDetectionPolicy -DisplayName $displayName -State $state -NotificationMessage $notificationMessage -NotificationEmails $notificationEmails -Threshold $threshold -WindowSize $windowSize
