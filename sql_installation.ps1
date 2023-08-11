#if (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")){ Start-Process powershell.exe "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs; exit }

#if([System.IO.File]::Exists("C:\temp\MyCloud\SQLInstallation\sqlIns.json")){
#$json = cat "C:\temp\MyCloud\SQLInstallation\sqlIns.json" | convertfrom-json
$instance = "INST01C"
$server_name ="AXSQL16-01.grouptest.bgc.net"
#$environment = $json.environment

if([System.IO.File]::Exists("D:\Softwares\SQLAutoInstaller\log.txt")){
	Remove-Item –path "D:\Softwares\SQLAutoInstaller\log.txt"
}
New-Item D:\Softwares\SQLAutoInstaller\log.txt

msg * "Please DO NOT reboot the server SQL Installation will start in 5 mins If Any work pending before SQL Deployment then request you to save your task."
#Start-Sleep -S 360

[String] $dblog="D:\Softwares\$instance\DBLog\"
[String] $dbdata="D:\Softwares\$instance\DBData\"
[String] $templog="D:\Softwares\TempLog\"
[String] $tempdata="D:\Softwares\TempData\"

If(!(test-path $dblog))
{
      New-Item -ItemType Directory -Force -Path $dblog
}
If(!(test-path $dbdata))
{
      New-Item -ItemType Directory -Force -Path $dbdata
}
If(!(test-path $templog))
{
      New-Item -ItemType Directory -Force -Path $templog
}
If(!(test-path $tempdata))
{
      New-Item -ItemType Directory -Force -Path $tempdata
}

Set-Content D:\Softwares\SQLAutoInstaller\log.txt "$(Get-Date) | Server Name: $server_name"
Add-Content D:\Softwares\SQLAutoInstaller\log.txt "$(Get-Date) | Environment: $environment"
Add-Content D:\Softwares\SQLAutoInstaller\log.txt "$(Get-Date) | Instance Name: $instance"
Add-Content D:\Softwares\SQLAutoInstaller\log.txt "$(Get-Date) | DBLog Path: $dblog"
Add-Content D:\Softwares\SQLAutoInstaller\log.txt "$(Get-Date) | DBData Path: $dbdata"
Add-Content D:\Softwares\SQLAutoInstaller\log.txt "$(Get-Date) | TempLog Path: $templog"
Add-Content D:\Softwares\SQLAutoInstaller\log.txt "$(Get-Date) | TempData Path: $tempdata"
Add-Content D:\Softwares\SQLAutoInstaller\log.txt "$(Get-Date) | Performing pre-checks"

