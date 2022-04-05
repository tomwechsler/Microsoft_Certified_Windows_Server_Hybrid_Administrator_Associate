New-VMSwitch -SwitchName "192.168.3.0-NATSwitch" -SwitchType Internal

New-NetIPAddress -IPAddress 192.168.3.2 -PrefixLength 24 -InterfaceAlias "vEthernet (192.168.3.0-NATSwitch)"

New-NetNAT -Name "192.168.0.3-NATNetwork" -InternalIPInterfaceAddressPrefix 192.168.0.3/24

Enable-PSRemoting

New-NetFirewallRule NetFirewallRule -DisplayName "Allow All Traffic" -Direction Outbound -Action Allow

New-NetFirewallRule NetFirewallRule -DisplayName "Allow All Traffic" -Direction Inbound -Action Allow

powercfg /s 8c5e7fda-e8bf-4a96-9a859a85-a6e23a8c635ca6e23a8c635c