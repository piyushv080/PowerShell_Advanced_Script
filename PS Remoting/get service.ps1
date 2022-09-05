$ser = Get-Service
$ser
$ser.status

$ser = Get-Service | select -First 5 |Get-Member
$ser