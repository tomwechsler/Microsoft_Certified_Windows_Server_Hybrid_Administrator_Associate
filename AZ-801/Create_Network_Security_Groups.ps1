Set-Location C:\
Clear-Host

#We need the module
Install-Module -Name Az -Force -AllowClobber -Verbose

#Log into Azure
Connect-AzAccount

#Select the correct subscription
Get-AzSubscription
Get-AzSubscription -SubscriptionName "MSDN Platforms" | Select-AzSubscription

$RGname = "az-801-rg"
$port = "8081"
$rulename = "allowAppPort$port"
$nsgname = "az-801-vnet-security"
$location = "westeurope"

New-AzNetworkSecurityGroup -Name $nsgname -ResourceGroupName $RGname -Location $location

#Get the NSG resource
$nsg = Get-AzNetworkSecurityGroup -Name $nsgname -ResourceGroupName $RGname

#Add the inbound security rule.
$nsg | Add-AzNetworkSecurityRuleConfig -Name $rulename -Description "Allow app port" -Access Allow `
    -Protocol * -Direction Inbound -Priority 3891 -SourceAddressPrefix "*" -SourcePortRange * `
    -DestinationAddressPrefix * -DestinationPortRange $port

#Update the NSG.
$nsg | Set-AzNetworkSecurityGroup

#Another way to create a detailed network security group
$rule1 = New-AzNetworkSecurityRuleConfig -Name rdp-rule -Description "Allow RDP" `
    -Access Allow -Protocol Tcp -Direction Inbound -Priority 100 -SourceAddressPrefix `
    Internet -SourcePortRange * -DestinationAddressPrefix * -DestinationPortRange 3389

$rule2 = New-AzNetworkSecurityRuleConfig -Name web-rule -Description "Allow HTTP" `
    -Access Allow -Protocol Tcp -Direction Inbound -Priority 101 -SourceAddressPrefix `
    Internet -SourcePortRange * -DestinationAddressPrefix * -DestinationPortRange 80

$nsg = New-AzNetworkSecurityGroup -ResourceGroupName "TestRG" -Location "westeurope" -Name `
    "NSG-FrontEnd" -SecurityRules $rule1,$rule2
