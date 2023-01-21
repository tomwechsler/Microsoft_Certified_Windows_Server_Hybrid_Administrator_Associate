#On the mgm01 System
#Kerberos delegation to configure Live-Migration in Kerberos mode for Windows Server 2022
Import-Module "ActiveDirectory"

#Variables
$HVHost01 = "HCLUS01"
$HVHost02 = "HCLUS02"
$HVHost03 = "HCLUS03"
$HVHost04 = "HCLUS04"

#Delegate Microsoft Virtual System Migration Service and CIFS for every other possible Live Migration host
$HCLUS01SPN = @("Microsoft Virtual System Migration Service/$HVHost01", "cifs/$HVHost01")
$HCLUS02SPN = @("Microsoft Virtual System Migration Service/$HVHost02", "cifs/$HVHost02")
$HCLUS03SPN = @("Microsoft Virtual System Migration Service/$HVHost03", "cifs/$HVHost03")
$HCLUS04SPN = @("Microsoft Virtual System Migration Service/$HVHost04", "cifs/$HVHost04")

$delegationProperty = "msDS-AllowedToDelegateTo"
$delegateToSpns = $HCLUS01SPN + $HCLUS02SPN + $HCLUS03SPN + $HCLUS04SPN

#Configure Kerberos to (Use any authentication protocol)
$HV01Account = Get-ADComputer $HVHost01
$HV01Account | Set-ADObject -Add @{$delegationProperty=$delegateToSpns}
Set-ADAccountControl $HV01Account -TrustedToAuthForDelegation $true

$HV02Account = Get-ADComputer $HVHost02
$HV02Account| Set-ADObject -Add @{$delegationProperty=$delegateToSpns}
Set-ADAccountControl $HV02Account -TrustedToAuthForDelegation $true

$HV03Account = Get-ADComputer $HVHost03
$HV03Account | Set-ADObject -Add @{$delegationProperty=$delegateToSpns}
Set-ADAccountControl $HV03Account -TrustedToAuthForDelegation $true

$HV04Account = Get-ADComputer $HVHost04
$HV04Account | Set-ADObject -Add @{$delegationProperty=$delegateToSpns}
Set-ADAccountControl $HV04Account -TrustedToAuthForDelegation $true