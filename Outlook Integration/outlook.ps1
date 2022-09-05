$outlook = New-Object -ComObject outlook.Application
$namespace = $outlook.getNamespace("MAPI")
$email = ($namespace.Folders|Where-Object {$_.Name -like "piyush_verma@hcl.com"}).Folders.Item("Inbox").Items
$sentemail = ($namespace.Folders|Where_Object {$_.Name -like "piyush_verma@hcl.com"}).Folders.Item("Sent items").Items
$sort = $email | Select-Object -Property SenderName,Subject,ReceivedTime -Last 5 |Sort-Object ReceivedTime -Descending |fl
$sort1 = $sentemail | Select-Object -Property SenderName,Subject,ReceivedTime -Last 5 |Sort-Object ReceivedTime -Descending |fl
$sort1