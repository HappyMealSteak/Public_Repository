# Import Azure AD module
Import-Module AzureAD

# Set policy settings
$displayName = "Detect Excessive Failed Login Attempts"
$state = "Enabled"
$notificationMessage = "Excessive failed login attempts detected for user {user}, please review"
$notificationEmails = "admin@example.com"
$threshold = 10
$windowSize = 5

# Create the policy
New-AzureADIdentityProtectionExcessiveFailedLoginsDetectionPolicy -DisplayName $displayName -State $state -NotificationMessage $notificationMessage -NotificationEmails $notificationEmails -Threshold $threshold -WindowSize $windowSize
