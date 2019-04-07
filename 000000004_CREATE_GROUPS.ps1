#Find for all class
$classes = $students | Select-Object -Property Class -Unique

New-ADGroup -Name "students" -GroupCategory Security -GroupScope DomainLocal
New-ADOrganizationalUnit -Name "Trainer" -Path "DC=IT2A023,DC=HK" -ProtectedFromAccidentalDeletion $False
New-ADGroup PECServer -DomainLocal Global -GroupCategory Security -Path "OU=Trainer,DC=IT2A023,DC=HK"

foreach($class in $classes){
    $class = $class.CLASS
    New-ADGroup -Name "class_$class" -GroupCategory Security -GroupScope DomainLocal
    Add-ADGroupMember -Identity students -Members "class_$class"
}
