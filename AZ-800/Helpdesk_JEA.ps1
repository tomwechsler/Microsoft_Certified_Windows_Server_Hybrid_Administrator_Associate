#1. Create a security group with the name Helpdesk in AD.
#2. Add users to the Helpdesk group

#We start a "normal" remote connection and check how many cmdlets are available
Enter-PSSession -ComputerName dc01

(Get-Command).count

#We navigate in to the following path
Set-Location 'C:\Program Files\WindowsPowerShell\Modules'

#Create a new directory
New-Item -ItemType Directory Helpdesk

#Navigate to the directory
Set-Location Helpdesk

#Creates a new module manifest
New-ModuleManifest .\Helpdesk.psd1

#Create a new directory
New-Item -ItemType Directory RoleCapabilities

#Navigate to the directory
Set-Location RoleCapabilities

#Creates a file that defines a set of capabilities to be exposed through a session configuration
New-PSRoleCapabilityFile -Path .\Helpdesk.psrc

#Now we edit this file
ISE .\Helpdesk.psrc

#Creates a file that defines a session configuration
New-PSSessionConfigurationFile .\Helpdesk.pssc

#Now we edit this file
ISE .\Helpdesk.pssc

#Let us check the settings 
Test-PSSessionConfigurationFile .\Helpdesk.pssc

#Creates and registers a new session configuration
Register-PSSessionConfiguration -Name Helpdesk -Path .\Helpdesk.pssc

#We need to restart the WinRM Service
Restart-Service WinRM

#We establish a connection
Enter-PSSession -ComputerName dc01 -ConfigurationName Helpdesk -Credential grid\james.west

#And check the number of cmdlets and the account created for the connection
Get-Command

#Close the Session
Exit-PSSession

#(Optional) Deletes registered session configurations from the computer
Unregister-PSSessionConfiguration -Name Helpdesk
