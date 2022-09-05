$services = Get-WmiObject win32_service
$running_services = $services|Where-Object {$_.state -eq "running"}
$stopped_services = $services|Where-Object {$_.state -eq "stopped"}
$a = @($running_services,$stopped_services)
    $excel = New-Object -ComObject Excel.Application
    $workbooks = $excel.workbooks.add()
    #$workbooks.name = "Services"
    $k = 1

    foreach($item in $a)
    {
    #running services
    $worksheets2 = $workbooks.worksheets.add()
    #$worksheet = $worksheets2.Item($k).activate()

    $worksheets2.cells.item(1,1) = "Services"
    $worksheets2.cells.item(1,2) = "Status"
    $worksheets2.cells.item(1,3) = "Mode"
    #$workbooks.name = "Service$k"
    $worksheets2.name = "status$k"

    For($i=2;$i -le $running_services.count; $i++){
        $worksheets2.cells.item($i,1) = $item[$i].displayname
        $worksheets2.cells.item($i,2) = $item[$i].state
        $worksheets2.cells.item($i,3) = $item[$i].startmode
    }
    $k++
    }
    ($s1 = $workbooks.sheets | where {$_.name -eq "Sheet1"}).delete()
    $path = "C:\Users\piyush_verma\Desktop\service2.xlsx"
    $workbooks.saveAs($path)
$excel.quit()