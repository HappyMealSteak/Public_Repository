# Import Active Directory module if not already loaded
if (-not (Get-Module -Name ActiveDirectory)) {
    Import-Module ActiveDirectory
}

# Define variables
$UserName = "Bruce.Banner"
$NewMobileNumber = "+1-555-555-1234"
$NewSecondaryEmail = "bruce.banner.new@email.com"

# Modify the user account
Set-ADUser -Identity $UserName -Replace @{mobile=$NewMobileNumber;mail=$NewSecondaryEmail}
