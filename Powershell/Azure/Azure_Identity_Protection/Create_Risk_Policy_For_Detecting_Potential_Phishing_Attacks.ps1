# Import Azure AD module
Import-Module AzureAD

# Set policy settings
$displayName = "Detect Potential Phishing Attacks"
$state = "Enabled"
$notificationMessage = "Potential phishing attack detected for user {user}, please review"
$notificationEmails = "admin@example.com"
$threshold = 10
$windowSize = 5

# Create the policy
New-AzureADIdentityProtectionPhishingDetectionPolicy -DisplayName $displayName -State $state -NotificationMessage $notificationMessage -NotificationEmails $notificationEmails -Threshold $threshold -WindowSize $windowSize
