
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
    $pw += $staffNames[0].SubString(1)
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

    $hkidNumber = [convert]::ToInt32($hkidCheckDigit)
    if ($hkidCheckDigit % 2 -eq 0) {
        Write-Output "#"
        return
    }
    Write-Output "!"
}

Export-ModuleMember -Function Get-TrainerUsername
Export-ModuleMember -Function Get-TrainerPassword
Export-ModuleMember -Function Get-PasswordSymbol