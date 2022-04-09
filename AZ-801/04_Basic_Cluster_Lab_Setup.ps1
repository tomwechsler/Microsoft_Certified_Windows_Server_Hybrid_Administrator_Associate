#The commands below assume a machine that is on the network and attached to an AD domain.
#Run this script from mgm01 and not the host machine.
#Start with servers powered on.

Install-WindowsFeature -ComputerName sitebfile01 FS-FileServer,FS-iSCSITarget-Server -IncludeAllSubfeature -IncludeManagementTools -Restart
Start-Sleep 60

Set-IscsiTargetServerSetting -ComputerName sitebfile01 -IP 192.168.3.131 -Enable $false
Set-IscsiTargetServerSetting -ComputerName sitebfile01 -IP 10.0.1.101 -Enable $true

New-iSCSIServerTarget -ComputerName sitebfile01 -TargetName "iscsi-sitebtarget1" -InitiatorIds @("IPAddress:10.0.1.3","IPAddress:10.0.1.4")

Invoke-Command -ComputerName sitebclus01,sitebclus02 -ScriptBlock { Set-Service msiscsi -StartupType "Automatic" ; Start-Service msiscsi }
Invoke-Command -ComputerName sitebclus01,sitebclus02 -ScriptBlock { New-IscsiTargetPortal -TargetPortalAddress 10.0.1.101 }
Invoke-Command -ComputerName sitebclus01,sitebclus02 -ScriptBlock { Get-IscsiTargetPortal | Update-IscsiTargetPortal }

Invoke-Command -ComputerName sitebclus01 -ScriptBlock { Connect-iscsitarget -nodeaddress iqn.1991-05.com.microsoft:sitebfile01-iscsi-sitebtarget1-target -IsPersistent $true -initiatorportaladdress 10.0.1.3 -targetportaladdress 10.0.1.101 }
Invoke-Command -ComputerName sitebclus02 -ScriptBlock { Connect-iscsitarget -nodeaddress iqn.1991-05.com.microsoft:sitebfile01-iscsi-sitebtarget1-target -IsPersistent $true -initiatorportaladdress 10.0.1.4 -targetportaladdress 10.0.1.101 }
Invoke-Command -ComputerName sitebclus01,sitebclus02 -ScriptBlock { Get-iscsisession | Register-iscsisession }

Invoke-Command -ComputerName sitebfile01 -ScriptBlock { New-iSCSIVirtualDisk -Path "C:\iscsi-siteblun4.vhdx" -Description "iscsi-siteblun4" -Size 100GB }
Invoke-Command -ComputerName sitebfile01 -ScriptBlock { Add-iSCSIVirtualDiskTargetMapping -TargetName "iscsi-sitebtarget1" -Path "c:\iscsi-siteblun4.vhdx" }

Invoke-Command -ComputerName sitebfile01 -ScriptBlock { New-iSCSIVirtualDisk -Path "C:\iscsi-siteblun4log.vhdx" -Description "iscsi-siteblun4log" -Size 10GB }
Invoke-Command -ComputerName sitebfile01 -ScriptBlock { Add-iSCSIVirtualDiskTargetMapping -TargetName "iscsi-sitebtarget1" -Path "c:\iscsi-siteblun4log.vhdx" }

Invoke-Command -ComputerName file01 -ScriptBlock { New-iSCSIVirtualDisk -Path "C:\iscsi-lun4log.vhdx" -Description "iscsi-lun4log" -Size 10GB }
Invoke-Command -ComputerName file01 -ScriptBlock { Add-iSCSIVirtualDiskTargetMapping -TargetName "iscsi-target1" -Path "c:\iscsi-lun4log.vhdx" }

Invoke-Command -ComputerName clus01,clus02,sitebclus01,sitebclus02 -ScriptBlock { Install-WindowsFeature Storage-Replica -IncludeAllSubfeature -IncludeManagementTools -Restart }

#The disks created above will need to be brought online, initialized, and formatted in order to use with Storage Replica.
