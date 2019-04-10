Import-Module '.\STAFF.psm1'
Import-Module '.\USER.psm1'

$students = Import-Csv -Path 'Enrollment19.csv'
$students | ForEach-Object {
    Set-StudentHomeProfile $_
}

$staff = Get-StaffList 'StaffList.txt'
$staff | ForEach-Object {
    Set-StaffHomeProfile (Get-TrainerUsername $_)
}