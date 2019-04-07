$staffs = ./000000006_LOAD_STAFF_DATA.ps1

"net use Z: \\PECserver\pigeonholes\%username%" > "C:\Windows\SYSVOL\domain\scripts\MOUNT_PIGEONHOLES.bat"

foreach($s in $staffs){
    $uname = Get-TrainerUsername $s
    Set-ADUser $uname -ScriptPath "MOUNT_PIGEONHOLES.bat"
}