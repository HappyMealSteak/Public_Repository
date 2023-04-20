# Import Active Directory module if not already loaded
if (-not (Get-Module -Name ActiveDirectory)) {
    Import-Module ActiveDirectory
}

# Define variables
$UserName = "Bruce.Banner"

# Disable the user account
Disable-ADAccount -Identity $UserName
