
Import-Module '.\REGEX_TEST.psm1'
function New-Student {
    Param ([object]$stu)
    #Check Account Availablity
    $enabled = 1
    if (!(Test-PhoneFormat $stu.PHONE)) {
        "Student " + $stu.FIRSTNAME + " " + $stu.LASTNAME + " (" + $stu.TID + ") inputted a error phone number (" + $stu.PHONE + ")" >> .\ERR_TraineePhone.txt
        $enabled = 0
    }
    if (!(Test-EmailFormat $stu.EMAIL)) {
        "Student " + $stu.FIRSTNAME + " " + $stu.LASTNAME + " (" + $stu.TID + ") inputted a error Email (" + $stu.EMAIL + ")" >> .\ERR_TraineeEmail.txt
        $enabled = 0
    }

    if (!(Test-PasswordLength $stu.PASSWORD)) {
        "Student " + $stu.FIRSTNAME + " " + $stu.LASTNAME + " (" + $stu.TID + ") inputted a password that's not match the length requirement" >> .\ERR_TraineePassword.txt
        $enabled = 0
    }
    if (!(Test-PasswordDigit $stu.PASSWORD)) {
        "Student " + $stu.FIRSTNAME + " " + $stu.LASTNAME + " (" + $stu.TID + ") inputted a password that's not contains a digit" >> .\ERR_TraineePassword.txt
        $enabled = 0
    }
    if (!(Test-PasswordSymbol $stu.PASSWORD)) {
        "Student " + $stu.FIRSTNAME + " " + $stu.LASTNAME + " (" + $stu.TID + ") inputted a password that's not contains a special symbol" >> .\ERR_TraineePassword.txt
        $enabled = 0
    }

    #Create User
    New-ADUser -Name $stu.TID  -GivenName $stu.FIRSTNAME -Surname $stu.LASTNAME -EmailAddress $stu.EMAIL -OfficePhone $stu.PHONE -AccountPassword (ConvertTo-SecureString ($stu.PASSWORD) -AsPlainText -Force) -Enabled $enabled -Description "Student" -ProfilePath "%LogonServer%\Profiles$\%username%"

    #Add User to Group
    $stuClass = $stu.CLASS
    Add-ADGroupMember -Identity "class_$stuClass" -Members $stu.TID
}


function Set-StudentHomeProfile {
    Param ([object]$stu)
    Set-ADUser $stu.TID -HomeDirectory "\\PECServer\private$\$($stu.TID)" -HomeDrive "X:"

    #Create Home Folder
    $folder = "C:\private\$($stu.TID)"
    New-Item $folder -ItemType Directory

    #Set Home Folder Permission
    $acl = Get-Acl $folder
    $acl.SetAccessRuleProtection($True, $False)
    $ace = New-Object System.Security.AccessControl.FileSystemAccessRule( "SYSTEM", "FullControl", "ContainerInherit, ObjectInherit", "None", "Allow" )
    $acl.SetAccessRule($ace)
    $ace = New-Object System.Security.AccessControl.FileSystemAccessRule( "Administrators", "FullControl", "None", "None", "Allow" )
    $acl.AddAccessRule($ace)

    $ace = New-Object System.Security.AccessControl.FileSystemAccessRule( $stu.TID, "FullControl", "ContainerInherit, ObjectInherit", "None", "Allow" )
    $acl.AddAccessRule($ace)

    Set-Acl $folder -AclObject $acl

    #Set Quota
    New-FsrmQuota -Path $folder -Size 2GB
}

function New-BatchStudent {
    Param([string]$path, [bool] $configHome)
    $students = Import-Csv -Path $path

    "File created on " + (Get-Date) > .\ERR_TraineePhone.txt
    "File created on " + (Get-Date) > .\ERR_TraineeEmail.txt
    "File created on " + (Get-Date) > .\ERR_TraineePassword.txt

    foreach ($stu in $students) {
        New-Student $stu
        if ($configHome) {
            Set-StudentHomeProfile $stu
        }
    }
}

function New-Staff {
    Param ([string]$uname, [string]$fullName, [string]$pw)
    #Add User
    New-ADUser -Name $uname -GivenName $fullName -AccountPassword (ConvertTo-SecureString $pw -AsPlainText -Force) -Enabled $True -Description "Trainer" -ProfilePath "%LogonServer%\Profiles$\%username%" -HomeDirectory "\\PECServer\private$\$uname" -HomeDrive "X:"

    #Add User to group
    Add-ADGroupMember -Identity "PECTrainer" -Members $uname
}


function Set-StaffHomeProfile {
    Param ([string]$uname)
    
    #Create home folder
    $folder = "C:\private\$uname"
    New-Item $folder -ItemType Directory

    #Set home folder permission
    $acl = Get-Acl $folder
    $acl.SetAccessRuleProtection($True, $False)
    $ace = New-Object System.Security.AccessControl.FileSystemAccessRule( "SYSTEM", "FullControl", "ContainerInherit, ObjectInherit", "None", "Allow" )
    $acl.SetAccessRule($ace)
    $ace = New-Object System.Security.AccessControl.FileSystemAccessRule( "Administrators", "FullControl", "None", "None", "Allow" )
    $acl.AddAccessRule($ace)

    $ace = New-Object System.Security.AccessControl.FileSystemAccessRule( $uname, "FullControl", "ContainerInherit, ObjectInherit", "None", "Allow" )
    $acl.AddAccessRule($ace)

    Set-Acl $folder -AclObject $acl

    #Set home folder quota
    New-FsrmQuota -Path $folder -Size 2GB
}

function Set-StaffPigeonholes {
    Param ([string]$uname)
    #Create pigeonholes
    $folder = "C:\pigeonholes\$uname"
    New-Item $folder -ItemType Directory

    #Set pigeonholes permission
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

    #Folder for pigeonholes
    New-FsrmQuota -Path $folder -Size 4GB
}

Export-ModuleMember -Function New-Student
Export-ModuleMember -Function New-Staff
Export-ModuleMember -Function New-BatchStudent
Export-ModuleMember -Function Set-StudentHomeProfile 
Export-ModuleMember -Function Set-StaffHomeProfile
Export-ModuleMember -Function Set-StaffPigeonholes