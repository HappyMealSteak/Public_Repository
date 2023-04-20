# Set the variables for the user account to modify
$UserName = "JohnDoe"
$Description = "Updated user account for John Doe"
$EmailAddress = "johndoe@contoso.com"

# Modify the user account
Set-ADUser -Identity $UserName -Description $Description -EmailAddress $EmailAddress
