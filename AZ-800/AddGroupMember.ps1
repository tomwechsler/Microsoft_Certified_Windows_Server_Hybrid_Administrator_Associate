#Create new group
New-ADGroup -Name "Marketing" -GroupScope DomainLocal
New-ADGroup -Name "Logistik" -GroupScope Global

#By default, a security group is created "GroupCategory: Security"
Get-ADGroup "Marketing"

#Create a new group with more information
New-ADGroup -Name 'Technik' `
-Description 'Sicherheitsgruppe fuer alle Technik Benutzer' `
-DisplayName 'Technik' `
-GroupCategory Security `
-GroupScope Global `
-SAMAccountName 'Technik' `
-PassThru

#Add user to group
Add-ADGroupMember -Identity Technik -Members frabets, janschm -PassThru

#Did it work? (As far as OK, but I had to "search" for the account itself)
Get-ADGroupMember -Identity Technik 

#This works even better
New-ADGroup -Name 'Manager' `
-Description 'Sicherheitsgruppe fuer alle Manager' `
-DisplayName 'Manager' `
-GroupCategory Security `
-GroupScope Global `
-SAMAccountName 'Manager' `
-PassThru

#We create a variable
$ManagerArray = (Get-ADUser -Filter {Title -like "*Manager*" } `
-Properties Title).SAMAccountName

#Is the variable OK?
$ManagerArray

#Now I add the content of the variable to the group
Add-ADGroupMember -Identity "Manager" -Members $ManagerArray -PassThru

#Did it work?
Get-ADGroupMember -Identity Manager `
| Get-ADUser -Properties Title `
| Format-Table -AutoSize SAMAccountName,Name,Title
