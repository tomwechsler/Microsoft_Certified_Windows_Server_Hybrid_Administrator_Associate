#On the mgm01 System
Invoke-Command -ComputerName hclus01,hclus02,hclus03,hclus04 -Credential $cred -ScriptBlock { Install-WindowsFeature -Name FS-FileServer -IncludeAllSubfeature -IncludeManagementTools }

Add-ClusterScaleOutFileServerRole -Name clustersofs

New-Item -Path C:\ClusterStorage\$($volume.FileSystemLabel)\Share -ItemType Directory

New-SmbShare -Name Share -Path C:\ClusterStorage\$($volume.FileSystemLabel)\Share