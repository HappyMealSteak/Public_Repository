# Set variables
$userName = "bbanner"
$newDisplayName = "Dr. Bruce Banner"
$newEmail = "bruce@avengers.com"

# Get user object
$user = Get-ADUser -Identity $userName

# Modify user account
Set-ADUser -Identity $user `
           -DisplayName $newDisplayName `
           -EmailAddress $newEmail
