$path = "C:\Users\piyush_verma\Desktop\demo.txt"
$outlook = New-Object -ComObject outlook.Application
$email = $outlook.createitem(0)
$email.To = ""
$email.Subject = "Running Services"
$email.Attachments.Add("$path")
$email.Body = "Hi , Please find the attachment"
$email.Send()
