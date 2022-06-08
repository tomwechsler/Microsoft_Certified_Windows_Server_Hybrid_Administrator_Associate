Set-Location C:\
Clear-Host

#Downloading LAPS
https://www.microsoft.com/en-us/download/details.aspx?id=46899

#Extend the AD Schema
Import-module AdmPwd.PS
Update-AdmPwdADSchema

#Change Computer object permissions
Set-AdmPwdComputerSelfPermission -OrgUnit LAPSCLIENT

#Assign permissions to the group for password access
#The extended permissions are only applied to the Domain Admins group
Find-AdmPwdExtendedRights -Identity "LAPSCLIENT"

#We need to grant the read permissions to "ITAdmins" Security group (The administrators optionally also added)
Set-AdmPwdReadPasswordPermission -Identity "LAPSCLIENT" -AllowedPrincipals prime\Administrator,prime\ITAdmins

#We need to grant the write permissions to "ITAdmins" Security group (The administrators optionally also added)
Set-AdmPwdResetPasswordPermission -OrgUnit Client -AllowedPrincipals prime\Administrator,prime\ITAdmins

#We can verify now the permissions
Find-AdmPwdExtendedRights -Identity "LAPSCLIENT" | Format-List

#Install CSE in Computers (for example with a GPO)
#Create GPO for LAPS settings

#Checking local administrator password
Get-AdmPwdPassword -ComputerName CL01
