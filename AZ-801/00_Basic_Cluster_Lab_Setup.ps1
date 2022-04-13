#On your physical Hyper-V host (Create a NAT Switch)
New-VMSwitch -SwitchName "192.168.3.0-NATSwitch" -SwitchType Internal

New-NetIPAddress -IPAddress 192.168.3.2 -PrefixLength 24 -InterfaceAlias "vEthernet (192.168.3.0-NATSwitch)"

New-NetNAT -Name "192.168.3.0-NATNetwork" -InternalIPInterfaceAddressPrefix 192.168.3.0/24

#Install the operating system for all VMs

#Set the IPAddress
Get-NetIPInterface

Set-NetIPInterface -InterfaceAlias "Ethernet" -Dhcp Disabled

New-NetIPAddress -InterfaceAlias "Ethernet" -IPAddress 192.168.3.20 -PrefixLength 24 -DefaultGateway 192.168.3.2

Set-DnsClientServerAddress -InterfaceAlias "Ethernet" -ServerAddresses ("192.168.3.10")

#Rename the Computer
Rename-Computer -NewName clus01 -Restart

#Join to the Domain
$domain = "prime.pri"
$password = "P@ssw0rd" | ConvertTo-SecureString -asPlainText -Force
$username = "$domain\administrator" 
$credential = New-Object System.Management.Automation.PSCredential($username,$password)

Add-Computer -DomainName $domain -Credential $credential -Restart -Force

#On all virtual systems you want to manage (absolutely fine for the test environment - never adjust the firewall like this in a prductive environment)
Enable-PSRemoting

New-NetFirewallRule NetFirewallRule -DisplayName "Allow All Traffic" -Direction Outbound -Action Allow

New-NetFirewallRule NetFirewallRule -DisplayName "Allow All Traffic" -Direction Inbound -Action Allow

#Set power management to maximum performance
powercfg /s 8c5e7fda-e8bf-4a96-9a85-a6e23a8c63