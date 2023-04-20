# Import Azure AD module
Import-Module AzureAD

# Set policy settings
$displayName = "Detect User Consent Grants"
$state = "Enabled"
$notificationMessage = "User consent grant detected for user {user}, please review"
$notificationEmails = "admin@example.com"
$threshold = 10
$windowSize = 5

# Create the policy
New-AzureADIdentityProtectionUserConsentGrantDetectionPolicy -DisplayName $displayName -State $state -NotificationMessage $notificationMessage -NotificationEmails $notificationEmails -Threshold $threshold -WindowSize $windowSize
