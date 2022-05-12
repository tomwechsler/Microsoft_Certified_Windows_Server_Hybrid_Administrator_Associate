#The first step, create the root key

#Use this command in productive environment (Important wait 10h - replication)
Add-KdsRootKey -EffectiveImmediately

#This command is for a test environment 
Add-KdsRootKey -EffectiveTime ((Get-Date).AddHours(-10)) 

#Create a new group
New-ADGroup -Name TestMSA `
-GroupScope DomainLocal `
-Description "Gruppe fuer Server von TestMSA" `
-DisplayName "Test gMSA Gruppe" `
-GroupCategory Security `
-SAMAccountName TestMSA `
-PassThru

#To this group we now add the "Members
Add-ADGroupMember -Identity TestMSA `
-Members "dcsrv01$","dcsrv02$" `
-PassThru

#Control
Get-ADGroupMember -Identity TestMSA

#Now create a new account
New-ADServiceAccount -Name SvcAcnt1 `
-DNSHostName SvcAcnt1.corp.int `
-PassThru

#The account will be edited now
Set-ADServiceAccount -Identity SvcAcnt1 `
-PrincipalsAllowedToRetrieveManagedPassword TestMSA `
-PrincipalsAllowedToDelegateToAccount TestMSA `
-PassThru

#Before running this cmdlet, the systems must be restarted (so that group membership is applied)
Invoke-Command -ComputerName dcsrv02 -ScriptBlock {Restart-Computer -Force}

#Install the service account on DCSRV02
Invoke-Command -ComputerName dcsrv02 -ScriptBlock {Install-ADServiceAccount -Identity SvcAcnt1}

#Control
Invoke-Command -ComputerName dcsrv02 -ScriptBlock {Test-ADServiceAccount -Identity SvcAcnt1}

#Now in the services we can select this account for a specific service