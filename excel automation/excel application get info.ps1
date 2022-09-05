$excel = New-Object -ComObject Excel.Application
$workbook = $excel.workbook.open("C:\Users\piyush_verma\Desktop\service.xlsx")
$worksheets = $workbook.worksheets.item("status")
$task =@()
$length = ($workbook.UsedRange.Rows).count
For($i=2;$i -le $length; $i++)
{
    $task += [PScustomobject]@{
    Track = $worksheets.cells.Item($i,1).text
    Task  = $worksheets.cells.Item($i,2).text
    #status
    }
}

$worksheets.Range("A2").text
$workbook.close()
$excel.quit()