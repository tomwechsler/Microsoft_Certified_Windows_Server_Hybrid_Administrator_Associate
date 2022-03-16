Set-Location C:\
Clear-Host

#Install Hyper-V
Install-WindowsFeature -Name Hyper-V -IncludeManagementTools -Restart

#Create a Virtual Switch with PowerShell

#Find the interface index
Get-NetAdapter

#Create a variable
$net = Get-NetAdapter -Name 'Ethernet'

#Create the switch
New-VMSwitch -Name "External VM Switch" -AllowManagementOS $True -NetAdapterName $net.Name

#Create a virtual computer with an existing virtual hard disk
New-VM -Name Win10VM -MemoryStartupBytes 4GB -BootDevice VHD -VHDPath .\VMs\Win10.vhdx -Path .\VMData -Generation 2 -Switch "External VM Switch"

#Create a virtual computer with a new virtual hard disk
New-VM -Name Win10VM -MemoryStartupBytes 4GB -BootDevice VHD -NewVHDPath .\VMs\Win10.vhdx -Path .\VMData -NewVHDSizeBytes 20GB -Generation 2 -Switch "External VM Switch"

#Start the VM
Start-VM -Name Win10VM

#Connect
VMConnect.exe

#Enable nested virtualization
Set-VMProcessor -VMName 'srv01' -ExposeVirtualizationExtensions $true -Confirm $true

#Enable MAC address spoofing on Hyper-V host
Get-VMNetworkAdapter -VMName 'srv01' | Set-VMNetworkAdapter -MacAddressSpoofing On

#Manage Hyper-V

#Set VM default checkpoint type
Set-VM -Name 'srv01' -CheckpointType Standard #or 'Production'

#Create a checkpoint
Checkpoint-VM -Name 'srv01'

#Apply a checkpoint
Get-VMCheckpoint -VMName 'srv01'

Restore-VMCheckpoint -Name 'srv01-chkpo01' -VMName 'srv01' -Confirm:$false

#Rename a checkpoint
Rename-VMCheckpoint -VMName'srv01'-Name 'srv01-chkpo01' -NewName srv01-checkpoint2

#Export a checkpoint
Export-VMCheckpoint -VMName'srv01' -Name 'srv01-chkpo01' -Path 'c:\migrate'

#Delete a checkpoint
Remove-VMCheckpoint -VMName'srv01' -Name 'srv01-chkpo01'

#Remove snapshots older than 30 days
Get-VMSnapshot -VMName 'srv01' | Where-Object { $_.CreationTime -lt (Get-Date).AddDays(-30) } | Remove-VMSnapshot
