.\_ENVIRONMENT.ps1
#Add new Organizational Unit for TrainerComputer and add to Group
New-ADOrganizationalUnit -Name "TrainerComputer" -Path "DC=IT2A023,DC=HK" -ProtectedFromAccidentalDeletion $False
New-ADGroup TrainerComputerGroup -GroupScope Global -GroupCategory Security -Path "OU=TrainerComputer,DC=IT2A023,DC=HK"

#Generation Configuration
[string[]] $room = "a", "b", "c", "d"
$computerStart = 1
$computerEnd = 20

#Create Trainer Computer
foreach ($r in $room) {
    New-ADComputer -Name "pec00$r" -Path "OU=TrainerComputer,DC=IT2A023,DC=HK" -Enabled $True
    Add-ADGroupMember -Identity "CN=TrainerComputerGroup,OU=TrainerComputer,DC=IT2A023,DC=HK" -Members "CN=pec00$r,OU=TrainerComputer,$ENV:DOMAIN"
}


#Create Student Computer
foreach ($r in $room) {
    foreach ($computer in $computerStart..$computerEnd) {
        $computerString = $computer.ToString("00")
        New-ADComputer -Name "pec$computerString$r" -Enabled $True
    }
}



#Create student and trainer group
New-ADGroup -Name "students" -GroupCategory Security -GroupScope DomainLocal
New-ADGroup -Name "PECServer" -GroupCategory Security -DomainLocal DomainLocal

#Create class group
[string[]] $classes = "A", "B", "C", "D"
foreach($class in $classes){
    $class = $class.CLASS
    New-ADGroup -Name "class_$class" -GroupCategory Security -GroupScope DomainLocal
    Add-ADGroupMember -Identity students -Members "class_$class"
}


#Create User Profile Folder
New-Item C:\UserProfiles -ItemType Directory
$acl = Get-Acl C:\UserProfiles
$acl.SetAccessRuleProtection($True, $False)
$ace = New-Object System.Security.AccessControl.FileSystemAccessRule( "SYSTEM", "FullControl", "ContainerInherit, ObjectInherit", "None", "Allow" )
$acl.SetAccessRule($ace)
$ace = New-Object System.Security.AccessControl.FileSystemAccessRule( "Administrators", "FullControl", "None", "None", "Allow" )
$acl.AddAccessRule($ace)
$ace = New-Object System.Security.AccessControl.FileSystemAccessRule( "CREATOR OWNER", "FullControl", "ContainerInherit, ObjectInherit", "None", "Allow" )
$acl.AddAccessRule($ace)
$ace = New-Object System.Security.AccessControl.FileSystemAccessRule( "students", "ReadData, AppendData", "None", "None", "Allow" )
$acl.AddAccessRule($ace)
$ace = New-Object System.Security.AccessControl.FileSystemAccessRule( "PECTrainer", "ReadData, AppendData", "None", "None", "Allow" )
$acl.AddAccessRule($ace)
Set-Acl C:\UserProfiles -AclObject $acl
New-SmbShare -Name Profiles$ -Path C:\UserProfiles -FullAccess "Authenticated Users"

#Create Home Folder
$homeFolder = "C:\private"
New-Item $homeFolder -ItemType Directory

$acl = Get-Acl $homeFolder
$acl.SetAccessRuleProtection($True, $False)
$ace = New-Object System.Security.AccessControl.FileSystemAccessRule( "SYSTEM", "FullControl", "ContainerInherit, ObjectInherit", "None", "Allow" )
$acl.SetAccessRule($ace)
$ace = New-Object System.Security.AccessControl.FileSystemAccessRule( "Administrators", "FullControl", "None", "None", "Allow" )
$acl.AddAccessRule($ace)
$ace = New-Object System.Security.AccessControl.FileSystemAccessRule( "CREATOR OWNER", "FullControl", "ContainerInherit, ObjectInherit", "None", "Allow" )
$acl.AddAccessRule($ace)
$ace = New-Object System.Security.AccessControl.FileSystemAccessRule( "students", "ReadData", "None", "None", "Allow" )
$acl.AddAccessRule($ace)
$ace = New-Object System.Security.AccessControl.FileSystemAccessRule( "PECTrainer", "ReadData", "None", "None", "Allow" )
$acl.AddAccessRule($ace)


Set-Acl $homeFolder -AclObject $acl

New-SmbShare private$ -Path $homeFolder -FullAccess "Authenticated Users"

#Create pigeonholes folder

$homeFolder = "C:\pigeonholes"
New-Item $homeFolder -ItemType Directory

$acl = Get-Acl $homeFolder
$acl.SetAccessRuleProtection($True, $False)
$ace = New-Object System.Security.AccessControl.FileSystemAccessRule( "SYSTEM", "FullControl", "ContainerInherit, ObjectInherit", "None", "Allow" )
$acl.SetAccessRule($ace)
$ace = New-Object System.Security.AccessControl.FileSystemAccessRule( "Administrators", "FullControl", "None", "None", "Allow" )
$acl.AddAccessRule($ace)
$ace = New-Object System.Security.AccessControl.FileSystemAccessRule( "CREATOR OWNER", "FullControl", "ContainerInherit, ObjectInherit", "None", "Allow" )
$acl.AddAccessRule($ace)
$ace = New-Object System.Security.AccessControl.FileSystemAccessRule( "students", "ReadData", "None", "None", "Allow" )
$acl.AddAccessRule($ace)
$ace = New-Object System.Security.AccessControl.FileSystemAccessRule( "PECTrainer", "ReadData", "None", "None", "Allow" )
$acl.AddAccessRule($ace)

Set-Acl $homeFolder -AclObject $acl

New-SmbShare pigeonholes -Path $homeFolder -FullAccess "Authenticated Users"
