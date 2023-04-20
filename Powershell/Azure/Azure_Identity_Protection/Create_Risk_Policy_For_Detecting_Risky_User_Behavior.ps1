# Import Azure AD module
Import-Module AzureAD

# Set policy settings
$displayName = "Detect Risky User Behavior"
$state = "Enabled"
$notificationMessage = "Risky user behavior detected for user {user}, please review"
$notificationEmails = "admin@example.com"
$threshold = 10
$windowSize = 5

# Create the policy
New-AzureADIdentityProtectionRiskyUserDetectionPolicy -DisplayName $displayName -State $state -NotificationMessage $notificationMessage -NotificationEmails $notificationEmails -Threshold $threshold -WindowSize $windowSize
