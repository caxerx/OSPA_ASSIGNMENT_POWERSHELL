#Remove Old Version Cache
Import-Module '.\000000007_STAFF_FUNCTIONS.psm1'
Remove-Module '000000007_STAFF_FUNCTIONS'

#Import Module
Import-Module '.\000000007_STAFF_FUNCTIONS.psm1'

#Load content from staff list
$staffContent = ((Get-Content StaffList.txt) -Split [Environment]::NewLine)

#Create a staff list
$staffs = New-Object Collections.ArrayList

#Create a staff object
$staff = @{
}

#Iterate over the staff list
foreach ($i in $staffContent) {
    #Goto next object when a line seperator
    if ($i -eq "") {
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

Write-Output $staffs