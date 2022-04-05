##NOTE:The commands below assume a machine that is on the network and attached to an AD domain.
##NOTE:Run these commands from the host machine
##NOTE:Start with machines powered off.

$cred = Get-Credential
Set-VMProcessor -VMName clus01,clus02 -ExposeVirtualizationExtensions $true
Start-VM -Name clus01,clus02

Invoke-Command -VMName clus01,clus02 -Credential $cred -ScriptBlock { Install-WindowsFeature Hyper-V,Failover-Clustering -IncludeAllSubfeature -IncludeManagementTools -Restart }

Get-VMSwitch

Add-VMNetworkAdapter -VMName clus01,clus02 -SwitchName "192.168.3.0-NATSwitch" -DeviceNaming On
Add-VMNetworkAdapter -VMName clus01,clus02 -SwitchName "192.168.3.0-NATSwitch" -DeviceNaming On
Add-VMNetworkAdapter -VMName clus01,clus02 -SwitchName "192.168.3.0-NATSwitch" -DeviceNaming On

Get-VMNetworkAdapter -VMName clus01,clus02

Get-VMNetworkAdapter -VMName clus01,clus02 | Set-VMNetworkAdapter -MacAddressSpoofing On -AllowTeaming On

Invoke-Command -VMName clus01,clus02 -credential $cred -ScriptBlock { Get-NetAdapter | Format-Table }

Invoke-Command -VMName clus01,clus02 -Credential $cred -ScriptBlock { New-VMSwitch -Name Management -EnableEmbeddedTeaming $True -AllowManagementOS $True -NetAdapterName "Ethernet","Ethernet 2","Ethernet 3","Ethernet 4" }

Invoke-Command -VMName clus01,clus02 -Credential $cred -ScriptBlock { Get-NetIPAddress | Format-Table interfacealias, ipaddress }

Invoke-Command -VMName clus01,clus02 -Credential $cred -ScriptBlock { Add-VMNetworkAdapter -ManagementOS -Name "Cluster" -SwitchName Management }
Invoke-Command -VMName clus01,clus02 -Credential $cred -ScriptBlock { Add-VMNetworkAdapter -ManagementOS -Name "Storage" -SwitchName Management }

Invoke-Command -VMName clus01,clus02 -Credential $cred -ScriptBlock { Get-NetIPAddress | Format-Table interfacealias, ipaddress }

Invoke-Command -VMName clus01 -Credential $cred -ScriptBlock { New-NetIPAddress -InterfaceAlias "vEthernet (Cluster)" -IPAddress 10.0.0.1 -PrefixLength 24 }
Invoke-Command -VMName clus01 -Credential $cred -ScriptBlock { New-NetIPAddress -InterfaceAlias "vEthernet (Storage)" -IPAddress 10.0.1.1 -PrefixLength 24 }
Invoke-Command -VMName clus02 -Credential $cred -ScriptBlock { New-NetIPAddress -InterfaceAlias "vEthernet (Cluster)" -IPAddress 10.0.0.2 -PrefixLength 24 }
Invoke-Command -VMName clus02 -Credential $cred -ScriptBlock { New-NetIPAddress -InterfaceAlias "vEthernet (Storage)" -IPAddress 10.0.1.2 -PrefixLength 24 }

Invoke-Command -VMName clus01,clus02 -Credential $cred -ScriptBlock { Get-NetIPAddress | Format-Table interfacealias, ipaddress }

Invoke-Command -VMName clus01,clus02 -Credential $cred -ScriptBlock { Set-VMSwitchTeam -Name Management -LoadBalancingAlgorithm Dynamic }

Add-VMNetworkAdapter -VMName file01 -SwitchName "192.168.3.0-NATSwitch" -DeviceNaming On

Start-VM -Name file01

Invoke-Command -VMName file01 -Credential $cred -ScriptBlock { New-NetIPAddress -InterfaceAlias "Ethernet 2" -IPAddress 10.0.1.100 -PrefixLength 24 }