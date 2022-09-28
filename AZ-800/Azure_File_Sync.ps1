#https://learn.microsoft.com/en-us/azure/storage/file-sync/file-sync-deployment-guide

#Disable the Internet Explorer Enhanced Security Configuration
$installType = (Get-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\").InstallationType

# This step is not required for Server Core
if ($installType -ne "Server Core") {
    # Disable Internet Explorer Enhanced Security Configuration 
    # for Administrators
    Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Active Setup\Installed Components\{A509B1A7-37EF-4b3f-8CFC-4F3A74704073}" -Name "IsInstalled" -Value 0 -Force

    # Disable Internet Explorer Enhanced Security Configuration 
    # for Users
    Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Active Setup\Installed Components\{A509B1A8-37EF-4b3f-8CFC-4F3A74704073}" -Name "IsInstalled" -Value 0 -Force

    # Force Internet Explorer closed, if open. This is required to fully apply the setting.
    # Save any work you have open in the IE browser. This will not affect other browsers,
    # including Microsoft Edge.
    Stop-Process -Name iexplore -ErrorAction SilentlyContinue
}

#We need the Az module
Install-Module -Name Az -AllowClobber -Force -Verbose

#Or at least
Install-Module -Name Az.StorageSync -AllowClobber -Force -Verbose

#The cmdlets
Get-Command -Module Az.StorageSync

#Compatibility Check
Invoke-AzStorageSyncCompatibilityCheck -Path C:\Temp
