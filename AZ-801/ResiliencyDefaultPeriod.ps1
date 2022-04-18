Enter-PSSession -ComputerName clus01

Get-Cluster -Name primecluster | fl *

#Value in seconds
(Get-Cluster).ResiliencyDefaultPeriod = 120