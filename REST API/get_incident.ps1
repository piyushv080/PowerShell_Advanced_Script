[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

$global:headers = @{"Authorization" = "Basic YWRtaW46d0VedTJYVmIhVmc2"}

$uri = "https://dev96716.service-now.com/api/now/table/incident?sysparam_query=active=true"

$result = Invoke-RestMethod -Uri $uri -ContentType 'application/json' -Method Get -Body $bjson -Headers $global:headers
$result.result
#$result.result.number