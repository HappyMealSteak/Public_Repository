# Check if the Hyper-V feature is already enabled
$hyperVEnabled = Get-WindowsOptionalFeature -Online -FeatureName Microsoft-Hyper-V-All -ErrorAction SilentlyContinue | Select-Object -ExpandProperty State

if ($hyperVEnabled -eq 'Enabled') {
    Write-Host 'Hyper-V is already enabled.'
} else {
    # Enable the Hyper-V feature
    Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Hyper-V -All -NoRestart
    Write-Host 'Hyper-V has been enabled. A restart may be required for changes to take effect.'
}
