[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

$global:headers = @{"Authorization" = "Basic YWRtaW46d0VedTJYVmIhVmc2"}

$uri = "https://dev96716.service-now.com/api/now/table/incident"

$body = @{
                       Caller_id = "Alene Rabeck"
                       short_description = "DB Server Down"
                       assignment_group = "Database"
                       urgency = 1
                       }

$bjson = $body | ConvertTo-Json
# POST method for creating the ticket 
$incident = Invoke-RestMethod -Headers $global:headers -Uri $uri -ContentType 'application/json' -Method POST -Body $bjson
$inc_no = $incident.result.number

# updating our ticket 
# In Servicenow sysid is unique id for update ticket
$sys_id = $incident.result.sys_id
$sys_id