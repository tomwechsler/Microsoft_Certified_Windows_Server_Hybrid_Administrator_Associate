Set-Location C:\
Clear-Host

#Use the Test-SRTopology cmdlet to determine whether the source and destination volumes meet the Storage Replica requirements.
Test-SRTopology -SourceComputerName "SEA-SVR1" -SourceVolumeName "D:" -SourceLogVolumeName "E:" -DestinationComputerName "SEA-SVR2" -DestinationVolumeName "D:" -DestinationLogVolumeName "E:" -DurationInMinutes 10 -ResultPath "C:\temp"

#Use the New-SRPartnership cmdlet to create a Storage Replica partnership
New-SRPartnership -SourceComputerName 'SEA-SVR1' -SourceRGName 'RG01' -SourceVolumeName S: -SourceLogVolumeName L: -DestinationComputerName 'SEA-SVR2' -DestinationRGName 'RG02' -DestinationVolumeName S: -DestinationLogVolumeName L:

#To track the replication progress on the source server and then examine events 5015, 5002, 5004, 1237, 5001, and 2200
Get-WinEvent -ProviderName Microsoft-Windows-StorageReplica -max 20

#On the destination server, run the following command to review the Storage Replica events that depict the creation of the partnership
Get-WinEvent -ProviderName Microsoft-Windows-StorageReplica | Where-Object {$_.ID -eq "1215"} | Format-List

#Alternatively, you can run the following command on the destination server
(Get-SRGroup).Replicas | Select-Object NumOfBytesRemaining

#To track the replication progress on the destination server, run the following command, and then examine events 5009, 1237, 5001, 5015, 5005, and 2200
Get-WinEvent -ProviderName Microsoft-Windows-StorageReplica | FL

#To change direction of replication, run the following command
Set-SRPartnership -NewSourceComputerName  -SourceRGName 'SEA-SVR2' -DestinationComputerName 'SEA-SVR1' -DestinationRGName 'RG02'
