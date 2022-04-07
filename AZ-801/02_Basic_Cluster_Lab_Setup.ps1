#The commands below assume a machine that is on the network and attached to an AD domain.
#Run this script from mgm01 (this is the management VM in your domain)
#Start with servers powered on.

Install-WindowsFeature -ComputerName file01 FS-FileServer,FS-iSCSITarget-Server -IncludeAllSubfeature -IncludeManagementTools -Restart

Invoke-Command -ComputerName clus01,clus02 -ScriptBlock { Set-Service msiscsi -StartupType "Automatic" ; Start-Service msiscsi }
Invoke-Command -ComputerName clus01,clus02 -ScriptBlock { Get-InitiatorPort }
Invoke-Command -ComputerName clus01,clus02 -ScriptBlock { New-IscsiTargetPortal -TargetPortalAddress 10.0.1.100 }

Invoke-Command -ComputerName file01 -ScriptBlock { New-iSCSIVirtualDisk -Path "C:\iscsi-lun1.vhdx" -Description "iscsi-lun1" -Size 10GB }
Invoke-Command -ComputerName file01 -ScriptBlock { New-iSCSIServerTarget -TargetName "iscsi-target1" -InitiatorIds @("IPAddress:10.0.1.1","IPAddress:10.0.1.2") }
Invoke-Command -ComputerName file01 -ScriptBlock { Add-iSCSIVirtualDiskTargetMapping -TargetName "iscsi-target1" -Path "c:\iscsi-lun1.vhdx" }

Invoke-Command -ComputerName clus01,clus02 -ScriptBlock { Get-IscsiTargetPortal | Update-IscsiTargetPortal }

Invoke-Command -ComputerName clus01,clus02 -ScriptBlock { Get-IscsiTarget }

Invoke-Command -ComputerName clus01 -ScriptBlock { Connect-iscsitarget -nodeaddress iqn.1991-05.com.microsoft:file01-iscsi-target1-target -IsPersistent $true -initiatorportaladdress 10.0.1.1 -targetportaladdress 10.0.1.100 }
Invoke-Command -ComputerName clus02 -ScriptBlock { Connect-iscsitarget -nodeaddress iqn.1991-05.com.microsoft:file01-iscsi-target1-target -IsPersistent $true -initiatorportaladdress 10.0.1.2 -targetportaladdress 10.0.1.100 }

Invoke-Command -ComputerName clus01,clus02 -ScriptBlock { Get-iscsisession | Register-iscsisession }
	
##At this point, bring online, initialize, and format the disk.
##Server Manager | File and Storage Services | Disks
##IMPORTANT FROM ONE SERVER!!!
##Bring the disk online
##Initialize the disk
##Format the disk | Q: (this will be the quorum disk)

New-Cluster -Name primecluster -Node clus01,clus02 -StaticAddress 192.168.3.148
