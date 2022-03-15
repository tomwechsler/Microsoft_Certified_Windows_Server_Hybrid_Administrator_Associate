Set-Location C:\
Clear-Host

#PowerShell Direct (on a Hyper-V host)
Enter-PSSession -VMName 'srv01' -Credential (Get-Credential)

Invoke-Command -VMName 'srv01' -ScriptBlock { Get-Service -Name 'WinRM' }

$s = New-PSSession -VMName 'srv01'-Credential (Get-Credential)

Copy-Item -ToSession $s -Path 'C:\scripts\add-user.ps1' -Destination 'C:\scripts\'

#PowerShell Remoting
Invoke-Command -VMName 'srv01' -ScriptBlock { Enable-PSRemoting -SkipNetworkProfileCheck -Force } #via PowerShell Direct enable PowerSell remoting if necessary (e.g. Windows 10/11)

Enter-PSSession -ComputerName 'srv01' -Credential (Get-Credential)

Invoke-Command -ComputerName 'srv01' -ScriptBlock { Get-Service -Name 'WinRM' }
