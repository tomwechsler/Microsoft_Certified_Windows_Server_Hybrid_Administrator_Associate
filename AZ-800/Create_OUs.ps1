#Create a new OU
New-ADOrganizationalUnit -Name "Technik"

#Short check
Get-ADOrganizationalUnit -Filter *

#Two new OU's
New-ADOrganizationalUnit -Name "Bern"

New-ADOrganizationalUnit -Path "OU=Bern,DC=corp,DC=int" -Name "Technik"

#Now there is a problem where is the OU Technik?
Get-ADOrganizationalUnit Technik

#What does the help say?
help get-ADOrganizationalUnit 
help Get-ADOrganizationalUnit -Parameter identity

#Identify the OUs
Get-ADOrganizationalUnit -Identity "OU=Technik,OU=Bern,DC=corp,DC=int"
Get-ADOrganizationalUnit -Identity "OU=Technik,DC=corp,DC=int"

#Error, correctly I have to specify the path
Remove-ADOrganizationalUnit "Technik" 

#Access is denied, but I am logged in as admin
Remove-ADOrganizationalUnit "OU=Technik,DC=corp,DC=int" 

#With which account am I logged in?
whoami

#Let's take a close look at the OU
get-ADOrganizationalUnit "OU=Technik,DC=corp,DC=int" -Properties *

#We set the value to False
Set-ADOrganizationalUnit -ProtectedFromAccidentalDeletion $false -Identity "OU=Technik,DC=corp,DC=int"

#Now we can delete the OU
Remove-ADOrganizationalUnit "OU=Technik,DC=corp,DC=int"

#Did it work?
Get-ADOrganizationalUnit -Identity "OU=Technik,DC=corp,DC=int"