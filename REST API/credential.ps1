$username = "admin"
$password = ""
[System.Convert]::ToBase64String([System.Text.Encoding]::UTF8.GetBytes($username+":"+$password))
