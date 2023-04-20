# Import Azure AD module
Import-Module AzureAD

# Set policy settings
$displayName = "Detect Suspicious Inbox Forwarding"
$state = "Enabled"
$notificationMessage = "Suspicious inbox forwarding detected for user {user}, please review"
$notificationEmails = "admin@example.com"
$threshold = 10
$windowSize = 5

# Create the policy
New-AzureADIdentityProtectionInboxForwardingDetectionPolicy -DisplayName $displayName -State $state -NotificationMessage $notificationMessage -NotificationEmails $notificationEmails -Threshold $threshold -WindowSize $windowSize
