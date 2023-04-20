# Import Azure AD module
Import-Module AzureAD

# Set policy settings
$displayName = "Detect Password Spray Attacks"
$state = "Enabled"
$notificationMessage = "Password spray attack detected for user {user}, please review"
$notificationEmails = "admin@example.com"
$threshold = 10
$windowSize = 5
$blockDuration = 30

# Create the policy
New-AzureADIdentityProtectionPasswordSprayDetectionPolicy -DisplayName $displayName -State $state -NotificationMessage $notificationMessage -NotificationEmails $notificationEmails -Threshold $threshold -WindowSize $windowSize -BlockDuration $blockDuration
