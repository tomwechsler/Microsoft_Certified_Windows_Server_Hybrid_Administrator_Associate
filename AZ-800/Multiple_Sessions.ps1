Set-Location c:\
Clear-Host

#Simple connection
Enter-PSSession -ComputerName dc01

#Exit the session
Exit-PSSession

#Multiple machines
$dcs = "dc01","dc02"

#Let's run
Invoke-Command -ComputerName $dcs -ScriptBlock {$env:computername}

#Create a variable
$sess = New-PSSession -ComputerName $dcs

#Whats in the variable
$sess

#Run the command
Invoke-Command -Session $sess -ScriptBlock {$env:computername}

#Remove the sessions
Get-PSSession | Remove-PSSession 

#Define Remote Computers
$computers = "dc01","dc02","fs01"

#Create Multiple Remote Sessions
New-PSSession -ComputerName $computers

#Let's check
Get-PSSession

#Run the command
Invoke-Command -ComputerName $computers -ScriptBlock {$env:computername}

#Remove the sessions
Get-PSSession | Remove-PSSession

#Create Multiple Remote Sessions into Variables
$dc01, $dc02 = New-PSSession -ComputerName "dc01","dc02"

#Let's check
Get-PSSession

#Run the command
Invoke-Command -Session $dc02 -ScriptBlock {$env:computername}

#Remove a session
Remove-PSSession -Id <Session ID>