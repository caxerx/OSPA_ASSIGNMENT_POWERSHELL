
function Get-TrainerUsername {
    Param ([object]$staff)
    $uname = ""
    $staffNames = ($staff.Full_Name -split " ")
    $uname += $staffNames[0].SubString(0, 1).ToLower()
    $uname += $staffNames[1].ToLower()
    Write-Output $uname
}

function Get-TrainerPassword {
    Param ([object]$staff)
    $pw = ""
    $staffNames = ($staff.Full_Name -split " ")
    $pw += $staffNames[0].SubString($staffNames[0].Length - 2, 2)
    $pw += Get-PasswordSymbol($staff.HKID)
    $pw += $staff.HKID.SubString(0, 5)
    Write-Output $pw
}

function Get-PasswordSymbol {
    Param ([string]$hkid)
    $hkidCheckDigit = $hkid.Substring(8, 1)
    if ($hkidCheckDigit -match "[a-zA-Z]") {
        Write-Output "%"
        return
    }

    if ($hkidCheckDigit % 2 -eq 0) {
        Write-Output "#"
        return
    }
    Write-Output "!"
}

function Get-StaffList {
    Param ([string]$file)
    #Load content from staff list
    $staffContent = ((Get-Content $file) -Split [Environment]::NewLine)

    #Create a staff list
    $staffs = New-Object Collections.ArrayList

    #Create a staff object
    $staff = @{
    }

    #Iterate over the staff list
    foreach ($i in $staffContent) {
        #Goto next object when a line seperator
        if ([string]::IsNullOrWhiteSpace($i)) {
            #Supress output
            $staffs.Add($staff) > $null
            $staff = @{
            }
            continue
        }

        #Set property of this staff
        $lineData = ($i -Split ":")
        $prop = $lineData[0]
        $data = $lineData[1] 
        $staff.$prop = $data
    }

    if ($staff.Count -ne 0) {
        $staffs.Add($staff) > $null
    }

    Write-Output $staffs
}

Export-ModuleMember -Function Get-TrainerUsername
Export-ModuleMember -Function Get-TrainerPassword
Export-ModuleMember -Function Get-PasswordSymbol
Export-ModuleMember -Function Get-StaffList