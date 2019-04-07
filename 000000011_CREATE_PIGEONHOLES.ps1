$staffs = ./000000006_LOAD_STAFF_DATA.ps1


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


foreach ($s in $staffs) {
    $uname = Get-TrainerUsername $s
    $folder = "C:\pigeonholes\$uname"
    New-Item $folder -ItemType Directory
    $acl = Get-Acl $folder
    $acl.SetAccessRuleProtection($True, $False)
    $ace = New-Object System.Security.AccessControl.FileSystemAccessRule( "SYSTEM", "FullControl", "ContainerInherit, ObjectInherit", "None", "Allow" )
    $acl.SetAccessRule($ace)
    $ace = New-Object System.Security.AccessControl.FileSystemAccessRule( "Administrators", "FullControl", "None", "None", "Allow" )
    $acl.AddAccessRule($ace)
    $ace = New-Object System.Security.AccessControl.FileSystemAccessRule( $uname, "FullControl", "ContainerInherit, ObjectInherit", "None", "Allow" )
    $acl.AddAccessRule($ace)

    $ace = New-Object System.Security.AccessControl.FileSystemAccessRule( "students", "ListDirectory, CreateDirectories, CreateFiles", "ContainerInherit, ObjectInherit", "None", "Allow" )
    $acl.AddAccessRule($ace)
    $ace = New-Object System.Security.AccessControl.FileSystemAccessRule( "PECTrainer", "ListDirectory, CreateDirectories, CreateFiles", "ContainerInherit, ObjectInherit", "None", "Allow" )
    $acl.AddAccessRule($ace)



    Set-Acl $folder -AclObject $acl

    New-FsrmQuota -Path $folder -Size 4GB
}