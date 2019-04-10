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
