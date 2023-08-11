Import-Module -Name SqlServer

#Import-Module -Name C:\Program Files\WindowsPowerShell\Modules\sqlserver.21.1.18256 -verbose #importing modules of sql server



####################################################verify sql server is accessible and not updated#################################################

$ComputerName1 = 'AXSQL16-01\INST01A'
$ServicePack1  = 'CU8'

	try {
		$SQLInstance  = Get-SQLInstance -ServerInstance $ComputerName1 -ErrorAction 'Stop'
	} Catch {
		Throw "Unable to retrieve SQL Instance"
	}

	$CurrentServicePackVersion = $SQLInstance.UpdateLevel
	Write-Host "Current Service Pack Version: $CurrentServicePackVersion"

	If ($CurrentServicePackVersion -EQ $ServicePack1) {
		Throw "Service Pack already installed"
	}
    else{
    Write-Host "No Service Pack Found"
    }


############################################install service pack and restart server##########################################################


$ComputerName = 'AXSQL16-01.grouptest.bgc.net'
$ServicePack  = 'CU9'
$InstallerPath      = 'D:\SQL_patching\Downloads\15.0.4123.1\sqlserver2019-kb5001090.exe'
Start-Process -verb runas -FilePath $InstallerPath -ArgumentList "/Quiet", "/IAcceptSQLServerLicenseTerms", "/Action=Patch", "/AllInstances", "/SkipRules=RebootRequiredCheck" -Wait

#Restart-Computer -ComputerName $ComputerName -Wait -Force



Start-Process -verb runas -FilePath "D:\SQL_patching\Downloads\15.0.4123.1\1-SQLServer2016SP2-KB4052908-x64-ENU-SP2.exe" -ArgumentList "/Quiet", "/IAcceptSQLServerLicenseTerms", "/Action=Patch", "/AllInstances", "/SkipRules=RebootRequiredCheck" -Wait


###########################################################verify proper service pack installation#################################################

	try {
		$SQLInstance  = Get-SQLInstance -ComputerName $ComputerName -ErrorAction 'Stop'
	} catch {
		Throw "Unable to retrieve SQL Instance"
	}

	$CurrentServicePackVersion = $SQLInstance.ServicePack
	Write-Host "Current Service Pack Version: $CurrentServicePackVersion"

	If ($CurrentServicePackVersion -EQ $ServicePack) {
		Write-Host "Sucess, the Service Pack is installed"
	}

			#main command end
