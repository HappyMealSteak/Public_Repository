# Connect to Azure
Connect-AzAccount

# Get the list of all resource groups
$resourceGroups = Get-AzResourceGroup

# Display the list of resource groups
$resourceGroups | Format-Table ResourceGroupName, Location