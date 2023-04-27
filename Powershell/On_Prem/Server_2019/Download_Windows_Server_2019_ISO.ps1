# Define the URL for the Windows Server 2016 ISO from the official Microsoft source
$url = "https://go.microsoft.com/fwlink/p/?LinkID=2195167&clcid=0x409&culture=en-us&country=US"

# Define the destination path for the downloaded ISO
$destination = "C:\Downloads\Windows_Server_2019.iso"

# Check if the destination folder exists, if not create it
$destinationFolder = Split-Path -Path $destination -Parent
if (-not (Test-Path $destinationFolder)) {
    New-Item -Path $destinationFolder -ItemType Directory
}

# Download the ISO using Invoke-WebRequest
Write-Host "Downloading Windows Server 2019 ISO..."
Invoke-WebRequest -Uri $url -OutFile $destination

# Verify the download
if (Test-Path $destination) {
    Write-Host "Download completed successfully!"
} else {
    Write-Host "Download failed. Please check the URL and try again."
}
