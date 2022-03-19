Set-Location C:\
Clear-Host

#Implement iSCSI Target Server
Install-WindowsFeature FS-iSCSITarget-Server
New-IscsiVirtualDisk E:\iSCSIVirtualHardDisk\1.vhdx –size 1GB
New-IscsiServerTarget SQLTarget –InitiatorIds 'IQN: iqn.1991-05.com.Microsoft:SQL1.Contoso.com'
Add-IscsiVirtualDiskTargetMapping SQLTarget E:\iSCSIVirtualHardDisk\1.vhdx

#Implement iSCSI initiator
Start-Service msiscsi
Set-Service msiscsi –StartupType 'Automatic'
New-IscsiTargetPortal –TargetPortalAddress iSCSIServer1
Connect-IscsiTarget –NodeAddress 'iqn.1991-05.com.microsoft:netboot-1-SQLTarget-target'
