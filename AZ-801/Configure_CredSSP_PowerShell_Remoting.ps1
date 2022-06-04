Set-Location C:\
Clear-Host

#Configure CredSSP for PowerShell Remoting and Kerberos Delegation

#Verify the problem
Enter-PSSession -ComputerName 'srv01.cloudgrid.pri'
Invoke-Command -ComputerName 'dc01.cloudgrid.pri' -ScriptBlock { Get-WindowsFeature | Where-Object -FilterScript { $_.InstallState -eq 'Installed' } }

#Command search
Get-Command -Name *credssp* | Select-Object -Property Name, Source

#Enable srv01 to delegate my credentials
Enable-WSManCredSSP -Role Client -DelegateComputer srv01.cloudgrid.pri -Force

#Verify configuration
Get-WSManCredSSP

#Configure srv01 to act as a delegate on my behalf
Invoke-Command -ComputerName "srv01.cloudgrid.pri" -Scriptblock {Get-WSManCredSSP}

#Connect to srv01 specifying CredSSP
Enter-PSSession -ComputerName "srv01.cloudgrid.pri"-Credential "cloudgrid\administrator" -Authentication CredSSP

#Now it works
Invoke-Command -ComputerName 'dc01.cloudgrid.pri' -ScriptBlock { Get-WindowsFeature | Where-Object -FilterScript { $_.InstallState -eq 'Installed' } }

#Do not forget to deactivate CredSSP again
Disable-WSManCredSSP -Role Client

Invoke-Command -ComputerName "srv01.cloudgrid.pri" -ScriptBlock { Disable-WSManCredSSP -Role Server }