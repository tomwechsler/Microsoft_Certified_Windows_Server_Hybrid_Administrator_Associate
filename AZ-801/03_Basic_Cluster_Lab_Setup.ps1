#The commands below assume a machine that is on the network and attached to an AD domain.
#Run these commands from the host machine and not mgm01.
#Start with machines powered off.

$cred = Get-Credential   ## Enter an Administrator credential in the AD domain.
Set-VMProcessor -VMName sitebclus01,sitebclus02 -ExposeVirtualizationExtensions $true

Start-VM -Name sitebclus01,sitebclus02
Start-Sleep 30

Invoke-Command -VMName sitebclus01,sitebclus02 -Credential $cred -ScriptBlock { Install-WindowsFeature Hyper-V,Failover-Clustering -IncludeAllSubfeature -IncludeManagementTools -Restart }
Start-Sleep 90

Add-VMNetworkAdapter -VMName sitebclus01,sitebclus02 -SwitchName "192.168.3.0-NATSwitch" -DeviceNaming On
Add-VMNetworkAdapter -VMName sitebclus01,sitebclus02 -SwitchName "192.168.3.0-NATSwitch" -DeviceNaming On
Add-VMNetworkAdapter -VMName sitebclus01,sitebclus02 -SwitchName "192.168.3.0-NATSwitch" -DeviceNaming On
Get-VMNetworkAdapter -VMName sitebclus01,sitebclus02 | Set-VMNetworkAdapter -MacAddressSpoofing On -AllowTeaming On

Invoke-Command -VMName sitebclus01,sitebclus02 -Credential $cred -ScriptBlock { New-VMSwitch -Name Management -EnableEmbeddedTeaming $True -AllowManagementOS $True -NetAdapterName "Ethernet","Ethernet 2","Ethernet 3","Ethernet 4" }
Invoke-Command -VMName sitebclus01,sitebclus02 -Credential $cred -ScriptBlock { Add-VMNetworkAdapter -ManagementOS -Name "SiteBCluster" -SwitchName Management }
Invoke-Command -VMName sitebclus01,sitebclus02 -Credential $cred -ScriptBlock { Add-VMNetworkAdapter -ManagementOS -Name "SiteBStorage" -SwitchName Management }

Invoke-Command -VMName sitebclus01 -Credential $cred -ScriptBlock { New-NetIPAddress -InterfaceAlias "vEthernet (SiteBCluster)" -IPAddress 10.0.0.3 -PrefixLength 24 }
Invoke-Command -VMName sitebclus01 -Credential $cred -ScriptBlock { New-NetIPAddress -InterfaceAlias "vEthernet (SiteBStorage)" -IPAddress 10.0.1.3 -PrefixLength 24 }
Invoke-Command -VMName sitebclus02 -Credential $cred -ScriptBlock { New-NetIPAddress -InterfaceAlias "vEthernet (SiteBCluster)" -IPAddress 10.0.0.4 -PrefixLength 24 }
Invoke-Command -VMName sitebclus02 -Credential $cred -ScriptBlock { New-NetIPAddress -InterfaceAlias "vEthernet (SiteBStorage)" -IPAddress 10.0.1.4 -PrefixLength 24 }

Start-VM -Name sitebfile01
Start-Sleep 30

Add-VMNetworkAdapter -VMName sitebfile01 -SwitchName "192.168.3.0-NATSwitch" -DeviceNaming On
Invoke-Command -VMName sitebfile01 -Credential $cred -ScriptBlock { New-NetIPAddress -InterfaceAlias "Ethernet 2" -IPAddress 10.0.1.101 -PrefixLength 24 }