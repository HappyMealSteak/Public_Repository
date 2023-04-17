# Connect to Azure
Connect-AzAccount

# Prompt the user for the resource group name
Write-Host "Enter the name for the new resource group (e.g., 'MyResourceGroup'):"
$ResourceGroupName = Read-Host

# Prompt the user for the location
Write-Host "Enter the location for the new resource group (e.g., 'East US', 'West Europe'):"
$Location = Read-Host

# Create the new resource group
New-AzResourceGroup -Name $ResourceGroupName -Location $Location

# Display a success message
Write-Host "Resource group '$ResourceGroupName' created in location '$Location'"
