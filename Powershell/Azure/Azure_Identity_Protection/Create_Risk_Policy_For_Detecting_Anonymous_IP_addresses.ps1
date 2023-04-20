# Import Azure AD module
Import-Module AzureAD

# Set policy settings
$displayName = "Detect Anonymous IP Addresses"
$state = "Enabled"
$notificationMessage = "Sign-in from anonymous IP address detected for user {user}, please review"
$notificationEmails = "admin@example.com"
$threshold = 10
$windowSize = 5

# Create the policy
New-AzureADIdentityProtectionAnonymousIpDetectionPolicy -DisplayName $displayName -State $state -NotificationMessage $notificationMessage -NotificationEmails $notificationEmails -Threshold $threshold -WindowSize $windowSize
