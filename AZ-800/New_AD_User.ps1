#Create AD users and groups

#Create AD users in bulk

#Enter a path to your import CSV file
Import-Module ActiveDirectory
$ADUsers = Import-csv C:\scripts\newusers.csv

foreach ($User in $ADUsers) {

  $Username = $User.username
  $Password = $User.password
  $Firstname = $User.firstname
  $Lastname = $User.lastname
  $Department = $User.department
  $OU = $User.ou

  #Check if the user account already exists in AD
  if (Get-ADUser -F { SamAccountName -eq $Username }) {
    #If user does exist, output a warning message
    Write-Warning "A user account $Username has already exist in Active Directory."
  }
  else {
    #If a user does not exist then create a new user account

    #Account will be created in the OU listed in the $OU variable in the CSV file; don’t forget to change the domain name in the "-UserPrincipalName" variable
    New-ADUser `
      -SamAccountName $Username `
      -UserPrincipalName "$Username@prime.pri" `
      -Name "$Firstname $Lastname" `
      -GivenName $Firstname `
      -Surname $Lastname `
      -Enabled $True `
      -ChangePasswordAtLogon $True `
      -DisplayName "$Lastname, $Firstname" `
      -Department $Department `
      -Path $OU `
      -AccountPassword (ConvertTo-SecureString $Password -AsPlainText -Force)

  }
}

#Bulk add users to group
Import-Module ActiveDirectory

$dcname = 'dc01' #add you DC name here

Import-Csv "C:\Scripts\orgusers.csv" |
ForEach-Object {
  $prop = @{
    name              = $_.name
    path              = $_.parentou
    SamAccountName    = $_.samaccountname
    UserPrincipalName = $_."samAccountName" + "@prime.pri"
    AccountPassword   = (ConvertTo-SecureString "Pa$$w0rd" -AsPlainText -Force)
    Enabled           = $true
    Server            = $dcname

  }
  New-ADUser @prop

  Add-ADGroupMember -Identity $_.group -Members $_.name -Server $dcname
}
