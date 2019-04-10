#Remove Old Version Cache
Import-Module '.\000000003_REGEX_FUNCTIONS.psm1'
Remove-Module '000000003_REGEX_FUNCTIONS'

#Import REGEX Module
Import-Module '.\000000003_REGEX_FUNCTIONS.psm1'

#Import student from csv
$students = Import-Csv -Path Enrollment19.csv

"File created on " + (Get-Date) > .\ERR_TraineePhone.txt
"File created on " + (Get-Date) > .\ERR_TraineeEmail.txt
"File created on " + (Get-Date) > .\ERR_TraineePassword.txt

foreach ($stu in $students) {
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

    New-ADUser -Name $stu.TID  -GivenName "$($stu.FIRSTNAME) $($stu.LASTNAME)" -AccountPassword (ConvertTo-SecureString ($stu.PASSWORD) -AsPlainText -Force) -Enabled $enabled -Description "Student" -ProfilePath "%LogonServer%\Profiles$\%username%"

    $stuClass = $stu.CLASS
    Add-ADGroupMember -Identity "class_$stuClass" -Members $stu.TID
}