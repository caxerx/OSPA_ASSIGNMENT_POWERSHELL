Import-Module '.\STAFF.psm1'
Import-Module '.\USER.psm1'

$staff = Get-StaffList 'StaffList.txt'
$staff | ForEach-Object {
    Set-StaffPigeonholes (Get-TrainerUsername $_)
}