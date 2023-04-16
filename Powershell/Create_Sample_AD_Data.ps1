# Import the Active Directory module
Import-Module ActiveDirectory

# Get the current domain
$domain = (Get-ADDomain).DistinguishedName

# Create Organizational Units
$ou1 = "IT"
$ou2 = "HR"

New-ADOrganizationalUnit -Name $ou1 -Path $domain
New-ADOrganizationalUnit -Name $ou2 -Path $domain

# Create groups
$group1 = @{
    Name = "IT Admins"
    GroupCategory = "Security"
    GroupScope = "Global"
    Path = "OU=$ou1,$domain"
}
$group2 = @{
    Name = "HR Team"
    GroupCategory = "Security"
    GroupScope = "Global"
    Path = "OU=$ou2,$domain"
}

New-ADGroup @group1
New-ADGroup @group2

# Create users
$user1 = @{
    Name = "John Doe"
    GivenName = "John"
    Surname = "Doe"
    DisplayName = "John Doe"
    SamAccountName = "jdoe"
    UserPrincipalName = "jdoe@$(Get-ADDomain).DNSRoot"
    AccountPassword = (ConvertTo-SecureString "P@ssw0rd" -AsPlainText -Force)
    Enabled = $true
    Path = "OU=$ou1,$domain"
}
$user2 = @{
    Name = "Jane Smith"
    GivenName = "Jane"
    Surname = "Smith"
    DisplayName = "Jane Smith"
    SamAccountName = "jsmith"
    UserPrincipalName = "jsmith@$(Get-ADDomain).DNSRoot"
    AccountPassword = (ConvertTo-SecureString "P@ssw0rd" -AsPlainText -Force)
    Enabled = $true
    Path = "OU=$ou2,$domain"
}

New-ADUser @user1
New-ADUser @user2

# Add users to groups
Add-ADGroupMember -Identity "IT Admins" -Members "jdoe"
Add-ADGroupMember -Identity "HR Team" -Members "jsmith"
