#Using Windows PowerShell to administer firewall settings

#Create a firewall rule to allow use of the application that uses the application.exe executable
New-NetFirewallRule -DisplayName “Allow Inbound Application” -Direction Inbound -Program %SystemRoot%\System32\application.exe -RemoteAddress LocalSubnet -Action Allow

#To modify an existing rule
Set-NetFirewallRule –DisplayName “Allow Web 80” -RemoteAddress 192.168.0.2

#To delete an existing rule
Remove-NetFirewallRule –DisplayName “Allow Web 80”
