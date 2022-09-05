$path = "C:\service.txt"

#Checking the path

if(Test-Path $path)
{
$servicename = Get-Content -Path $path
}
else
{
    Write-Host "$path does not exist"
    Start-Sleep 2
    Exit
}

$logfilepath = "C:\log.txt"

# appending the value to the lof file

"Service Details"| Out-File $logfilepath

foreach($ser in $servicename)
{
try{

#Get the service status

$service = Get-Service -Name $ser -ErrorAction Stop
$date = Get-Date
$status = $service.Status
if($status -eq "Running")
{
    $date | Out-File $logfilepath -Append
    "$ser is Running" | Out-File $logfilepath -Append
    " " | Out-File $logfilepath -Append
}
elseif($status -eq "Stopped")
{
    $date | out-File $logfilepath -Append
    "$ser is stopped" | Out-File $logfilepath -Append
    " " | Out-File $logfilepath -Append
}
}catch{
    $date | Out-File $logfilepath -Append
    $_.Exception | Out-File $logfilepath -Append
}
finally{
$Error.clear()
}
}




