Get-Service -Name "winrm" | Select-Object -Property "name","status"

Get-Service | Where-Object {$_.Status -ne "stopped"}
Get-Service | Where-Object {$_.Name -eq "winrm"}

Get-Process | Select-Object -First 5 -Property "Handles", "processname" | Add-Content C:\Users\Administrator.DEMO\Desktop\pstraining\test.txt
Get-Process | Select-Object -First 5 -Property "Handles", "processname" | Out-File C:\Users\Administrator.DEMO\Desktop\pstraining\test1.txt

$process = Get-Process | Select-Object -First 5 -Property "Handles", "processname"
$process | Export-Csv C:\Users\Administrator.DEMO\Desktop\pstraining\test.csv

Select-Object *| Sort-Object -Descending -Property "Handles"