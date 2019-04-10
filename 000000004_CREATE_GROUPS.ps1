#Find for all class
$classes = $students | Select-Object -Property Class -Unique

New-ADGroup -Name "students" -GroupCategory Security -GroupScope DomainLocal
New-ADGroup -Name "PECServer" -GroupCategory Security -DomainLocal DomainLocal

foreach($class in $classes){
    $class = $class.CLASS
    New-ADGroup -Name "class_$class" -GroupCategory Security -GroupScope DomainLocal
    Add-ADGroupMember -Identity students -Members "class_$class"
}
