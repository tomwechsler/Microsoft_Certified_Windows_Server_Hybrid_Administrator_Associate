#The commands below assume a machine that is on the network and attached to an AD domain.
#Run these commands from the host machine and not mgm01.
#Start with machines powered off.

$cred = Get-Credential   ## Enter an Administrator credential in the AD domain.
Set-VMProcessor -VMName hcluster1,hcluster2,hcluster3,hcluster4 -ExposeVirtualizationExtensions $true

$rootPath = "H:\Windows Server 2022"
$S2DVMNames = @("hcluster1","hcluster2","hcluster3","hcluster4")
$S2DVMNames | ForEach-Object {

New-VHD -Path "$rootPath\$_\Disk1.vhdx" -SizeBytes 100GB -Dynamic
New-VHD -Path "$rootPath\$_\Disk2.vhdx" -SizeBytes 100GB -Dynamic
New-VHD -Path "$rootPath\$_\Disk3.vhdx" -SizeBytes 100GB -Dynamic
New-VHD -Path "$rootPath\$_\Disk4.vhdx" -SizeBytes 100GB -Dynamic
New-VHD -Path "$rootPath\$_\Disk5.vhdx" -SizeBytes 100GB -Dynamic
New-VHD -Path "$rootPath\$_\Disk6.vhdx" -SizeBytes 100GB -Dynamic

Add-VMHardDiskDrive -VMName $_ -Path "$rootPath\$_\Disk1.vhdx" -ControllerType SCSI
Add-VMHardDiskDrive -VMName $_ -Path "$rootPath\$_\Disk2.vhdx" -ControllerType SCSI
Add-VMHardDiskDrive -VMName $_ -Path "$rootPath\$_\Disk3.vhdx" -ControllerType SCSI
Add-VMHardDiskDrive -VMName $_ -Path "$rootPath\$_\Disk4.vhdx" -ControllerType SCSI
Add-VMHardDiskDrive -VMName $_ -Path "$rootPath\$_\Disk5.vhdx" -ControllerType SCSI
Add-VMHardDiskDrive -VMName $_ -Path "$rootPath\$_\Disk6.vhdx" -ControllerType SCSI

}

Start-VM -Name hcluster1,hcluster2,hcluster3,hcluster4
Start-Sleep 30

Invoke-Command -VMName hcluster1,hcluster2,hcluster3,hcluster4 -Credential $cred -ScriptBlock { Install-WindowsFeature Hyper-V,Failover-Clustering -IncludeAllSubfeature -IncludeManagementTools -Restart }
Start-Sleep 60

Add-VMNetworkAdapter -VMName hcluster1,hcluster2,hcluster3,hcluster4 -SwitchName "192.168.3.0-NATSwitch" -DeviceNaming On
Add-VMNetworkAdapter -VMName hcluster1,hcluster2,hcluster3,hcluster4 -SwitchName "192.168.3.0-NATSwitch" -DeviceNaming On
Add-VMNetworkAdapter -VMName hcluster1,hcluster2,hcluster3,hcluster4 -SwitchName "192.168.3.0-NATSwitch" -DeviceNaming On
Get-VMNetworkAdapter -VMName hcluster1,hcluster2,hcluster3,hcluster4 | Set-VMNetworkAdapter -MacAddressSpoofing On -AllowTeaming On

Invoke-Command -VMName hcluster1,hcluster2,hcluster3,hcluster4 -Credential $cred -ScriptBlock { New-VMSwitch -Name Management -EnableEmbeddedTeaming $True -AllowManagementOS $True -NetAdapterName "Ethernet","Ethernet 2","Ethernet 3","Ethernet 4" }
Invoke-Command -VMName hcluster1,hcluster2,hcluster3,hcluster4 -Credential $cred -ScriptBlock { Add-VMNetworkAdapter -ManagementOS -Name "Cluster" -SwitchName Management }
Invoke-Command -VMName hcluster1,hcluster2,hcluster3,hcluster4 -Credential $cred -ScriptBlock { Add-VMNetworkAdapter -ManagementOS -Name "Storage" -SwitchName Management }

Invoke-Command -VMName hcluster1 -Credential $cred -ScriptBlock { New-NetIPAddress -InterfaceAlias "vEthernet (Cluster)" -IPAddress 10.0.0.5 -PrefixLength 24 }
Invoke-Command -VMName hcluster2 -Credential $cred -ScriptBlock { New-NetIPAddress -InterfaceAlias "vEthernet (Cluster)" -IPAddress 10.0.0.6 -PrefixLength 24 }
Invoke-Command -VMName hcluster3 -Credential $cred -ScriptBlock { New-NetIPAddress -InterfaceAlias "vEthernet (Cluster)" -IPAddress 10.0.0.7 -PrefixLength 24 }
Invoke-Command -VMName hcluster4 -Credential $cred -ScriptBlock { New-NetIPAddress -InterfaceAlias "vEthernet (Cluster)" -IPAddress 10.0.0.8 -PrefixLength 24 }

Invoke-Command -VMName hcluster1 -Credential $cred -ScriptBlock { New-NetIPAddress -InterfaceAlias "vEthernet (Storage)" -IPAddress 10.0.1.5 -PrefixLength 24 }
Invoke-Command -VMName hcluster2 -Credential $cred -ScriptBlock { New-NetIPAddress -InterfaceAlias "vEthernet (Storage)" -IPAddress 10.0.1.6 -PrefixLength 24 }
Invoke-Command -VMName hcluster3 -Credential $cred -ScriptBlock { New-NetIPAddress -InterfaceAlias "vEthernet (Storage)" -IPAddress 10.0.1.7 -PrefixLength 24 }
Invoke-Command -VMName hcluster4 -Credential $cred -ScriptBlock { New-NetIPAddress -InterfaceAlias "vEthernet (Storage)" -IPAddress 10.0.1.8 -PrefixLength 24 }

Invoke-Command -VMName hcluster1,hcluster2,hcluster3,hcluster4 -Credential $cred -ScriptBlock { Set-Disk -Number 1 -IsOffline $false | Initialize-Disk } 
Invoke-Command -VMName hcluster1,hcluster2,hcluster3,hcluster4 -Credential $cred -ScriptBlock { Set-Disk -Number 2 -IsOffline $false | Initialize-Disk } 
Invoke-Command -VMName hcluster1,hcluster2,hcluster3,hcluster4 -Credential $cred -ScriptBlock { Set-Disk -Number 3 -IsOffline $false | Initialize-Disk } 
Invoke-Command -VMName hcluster1,hcluster2,hcluster3,hcluster4 -Credential $cred -ScriptBlock { Set-Disk -Number 4 -IsOffline $false | Initialize-Disk } 
Invoke-Command -VMName hcluster1,hcluster2,hcluster3,hcluster4 -Credential $cred -ScriptBlock { Set-Disk -Number 5 -IsOffline $false | Initialize-Disk } 
Invoke-Command -VMName hcluster1,hcluster2,hcluster3,hcluster4 -Credential $cred -ScriptBlock { Set-Disk -Number 6 -IsOffline $false | Initialize-Disk } 

Invoke-Command -VMName hcluster1,hcluster2,hcluster3,hcluster4 -Credential $cred -ScriptBlock { Restart-Computer hcluster1,hcluster2,hcluster3,hcluster4 }