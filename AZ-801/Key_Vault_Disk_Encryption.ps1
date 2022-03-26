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
$location = "westeurope"

#Create a resource group
New-AzResourceGroup -Name $RGname -Location $location

#Create a key vault
New-AzKeyvault -Name ContosoADEKeyVault -ResourceGroupName $RGname -Location $location

#Set the key vault advanced access policies
Set-AzKeyVaultAccessPolicy -VaultName 'ContosoADEKVault' -ResourceGroupName $RGname -EnabledForDiskEncryption -EnabledForDeployment -EnabledForTemplateDeployment

#Encrypt a VM
$KeyVault = Get-AzKeyVault -VaultName ContosoADEKeyVault -ResourceGroupName $RGname

Set-AzVMDiskEncryptionExtension -ResourceGroupName MyResourceGroup -VMName ContosoVM1 -DiskEncryptionKeyVaultUrl $KeyVault.VaultUri -DiskEncryptionKeyVaultId $KeyVault.ResourceId

#Decrypt a disk
Disable-AzVMDiskEncryption -ResourceGroupName $RGname -VMName ContosoVM1
