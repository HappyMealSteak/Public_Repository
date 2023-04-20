 # Import Active Directory module if not already loaded
if (-not (Get-Module -Name ActiveDirectory)) {
    Import-Module ActiveDirectory
}

# Define variables
$FirstName = "Bruce"
$LastName = "Banner"
$UserName = "Bruce.Banner"
$DisplayName = "$FirstName $LastName"
$UserPrincipalName = "$UserName@dadomain.local"
$Password = "YourStrongP@ssword"
$MobileNumber = "+1-555-555-5555"
$SecondaryEmail = "bruce.banner.personal@email.com"

# Create a secure password
$SecurePassword = ConvertTo-SecureString $Password -AsPlainText -Force

# Create the user account
New-ADUser -GivenName $FirstName -Surname $LastName -Name $DisplayName -UserPrincipalName $UserPrincipalName -SamAccountName $UserName -AccountPassword $SecurePassword -Enabled $true -OtherAttributes @{'mobile'=$MobileNumber;'mail'=$SecondaryEmail} -ChangePasswordAtLogon $true -CannotChangePassword $false -PasswordNeverExpires $false 
