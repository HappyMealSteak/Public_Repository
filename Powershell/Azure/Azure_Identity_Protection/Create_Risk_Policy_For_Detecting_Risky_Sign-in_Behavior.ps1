# Import Azure AD module
Import-Module AzureAD

# Set policy settings
$displayName = "Detect Risky Sign-in Behavior"
$state = "Enabled"
$notificationMessage = "Risky sign-in behavior detected for user {user}, please review"
$notificationEmails = "admin@example.com"
$threshold = 10
$windowSize = 5

# Create the policy
New-AzureADIdentityProtectionRiskySignInDetectionPolicy -DisplayName $displayName -State $state -NotificationMessage $notificationMessage -NotificationEmails $notificationEmails -Threshold $threshold -WindowSize $windowSize
