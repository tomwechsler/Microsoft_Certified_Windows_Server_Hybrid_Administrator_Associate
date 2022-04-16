
Invoke-Command -ComputerName file01 -ScriptBlock { New-iSCSIVirtualDisk -Path "C:\iscsi-lun2.vhdx" -Description "iscsi-lun2" -Size 20GB }
Invoke-Command -ComputerName file01 -ScriptBlock { Add-iSCSIVirtualDiskTargetMapping -TargetName "iscsi-target1" -Path "c:\iscsi-lun2.vhdx" }

Invoke-Command -ComputerName clus01,clus02 -ScriptBlock { Install-WindowsFeature dhcp }

Invoke-Command -ComputerName clus01,clus02 -ScriptBlock { Install-WindowsFeature FS-FileServer }

Invoke-Command -ComputerName file01 -ScriptBlock { New-iSCSIVirtualDisk -Path "C:\iscsi-lun3.vhdx" -Description "iscsi-lun3" -Size 30GB }
Invoke-Command -ComputerName file01 -ScriptBlock { Add-iSCSIVirtualDiskTargetMapping -TargetName "iscsi-target1" -Path "c:\iscsi-lun3.vhdx" }

Invoke-Command -ComputerName file01 -ScriptBlock { New-iSCSIVirtualDisk -Path "C:\iscsi-lun4.vhdx" -Description "iscsi-lun4" -Size 100GB }
Invoke-Command -ComputerName file01 -ScriptBlock { Add-iSCSIVirtualDiskTargetMapping -TargetName "iscsi-target1" -Path "c:\iscsi-lun4.vhdx" }
