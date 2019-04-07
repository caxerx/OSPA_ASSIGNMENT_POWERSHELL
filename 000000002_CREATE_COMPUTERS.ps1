New-ADOrganizationalUnit -Name "TrainerComputer" -Path "DC=IT2A023,DC=HK" -ProtectedFromAccidentalDeletion $False
New-ADGroup TrainerComputerGroup -GroupScope Global -GroupCategory Security -Path "OU=TrainerComputer,DC=IT2A023,DC=HK"
#Configuration
[string[]] $room = "a", "b", "c", "d"
$computerStart = 1
$computerEnd = 20

#Create Classes
foreach ($r in $room) {
    New-ADComputer -Name "pec00$r" -Path "OU=TrainerComputer,DC=IT2A023,DC=HK" -Enabled $True
    Add-ADGroupMember -Identity "CN=TrainerComputerGroup,OU=TrainerComputer,DC=IT2A023,DC=HK" -Members "CN=pec00$r,OU=TrainerComputer,DC=IT2A023,DC=HK"
    foreach ($computer in $computerStart..$computerEnd) {
        $computerString = $computer.ToString("00")
        New-ADComputer -Name "pec$computerString$r" -Enabled $True
    }
}


