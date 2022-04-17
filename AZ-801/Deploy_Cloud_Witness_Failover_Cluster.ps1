Set-Location c:\
Clear-Host

#Is the module present? If no...
Get-InstalledModule -Name "Az"

#We need the cmdlets
Install-Module -Name Az -Force -AllowClobber -Verbose

#Prefix for resources
$prefix = "tw"

#Basic variables
$location = "westeurope"
$id = Get-Random -Minimum 1000 -Maximum 9999
$storageaccountname = "$($prefix)sa$id"
$resourceGroup = "$prefix-rg-$id"

#Log into Azure
Connect-AzAccount

#Select the correct subscription
Get-AzSubscription -SubscriptionName "Microsoft Azure Sponsorship" | Select-AzSubscription

#Create a new resource group
New-AzResourceGroup -Name $resourceGroup -Location $location

#Supported regions for your subscription
Get-AzLocation | select Location

#Create a general-purpose v2 storage account
New-AzStorageAccount -ResourceGroupName $resourceGroup `
  -Name $storageaccountname `
  -Location $location `
  -SkuName Standard_LRS `
  -Kind StorageV2

#This command gets a specific key for a Storage account.
(Get-AzStorageAccountKey -ResourceGroupName $resourceGroup -AccountName $storageaccountname)| Where-Object {$_.KeyName -eq "key1"}

#Configuring Cloud Witness using PowerShell
Set-ClusterQuorum -CloudWitness -AccountName <StorageAccountName> -AccessKey <StorageAccountAccessKey>