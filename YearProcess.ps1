Import-Module '.\USER.psm1'
Import-Module '.\REGEX_TEST.psm1'

function Write-Menu {
    "1. Create a Trainee's Account"
    "2. Create Trainee's Accounts in batch"
    "3. Disable a Trainee's Account"
    "4. Purge Trainee's Accounts in batch"
    "5. Exit"
}

function Read-Trainee {
    $s = @{

    }

    $valid = $False
    $val = ""
    while (!$valid) {
        $val = Read-Host "Please Input Student Class"
        if ($val -match "[a-dA-D]") {
            $valid = $True
            $s.CLASS = $val.ToUpper();
        }
        else {
            "Please input class A-D"
        }
    }

    $val = Read-Host "Please Input Student First Name"
    $s.FIRST_NAME = $val;

    $val = Read-Host "Please Input Student Last Name"
    $s.LAST_NAME = $val;


    $valid = $False
    $val = ""
    while (!$valid) {
        $val = Read-Host "Please Input Student Phone Number"
        if (Test-PhoneFormat $val) {
            $valid = $True
            $s.PHONE = $val;
        }
        else {
            "Please input vaild Phone Number"
        }
    }

    
    $valid = $False
    $val = ""
    while (!$valid) {
        $val = Read-Host "Please Input Student Email"
        if (Test-EmailFormat $val) {
            $valid = $True
            $s.EMAIL = $val;
        }
        else {
            "Please input vaild Email"
        }
    }

    
    
    $valid = $False
    $val = ""
    while (!$valid) {
        $val = Read-Host "Please Input Student TID"
        if (![string]::IsNullOrWhiteSpace($val)) {
            $valid = $True
            $s.TID = $val;
        }
        else {
            "Please input Non Empty TID"
        }
    }

    $valid = $False
    $val = ""
    while (!$valid) {
        $ss = (Read-Host "Please Input Student Password" -AsSecureString);
        $val = [Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR($ss))
        $val = "$val"
        if (![string]::IsNullOrWhiteSpace($val) -and (Test-PasswordLength $val) -and (Test-PasswordDigit $val) -and (Test-PasswordSymbol $val)) {
            $valid = $True
            $s.PASSWORD = $val; 
        }
        else {
            "Please input a complex password"
        }
    }

    New-Student $s
    Set-StudentHomeProfile $s
}


function Invoke-Command {
    Param([string]$option)
    Switch ($option) {
        "1" {
            try {
                Read-Trainee
                "Trainee Created"
            }
            catch {
                "Trainee Creation Failed"
            }
        }
        "2" {
            $valid = $False
            $val = ""
            while (!$valid) {
                $val = Read-Host "Please Input File Path"
                if (![string]::IsNullOrWhiteSpace($val)) {
                    $valid = $True
                    try {
                        New-BatchStudent $val $True
                        
                        "Trainee Creation Success"
                    }
                    catch {
                        "Trainee Creation Failed"
                    }
                }
                else {
                    "Please input valid file path"
                }
            }
        }
        "3" {
            $val = Read-Host "Please Input Username"
            try {
                Set-ADUser $val -Enabled $False
            }
            catch {
                "User Not Exist"
            }
        }
        "4" {
            $users = Get-ADGroupMember students -Recursive | Where-Object objectClass -eq 'user'
            $confirm = Read-Host "Are you sure to remove all the student? (Y/N)"
            if ($confirm -eq "Y") {
                $users | ForEach-Object { Remove-Item "C:\private\$($_.Name)" -Recurse }
                $users | Remove-ADUser -Confirm:$False
            }
        }
        "5"{

        }
        default {
            "Invalid Option."
        }
    }
}

$n = 0
do {
    Write-Menu
    $n = Read-Host "Option"
    Invoke-Command $n
    ""
} until ($n -eq 5)

