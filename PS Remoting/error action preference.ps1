Get-Service -Name "AA" -ErrorAction Continue
Write-Host "Helloworld"

Get-Service -Name "AA" -ErrorAction Ignore
Write-Host "Helloworld"

Get-Service -Name "AA" -ErrorAction Inquire
Write-Host "Helloworld"

Get-Service -Name "AA" -ErrorAction SilentlyContinue
Write-Host "Helloworld"

Get-Service -Name "AA" -ErrorAction Stop
Write-Host "Helloworld"

Get-Service -ErrorAction -