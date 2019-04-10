$staffs = ./000000006_LOAD_STAFF_DATA.ps1

foreach ($s in $staffs) {
    $uname = Get-TrainerUsername $s
    $pw = Get-TrainerPassword $s
    
    New-ADUser -Name $uname -DisplayName $s.Full_Name -AccountPassword (ConvertTo-SecureString $pw -AsPlainText -Force) -Enabled $True -Description "Trainer" -ProfilePath "%LogonServer%\Profiles$\%username%" -ScriptPath "MOUNT_PIGEONHOLES.bat"
    Add-ADGroupMember -Identity PECTrainer -Members $uname
}