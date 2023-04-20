# Import Azure AD module
Import-Module AzureAD

# Set policy settings
$displayName = "Detect Sign-in from Unfamiliar Device"
$state = "Enabled"
$notificationMessage = "Sign-in from unfamiliar device detected for user {user}, please review"
$notificationEmails = "admin@example.com"
$threshold = 10
$windowSize = 5

# Create the policy
New-AzureADIdentityProtectionUnfamiliarDeviceDetectionPolicy -DisplayName $displayName -State $state -NotificationMessage $notificationMessage -NotificationEmails $notificationEmails -Threshold $threshold -WindowSize $windowSize
