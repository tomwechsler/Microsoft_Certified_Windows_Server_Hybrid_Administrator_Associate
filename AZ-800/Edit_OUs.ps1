#The AD has no command for OUs to move content
Get-Command *org*

#We have to help ourselves with the cmdlet get-adobject. What does the help give us?
help Get-ADObject

#Let's search for accounts
Get-ADObject -SearchBase "OU=NewUsers,DC=corp,DC=int" -Filter *

#By department
Get-ADUser -Filter "department -eq 'Technik'"

#By department and city
Get-ADUser -Filter "department -eq 'Technik' -and city -eq 'Luzern'"

#Listed a bit better
Get-ADUser -Filter "department -eq 'Technik' -and city -eq 'Luzern'" -Properties department, city | Select-Object name, city, department

#Now we move these two accounts
Get-ADUser -Filter "department -eq 'Technik' -and city -eq 'Luzern'" -Properties department, city | Move-ADObject -TargetPath "OU=Technik,OU=Luzern,DC=corp,DC=int"

#Did it work?
Get-ADObject -SearchBase "OU=Technik,OU=Luzern,DC=corp,DC=int" -Filter *