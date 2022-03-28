Set-Location C:\
Clear-Host

#Create and manage DNS policies

#Create the required subnets
Add-DnsServerClientSubnet -Name "LondonSubnet" -IPv4Subnet "172.16.18.0/24" -PassThru
Add-DnsServerClientSubnet -Name "SeattleSubnet" -IPv4Subnet "172.16.10.0/24" -PassThru

#Create the DNS server zone scopes
Add-DnsServerZoneScope -ZoneName "prime.pri" -Name "LondonZoneScope" -PassThru
Add-DnsServerZoneScope -ZoneName "prime.pri" -Name "SeattleZoneScope" -PassThru

#Add the required host records
Add-DnsServerResourceRecord -ZoneName "prime.pri" -A -Name "www" -IPv4Address "172.16.10.41" -ZoneScope "SeattleZoneScope" -PassThru
Add-DnsServerResourceRecord -ZoneName "prime.pri" -A -Name "www" -IPv4Address "172.16.18.17" -ZoneScope "LondonZoneScope" -PassThru

#Create the DNS server query resolution policies
Add-DnsServerQueryResolutionPolicy -Name "LondonPolicy" -Action ALLOW -ClientSubnet "eq,LondonSubnet" -ZoneScope "LondonZoneScope,1" -ZoneName "prime.pri" -PassThru
Add-DnsServerQueryResolutionPolicy -Name "SeattlePolicy" -Action ALLOW -ClientSubnet "eq,SeattleSubnet" -ZoneScope "SeattleZoneScope,1" -ZoneName "prime.pri" -PassThru
