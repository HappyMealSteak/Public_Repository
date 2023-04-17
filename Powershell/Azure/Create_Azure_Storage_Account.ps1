# Connect to your Azure account
# This command will open a window to enter your Azure credentials
Connect-AzAccount

# Get the list of all resource groups in your tenant
$resourceGroups = Get-AzResourceGroup

# Display the list of resource groups with their names and locations
Write-Host "Available resource groups in your tenant:"
$resourceGroups | Format-Table ResourceGroupName, Location

# Prompt the user to enter the resource group name for the new storage account
# The user should choose one of the available resource groups displayed above
Write-Host "Enter the name of the resource group where the storage account will be created (e.g., 'MyResourceGroup'):"
$ResourceGroupName = Read-Host

# Prompt the user to enter a unique name for the new storage account
# The storage account name should be between 3 and 24 characters long, and can contain only lowercase letters and numbers
Write-Host "Enter a unique name for the new storage account (e.g., 'mystorageaccount123'):"
$StorageAccountName = Read-Host

# Prompt the user to enter the location for the new storage account
# The user should choose one of the available Azure regions (e.g., 'East US', 'West Europe')
Write-Host "Enter the location for the new storage account (e.g., 'East US', 'West Europe'):"
$Location = Read-Host

# Set the storage account SKU to Standard_LRS for the cheapest cost option
# Standard_LRS: Standard performance tier, Locally Redundant Storage (LRS) replication
$SkuName = "Standard_LRS"

# Create the new storage account with the specified resource group, storage account name, location, and SKU
# The Kind parameter is set to "StorageV2" to create a general-purpose v2 storage account
New-AzStorageAccount -ResourceGroupName $ResourceGroupName -Name $StorageAccountName -Location $Location -SkuName $SkuName -Kind "StorageV2"

# Display a success message with the storage account details
Write-Host "Storage account '$StorageAccountName' created in resource group '$ResourceGroupName' with location '$Location' and SKU '$SkuName'"
