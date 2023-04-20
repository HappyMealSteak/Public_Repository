# Import Azure AD module
Import-Module AzureAD

# Set policy settings
$displayName = "Detect Brute-Force Attacks"
$state = "Enabled"
$notificationMessage = "Brute-force attack detected for user {user}, please review"
$notificationEmails = "admin@example.com"
$threshold = 10
$windowSize = 5
$blockDuration = 30

# Create the policy
New-AzureADIdentityProtectionBruteForceAttackDetectionPolicy -DisplayName $displayName -State $state -NotificationMessage $notificationMessage -NotificationEmails $notificationEmails -Threshold $threshold -WindowSize $windowSize -BlockDuration $blockDuration
