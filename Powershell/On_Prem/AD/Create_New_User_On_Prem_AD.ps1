# Set variables
$firstName = "Bruce"
$lastName = "Banner"
$userName = "bbanner"
$password = "P@ssw0rd1"
$ouPath = "OU=Users,DC=Happymealsteak,DC=com"
$displayName = "Bruce Banner"
$email = "bbanner@happymealsteak.com"
$mobile = "555-555-5555"

# Create user account
New-ADUser -Name "$firstName $lastName" `
           -SamAccountName $userName `
           -AccountPassword (ConvertTo-SecureString $password -AsPlainText -Force) `
           -Enabled $true `
           -DisplayName $displayName `
           -EmailAddress $email `
           -MobilePhone $mobile `
           -Path $ouPath
