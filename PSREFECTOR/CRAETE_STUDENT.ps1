.\_ENVIRONMENT.ps1
#Import REGEX Module
Import-Module '.\USER.psm1'

#Import student from csv
$students = Import-Csv -Path Enrollment19.csv

"File created on " + (Get-Date) > .\ERR_TraineePhone.txt
"File created on " + (Get-Date) > .\ERR_TraineeEmail.txt
"File created on " + (Get-Date) > .\ERR_TraineePassword.txt

foreach ($stu in $students) {
    New-Student $stu
}