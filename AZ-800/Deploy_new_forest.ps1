#Deploy the first domain controller in a new forest

#Install the server role
Install-WindowsFeature -Name AD-Domain-Services -IncludeManagementTools

#Create forest root domain
Import-Module ADDSDeployment
Install-ADDSForest `
-CreateDnsDelegation:$false `
-DatabasePath "C:\Windows\NTDS" `
-DomainMode "WinThreshold" `
-DomainName "prime.pri" `
-DomainNetbiosName "PRIME" `
-ForestMode "WinThreshold" `
-InstallDns:$true `
-LogPath "C:\Windows\NTDS" `
-NoRebootOnCompletion:$false `
-SysvolPath "C:\Windows\SYSVOL" `
  -SafeModeAdministratorPassword (ConvertTo-SecureString 'P@ssw0rd' -AsPlainText -Force)
-Force:$true