$server_inst = -join($server_name,"\",$instance)
Add-Content D:\Softwares\SQLAutoInstaller\log.txt "$(Get-Date) | Instance name: $server_inst"

$object_sql = Get-service -ComputerName $server_name  | where {($_.name -like "SQL Server (*" -or $_.name -like "MSSQL$*" -or $_.name -like "MSSQLSERVER") }
$running_inst = 1
if ($object_sql){
	For ($i=0; $i -lt $object_sql.count; $i++) {
		$inst_name = $object_sql[$i].Name
		$inst_status = $object_sql[$i].Status
		if($inst_name -match "$instance"){
			Add-Content D:\Softwares\SQLAutoInstaller\log.txt "$(Get-Date) | SQL Already Installed"
			Add-Content D:\Softwares\SQLAutoInstaller\log.txt "$(Get-Date) | InstanceName: $inst_name"
			Add-Content D:\Softwares\SQLAutoInstaller\log.txt "$(Get-Date) | Status: $inst_status"
			$running_inst = 1
		}
		else{
			$running_inst = 0
		}
	}
}
else{
	$running_inst = 0
}

if($running_inst -eq 0){


###############################################Installing SQL Server###############################################################
	Add-Content D:\Softwares\SQLAutoInstaller\log.txt "$(Get-Date) | Installing SQL Server"
   Start-Process -verb runas -FilePath "D:\ToInstall\SQL2019\SQL_Svr_Ent_Core_2019_64Bit\setup.exe" -ArgumentList "/INSTANCENAME=$instance", "/INSTANCEID=$instance", "/SQLUSERDBDIR=$dbdata", "/SQLUSERDBLOGDIR=$dblog", "/SQLTEMPDBDIR=$tempdata", "/SQLTEMPDBLOGDIR=$templog", "/FTSVCACCOUNT='NT Service\MSSQLFDLauncher$%$instance%'", "/ConfigurationFile=D:\ToInstall\SQL2019\ConfigurationFile.ini" -Wait

	$server_inst = -join($server_name,"\",$instance)
	$object_sql = Get-service -ComputerName $server_name  | where {($_.name -like "SQL Server (*" -or $_.name -like "MSSQL$*" -or $_.name -like "MSSQLSERVER") }
	$found_inst = 1
	if ($object_sql){
		For ($i=0; $i -lt $object_sql.count; $i++) {
			$inst_name = $object_sql[$i].Name
			$inst_status = $object_sql[$i].Status
			if($inst_name -match "$instance" -and $inst_status -eq "Running"){
				Add-Content D:\Softwares\SQLAutoInstaller\log.txt "$(Get-Date) | SQL Installed Successfully"
				Add-Content D:\Softwares\SQLAutoInstaller\log.txt "$(Get-Date) | InstanceName: $inst_name"
				Add-Content D:\Softwares\SQLAutoInstaller\log.txt "$(Get-Date) | Status: $inst_status"

	            		Add-Content D:\Softwares\SQLAutoInstaller\log.txt "$(Get-Date) | Installing SQL Patches"
	            		Add-Content D:\Softwares\SQLAutoInstaller\log.txt "$(Get-Date) | Applying CU10"

	            		Start-Process -verb runas -FilePath "D:\ToInstall\SQL2019\CU9 - SQLServer2019-KB5000642-x64.exe" -ArgumentList "/Quiet", "/IAcceptSQLServerLicenseTerms", "/Action=Patch", "/AllInstances", "/SkipRules=RebootRequiredCheck" -Wait
				#Import-Module -Name "C:\Program Files (x86)\Microsoft SQL Server\130\Tools\PowerShell\Modules\SQLPS" #Needs to be changed in case of any other sql version change
			        Add-Content D:\Softwares\SQLAutoInstaller\log.txt "$(Get-Date) | Verifying Patches"
				$version=Invoke-Sqlcmd -Query "select @@version as version;" -ServerInstance "$server_inst" -Username 'sa' -Password 'Password@123' | select version
				Add-Content D:\Softwares\SQLAutoInstaller\log.txt "$(Get-Date) | $version"
				if($version -Match "CU20"){
					Add-Content D:\Softwares\SQLAutoInstaller\log.txt "$(Get-Date) | SQL Patch Applied Successfully"
				}else{
					Add-Content D:\Softwares\SQLAutoInstaller\log.txt "$(Get-Date) | Error Applying SQL Patches"
				}
				$found_inst = 1
				break
			}elseif($inst_name -Match "$instance" -and $inst_status -eq "Stopped"){
				Add-Content D:\Softwares\SQLAutoInstaller\log.txt "$(Get-Date) | SQL Installation Unsuccessful. Services are in Stopped state"
				$found_inst = 1
				break
			}else{
				$found_inst=0
			}
		}
		if($found_inst -eq 0){
			Add-Content D:\Softwares\SQLAutoInstaller\log.txt "$(Get-Date) | SQL Installation Failed"
		}
	}
}


###############################################Installing SSMS###############################################################

Add-Content D:\Softwares\SQLAutoInstaller\log.txt "$(Get-Date) | Checking SQL Server Management Studio if already Installed"
if (Test-Path “HKLM:\Software\Microsoft\Microsoft SQL Server\130\Tools\Setup\SQL_SSMS_Adv”) {
	Add-Content D:\Softwares\SQLAutoInstaller\log.txt "$(Get-Date) | SSMS Already Installed"
} Else {
	Add-Content D:\Softwares\SQLAutoInstaller\log.txt "$(Get-Date) | Installing SQL Server Management Studio"

	Start-Process -verb runas -FilePath "‪D:\ToInstall\SQL2019\18.8_SSMS-Setup-ENU.exe" -ArgumentList "/install", "/quiet", "/norestart", "/log ssms_log.txt" -Wait

	if (Test-Path “HKLM:\Software\Microsoft\Microsoft SQL Server\130\Tools\Setup\SQL_SSMS_Adv”) {
		Add-Content D:\Softwares\SQLAutoInstaller\log.txt "$(Get-Date) | SSMS Installation Complete"
	} Else {
		Add-Content D:\Softwares\SQLAutoInstaller\log.txt "$(Get-Date) | Error Installing SSMS"
	}
}

#}else{
	#$From = ""
	#$To = ""
	#$cc = ""
	#$Subject = "JSON not Found"
	#$Body = "No JSON File Found!! Hence Stopping Installation."
	#$SMTPServer = ""
	#$SMTPPort = "25"
	#if($PSVersionTable.PSVersion.Major -eq 2){
	#	Send-MailMessage -From $From -to $To -cc $cc -Subject $Subject -Body $Body -SmtpServer $SMTPServer –DeliveryNotificationOption OnSuccess
	#}else{
	#	Send-MailMessage -From $From -to $To -cc $cc -Subject $Subject -Body $Body -SmtpServer $SMTPServer -port $SMTPPort –DeliveryNotificationOption OnSuccess
	#}
#}
