function Test-EmailFormat {
    Param ([string]$em)
    $match = $em -match "^([\w+-]+\.)*[\w+-]+@([\w+-]+\.)*[\w+-]+\.[a-zA-Z]{2,4}$"
    Write-Output $match
}

function Test-PasswordLength {
    Param ([string]$pw)
    $match = $pw -match ".{8,}"
    Write-Output $match
}

function Test-PasswordDigit {
    Param ([string]$pw)
    $match = $pw -match "\d"
    Write-Output $match
}

function Test-PasswordSymbol {
    Param ([string]$pw)
    $match = $pw -match "[~!@#$%^&*()\\\-=+<>\?]"
    Write-Output $match
}


function Test-PhoneFormat {
    Param ([string]$phone)
    $match = $phone -match "^\d{8}$"
    Write-Output $match
}

Export-ModuleMember -Function Test-EmailFormat
Export-ModuleMember -Function Test-PhoneFormat
Export-ModuleMember -Function Test-PasswordLength
Export-ModuleMember -Function Test-PasswordDigit
Export-ModuleMember -Function Test-PasswordSymbol