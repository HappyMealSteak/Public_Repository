$adapter = Get-NetAdapter | ? { $_.Status -eq 'Up' } | Select-Object -First 1
$ipAddress = "192.168.1.100" # Change to your desired IP address
$subnetMask = "255.255.255.0" # Change to your subnet mask
$gateway = "192.168.1.1" # Change to your gateway
$dnsServers = "192.168.1.2", "8.8.8.8" # Change to your DNS servers

New-NetIPAddress -InterfaceAlias $adapter.Name -IPAddress $ipAddress -PrefixLength $subnetMask.Length -DefaultGateway $gateway
Set-DnsClientServerAddress -InterfaceAlias $adapter.Name -ServerAddresses $dnsServers
