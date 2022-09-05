Get-WmiObject -Class win32_Service -ComputerName dc1 -Credential Get-Credential

Invoke-Command -ComputerName dc1 -Credential Get-Credential -ScriptBlock {hostname}

Enter-PSSession -ComputerName DC1