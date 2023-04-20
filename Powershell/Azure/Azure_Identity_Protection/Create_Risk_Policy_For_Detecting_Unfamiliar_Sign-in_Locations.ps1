# Import Azure AD module
Import-Module AzureAD

# Set policy settings
$displayName = "Detect Unfamiliar Sign-in Locations"
$state = "Enabled"
$notificationMessage = "Sign-in from unfamiliar location detected for user {user}, please review"
$notificationEmails = "admin@example.com"
$threshold = 10
$windowSize = 5

# Create the policy
New-AzureADIdentityProtectionUnfamiliarLocationDetectionPolicy -DisplayName $displayName -State $state -NotificationMessage $notificationMessage -NotificationEmails $notificationEmails -Threshold $threshold -WindowSize $windowSize
