Enter-PSSession clus01

(Get-Cluster).AutoBalancerLevel

#To set a value
(Get-Cluster).AutoBalancerLevel = 1

#1=Low      (Default)	Move when host is more than 80% loaded
#2=Medium   Move when host is more than 70% loaded
#3=High 	Average nodes and move when host is more than 5% above average 
