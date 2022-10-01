Set-Location C:\
Clear-Host

#Search for the feature
Invoke-Command -ComputerName srv01,file01 -ScriptBlock {Get-WindowsFeature -Name *dfs-*}

#Install DFS
Invoke-Command -ComputerName srv01,file01 -ScriptBlock {Install-WindowsFeature -Name FS-DFS-Namespace,FS-DFS-Replication -IncludeManagementTools -IncludeAllSubFeature}