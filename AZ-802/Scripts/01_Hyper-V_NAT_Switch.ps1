#On your physical Hyper-V host (Create a NAT Switch)
New-VMSwitch -SwitchName "192.168.3.0-NATSwitch" -SwitchType Internal

New-NetIPAddress -IPAddress 192.168.3.2 -PrefixLength 24 -InterfaceAlias "vEthernet (192.168.3.0-NATSwitch)"

New-NetNAT -Name "192.168.3.0-NATNetwork" -InternalIPInterfaceAddressPrefix 192.168.3.0/24