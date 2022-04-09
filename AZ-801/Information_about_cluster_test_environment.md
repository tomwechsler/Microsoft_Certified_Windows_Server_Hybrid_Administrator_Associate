**Network:**  
IP range 192.168.3.0/24 (Nat Switch)  
Gateway: 192.168.3.2 (Nat Switch Gateway)  

**Domain:**  
Domain: prime.pri  
Clustername: primecluster  

**Host names and purpose:**  
| Name  | IP-Address  | Purpose  | Operating system  |
|---|---|---|---|
| dc01  | 192.168.3.10  | Domaincontroller  |  Windows Server Datacenter Core 2022 Evaluation |
|  mgm01 | 192.168.3.100  | Management System  | Windows 10 Enterprise Evaluation   |
|   |   |   |   |
| clus01 |  192.168.3.20 | clusternode  |  Windows Server Datacenter Core 2022 Evaluation |
| clus02  | 192.168.3.21 | clusternode  | Windows Server Datacenter Core 2022 Evaluation  |
| file01 | 192.168.3.22  | fileserver (iSCSI Target Server)  | Windows Server Datacenter Core 2022 Evaluation  |
|   |   |   |   |
| sitebclus01  | 192.168.3.30  | sitebclusternode  | Windows Server Datacenter Core 2022 Evaluation  |
| sitebclus02  | 192.168.3.31  | sitebclusternode  | Windows Server Datacenter Core 2022 Evaluation  |
| sitebfile01  | 192.168.3.32  | fileserver (iSCSI Target Server)  | Windows Server Datacenter Core 2022 Evaluation  |
|   |   |   |   |
| hclus01  | 192.168.3.40  | clusternode  | Windows Server Datacenter Core 2022 Evaluation  |
| hclus02  | 192.168.3.41  | clusternode  | Windows Server Datacenter Core 2022 Evaluation  |
| hclus03  | 192.168.3.42  | clusternode  | Windows Server Datacenter Core 2022 Evaluation  |
| hclus04  | 192.168.3.43  | clusternode  | Windows Server Datacenter Core 2022 Evaluation  |
