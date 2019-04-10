Import-Module '.\STAFF.psm1'
Import-Module '.\USER.psm1'
$staffs = Get-StaffList "StaffList.txt"
foreach ($s in $staffs) {
    $uname = Get-TrainerUsername $s
    $pw = Get-TrainerPassword $s
    
    New-Staff $uname $s.FULL_NAME $pw
}