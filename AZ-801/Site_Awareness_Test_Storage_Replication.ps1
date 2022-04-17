Enter-PSSession -ComputerName clus01

#Example: New-ClusterFaultDomain -Type Rack -Name "Rack1" -FaultDomain "Site001"

New-ClusterFaultDomain -Name SiteA -FaultDomainType Site -Description "SiteA" -Location "ZRH"
New-ClusterFaultDomain -Name SiteA -FaultDomainType Site -Description "SiteB" -Location "BSL"
Set-ClusterFaultDomain -Name clus01 -Parent "SiteA"
Set-ClusterFaultDomain -Name clus02 -Parent "SiteA"
Set-ClusterFaultDomain -Name sitebclus01 -Parent "SiteB"
Set-ClusterFaultDomain -Name sitebclus02 -Parent "SiteB"

Get-ClusterFaultDomain

(Get-Cluster).PreferredSite="SiteA"

#On clus01
Test-SRTopology -SourceComputerName clus01 `
-SourceVolumeName C:\ClusterStorage\Volume1 `
-SourceLogVolumeName L: `
-DestinationComputerName sitebclus01 `
-DestinationVolumeName M: `
-DestinationLogVolumeName N: `
-DurationInMinutes 1 `
-IgnorePerfTests -ResultPath C:\
