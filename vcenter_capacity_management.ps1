Install-Module -Name ImportExcel -Scope CurrentUser

Import-Module ImportExcel

$cred=Get-Credential|Export-Clixml -Path "\\Desktop\vcenter\CRED.xml"

$credim=Import-Clixml -Path "\\Desktop\vcenter\CRED.xml"

$date=Get-Date 
$filestring=$date.ToString("yyyy_MM_dd_HHmmss")

$vcenters=@('dsrv1231','vsrv959') #ServerUid

foreach($vserver in $vcenters)

{

Connect-VIServer -Server $vserver -Credential $credim

$dts=@()

$dc=@()

$Datacenter=Get-Datacenter

foreach($datap in $Datacenter)

{   

$dc=$datap

$datapb=@()

$results=@()     

$clusters=Get-Cluster -Location $datap

if($null -eq $clusters)

{

$datapb+= $datap

Write-Host $datapb

foreach($empt in $datapb){

$am=[PSCustomObject]@{

VcenterServer=$vserver

Datacenter= $empt

}   

}

$am|Export-Excel "\\bb-nas\homedrives\id881653\Desktop\vcenter\Capacity_Report$filestring.xlsx" -Append -WorksheetName "MtDtCntr($vserver)" -AutoSize -AutoFilter

}          

foreach($cluster in $clusters)     

{      

$ip=$vserver #servername      

$cpustat= Get-Stat -Entity $cluster -Stat "cpu.usage.average" -Start "1/07/2023, 12:00:00" -Finish "6/07/2023, 10:00:00"|Select-Object -ExpandProperty Value
$mem= Get-Stat -Entity $cluster -Stat "mem.consumed.average" -Start "1/07/2023, 12:00:00" -Finish "6/07/2023, 10:00:00"|Select-Object -ExpandProperty Value      

$totalHosts = $cluster|Get-VMHost | Measure-Object | Select-Object -ExpandProperty Count       

# total PCpu       

$totalpcpu=($cluster|Get-VMHost|Measure-Object -Property NumCpu -Sum).Sum       

#PeakCpu      

$PeakC=($cpustat|Select-Object -First 1)

$PeakCm="{0:N2}" -f $PeakC      

#AggregateCpu       

$aggbcu=($cpustat|Measure-Object -Maximum).Maximum       

#$PeakCp=$statscpu|Measure-Object -Property Value -Maximum|Select-Object -ExpandProperty Maximum       

#Average Mem Value      

$aggregte_mem=($mem|Measure-Object -Average).Average       

#Peak Value of Mem      

$Pek_mem=$mem|Select-Object -First 1      

#No.of hosts       

$totalHosts = $cluster|Get-VMHost | Measure-Object | Select-Object -ExpandProperty Count       

# total PCpu       

$totalpcpu=($cluster|Get-VMHost|Measure-Object -Property NumCpu -Sum).Sum      

#totalcores available      

$totalcores=4*$totalpcpu       

#Cpu Usage       

$cpuusage= ($cluster|Get-VMHost|Measure-Object -Property CpuUsageMhz -Sum).Sum/1000      

#Cpu Total       

$totalcpu= ($cluster|Get-VMHost|Measure-Object -Property CpuTotalMhz -Sum).Sum/1000      

#Memory TotalAvailable       

$TotalMemory= ($cluster|Get-VMHost|Measure-Object -Property MemoryTotalGB -Sum).Sum       

#Allocated memory      

$MemoryUsage= ($cluster|Get-VMHost|Measure-Object -Property MemoryUsageGB -Sum).Sum      

#Available memory      

$AvailMem=$TotalMemory-$MemoryUsage                                            

 

$bm=[PSCustomObject]@{

VcenterServer=$ip        

Datacenter= $datap        

Cluster_name = $cluster        

Total_Hosts = $totalHosts        

Total_pCpu= $totalpcpu               

Total_Cores= $totalcores                

Allocated_vCpu= [math]::Round(($cpuusage ),2)         

Available_CPU=[math]::Round(($totalcpu-$cpuusage),2)        

Aggregate_Cpu_Usage=[math]::Round(($aggbcu),2)         

Peak_Cpu_Usage=$PeakCm        

Total_pRam=[math]::Round(($TotalMemory),2)         

Allocated_vRam=[math]::Round(($MemoryUsage),2)         

Available_vMem=[math]::Round(($AvailMem),2)        

Average_Mem_Usage=[math]::Round(($aggregte_mem),2)        

Peak_Mem_Usage=$Pek_mem}        

 

 

#Datastorage        

$datastor=$cluster|Get-Datastore         

foreach($datastorage in $datastor)         

{

$datac=$datastorage|Select Name,CapacityMB,              

@{N="Provisioned (MB)"; E={[math]::round(($_.ExtensionData.Summary.Capacity - $_.ExtensionData.Summary.FreeSpace + $_.ExtensionData.Summary.Uncommitted)/1MB,2) }},              

@{N="InUse MB"; E={[math]::Round(($_.CapacityMB - $_.FreeSpaceMB))}},FreeSpaceMB,@{N="Free %"; E ={[math]::Round((($_.FreeSpaceMB)/($_.CapacityMB))*100)}}           

$dts+=$datac         

}$results+=$bm    

 

} $results|Export-Excel "\\Desktop\vcenter\Capacity_Report$filestring.xlsx" -Append -WorksheetName "Vc($vserver)" -AutoSize -AutoFilter

 

}$dts|Export-Excel "\Desktop\vcenter\Capacity_Report$filestring.xlsx" -Append -WorksheetName "Ds($vserver)" -AutoSize -AutoFilter




Disconnect-VIServer -Server $vserver -Confirm:$false #Disconnect with Servers

 

}
