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