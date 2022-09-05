[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

$global:headers = @{"Authorization" = "Basic YWRtaW46d0VedTJYVmIhVmc2"}

$uri = "https://dev96716.service-now.com/api/now/table/incident/ c73a100597611110369cfef3a253af7c"

$body = @{
                work_notes = "Ticket Created form powershell"
         
         }

$bjson = $body | ConvertTo-Json
# PUT method for update the ticket 
$incident = Invoke-RestMethod -Headers $global:headers -Uri $uri -ContentType 'application/json' -Method put -Body $bjson
$inc_no = $incident.result.number