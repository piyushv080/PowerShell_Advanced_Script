$username = "admin"
$password = "wE^u2XVb!Vg6"
[System.Convert]::ToBase64String([System.Text.Encoding]::UTF8.GetBytes($username+":"+$password))