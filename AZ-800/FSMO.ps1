#Manage FSMO roles

#Discover FSMO role holders
netdom /query fsmo

#Determine the operation master roles
Get-ADDomain | Select-Object InfrastructureMaster, PDCEmulator, RIDMaster | Format-List

#Determine the operation master roles
Get-ADForest | Select-Object DomainNamingMaster, SchemaMaster | Format-List

#Move or seize a FSMO role
<#
PDCEmulator or 0
RIDMaster or 1
InfrastructureMaster or 2
SchemaMaster or 3
DomainNamingMaster or 4
#>

#If you use -force, make sure that the old role holder no longer comes online.
Move-ADDirectoryServerOperationMasterRole -Identity "dc01" -OperationMasterRole 0, 1, 2, 3, 4 -Confirm:$false -Force