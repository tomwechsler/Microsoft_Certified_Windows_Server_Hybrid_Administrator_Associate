Get-NetIPInterface

Set-NetIPInterface -InterfaceAlias "Ethernet" -Dhcp Disabled

New-NetIPAddress -InterfaceAlias "Ethernet" -IPAddress 192.168.3.20 -PrefixLength 24 -DefaultGateway 192.168.3.2

Set-DnsClientServerAddress -InterfaceAlias "Ethernet" -ServerAddresses ("192.168.3.10")

Rename-Computer -NewName clus01 -Restart

$domain = "prime.pri"
$password = "P@ssw0rd" | ConvertTo-SecureString -asPlainText -Force
$username = "$domain\administrator" 
$credential = New-Object System.Management.Automation.PSCredential($username,$password)

Add-Computer -DomainName $domain -Credential $credential -Restart -Force
