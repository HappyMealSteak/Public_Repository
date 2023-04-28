 # Update SSL/TLS protocols
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

# Check the installed .NET Framework version
$installedVersion = [System.Environment]::Version.Version.Major

# Specify the download URL for the .NET Framework installer
$downloadUrl = "https://go.microsoft.com/fwlink/?linkid=2088631"

# Specify the target directory to save the installer
$targetDirectory = "C:\Apps\Net_Framework"

# Specify the latest .NET Framework version to install
$latestVersion = 4.8

# Check if the installed version is older than the latest version
if ($installedVersion -lt $latestVersion) {
    Write-Host "The installed .NET Framework version is older. Updating to the latest version..."

    # Create the target directory if it does not exist
    if (-not (Test-Path -Path $targetDirectory)) {
        New-Item -ItemType Directory -Path $targetDirectory | Out-Null
    }

    # Specify the path to save the downloaded installer
    $installerPath = Join-Path -Path $targetDirectory -ChildPath "dotnet-web-installer-latest.exe"

    # Download the .NET Framework installer
    try {
        Start-BitsTransfer -Source $downloadUrl -Destination $installerPath -TransferType Download -Priority High -ErrorAction Stop
        Write-Host "The .NET Framework installer has been downloaded successfully."
    }
    catch {
        Write-Host "Failed to download the .NET Framework installer. Please check your internet connection and try again."
        Exit
    }

    # Install the latest .NET Framework
    try {
        Start-Process -FilePath $installerPath -ArgumentList "/q" -Wait
        Write-Host "The .NET Framework has been updated to the latest version."
    }
    catch {
        Write-Host "Failed to install the .NET Framework. Please ensure you have the necessary permissions and try again."
        Exit
    }
}
else {
    Write-Host "The installed .NET Framework version is up to date."
}
 
