$staffs = ./000000006_LOAD_STAFF_DATA.ps1

foreach ($s in $staffs) {
    $uname = Get-TrainerUsername $s
    $pw = Get-TrainerPassword $s
    
    New-ADUser -Name $uname -DisplayName $s.Full_Name -AccountPassword (ConvertTo-SecureString $pw -AsPlainText -Force) -Enabled $True -Description "Trainer" -Path "OU=Trainer,DC=IT2A023,DC=HK" -ProfilePath "%LogonServer%\Profiles$\%username%"
    Add-ADGroupMember -Identity "CN=PECTrainer,OU=Trainer,DC=IT2A023,DC=HK" -Members "CN=$uname,OU=Trainer,DC=IT2A023,DC=HK"
}

