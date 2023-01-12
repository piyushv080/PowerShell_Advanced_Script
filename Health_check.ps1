Write-Host "Developed by Piyush Verma" -ForegroundColor Gray
$serverlist = "C:\Users\id881653\OneDrive - Proximus\Desktop\health_check\nbu_netops_server.txt"
#server_list 
$Servers = Get-Content -Path $serverlist
# Intializing Array to store the object  
$Array = @()
#Iterating Server List 
ForEach($Server in $Servers)
{
    $Server = $Server.trim()
    Write-Host "$Server - " -ForegroundColor Green -NoNewline
    $TestPath = Test-Path "\$Server\c$"
#Testing Server Connection  
If($TestPath -match "True")
{
    Write-Host "ERROR: Failed to connect"
    #Ping Status
    $Status = "Offline"
    $diskUtilization = "(Null)"
    $diskHtml = "(Null)"
    $Service_Status = "(Null)"
    $ServiceHtml = "(Null)"
    $trace = "(Null)"
}
Else
{
    Write-Host "SUCCESS: Server is up" -BackgroundColor Black
    $Status = "Online"
    #Tracert on Server
    $trace = Test-NetConnection -ComputerName $Server -TraceRoute
     if ($trace){
        $trace = "True"
     }
    $trace_status = $trace
    #Check Services
    $Services = Invoke-Command -ComputerName $Server -ScriptBlock {Get-service -Displayname "*spectrum*" |
                Select-Object -Property Status,@{Name="DisplayName";Expression={"{0:N2}" -f(($_.DisplayName))}}}
    $Service_Status = $Services
    $ServiceHtml = $Services | ConvertTo-Html -Property Status , DisplayName
    #Disk Utilization  
    $disk = Get-CimInstance Win32_logicaldisk -ComputerName $Server -Filter "DriveType=3" |select -property DeviceID,
    <#@{Name="Size(GB)";Expression={[decimal]("{0:N0}" -f($_.size/1gb))}},@{Name="Free Space(GB)";Expression={[decimal]("{0:N0}" -f($_.freespace/1gb))}},#>
    @{Name="Free (%)";Expression={"{0:N2}" -f((($_.freespace/1gb) / ($_.size/1gb))*100)}},@{Name="Utilize (%)";Expression={"{0:N2}" -f(100 - ((($_.freespace/1gb) / ($_.size/1gb))*100))}}
    $diskUtilization= $disk
    $diskHtml = $disk | ConvertTo-Html
}
# Creating custom object  
 $Object = New-Object PSObject -Property ([ordered]@{
 "ServerName" = $Server
 "Status" = $Status
 "Trace" = $trace_status
 "DiskUtlization" = $diskUtilization
 "DiskHtmlTable" = $diskHtml
 "ServiceStatus" = $Service_Status
 "ServiceHtml"= $ServiceHtml
 })
 # Add object to our array  
 $Array += $Object
 }
 ### HTML REPORT ############################################################################################################################
# Creating head style
$Style = @"
      
    <style>
      body {
        font-family: "Arial";
        font-size: 8pt;
        color: #4C607B;
        }
      th, td { 
        border: 1px solid #e57300;
        border-collapse: collapse;
        padding: 5px;
        }
      th {
        font-size: 1.2em;
        text-align: left;
        background-color: #003366;
        color: #ffffff;
        }
      td {
        color: #000000;
        
        }
      .even { background-color: #ffffff; }
      .odd { background-color: #bfbfbf; }
    </style>
      
"@
 # Creating head style and header title 
 $output = '<html><head>'
 #Import html style file 
 $output += $Style
 $output += '</head><body>'
 $output += "<h1 style='color: #0B2161'> <center>Netops Server Health Report </center> </h1>"
 $output += '<center> <h3> <span> <strong><font color="red">WARNING: </font></strong> Please review attached report. </h3> </center>'
 $output += '</br>'
 $output += '<hr>'
 $output += "<h4>Report of all the Server:</h4>"
 $output += "<table> <tr> 
             <th>Server Name</th>
             <th>Status</th>
             <th>Trace</th>
             <th>Service Status</th>
             <th>Disk Utlization</th> </tr>"
 Foreach($Entry in $Array)
 {
    $output += "<td>$($Entry.ServerName)</td> 
                <td>$($Entry.Status)</td>
                <td>$($Entry.Trace)</td>
                <td>$($Entry.ServiceHtml)</td> 
                <td>$($Entry.DiskHtmlTable)</td> </tr>"
 }
 $output += "</table></body></html>"
$header = @"
<style>
    h1 {
        font-family: Arial, Helvetica, sans-serif;
        color: #e68a00;
        font-size: 28px;
    }
    
    h2 {
        font-family: Arial, Helvetica, sans-serif;
        color: #000099;
        font-size: 16px;
    }
    
    
   table {
        font-size: 12px;
        border: 0px; 
        font-family: Arial, Helvetica, sans-serif;
    } 
    
    td {
        padding: 4px;
        margin: 0px;
        border: 0;
    }
    
    th {
        background: #395870;
        background: linear-gradient(#49708f, #293f50);
        color: #fff;
        font-size: 11px;
        text-transform: uppercase;
        padding: 10px 15px;
        vertical-align: middle;
    }
    tbody tr:nth-child(even) {
        background: #f0f0f2;
    }
        #CreationDate {
        font-family: Arial, Helvetica, sans-serif;
        color: #ff3300;
        font-size: 12px;
    }
</style>
"@
 If($Array)
 {
 Write-Host "`nResults" -ForegroundColor Yellow
 # Display results in console  
 $Array | Select-Object ServerName, Status, Trace, ServiceStatus, DiskUtlization | Format-Table -AutoSize -Wrap
 #Display results in new window  
 #$Array | Out-GridView  
 #Save as CSV file  
 #$Array | Export-Csv -Path C:\Users\id881653\OneDrive - Proximus\Desktop\health_check\nbu_results.csv -NoTypeInformation
 #Save as Html File  
 $output | out-file C:\Users\id881653\OneDrive - Proximus\Desktop\health_check\nbu_netops_server.txt\nbu_ccv.html
 }

<#Send email functionality from below line,  
$From = "piyush.verma.ext@proximus.com"
$To = "piyush.verma.ext@proximus.com"
#$Cc = "CC@gmail.com"
$Subject = "[Servers Health Report] $(Get-Date -Format "yyyy-MM-dd")|| Netops Server Report"
$SMTPServer = "mailout.int.belbone.be"
$SMTPPort = "25"
$Body = $output
Send-MailMessage -From $From -to $To  -Subject $Subject -BodyAsHtml -Body $Body -SmtpServer $SMTPServer -Port $SMTPPort
#-Credential $Credential
Write-Host "Email Sent....." -ForegroundColor DarkRed#>


